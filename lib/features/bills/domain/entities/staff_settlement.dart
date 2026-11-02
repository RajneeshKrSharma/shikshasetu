import 'package:equatable/equatable.dart';

import '../../../fees/domain/entities/fee_payment.dart';

/// A payment made to a staff member for approved bills, with its proof.
class StaffSettlement extends Equatable {
  const StaffSettlement({
    required this.id,
    required this.voucherNo,
    required this.staffId,
    required this.staffName,
    required this.amount,
    required this.paidAt,
    required this.mode,
    required this.paidBy,
    this.reference,
    this.proofPath,
    this.billCount = 0,
  });

  final String id;

  /// "PV-0021".
  final String voucherNo;
  final String staffId;
  final String staffName;
  final int amount;
  final DateTime paidAt;
  final PaymentMode mode;
  final String? reference;
  final String? proofPath;
  final String paidBy;

  /// How many bills it paid.
  final int billCount;

  bool get hasProof => proofPath != null;

  @override
  List<Object?> get props => [
    id,
    voucherNo,
    staffId,
    staffName,
    amount,
    paidAt,
    mode,
    reference,
    proofPath,
    paidBy,
    billCount,
  ];
}

/// What one staff member can be paid now, and what is still waiting.
class StaffPayable extends Equatable {
  const StaffPayable({
    required this.staffId,
    required this.name,
    required this.role,
    required this.payableAmount,
    required this.payableCount,
    required this.waitingCount,
    this.vehicleNumber,
  });

  final String staffId;
  final String name;
  final String role;
  final String? vehicleNumber;

  /// Approved and unpaid.
  final int payableAmount;
  final int payableCount;

  /// Waiting for the Principal's approval.
  final int waitingCount;

  @override
  List<Object?> get props => [
    staffId,
    name,
    role,
    vehicleNumber,
    payableAmount,
    payableCount,
    waitingCount,
  ];
}
