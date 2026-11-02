import 'package:equatable/equatable.dart';

enum FuelKind { petrol, diesel }

/// The Principal's answer to a bill.
enum BillStatus { pending, approved, rejected }

/// Where a bill stands, for a list: waiting, approved, turned down, or paid.
enum BillPhase { pending, approved, rejected, paid }

class StaffBill extends Equatable {
  const StaffBill({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.kind,
    required this.date,
    required this.amount,
    required this.status,
    this.vehicleNumber,
    this.litres,
    this.photoPath,
    this.note = '',
    this.settlementId,
  });

  final String id;
  final String staffId;
  final String staffName;
  final String? vehicleNumber;
  final FuelKind kind;
  final DateTime date;
  final double? litres;
  final int amount;
  final String? photoPath;
  final String note;
  final BillStatus status;

  /// The payment that settled it, once paid.
  final String? settlementId;

  bool get isPaid => settlementId != null;

  /// Approved and not yet paid: the only bills that can be paid.
  bool get isPayable => status == BillStatus.approved && !isPaid;

  BillPhase get phase => isPaid
      ? BillPhase.paid
      : switch (status) {
          BillStatus.pending => BillPhase.pending,
          BillStatus.approved => BillPhase.approved,
          BillStatus.rejected => BillPhase.rejected,
        };

  @override
  List<Object?> get props => [
    id,
    staffId,
    staffName,
    vehicleNumber,
    kind,
    date,
    litres,
    amount,
    photoPath,
    note,
    status,
    settlementId,
  ];
}
