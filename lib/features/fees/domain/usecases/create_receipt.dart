import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/fee_account.dart';
import '../entities/fee_payment.dart';
import '../repository/receipt_repository.dart';

class CreateReceiptParams extends Equatable {
  const CreateReceiptParams({
    required this.schoolName,
    required this.account,
    required this.payment,
    required this.allPayments,
  });

  final String schoolName;
  final FeeAccount account;
  final FeePayment payment;

  /// Every payment of the account, used to work out the balance at that time.
  final List<FeePayment> allPayments;

  @override
  List<Object?> get props => [schoolName, account, payment, allPayments];
}

/// Builds a receipt file and returns its path.
class CreateReceipt implements UseCase<String, CreateReceiptParams> {
  const CreateReceipt(this._repository);

  final ReceiptRepository _repository;

  @override
  Future<String> call(CreateReceiptParams p) {
    final paidUpTo = p.allPayments
        .where((x) => !x.paidAt.isAfter(p.payment.paidAt))
        .fold(0, (sum, x) => sum + x.amount);
    return _repository.create(
      schoolName: p.schoolName,
      account: p.account,
      payment: p.payment,
      balanceAfter: p.account.total - paidUpTo,
    );
  }
}
