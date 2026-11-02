import '../../../../core/usecase/usecase.dart';
import '../entities/fee_account.dart';
import '../repository/fees_repository.dart';

class GetFeeAccounts implements UseCase<List<FeeAccount>, NoParams> {
  const GetFeeAccounts(this._repository);

  final FeesRepository _repository;

  @override
  Future<List<FeeAccount>> call(NoParams params) => _repository.getAccounts();
}
