import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../fees/domain/entities/fee_payment.dart';
import '../../../fees/domain/entities/payment_draft.dart';
import '../entities/bill_drafts.dart';
import '../entities/staff_bill.dart';
import '../entities/staff_settlement.dart';
import '../repository/bills_repository.dart';

/// Bills of one staff member, or of everyone when the id is null.
class GetBills implements UseCase<List<StaffBill>, String?> {
  const GetBills(this._repository);

  final BillsRepository _repository;

  @override
  Future<List<StaffBill>> call(String? staffId) =>
      _repository.getBills(staffId: staffId);
}

/// Sends a bill for approval, if it has an amount and a photo of the bill.
/// Throws [BillException] otherwise.
class AddBill implements UseCase<StaffBill, BillDraft> {
  const AddBill(this._repository);

  final BillsRepository _repository;

  @override
  Future<StaffBill> call(BillDraft draft) {
    final problem = draft.problem;
    if (problem != null) throw BillException(problem);
    return _repository.add(draft);
  }
}

class GetStaffPayables implements UseCase<List<StaffPayable>, NoParams> {
  const GetStaffPayables(this._repository);

  final BillsRepository _repository;

  @override
  Future<List<StaffPayable>> call(NoParams params) => _repository.getPayables();
}

class SettleBillsParams extends Equatable {
  const SettleBillsParams({
    required this.staffId,
    required this.bills,
    required this.mode,
    required this.paidBy,
    required this.at,
    this.reference,
    this.proofPath,
  });

  final String staffId;

  /// The bills being paid, as they are now.
  final List<StaffBill> bills;
  final PaymentMode mode;
  final String paidBy;
  final DateTime at;
  final String? reference;
  final String? proofPath;

  @override
  List<Object?> get props => [
    staffId,
    bills,
    mode,
    paidBy,
    at,
    reference,
    proofPath,
  ];
}

/// Pays bills, if every one is approved and unpaid, and the payment has what
/// any payment needs: a reference and a photo of the proof for anything but
/// cash. Throws [SettleException] or [PaymentException] otherwise.
class SettleBills implements UseCase<StaffSettlement, SettleBillsParams> {
  const SettleBills(this._repository);

  final BillsRepository _repository;

  @override
  Future<StaffSettlement> call(SettleBillsParams p) {
    if (p.bills.isEmpty) {
      throw const SettleException(SettleProblem.nothingChosen);
    }
    if (p.bills.any((b) => !b.isPayable)) {
      throw const SettleException(SettleProblem.notApproved);
    }
    final total = p.bills.fold(0, (s, b) => s + b.amount);
    final problem = PaymentDraft(
      amount: total,
      mode: p.mode,
      reference: p.reference,
      proofPath: p.proofPath,
    ).problem(pending: total);
    if (problem != null) throw PaymentException(problem);
    return _repository.settle(
      staffId: p.staffId,
      billIds: [for (final b in p.bills) b.id],
      mode: p.mode,
      paidBy: p.paidBy,
      at: p.at,
      reference: p.reference,
      proofPath: p.proofPath,
    );
  }
}

class GetSettlements implements UseCase<List<StaffSettlement>, String?> {
  const GetSettlements(this._repository);

  final BillsRepository _repository;

  @override
  Future<List<StaffSettlement>> call(String? staffId) =>
      _repository.getSettlements(staffId: staffId);
}
