import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/fee_payment.dart';
import '../entities/payment_draft.dart';
import '../repository/fees_repository.dart';

class RecordPaymentParams extends Equatable {
  const RecordPaymentParams({
    required this.accountId,
    required this.amount,
    required this.at,
    this.mode = PaymentMode.cash,
    this.reference,
    this.proofPath,
  });

  final String accountId;
  final int amount;
  final DateTime at;
  final PaymentMode mode;
  final String? reference;
  final String? proofPath;

  @override
  List<Object?> get props => [
    accountId,
    amount,
    at,
    mode,
    reference,
    proofPath,
  ];
}

/// Records a payment, if it is acceptable: a real amount, no more than is
/// owed, and for anything but cash a reference and a photo as proof.
/// Throws [PaymentException] otherwise.
class RecordPayment implements UseCase<FeePayment, RecordPaymentParams> {
  const RecordPayment(this._repository);

  final FeesRepository _repository;

  @override
  Future<FeePayment> call(RecordPaymentParams p) async {
    final account = await _repository.getAccount(p.accountId);
    final draft = PaymentDraft(
      amount: p.amount,
      mode: p.mode,
      reference: p.reference,
      proofPath: p.proofPath,
    );
    final problem = draft.problem(pending: account?.pending ?? 0);
    if (problem != null) throw PaymentException(problem);
    return _repository.recordPayment(
      accountId: p.accountId,
      amount: p.amount,
      at: p.at,
      mode: p.mode,
      reference: p.reference,
      proofPath: p.proofPath,
    );
  }
}
