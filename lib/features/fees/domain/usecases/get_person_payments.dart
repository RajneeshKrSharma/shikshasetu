import '../../../../core/usecase/usecase.dart';
import '../entities/fee_payment.dart';
import '../repository/fees_repository.dart';

/// Every payment one person has made, by the fee it was for (account id),
/// newest first.
class GetPersonPayments
    implements UseCase<Map<String, List<FeePayment>>, String> {
  const GetPersonPayments(this._repository);

  final FeesRepository _repository;

  @override
  Future<Map<String, List<FeePayment>>> call(String personId) async {
    final byAccount = <String, List<FeePayment>>{};
    for (final r in await _repository.getPaymentHistory()) {
      if (r.personId == personId) {
        byAccount.putIfAbsent(r.payment.accountId, () => []).add(r.payment);
      }
    }
    return byAccount;
  }
}
