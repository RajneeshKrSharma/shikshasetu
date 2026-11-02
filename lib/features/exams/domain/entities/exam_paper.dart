import 'package:equatable/equatable.dart';

/// Where a paper is in its life. A teacher's paper goes draft → submitted;
/// the Principal then approves it (ready to conduct) or sends it back with a
/// note (changesRequested). A Principal's own paper can be approved directly.
enum PaperStatus {
  draft,
  submitted,
  changesRequested,
  approved,
  conducted;

  /// Reads a stored value. Papers saved before approvals existed are
  /// "scheduled", which is what "approved" replaced.
  static PaperStatus parse(String name) =>
      name == 'scheduled' ? approved : values.byName(name);
}

/// What kind of exam a paper is for.
enum ExamKind {
  weekly,
  midMonthly,
  unitTest,
  halfYearly,
  yearlyFinal;

  static ExamKind? parse(String? name) {
    for (final k in values) {
      if (k.name == name) return k;
    }
    return null;
  }
}

/// The shapes a question can take. Each has its own fields in [Question].
enum QuestionType {
  mcq,
  trueFalse,
  fillBlank,
  matchFollowing,
  shortAnswer,
  longAnswer;

  static QuestionType parse(String name) =>
      values.firstWhere((t) => t.name == name, orElse: () => shortAnswer);
}

/// One row of a "Match the following": [left] belongs with [right].
class MatchPair extends Equatable {
  const MatchPair(this.left, this.right);

  final String left;
  final String right;

  @override
  List<Object?> get props => [left, right];
}

class Question extends Equatable {
  const Question({
    required this.text,
    required this.marks,
    this.type = QuestionType.shortAnswer,
    this.options = const [],
    this.correctIndex,
    this.pairs = const [],
    this.answer = '',
  });

  /// The question itself, or its heading for MCQ and "match" questions.
  final String text;
  final int marks;
  final QuestionType type;

  /// MCQ choices.
  final List<String> options;

  /// Right choice of an MCQ (index in [options]) or of true/false
  /// (0 = true, 1 = false).
  final int? correctIndex;

  /// Rows of a "Match the following", each left item with its right match.
  final List<MatchPair> pairs;

  /// The expected answer of a fill-in-the-blank (or a short model answer).
  final String answer;

  @override
  List<Object?> get props => [
    text,
    marks,
    type,
    options,
    correctIndex,
    pairs,
    answer,
  ];
}

class ExamPaper extends Equatable {
  const ExamPaper({
    required this.id,
    required this.title,
    required this.subject,
    required this.classSection,
    required this.date,
    required this.durationMinutes,
    required this.questions,
    required this.status,
    this.createdBy,
    this.instructions = '',
    this.reviewNote,
    this.submittedAt,
    this.kind,
  });

  final String id;
  final String title;
  final String subject;
  final String classSection;
  final DateTime date;
  final int durationMinutes;
  final List<Question> questions;
  final PaperStatus status;

  /// Id of the teacher (or Principal) who set the paper.
  final String? createdBy;

  /// General instructions printed under the heading.
  final String instructions;

  /// Why the Principal sent it back.
  final String? reviewNote;
  final DateTime? submittedAt;

  /// Weekly, unit test, half-yearly...; null for papers made before this.
  final ExamKind? kind;

  int get totalMarks => questions.fold(0, (sum, q) => sum + q.marks);
  bool get isPast => status == PaperStatus.conducted;
  bool get awaitsApproval => status == PaperStatus.submitted;

  /// Still being written (the setter may edit freely).
  bool get isInProgress =>
      status == PaperStatus.draft || status == PaperStatus.changesRequested;

  ExamPaper copyWith({
    String? title,
    PaperStatus? status,
    List<Question>? questions,
    String? instructions,
    String? reviewNote,
    bool clearReviewNote = false,
    DateTime? submittedAt,
  }) => ExamPaper(
    id: id,
    title: title ?? this.title,
    subject: subject,
    classSection: classSection,
    date: date,
    durationMinutes: durationMinutes,
    questions: questions ?? this.questions,
    status: status ?? this.status,
    createdBy: createdBy,
    instructions: instructions ?? this.instructions,
    reviewNote: clearReviewNote ? null : (reviewNote ?? this.reviewNote),
    submittedAt: submittedAt ?? this.submittedAt,
    kind: kind,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    subject,
    classSection,
    date,
    durationMinutes,
    questions,
    status,
    createdBy,
    instructions,
    reviewNote,
    submittedAt,
    kind,
  ];
}
