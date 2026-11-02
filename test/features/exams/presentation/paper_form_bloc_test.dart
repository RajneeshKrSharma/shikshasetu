import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/exams/domain/entities/scanned_question.dart';
import 'package:shiksha_setu/features/exams/domain/repository/exams_repository.dart';
import 'package:shiksha_setu/features/exams/domain/repository/photo_picker_repository.dart';
import 'package:shiksha_setu/features/exams/domain/repository/question_scanner_repository.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/parse_question_text.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/pick_photo.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/question_parser.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/save_paper.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/scan_questions.dart';
import 'package:shiksha_setu/features/exams/presentation/bloc/paper_form_bloc.dart';

class FakePhotoPicker implements PhotoPickerRepository {
  FakePhotoPicker(this.path);

  final String? path;

  @override
  Future<String?> pick(PhotoSource source) async => path;
}

class FakeScanner implements QuestionScannerRepository {
  FakeScanner(this.text, {this.fails = false});

  final String text;
  final bool fails;

  @override
  Future<String> recognize(
    String imagePath, {
    required ScanScript script,
  }) async {
    if (fails) throw StateError('ocr failed');
    return text;
  }
}

class RecordingExams implements ExamsRepository {
  ExamPaper? saved;
  String? createdBy;

  @override
  Future<void> savePaper(ExamPaper paper, String by) async {
    saved = paper;
    createdBy = by;
  }

  @override
  Future<List<ExamPaper>> getPapers() async => const [];
  @override
  Future<void> setStatus(
    String id,
    PaperStatus status, {
    String? note,
    DateTime? at,
  }) async {}
  @override
  Future<void> deletePaper(String id) async {}
  @override
  Future<void> markConducted(String paperId) async {}
  @override
  Future<Map<String, int>> getMarks(String paperId) async => const {};
  @override
  Future<void> saveMarks(String paperId, Map<String, int> marks) async {}
}

void main() {
  late RecordingExams exams;
  final now = DateTime(2026, 9, 30);

  PaperFormBloc build({String? photo = '/p.jpg', FakeScanner? scanner}) =>
      PaperFormBloc(
        savePaper: SavePaper(exams),
        pickPhoto: PickPhoto(FakePhotoPicker(photo)),
        scanQuestions: ScanQuestions(
          scanner ?? FakeScanner('1. Define force. [2]\n2. Name a prime.'),
          const QuestionParser(),
        ),
        parseQuestionText: const ParseQuestionText(QuestionParser()),
        now: () => now,
      );

  setUp(() => exams = RecordingExams());

  test('initial state: one blank question, dated a week ahead', () {
    final bloc = build();

    expect(bloc.state.questions.length, 1);
    expect(bloc.state.questions.single.isBlank, isTrue);
    expect(bloc.state.date, now.add(const Duration(days: 7)));
  });

  blocTest<PaperFormBloc, PaperFormState>(
    'QuestionEdited: total marks follow what is typed',
    build: build,
    act: (b) => b
      ..add(const QuestionEdited(0, marks: '3'))
      ..add(const QuestionAdded())
      ..add(const QuestionEdited(1, marks: '4')),
    verify: (b) => expect(b.state.totalMarks, 7),
  );

  blocTest<PaperFormBloc, PaperFormState>(
    'QuestionRemoved: drops just that question',
    build: build,
    act: (b) => b
      ..add(const QuestionAdded())
      ..add(const QuestionRemoved(0)),
    verify: (b) => expect(b.state.questions.map((q) => q.id), [1]),
  );

  blocTest<PaperFormBloc, PaperFormState>(
    'ScanRequested: a readable photo yields questions to review',
    build: build,
    act: (b) =>
        b.add(const ScanRequested(PhotoSource.gallery, ScanScript.latin)),
    verify: (b) {
      final f = b.state.scanFeedback!;
      expect(f.kind, ScanFeedbackKind.found);
      expect(f.questions.map((q) => q.text), [
        'Define force.',
        'Name a prime.',
      ]);
      expect(f.questions.first.marks, 2);
      expect(b.state.scanning, isFalse);
    },
  );

  blocTest<PaperFormBloc, PaperFormState>(
    'ScanRequested: a cancelled photo changes nothing',
    build: () => build(photo: null),
    act: (b) =>
        b.add(const ScanRequested(PhotoSource.camera, ScanScript.latin)),
    expect: () => <PaperFormState>[],
  );

  blocTest<PaperFormBloc, PaperFormState>(
    'ScanRequested: no text in the photo → noText feedback',
    build: () => build(scanner: FakeScanner('  ')),
    act: (b) =>
        b.add(const ScanRequested(PhotoSource.camera, ScanScript.latin)),
    verify: (b) => expect(b.state.scanFeedback?.kind, ScanFeedbackKind.noText),
  );

  blocTest<PaperFormBloc, PaperFormState>(
    'ScanRequested: OCR error → failed feedback, scanning stops',
    build: () => build(scanner: FakeScanner('', fails: true)),
    act: (b) =>
        b.add(const ScanRequested(PhotoSource.camera, ScanScript.latin)),
    verify: (b) {
      expect(b.state.scanFeedback?.kind, ScanFeedbackKind.failed);
      expect(b.state.scanning, isFalse);
    },
  );

  blocTest<PaperFormBloc, PaperFormState>(
    'ScannedQuestionsAccepted: replaces the blank starter row',
    build: build,
    act: (b) => b.add(
      const ScannedQuestionsAccepted([
        ScannedQuestion(text: 'Q one', marks: 2),
        ScannedQuestion(text: 'Q two'),
      ]),
    ),
    verify: (b) {
      expect(b.state.questions.map((q) => q.text), ['Q one', 'Q two']);
      expect(b.state.questions.map((q) => q.marks), ['2', '']);
    },
  );

  blocTest<PaperFormBloc, PaperFormState>(
    'ScannedQuestionsAccepted: keeps a question that was already typed',
    build: build,
    act: (b) => b
      ..add(const QuestionEdited(0, text: 'Mine'))
      ..add(const ScannedQuestionsAccepted([ScannedQuestion(text: 'Scanned')])),
    verify: (b) =>
        expect(b.state.questions.map((q) => q.text), ['Mine', 'Scanned']),
  );

  blocTest<PaperFormBloc, PaperFormState>(
    'PaperSubmitted: saves the paper with its status and creator',
    build: build,
    act: (b) => b
      ..add(const PaperTitleChanged(' Unit Test '))
      ..add(const PaperSubjectChosen('Maths'))
      ..add(const PaperClassChosen('6-A'))
      ..add(const QuestionEdited(0, text: 'Q', marks: '5'))
      ..add(const PaperSubmitted(PaperStatus.approved, 'u1')),
    verify: (b) {
      final p = exams.saved!;
      expect(
        (p.title, p.subject, p.classSection, p.status, p.totalMarks),
        ('Unit Test', 'Maths', '6-A', PaperStatus.approved, 5),
      );
      expect(exams.createdBy, 'u1');
      expect(b.state.saved, isTrue);
    },
  );

  group('question types', () {
    blocTest<PaperFormBloc, PaperFormState>(
      'QuestionAdded: an MCQ starts with four empty options',
      build: build,
      act: (b) => b.add(const QuestionAdded(QuestionType.mcq)),
      verify: (b) {
        final q = b.state.questions.last;
        expect(q.type, QuestionType.mcq);
        expect(q.options, ['', '', '', '']);
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'QuestionAdded: a match question starts with two empty pairs',
      build: build,
      act: (b) => b.add(const QuestionAdded(QuestionType.matchFollowing)),
      verify: (b) => expect(b.state.questions.last.pairs.length, 2),
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'options: edit, add and pick the right one',
      build: build,
      act: (b) => b
        ..add(const QuestionAdded(QuestionType.mcq))
        ..add(const OptionEdited(1, 0, 'Delhi'))
        ..add(const OptionAdded(1))
        ..add(const CorrectChosen(1, 0)),
      verify: (b) {
        final q = b.state.questions.last;
        expect(q.options, ['Delhi', '', '', '', '']);
        expect(q.correctIndex, 0);
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'OptionRemoved: the right answer follows its option',
      build: build,
      act: (b) => b
        ..add(const QuestionAdded(QuestionType.mcq))
        ..add(const CorrectChosen(1, 2))
        ..add(const OptionRemoved(1, 0)),
      verify: (b) => expect(b.state.questions.last.correctIndex, 1),
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'OptionRemoved: removing the right option clears the answer',
      build: build,
      act: (b) => b
        ..add(const QuestionAdded(QuestionType.mcq))
        ..add(const CorrectChosen(1, 2))
        ..add(const OptionRemoved(1, 2)),
      verify: (b) => expect(b.state.questions.last.correctIndex, isNull),
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'QuestionTypeChanged: text and marks carry over, options start fresh',
      build: build,
      act: (b) => b
        ..add(const QuestionEdited(0, text: 'Capital?', marks: '2'))
        ..add(const QuestionTypeChanged(0, QuestionType.mcq)),
      verify: (b) {
        final q = b.state.questions.first;
        expect(
          (q.type, q.text, q.marks, q.options.length),
          (QuestionType.mcq, 'Capital?', '2', 4),
        );
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'PairEdited: fills a row of a match question',
      build: build,
      act: (b) => b
        ..add(const QuestionAdded(QuestionType.matchFollowing))
        ..add(const PairEdited(1, 0, left: 'Cat'))
        ..add(const PairEdited(1, 0, right: 'Meow')),
      verify: (b) => expect(
        b.state.questions.last.pairs.first,
        const PairDraft(left: 'Cat', right: 'Meow'),
      ),
    );

    test('toQuestion: empty options are dropped and the answer re-pointed', () {
      const draft = QuestionDraft(
        id: 0,
        type: QuestionType.mcq,
        text: ' Q ',
        marks: '1',
        options: ['', 'Delhi', '', 'Pune'],
        correctIndex: 3,
      );

      final q = draft.toQuestion();

      expect(q.text, 'Q');
      expect(q.options, ['Delhi', 'Pune']);
      expect(q.correctIndex, 1);
    });

    test('toQuestion: half-filled match rows are dropped', () {
      const draft = QuestionDraft(
        id: 0,
        type: QuestionType.matchFollowing,
        text: 'Match',
        marks: '4',
        pairs: [
          PairDraft(left: 'Cat', right: 'Meow'),
          PairDraft(left: 'Dog'),
        ],
      );

      expect(draft.toQuestion().pairs, [const MatchPair('Cat', 'Meow')]);
    });
  });

  group('building the paper', () {
    blocTest<PaperFormBloc, PaperFormState>(
      'QuestionMoved: the dropped question lands where it was dropped',
      build: build,
      act: (b) => b
        ..add(const QuestionEdited(0, text: 'A'))
        ..add(const QuestionAdded())
        ..add(const QuestionEdited(1, text: 'B'))
        ..add(const QuestionAdded())
        ..add(const QuestionEdited(2, text: 'C'))
        // Drag A to the end: Flutter reports index 3 for "after C".
        ..add(const QuestionMoved(0, 3)),
      verify: (b) =>
          expect(b.state.questions.map((q) => q.text), ['B', 'C', 'A']),
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'QuestionMoved: dragging up',
      build: build,
      act: (b) => b
        ..add(const QuestionEdited(0, text: 'A'))
        ..add(const QuestionAdded())
        ..add(const QuestionEdited(1, text: 'B'))
        ..add(const QuestionMoved(1, 0)),
      verify: (b) => expect(b.state.questions.map((q) => q.text), ['B', 'A']),
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'QuestionDuplicated: a copy sits right after the original',
      build: build,
      act: (b) => b
        ..add(const QuestionEdited(0, text: 'A', marks: '2'))
        ..add(const QuestionAdded())
        ..add(const QuestionDuplicated(0)),
      verify: (b) {
        expect(b.state.questions.map((q) => q.text), ['A', 'A', '']);
        expect(b.state.questions[1].marks, '2');
        expect(b.state.questions.map((q) => q.id).toSet().length, 3);
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'MarksAppliedToAll: every question, or only one type',
      build: build,
      act: (b) => b
        ..add(const QuestionAdded(QuestionType.mcq))
        ..add(const MarksAppliedToAll(2, type: QuestionType.mcq))
        ..add(const MarksAppliedToAll(5, type: QuestionType.shortAnswer)),
      verify: (b) {
        expect(b.state.questions.map((q) => q.marks), ['5', '2']);
        expect(b.state.totalMarks, 7);
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'QuestionsShuffled: same questions, sections kept',
      build: () => PaperFormBloc(
        savePaper: SavePaper(exams),
        pickPhoto: PickPhoto(FakePhotoPicker('/p.jpg')),
        scanQuestions: ScanQuestions(FakeScanner(''), const QuestionParser()),
        parseQuestionText: const ParseQuestionText(QuestionParser()),
        now: () => now,
        random: Random(7),
      ),
      act: (b) => b
        ..add(const QuestionAdded(QuestionType.mcq))
        ..add(const QuestionAdded(QuestionType.mcq))
        ..add(const QuestionAdded())
        ..add(const QuestionsShuffled()),
      verify: (b) {
        expect(b.state.questions.length, 4);
        // The starter short answer (id 0) and the new one (id 3) stay last
        // or first as a group; MCQs stay together.
        final types = b.state.questions.map((q) => q.type).toList();
        final firstMcq = types.indexOf(QuestionType.mcq);
        expect(types.sublist(firstMcq, firstMcq + 2), [
          QuestionType.mcq,
          QuestionType.mcq,
        ]);
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'TextImported: pasted questions are added and marked for checking',
      build: build,
      act: (b) => b.add(
        const TextImported(
          '1. Capital?\n(a) Delhi\n(b) Pune\n2. Water boils at ____ degrees.',
        ),
      ),
      verify: (b) {
        expect(b.state.questions.map((q) => q.type), [
          QuestionType.mcq,
          QuestionType.fillBlank,
        ]);
        expect(b.state.questions.every((q) => q.needsReview), isTrue);
        expect(b.state.questions.first.options, ['Delhi', 'Pune']);
        expect(b.state.scanFeedback?.kind, ScanFeedbackKind.found);
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'TextImported: nothing readable → noText and the paper is unchanged',
      build: build,
      act: (b) => b.add(const TextImported('   ')),
      verify: (b) {
        expect(b.state.scanFeedback?.kind, ScanFeedbackKind.noText);
        expect(b.state.questions.single.isBlank, isTrue);
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'editing an imported question clears its "check" flag',
      build: build,
      act: (b) async {
        b.add(const TextImported('1. Define force.'));
        await Future<void>.delayed(Duration.zero);
        b.add(const QuestionEdited(1, marks: '2'));
      },
      verify: (b) => expect(b.state.questions.single.needsReview, isFalse),
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'MasterQuestionsAdded: questions from the bank join the paper',
      build: build,
      act: (b) => b.add(
        const MasterQuestionsAdded([
          Question(
            text: 'Capital?',
            marks: 1,
            type: QuestionType.mcq,
            options: ['Delhi', 'Pune'],
            correctIndex: 0,
          ),
        ]),
      ),
      verify: (b) {
        final q = b.state.questions.single;
        expect(q.type, QuestionType.mcq);
        expect(q.options, ['Delhi', 'Pune']);
        expect((q.correctIndex, q.marks), (0, '1'));
        expect(q.needsReview, isFalse);
      },
    );
  });

  group('editing an existing paper', () {
    final existing = ExamPaper(
      id: 'p9',
      title: 'Half-yearly',
      subject: 'Maths',
      classSection: '6-A',
      date: DateTime(2026, 11, 1),
      durationMinutes: 90,
      status: PaperStatus.submitted,
      createdBy: 't1',
      instructions: 'Be neat.',
      reviewNote: 'Shorter please',
      questions: const [
        Question(text: 'Q1', marks: 2),
        Question(
          text: 'Capital?',
          marks: 1,
          type: QuestionType.mcq,
          options: ['Delhi', 'Pune'],
          correctIndex: 0,
        ),
      ],
    );

    PaperFormBloc editing() => PaperFormBloc(
      savePaper: SavePaper(exams),
      pickPhoto: PickPhoto(FakePhotoPicker(null)),
      scanQuestions: ScanQuestions(FakeScanner(''), const QuestionParser()),
      parseQuestionText: const ParseQuestionText(QuestionParser()),
      initial: existing,
      now: () => now,
    );

    test('starts filled in from the paper', () {
      final s = editing().state;

      expect(
        (s.paperId, s.title, s.subject, s.classSection),
        ('p9', 'Half-yearly', 'Maths', '6-A'),
      );
      expect(
        (s.durationMinutes, s.instructions, s.reviewNote),
        (90, 'Be neat.', 'Shorter please'),
      );
      expect(s.questions.map((q) => q.type), [
        QuestionType.shortAnswer,
        QuestionType.mcq,
      ]);
      expect(s.isEditing, isTrue);
    });

    blocTest<PaperFormBloc, PaperFormState>(
      'saving keeps the id and the original setter, with the new status',
      build: editing,
      act: (b) => b
        ..add(const QuestionRemoved(0))
        ..add(const PaperSubmitted(PaperStatus.approved, 'principal')),
      verify: (b) {
        final p = exams.saved!;
        expect(
          (p.id, p.createdBy, p.status),
          ('p9', 't1', PaperStatus.approved),
        );
        expect(p.questions.single.type, QuestionType.mcq);
        expect(p.instructions, 'Be neat.');
        expect(b.state.savedAs, PaperStatus.approved);
      },
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'new questions after editing get fresh ids',
      build: editing,
      act: (b) => b.add(const QuestionAdded()),
      verify: (b) =>
          expect(b.state.questions.map((q) => q.id).toSet().length, 3),
    );

    blocTest<PaperFormBloc, PaperFormState>(
      'sending for approval stamps the time',
      build: editing,
      act: (b) => b.add(const PaperSubmitted(PaperStatus.submitted, 't1')),
      verify: (b) => expect(exams.saved!.submittedAt, now),
    );
  });
}
