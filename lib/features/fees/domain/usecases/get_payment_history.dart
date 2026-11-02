import '../../../../core/usecase/usecase.dart';
import '../entities/fee_payment_record.dart';
import '../repository/fees_repository.dart';

class GetPaymentHistory implements UseCase<List<FeePaymentRecord>, NoParams> {
  const GetPaymentHistory(this._repository);

  final FeesRepository _repository;

  @override
  Future<List<FeePaymentRecord>> call(NoParams params) =>
      _repository.getPaymentHistory();
}
