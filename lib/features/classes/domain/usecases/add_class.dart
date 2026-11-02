import '../../../../core/usecase/usecase.dart';
import '../repository/classes_repository.dart';

class AddClass implements UseCase<void, String> {
  const AddClass(this._repository);

  final ClassesRepository _repository;

  @override
  Future<void> call(String name) => _repository.add(name.trim());
}
