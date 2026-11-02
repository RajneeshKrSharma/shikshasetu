import '../../../fees/domain/entities/fee_payment.dart';
import '../entities/bill_drafts.dart';
import '../entities/staff_bill.dart';
import '../entities/staff_settlement.dart';

abstract interface class BillsRepository {
  /// Bills, newest first; of one staff member when [staffId] is given.
  Future<List<StaffBill>> getBills({String? staffId});

  /// Saves a bill as waiting for approval.
  Future<StaffBill> add(BillDraft draft);

  /// The Principal's answer. A bill that is already paid is left as it is.
  Future<void> decide(String billId, BillStatus status, DateTime at);

  /// Every active staff member who has bills, with what can be paid now.
  Future<List<StaffPayable>> getPayables();

  /// Pays [billIds] of one staff member in one go. Throws [SettleException]
  /// when any of them is not approved and unpaid.
  Future<StaffSettlement> settle({
    required String staffId,
    required List<String> billIds,
    required PaymentMode mode,
    required String paidBy,
    required DateTime at,
    String? reference,
    String? proofPath,
  });

  Future<List<StaffSettlement>> getSettlements({String? staffId});
}
