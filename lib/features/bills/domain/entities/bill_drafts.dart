import 'package:equatable/equatable.dart';

import 'staff_bill.dart';

enum BillProblem { amountInvalid, photoMissing }

class BillException implements Exception {
  const BillException(this.problem);

  final BillProblem problem;
}

/// A bill being sent for approval, and what it must have: an amount and a
/// photo of the bill.
class BillDraft extends Equatable {
  const BillDraft({
    required this.staffId,
    required this.kind,
    required this.date,
    required this.amount,
    this.litres,
    this.photoPath,
    this.note = '',
  });

  final String staffId;
  final FuelKind kind;
  final DateTime date;
  final int amount;
  final double? litres;
  final String? photoPath;
  final String note;

  BillProblem? get problem {
    if (amount <= 0) return BillProblem.amountInvalid;
    if (photoPath == null) return BillProblem.photoMissing;
    return null;
  }

  @override
  List<Object?> get props => [
    staffId,
    kind,
    date,
    amount,
    litres,
    photoPath,
    note,
  ];
}

/// Why bills cannot be paid as chosen.
enum SettleProblem { nothingChosen, notApproved }

class SettleException implements Exception {
  const SettleException(this.problem);

  final SettleProblem problem;
}
