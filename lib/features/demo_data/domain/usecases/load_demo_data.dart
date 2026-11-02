import '../../../../core/usecase/usecase.dart';
import '../repository/demo_data_repository.dart';

class LoadDemoData implements UseCase<void, NoParams> {
  const LoadDemoData(this._repository);

  final DemoDataRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.load();
}
