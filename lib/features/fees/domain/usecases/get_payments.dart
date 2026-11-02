import '../../../../core/usecase/usecase.dart';
import '../entities/fee_payment.dart';
import '../repository/fees_repository.dart';

class GetPayments implements UseCase<List<FeePayment>, String> {
  const GetPayments(this._repository);

  final FeesRepository _repository;

  @override
  Future<List<FeePayment>> call(String accountId) =>
      _repository.getPayments(accountId);
}
