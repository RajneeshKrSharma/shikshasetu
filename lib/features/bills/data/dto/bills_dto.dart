/// A row of `staff_bills`, with the staff member's name and van when joined.
class StaffBillDto {
  const StaffBillDto({
    required this.id,
    required this.staffId,
    required this.kind,
    required this.billDate,
    required this.amount,
    required this.status,
    this.staffName = '',
    this.vehicleNumber,
    this.litres,
    this.photoPath,
    this.note,
    this.decidedAt,
    this.settlementId,
  });

  final String id;
  final String staffId;
  final String kind;
  final int billDate;
  final int amount;
  final String status;
  final String staffName;
  final String? vehicleNumber;
  final double? litres;
  final String? photoPath;
  final String? note;
  final int? decidedAt;
  final String? settlementId;

  factory StaffBillDto.fromMap(Map<String, Object?> m) => StaffBillDto(
    id: m['id']! as String,
    staffId: m['staff_id']! as String,
    kind: m['kind']! as String,
    billDate: m['bill_date']! as int,
    amount: m['amount']! as int,
    status: m['status']! as String,
    staffName: (m['staff_name'] as String?) ?? '',
    vehicleNumber: m['vehicle_number'] as String?,
    litres: (m['litres'] as num?)?.toDouble(),
    photoPath: m['photo_path'] as String?,
    note: m['note'] as String?,
    decidedAt: m['decided_at'] as int?,
    settlementId: m['settlement_id'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'staff_id': staffId,
    'kind': kind,
    'bill_date': billDate,
    'litres': litres,
    'amount': amount,
    'photo_path': photoPath,
    'note': note,
    'status': status,
    'decided_at': decidedAt,
    'settlement_id': settlementId,
  };
}

/// A row of `staff_settlements`, with the staff member's name and how many
/// bills it paid when joined.
class StaffSettlementDto {
  const StaffSettlementDto({
    required this.id,
    required this.voucherNo,
    required this.staffId,
    required this.amount,
    required this.paidAt,
    required this.mode,
    required this.paidBy,
    this.staffName = '',
    this.reference,
    this.proofPath,
    this.billCount = 0,
  });

  final String id;
  final String voucherNo;
  final String staffId;
  final int amount;
  final int paidAt;
  final String mode;
  final String paidBy;
  final String staffName;
  final String? reference;
  final String? proofPath;
  final int billCount;

  factory StaffSettlementDto.fromMap(Map<String, Object?> m) =>
      StaffSettlementDto(
        id: m['id']! as String,
        voucherNo: m['voucher_no']! as String,
        staffId: m['staff_id']! as String,
        amount: m['amount']! as int,
        paidAt: m['paid_at']! as int,
        mode: m['mode']! as String,
        paidBy: m['paid_by']! as String,
        staffName: (m['staff_name'] as String?) ?? '',
        reference: m['reference'] as String?,
        proofPath: m['proof_path'] as String?,
        billCount: (m['bill_count'] as int?) ?? 0,
      );

  Map<String, Object?> toMap() => {
    'id': id,
    'voucher_no': voucherNo,
    'staff_id': staffId,
    'amount': amount,
    'paid_at': paidAt,
    'mode': mode,
    'reference': reference,
    'proof_path': proofPath,
    'paid_by': paidBy,
  };
}
