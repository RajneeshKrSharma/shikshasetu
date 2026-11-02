import 'package:equatable/equatable.dart';

import '../../../exams/domain/entities/exam_paper.dart';
import 'bank_scope.dart';

/// A unit (chapter) of a bank: where its questions are kept.
class BankUnit extends Equatable {
  const BankUnit({
    required this.id,
    required this.scope,
    required this.name,
    required this.position,
  });

  final String id;
  final BankScope scope;
  final String name;
  final int position;

  @override
  List<Object?> get props => [id, scope, name, position];
}

/// A question kept in a unit.
class BankQuestion extends Equatable {
  const BankQuestion({
    required this.id,
    required this.unitId,
    required this.question,
    required this.createdAt,
  });

  final String id;
  final String unitId;
  final Question question;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, unitId, question, createdAt];
}

/// A unit with how many questions of each type it holds.
class UnitSummary extends Equatable {
  const UnitSummary({required this.unit, required this.counts});

  final BankUnit unit;
  final Map<QuestionType, int> counts;

  int get total => counts.values.fold(0, (a, b) => a + b);

  /// The types it holds, most numerous first.
  List<MapEntry<QuestionType, int>> get byCount =>
      counts.entries.where((e) => e.value > 0).toList()
        ..sort((a, b) => b.value.compareTo(a.value));

  @override
  List<Object?> get props => [unit, counts];
}

/// Everything in one bank.
class BankOverview extends Equatable {
  const BankOverview({required this.scope, required this.units});

  final BankScope scope;
  final List<UnitSummary> units;

  int get total => units.fold(0, (a, u) => a + u.total);

  @override
  List<Object?> get props => [scope, units];
}
