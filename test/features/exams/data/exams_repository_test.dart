import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/classes/data/repository/classes_repository_impl.dart';
import 'package:shiksha_setu/features/exams/data/repository/exams_repository_impl.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late ExamsRepositoryImpl repo;

  ExamPaper paper({PaperStatus status = PaperStatus.approved}) => ExamPaper(
    id: 'p1',
    title: 'Unit Test',
    subject: 'Maths',
    classSection: '6-A',
    date: DateTime(2026, 10, 5),
    durationMinutes: 60,
    status: status,
    questions: const [
      Question(text: 'Q one', marks: 2),
      Question(text: 'Q two', marks: 3),
    ],
  );

  setUp(() async {
    database = await openTestDatabase();
    repo = ExamsRepositoryImpl(database);
    await ClassesRepositoryImpl(database).add('6-A');
    await insertStudent(database, 's1', '6-A');
  });

  tearDown(() => database.close());

  test(
    'savePaper: questions come back in the order they were written',
    () async {
      await repo.savePaper(paper(), 'u1');

      final saved = (await repo.getPapers()).single;
      expect(saved.questions.map((q) => q.text), ['Q one', 'Q two']);
      expect(saved.totalMarks, 5);
    },
  );

  test(
    'savePaper: saving the same paper again replaces its questions',
    () async {
      await repo.savePaper(paper(), 'u1');

      await repo.savePaper(
        ExamPaper(
          id: 'p1',
          title: 'Unit Test',
          subject: 'Maths',
          classSection: '6-A',
          date: DateTime(2026, 10, 5),
          durationMinutes: 60,
          status: PaperStatus.approved,
          questions: const [Question(text: 'Only', marks: 10)],
        ),
        'u1',
      );

      expect((await repo.getPapers()).single.questions.length, 1);
    },
  );

  test('markConducted: status changes to conducted', () async {
    await repo.savePaper(paper(), 'u1');

    await repo.markConducted('p1');

    expect((await repo.getPapers()).single.status, PaperStatus.conducted);
  });

  test('saveMarks: marks are stored per student and can be updated', () async {
    await repo.savePaper(paper(status: PaperStatus.conducted), 'u1');

    await repo.saveMarks('p1', {'s1': 3});
    await repo.saveMarks('p1', {'s1': 4});

    expect(await repo.getMarks('p1'), {'s1': 4});
  });

  test('deleting a student removes their marks', () async {
    await repo.savePaper(paper(status: PaperStatus.conducted), 'u1');
    await repo.saveMarks('p1', {'s1': 4});

    await database.db.delete('students', where: 'id = ?', whereArgs: ['s1']);

    expect(await repo.getMarks('p1'), isEmpty);
  });

  group('question types and approval', () {
    const rich = [
      Question(
        text: 'Capital of India?',
        marks: 1,
        type: QuestionType.mcq,
        options: ['Mumbai', 'Delhi', 'Pune'],
        correctIndex: 1,
      ),
      Question(
        text: 'The earth is flat.',
        marks: 1,
        type: QuestionType.trueFalse,
        correctIndex: 1,
      ),
      Question(
        text: 'Water boils at _____ degrees.',
        marks: 1,
        type: QuestionType.fillBlank,
        answer: '100',
      ),
      Question(
        text: 'Match the following',
        marks: 4,
        type: QuestionType.matchFollowing,
        pairs: [MatchPair('Cat', 'Meow'), MatchPair('Dog', 'Bark')],
      ),
      Question(text: 'Define force.', marks: 2),
      Question(
        text: 'Explain photosynthesis.',
        marks: 5,
        type: QuestionType.longAnswer,
      ),
    ];

    ExamPaper withQuestions(
      List<Question> q, {
      PaperStatus status = PaperStatus.draft,
      String? createdBy,
      String instructions = '',
    }) => ExamPaper(
      id: 'p1',
      title: 'Unit Test',
      subject: 'Maths',
      classSection: '6-A',
      date: DateTime(2026, 10, 5),
      durationMinutes: 60,
      status: status,
      questions: q,
      createdBy: createdBy,
      instructions: instructions,
    );

    test('every question type survives a save and a load', () async {
      await repo.savePaper(withQuestions(rich, instructions: 'Be neat.'), 'u1');

      final saved = (await repo.getPapers()).single;

      expect(saved.questions, rich);
      expect(saved.instructions, 'Be neat.');
    });

    test(
      'the setter is kept when someone else (the Principal) edits it',
      () async {
        await repo.savePaper(withQuestions(rich, createdBy: 't1'), 't1');

        await repo.savePaper(
          withQuestions(rich.take(2).toList(), createdBy: 't1'),
          'principal',
        );

        expect((await repo.getPapers()).single.createdBy, 't1');
      },
    );

    test('a paper without a setter takes the saver', () async {
      await repo.savePaper(withQuestions(rich), 'u9');

      expect((await repo.getPapers()).single.createdBy, 'u9');
    });

    test(
      'submitting records when; approving moves it on; sending back keeps the note',
      () async {
        await repo.savePaper(withQuestions(rich), 't1');
        final at = DateTime(2026, 10, 1, 9);

        await repo.setStatus('p1', PaperStatus.submitted, at: at);
        var p = (await repo.getPapers()).single;
        expect((p.status, p.submittedAt), (PaperStatus.submitted, at));
        expect(p.awaitsApproval, isTrue);

        await repo.setStatus(
          'p1',
          PaperStatus.changesRequested,
          note: 'Too long',
        );
        p = (await repo.getPapers()).single;
        expect(
          (p.status, p.reviewNote),
          (PaperStatus.changesRequested, 'Too long'),
        );
        expect(p.isInProgress, isTrue);

        await repo.setStatus('p1', PaperStatus.approved);
        p = (await repo.getPapers()).single;
        expect(p.status, PaperStatus.approved);
        // The old note goes once the paper moves on.
        expect(p.reviewNote, isNull);
      },
    );

    test('deletePaper removes the paper and its questions', () async {
      await repo.savePaper(withQuestions(rich), 't1');

      await repo.deletePaper('p1');

      expect(await repo.getPapers(), isEmpty);
      expect(await database.db.query('exam_questions'), isEmpty);
    });

    test('a paper stored as "scheduled" reads as approved', () async {
      await repo.savePaper(withQuestions(rich), 't1');
      await database.db.update('exam_papers', {'status': 'scheduled'});

      expect((await repo.getPapers()).single.status, PaperStatus.approved);
    });
  });
}
