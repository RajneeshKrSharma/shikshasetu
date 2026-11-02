import 'package:equatable/equatable.dart';

import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

enum ExamType {
  unitTest('unit_test'),
  midTerm('mid_term'),
  annual('annual');

  const ExamType(this.code);

  final String code;

  static ExamType fromCode(String? code) {
    for (final t in values) {
      if (t.code == code) return t;
    }
    return ExamType.unitTest;
  }
}

enum QuestionType {
  mcq('mcq'),
  short('short'),
  long('long');

  const QuestionType(this.code);

  final String code;

  static QuestionType fromCode(String? code) {
    for (final t in values) {
      if (t.code == code) return t;
    }
    return QuestionType.short;
  }
}

enum PaperStatus {
  draft('draft'),
  sent('sent'),
  approved('approved'),
  rejected('rejected');

  const PaperStatus(this.code);

  final String code;

  static PaperStatus? fromCode(String? code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return null;
  }
}

class Exam extends Equatable {
  const Exam({
    required this.id,
    required this.type,
    required this.classId,
    required this.className,
    required this.subject,
    required this.heldOn,
    required this.maxMarks,
    required this.teacherId,
    required this.teacherName,
    required this.paperStatus,
  });

  final String id;
  final ExamType type;
  final String classId;
  final String className;
  final String subject;
  final DateTime heldOn;
  final int maxMarks;
  final String? teacherId;
  final String teacherName;
  final PaperStatus? paperStatus;

  @override
  List<Object?> get props => [
    id,
    type,
    classId,
    className,
    subject,
    heldOn,
    maxMarks,
    teacherId,
    teacherName,
    paperStatus,
  ];
}

/// What the Principal fills to schedule an exam; class and subject cannot
/// change once it exists.
class ExamDraft extends Equatable {
  const ExamDraft({
    this.id,
    required this.type,
    this.classId = '',
    this.subject = '',
    required this.heldOn,
    required this.maxMarks,
  });

  final String? id;
  final ExamType type;
  final String classId;
  final String subject;
  final DateTime heldOn;
  final int maxMarks;

  @override
  List<Object?> get props => [id, type, classId, subject, heldOn, maxMarks];
}

class MarkLine extends Equatable {
  const MarkLine({
    required this.studentId,
    required this.name,
    required this.rollNumber,
    required this.marks,
    required this.absent,
    required this.entered,
    required this.percentage,
  });

  final String studentId;
  final String name;
  final String rollNumber;
  final int? marks;
  final bool absent;
  final bool entered;
  final String? percentage;

  @override
  List<Object?> get props => [
    studentId,
    name,
    rollNumber,
    marks,
    absent,
    entered,
    percentage,
  ];
}

class ExamResults extends Equatable {
  const ExamResults({
    required this.entered,
    required this.absent,
    required this.average,
    required this.highest,
    required this.lowest,
    required this.lines,
  });

  final int entered;
  final int absent;
  final String? average;
  final int? highest;
  final int? lowest;
  final List<MarkLine> lines;

  @override
  List<Object?> get props => [entered, absent, average, highest, lowest, lines];
}

class MarkEntry extends Equatable {
  const MarkEntry({required this.studentId, this.marks, this.absent = false});

  final String studentId;
  final int? marks;
  final bool absent;

  @override
  List<Object?> get props => [studentId, marks, absent];
}

class ExamLineResult extends Equatable {
  const ExamLineResult({
    required this.type,
    required this.subject,
    required this.heldOn,
    required this.maxMarks,
    required this.marks,
    required this.absent,
    required this.percentage,
  });

  final ExamType type;
  final String subject;
  final DateTime heldOn;
  final int maxMarks;
  final int? marks;
  final bool absent;
  final String? percentage;

  @override
  List<Object?> get props => [
    type,
    subject,
    heldOn,
    maxMarks,
    marks,
    absent,
    percentage,
  ];
}

/// One student's exams and totals.
class StudentResults extends Equatable {
  const StudentResults({
    required this.totalObtained,
    required this.totalOutOf,
    required this.percentage,
    required this.exams,
  });

  final int totalObtained;
  final int totalOutOf;
  final String? percentage;
  final List<ExamLineResult> exams;

  @override
  List<Object?> get props => [totalObtained, totalOutOf, percentage, exams];
}

// ------------------------------------------------------------ question bank
class QuestionUnit extends Equatable {
  const QuestionUnit({
    required this.id,
    required this.teacherName,
    required this.classId,
    required this.className,
    required this.subject,
    required this.name,
  });

  final String id;
  final String teacherName;
  final String classId;
  final String className;
  final String subject;
  final String name;

  @override
  List<Object?> get props => [
    id,
    teacherName,
    classId,
    className,
    subject,
    name,
  ];
}

class UnitDraft extends Equatable {
  const UnitDraft({
    this.id,
    this.classId = '',
    this.subject = '',
    required this.name,
  });

  final String? id;
  final String classId;
  final String subject;
  final String name;

  @override
  List<Object?> get props => [id, classId, subject, name];
}

class Question extends Equatable {
  const Question({
    required this.id,
    required this.unitId,
    required this.text,
    required this.marks,
    required this.type,
  });

  final String id;
  final String unitId;
  final String text;
  final int marks;
  final QuestionType type;

  @override
  List<Object?> get props => [id, unitId, text, marks, type];
}

class QuestionDraft extends Equatable {
  const QuestionDraft({
    this.id,
    required this.unitId,
    required this.text,
    required this.marks,
    required this.type,
  });

  final String? id;
  final String unitId;
  final String text;
  final int marks;
  final QuestionType type;

  @override
  List<Object?> get props => [id, unitId, text, marks, type];
}

// -------------------------------------------------------------------- paper
class PaperQuestion extends Equatable {
  const PaperQuestion({
    required this.position,
    required this.questionId,
    required this.text,
    required this.marks,
    required this.type,
  });

  final int position;
  final String? questionId;
  final String text;
  final int marks;
  final QuestionType type;

  @override
  List<Object?> get props => [position, questionId, text, marks, type];
}

class Paper extends Equatable {
  const Paper({
    required this.examId,
    required this.status,
    required this.totalMarks,
    required this.preparedByName,
    required this.decisionNote,
    required this.questions,
  });

  final String examId;
  final PaperStatus status;
  final int totalMarks;
  final String preparedByName;
  final String decisionNote;
  final List<PaperQuestion> questions;

  bool get isEditable =>
      status == PaperStatus.draft || status == PaperStatus.rejected;

  @override
  List<Object?> get props => [
    examId,
    status,
    totalMarks,
    preparedByName,
    decisionNote,
    questions,
  ];
}

class ExamsAccess {
  const ExamsAccess._({
    required this.canSchedule,
    required this.canConduct,
    required this.canPrepare,
    required this.canManageBank,
    required this.canSeeResults,
  });

  factory ExamsAccess.of(Account account) => ExamsAccess._(
    canSchedule: account.can(Permission.scheduleExams),
    canConduct: account.canAny(const [
      Permission.conductExams,
      Permission.scheduleExams,
    ]),
    canPrepare: account.can(Permission.prepareQuestions),
    canManageBank: account.can(Permission.manageQuestionBank),
    canSeeResults: account.canAny(const [
      Permission.viewResults,
      Permission.scheduleExams,
      Permission.conductExams,
    ]),
  );

  final bool canSchedule;
  final bool canConduct;
  final bool canPrepare;
  final bool canManageBank;
  final bool canSeeResults;

  bool get canSeeBank => canManageBank || canPrepare;
}
