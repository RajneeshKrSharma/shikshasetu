import '../../../fees/domain/entities/fee_payment.dart';
import '../../domain/entities/staff_bill.dart';
import '../../domain/entities/staff_settlement.dart';
import '../dto/bills_dto.dart';

class StaffBillModel extends StaffBill {
  const StaffBillModel({
    required super.id,
    required super.staffId,
    required super.staffName,
    required super.kind,
    required super.date,
    required super.amount,
    required super.status,
    super.vehicleNumber,
    super.litres,
    super.photoPath,
    super.note,
    super.settlementId,
  });

  factory StaffBillModel.fromDto(StaffBillDto d) => StaffBillModel(
    id: d.id,
    staffId: d.staffId,
    staffName: d.staffName,
    vehicleNumber: (d.vehicleNumber?.isEmpty ?? true) ? null : d.vehicleNumber,
    kind: FuelKind.values.byName(d.kind),
    date: DateTime.fromMillisecondsSinceEpoch(d.billDate),
    litres: d.litres,
    amount: d.amount,
    photoPath: d.photoPath,
    note: d.note ?? '',
    status: BillStatus.values.byName(d.status),
    settlementId: d.settlementId,
  );
}

class StaffSettlementModel extends StaffSettlement {
  const StaffSettlementModel({
    required super.id,
    required super.voucherNo,
    required super.staffId,
    required super.staffName,
    required super.amount,
    required super.paidAt,
    required super.mode,
    required super.paidBy,
    super.reference,
    super.proofPath,
    super.billCount,
  });

  factory StaffSettlementModel.fromDto(StaffSettlementDto d) =>
      StaffSettlementModel(
        id: d.id,
        voucherNo: d.voucherNo,
        staffId: d.staffId,
        staffName: d.staffName,
        amount: d.amount,
        paidAt: DateTime.fromMillisecondsSinceEpoch(d.paidAt),
        mode: PaymentMode.values.byName(d.mode),
        paidBy: d.paidBy,
        reference: d.reference,
        proofPath: d.proofPath,
        billCount: d.billCount,
      );
}
