import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/exam_paper.dart';
import '../../domain/entities/scanned_question.dart';
import '../../domain/usecases/parse_question_text.dart';
import '../../domain/usecases/pick_photo.dart';
import '../../domain/usecases/save_paper.dart';
import '../../domain/usecases/scan_questions.dart';
import '../../domain/usecases/shuffle_questions.dart';
import 'question_draft.dart';

export 'question_draft.dart';

enum ScanFeedbackKind { noText, failed, found }

/// Result of the last scan or paste. [id] changes each time so listeners fire
/// again.
class ScanFeedback extends Equatable {
  const ScanFeedback(this.kind, this.id, [this.questions = const []]);

  final ScanFeedbackKind kind;
  final int id;
  final List<ScannedQuestion> questions;

  @override
  List<Object?> get props => [kind, id, questions];
}

sealed class PaperFormEvent extends Equatable {
  const PaperFormEvent();

  @override
  List<Object?> get props => const [];
}

final class PaperTitleChanged extends PaperFormEvent {
  const PaperTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

final class PaperSubjectChosen extends PaperFormEvent {
  const PaperSubjectChosen(this.subject);

  final String? subject;

  @override
  List<Object?> get props => [subject];
}

final class PaperClassChosen extends PaperFormEvent {
  const PaperClassChosen(this.classSection);

  final String? classSection;

  @override
  List<Object?> get props => [classSection];
}

final class PaperDurationChosen extends PaperFormEvent {
  const PaperDurationChosen(this.minutes);

  final int minutes;

  @override
  List<Object?> get props => [minutes];
}

final class PaperDateChosen extends PaperFormEvent {
  const PaperDateChosen(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class PaperInstructionsChanged extends PaperFormEvent {
  const PaperInstructionsChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

final class QuestionAdded extends PaperFormEvent {
  const QuestionAdded([this.type = QuestionType.shortAnswer]);

  final QuestionType type;

  @override
  List<Object?> get props => [type];
}

final class QuestionRemoved extends PaperFormEvent {
  const QuestionRemoved(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

final class QuestionDuplicated extends PaperFormEvent {
  const QuestionDuplicated(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Drag and drop: the question at [from] is dropped at [to] (the list's new
/// order, as Flutter's reorderable list reports it).
final class QuestionMoved extends PaperFormEvent {
  const QuestionMoved(this.from, this.to);

  final int from;
  final int to;

  @override
  List<Object?> get props => [from, to];
}

final class QuestionEdited extends PaperFormEvent {
  const QuestionEdited(this.id, {this.text, this.marks, this.answer});

  final int id;
  final String? text;
  final String? marks;
  final String? answer;

  @override
  List<Object?> get props => [id, text, marks, answer];
}

final class QuestionTypeChanged extends PaperFormEvent {
  const QuestionTypeChanged(this.id, this.type);

  final int id;
  final QuestionType type;

  @override
  List<Object?> get props => [id, type];
}

final class OptionEdited extends PaperFormEvent {
  const OptionEdited(this.id, this.index, this.text);

  final int id;
  final int index;
  final String text;

  @override
  List<Object?> get props => [id, index, text];
}

final class OptionAdded extends PaperFormEvent {
  const OptionAdded(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

final class OptionRemoved extends PaperFormEvent {
  const OptionRemoved(this.id, this.index);

  final int id;
  final int index;

  @override
  List<Object?> get props => [id, index];
}

/// Marks which option (or true/false choice) is right; null clears it.
final class CorrectChosen extends PaperFormEvent {
  const CorrectChosen(this.id, this.index);

  final int id;
  final int? index;

  @override
  List<Object?> get props => [id, index];
}

final class PairEdited extends PaperFormEvent {
  const PairEdited(this.id, this.index, {this.left, this.right});

  final int id;
  final int index;
  final String? left;
  final String? right;

  @override
  List<Object?> get props => [id, index, left, right];
}

final class PairAdded extends PaperFormEvent {
  const PairAdded(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

final class PairRemoved extends PaperFormEvent {
  const PairRemoved(this.id, this.index);

  final int id;
  final int index;

  @override
  List<Object?> get props => [id, index];
}

final class ScanRequested extends PaperFormEvent {
  const ScanRequested(this.source, this.script);

  final PhotoSource source;
  final ScanScript script;

  @override
  List<Object?> get props => [source, script];
}

/// Typed or pasted text to split into questions.
final class TextImported extends PaperFormEvent {
  const TextImported(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

final class ScannedQuestionsAccepted extends PaperFormEvent {
  const ScannedQuestionsAccepted(this.questions);

  final List<ScannedQuestion> questions;

  @override
  List<Object?> get props => [questions];
}

/// Questions picked from the master bank.
final class MasterQuestionsAdded extends PaperFormEvent {
  const MasterQuestionsAdded(this.questions);

  final List<Question> questions;

  @override
  List<Object?> get props => [questions];
}

/// Gives every question (or only those of [type]) the same marks.
final class MarksAppliedToAll extends PaperFormEvent {
  const MarksAppliedToAll(this.marks, {this.type});

  final int marks;
  final QuestionType? type;

  @override
  List<Object?> get props => [marks, type];
}

final class QuestionsShuffled extends PaperFormEvent {
  const QuestionsShuffled({this.options = false});

  /// Also shuffle the options of each MCQ.
  final bool options;

  @override
  List<Object?> get props => [options];
}

final class PaperSubmitted extends PaperFormEvent {
  const PaperSubmitted(this.status, this.createdBy);

  final PaperStatus status;
  final String createdBy;

  @override
  List<Object?> get props => [status, createdBy];
}

class PaperFormState extends Equatable {
  const PaperFormState({
    required this.date,
    required this.questions,
    this.paperId,
    this.createdBy,
    this.title = '',
    this.subject,
    this.classSection,
    this.durationMinutes = 60,
    this.instructions = '',
    this.reviewNote,
    this.saving = false,
    this.saved = false,
    this.savedAs,
    this.scanning = false,
    this.scanFeedback,
  });

  /// Set when an existing paper is being edited.
  final String? paperId;
  final String? createdBy;
  final String title;
  final String? subject;
  final String? classSection;
  final int durationMinutes;
  final DateTime date;
  final String instructions;

  /// The Principal's note when the paper was sent back.
  final String? reviewNote;
  final List<QuestionDraft> questions;
  final bool saving;
  final bool saved;

  /// The status the paper was saved with.
  final PaperStatus? savedAs;
  final bool scanning;
  final ScanFeedback? scanFeedback;

  bool get isEditing => paperId != null;

  int get totalMarks =>
      questions.fold(0, (s, q) => s + (int.tryParse(q.marks.trim()) ?? 0));

  PaperFormState copyWith({
    String? title,
    String? subject,
    bool clearSubject = false,
    String? classSection,
    bool clearClass = false,
    int? durationMinutes,
    DateTime? date,
    String? instructions,
    List<QuestionDraft>? questions,
    bool? saving,
    bool? saved,
    PaperStatus? savedAs,
    bool? scanning,
    ScanFeedback? scanFeedback,
  }) => PaperFormState(
    paperId: paperId,
    createdBy: createdBy,
    title: title ?? this.title,
    subject: clearSubject ? null : (subject ?? this.subject),
    classSection: clearClass ? null : (classSection ?? this.classSection),
    durationMinutes: durationMinutes ?? this.durationMinutes,
    date: date ?? this.date,
    instructions: instructions ?? this.instructions,
    reviewNote: reviewNote,
    questions: questions ?? this.questions,
    saving: saving ?? this.saving,
    saved: saved ?? this.saved,
    savedAs: savedAs ?? this.savedAs,
    scanning: scanning ?? this.scanning,
    scanFeedback: scanFeedback ?? this.scanFeedback,
  );

  @override
  List<Object?> get props => [
    paperId,
    createdBy,
    title,
    subject,
    classSection,
    durationMinutes,
    date,
    instructions,
    reviewNote,
    questions,
    saving,
    saved,
    savedAs,
    scanning,
    scanFeedback,
  ];
}

/// The paper builder: details, questions of every type, and the quick ways
/// to fill it (scan a photo, paste text, pick from the master bank).
/// With [initial] it edits that paper instead of starting a new one.
class PaperFormBloc extends Bloc<PaperFormEvent, PaperFormState> {
  PaperFormBloc({
    required SavePaper savePaper,
    required PickPhoto pickPhoto,
    required ScanQuestions scanQuestions,
    required ParseQuestionText parseQuestionText,
    ExamPaper? initial,
    DateTime Function()? now,
    Random? random,
  }) : _save = savePaper,
       _pickPhoto = pickPhoto,
       _scan = scanQuestions,
       _parseText = parseQuestionText,
       _now = now ?? DateTime.now,
       _random = random ?? Random(),
       super(_start(initial, (now ?? DateTime.now)())) {
    _nextId = state.questions.fold(-1, (m, q) => q.id > m ? q.id : m) + 1;
    on<PaperTitleChanged>((e, emit) => emit(state.copyWith(title: e.title)));
    on<PaperSubjectChosen>(
      (e, emit) => emit(
        e.subject == null
            ? state.copyWith(clearSubject: true)
            : state.copyWith(subject: e.subject),
      ),
    );
    on<PaperClassChosen>(
      (e, emit) => emit(
        e.classSection == null
            ? state.copyWith(clearClass: true)
            : state.copyWith(classSection: e.classSection),
      ),
    );
    on<PaperDurationChosen>(
      (e, emit) => emit(state.copyWith(durationMinutes: e.minutes)),
    );
    on<PaperDateChosen>((e, emit) => emit(state.copyWith(date: e.date)));
    on<PaperInstructionsChanged>(
      (e, emit) => emit(state.copyWith(instructions: e.text)),
    );
    on<QuestionAdded>(
      (e, emit) => emit(
        state.copyWith(
          questions: [
            ...state.questions,
            QuestionDraft.blank(_nextId++, e.type),
          ],
        ),
      ),
    );
    on<QuestionRemoved>(
      (e, emit) => emit(
        state.copyWith(
          questions: [
            for (final q in state.questions)
              if (q.id != e.id) q,
          ],
        ),
      ),
    );
    on<QuestionDuplicated>(_onDuplicated);
    on<QuestionMoved>(_onMoved);
    on<QuestionEdited>(
      (e, emit) => _update(
        e.id,
        emit,
        (q) => q.copyWith(text: e.text, marks: e.marks, answer: e.answer),
      ),
    );
    on<QuestionTypeChanged>(
      (e, emit) => _update(e.id, emit, (q) => q.withType(e.type)),
    );
    on<OptionEdited>(
      (e, emit) =>
          _update(e.id, emit, (q) => q.withOptionEdited(e.index, e.text)),
    );
    on<OptionAdded>(
      (e, emit) => _update(e.id, emit, (q) => q.withOptionAdded()),
    );
    on<OptionRemoved>(
      (e, emit) => _update(e.id, emit, (q) => q.withOptionRemoved(e.index)),
    );
    on<CorrectChosen>(
      (e, emit) => _update(e.id, emit, (q) => q.withCorrect(e.index)),
    );
    on<PairEdited>(
      (e, emit) => _update(
        e.id,
        emit,
        (q) => q.withPairEdited(e.index, left: e.left, right: e.right),
      ),
    );
    on<PairAdded>((e, emit) => _update(e.id, emit, (q) => q.withPairAdded()));
    on<PairRemoved>(
      (e, emit) => _update(e.id, emit, (q) => q.withPairRemoved(e.index)),
    );
    on<ScanRequested>(_onScan);
    on<TextImported>(_onTextImported);
    on<ScannedQuestionsAccepted>(
      (e, emit) => _append([
        for (final q in e.questions) QuestionDraft.fromScanned(_nextId++, q),
      ], emit),
    );
    on<MasterQuestionsAdded>(
      (e, emit) => _append([
        for (final q in e.questions) QuestionDraft.fromQuestion(_nextId++, q),
      ], emit),
    );
    on<MarksAppliedToAll>(
      (e, emit) => emit(
        state.copyWith(
          questions: [
            for (final q in state.questions)
              e.type == null || q.type == e.type
                  ? q.copyWith(marks: '${e.marks}')
                  : q,
          ],
        ),
      ),
    );
    on<QuestionsShuffled>(_onShuffled);
    on<PaperSubmitted>(_onSubmitted);
  }

  static PaperFormState _start(ExamPaper? p, DateTime now) {
    if (p == null) {
      return PaperFormState(
        date: now.add(const Duration(days: 7)),
        questions: const [QuestionDraft(id: 0)],
      );
    }
    return PaperFormState(
      paperId: p.id,
      createdBy: p.createdBy,
      title: p.title,
      subject: p.subject,
      classSection: p.classSection,
      durationMinutes: p.durationMinutes,
      date: p.date,
      instructions: p.instructions,
      reviewNote: p.reviewNote,
      questions: [
        for (var i = 0; i < p.questions.length; i++)
          QuestionDraft.fromQuestion(i, p.questions[i]),
      ],
    );
  }

  final SavePaper _save;
  final PickPhoto _pickPhoto;
  final ScanQuestions _scan;
  final ParseQuestionText _parseText;
  final DateTime Function() _now;
  final Random _random;

  late int _nextId;
  int _feedbackId = 0;

  void _update(
    int id,
    Emitter<PaperFormState> emit,
    QuestionDraft Function(QuestionDraft) change,
  ) => emit(
    state.copyWith(
      questions: [
        for (final q in state.questions)
          // Any edit means the teacher has looked at it.
          if (q.id == id) change(q).copyWith(needsReview: false) else q,
      ],
    ),
  );

  void _onDuplicated(QuestionDuplicated e, Emitter<PaperFormState> emit) {
    final index = state.questions.indexWhere((q) => q.id == e.id);
    if (index < 0) return;
    final copy = QuestionDraft(
      id: _nextId++,
      type: state.questions[index].type,
      text: state.questions[index].text,
      marks: state.questions[index].marks,
      options: state.questions[index].options,
      correctIndex: state.questions[index].correctIndex,
      pairs: state.questions[index].pairs,
      answer: state.questions[index].answer,
    );
    emit(
      state.copyWith(questions: [...state.questions]..insert(index + 1, copy)),
    );
  }

  void _onMoved(QuestionMoved e, Emitter<PaperFormState> emit) {
    final list = [...state.questions];
    final moved = list.removeAt(e.from);
    // Flutter reports the target as if the item were still in the list.
    list.insert(e.to > e.from ? e.to - 1 : e.to, moved);
    emit(state.copyWith(questions: list));
  }

  void _append(List<QuestionDraft> added, Emitter<PaperFormState> emit) {
    if (added.isEmpty) return;
    // Replace the untouched starter row instead of leaving it empty.
    final kept = state.questions.length == 1 && state.questions.first.isBlank
        ? <QuestionDraft>[]
        : state.questions;
    emit(state.copyWith(questions: [...kept, ...added]));
  }

  void _onShuffled(QuestionsShuffled e, Emitter<PaperFormState> emit) {
    final shuffled = shuffleWithinSections(
      state.questions,
      (q) => q.type,
      _random,
    );
    emit(
      state.copyWith(
        questions: e.options
            ? [
                for (final q in shuffled)
                  if (q.type == QuestionType.mcq && q.options.length >= 2)
                    _shuffleDraftOptions(q)
                  else
                    q,
              ]
            : shuffled,
      ),
    );
  }

  QuestionDraft _shuffleDraftOptions(QuestionDraft q) {
    final order = List<int>.generate(q.options.length, (i) => i)
      ..shuffle(_random);
    return q.copyWith(
      options: [for (final i in order) q.options[i]],
      correctIndex: q.correctIndex == null
          ? null
          : order.indexOf(q.correctIndex!),
      clearCorrect: q.correctIndex == null,
    );
  }

  Future<void> _onScan(ScanRequested e, Emitter<PaperFormState> emit) async {
    final path = await _pickPhoto(e.source);
    if (path == null) return; // cancelled
    emit(state.copyWith(scanning: true));
    try {
      final found = await _scan(ScanQuestionsParams(path, e.script));
      _finishImport(found, emit);
    } catch (_) {
      emit(
        state.copyWith(
          scanning: false,
          scanFeedback: ScanFeedback(ScanFeedbackKind.failed, ++_feedbackId),
        ),
      );
    }
  }

  Future<void> _onTextImported(
    TextImported e,
    Emitter<PaperFormState> emit,
  ) async => _finishImport(await _parseText(e.text), emit);

  /// Adds what was found to the paper (marked "check me") and reports it.
  void _finishImport(
    List<ScannedQuestion> found,
    Emitter<PaperFormState> emit,
  ) {
    final feedback = ScanFeedback(
      found.isEmpty ? ScanFeedbackKind.noText : ScanFeedbackKind.found,
      ++_feedbackId,
      found,
    );
    final added = [
      for (final q in found) QuestionDraft.fromScanned(_nextId++, q),
    ];
    final kept = state.questions.length == 1 && state.questions.first.isBlank
        ? <QuestionDraft>[]
        : state.questions;
    emit(
      state.copyWith(
        scanning: false,
        questions: added.isEmpty ? null : [...kept, ...added],
        scanFeedback: feedback,
      ),
    );
  }

  Future<void> _onSubmitted(
    PaperSubmitted e,
    Emitter<PaperFormState> emit,
  ) async {
    emit(state.copyWith(saving: true));
    await _save(
      SavePaperParams(
        ExamPaper(
          id: state.paperId ?? const Uuid().v4(),
          title: state.title.trim(),
          subject: state.subject!,
          classSection: state.classSection!,
          date: state.date,
          durationMinutes: state.durationMinutes,
          status: e.status,
          createdBy: state.createdBy,
          instructions: state.instructions.trim(),
          submittedAt: e.status == PaperStatus.submitted ? _now() : null,
          questions: [for (final q in state.questions) q.toQuestion()],
        ),
        e.createdBy,
      ),
    );
    emit(state.copyWith(saving: false, saved: true, savedAs: e.status));
  }
}
