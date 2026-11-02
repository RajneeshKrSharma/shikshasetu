import 'package:equatable/equatable.dart';

import '../../../exams/domain/entities/exam_paper.dart';
import 'bank_scope.dart';
import 'bank_unit.dart';

/// How many questions of one type a paper takes, from which units.
class TypePlan extends Equatable {
  const TypePlan({
    required this.type,
    required this.unitIds,
    required this.count,
    required this.marksEach,
  });

  final QuestionType type;
  final Set<String> unitIds;
  final int count;
  final int marksEach;

  int get marks => count * marksEach;

  TypePlan copyWith({Set<String>? unitIds, int? count, int? marksEach}) =>
      TypePlan(
        type: type,
        unitIds: unitIds ?? this.unitIds,
        count: count ?? this.count,
        marksEach: marksEach ?? this.marksEach,
      );

  @override
  List<Object?> get props => [type, unitIds, count, marksEach];
}

/// How many questions of a type each unit holds.
class TypeAvailability extends Equatable {
  const TypeAvailability({required this.type, required this.perUnit});

  final QuestionType type;
  final Map<String, int> perUnit;

  int get total => perUnit.values.fold(0, (a, b) => a + b);

  @override
  List<Object?> get props => [type, perUnit];
}

/// Everything asked for in a paper made from the bank.
class PaperPlan extends Equatable {
  const PaperPlan({
    required this.kind,
    required this.scope,
    required this.totalMarks,
    required this.minutes,
    required this.date,
    required this.unitIds,
    required this.types,
  });

  final ExamKind kind;
  final BankScope scope;
  final int totalMarks;
  final int minutes;
  final DateTime date;
  final Set<String> unitIds;
  final List<TypePlan> types;

  int get plannedMarks => types.fold(0, (a, t) => a + t.marks);

  @override
  List<Object?> get props => [
    kind,
    scope,
    totalMarks,
    minutes,
    date,
    unitIds,
    types,
  ];
}

/// One question chosen for a paper, with the marks the plan gives it.
class PlannedQuestion extends Equatable {
  const PlannedQuestion({required this.bank, required this.marks});

  final BankQuestion bank;
  final int marks;

  QuestionType get type => bank.question.type;

  @override
  List<Object?> get props => [bank, marks];
}

/// The set made for a plan: in the order of the plan's types, and how many
/// questions of each type the bank could not give.
class PaperSet extends Equatable {
  const PaperSet({this.questions = const [], this.shortBy = const {}});

  final List<PlannedQuestion> questions;
  final Map<QuestionType, int> shortBy;

  int get marks => questions.fold(0, (a, q) => a + q.marks);

  @override
  List<Object?> get props => [questions, shortBy];
}
