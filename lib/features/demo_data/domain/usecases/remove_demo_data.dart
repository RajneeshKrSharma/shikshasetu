import '../../../../core/usecase/usecase.dart';
import '../repository/demo_data_repository.dart';

class RemoveDemoData implements UseCase<void, NoParams> {
  const RemoveDemoData(this._repository);

  final DemoDataRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.remove();
}
