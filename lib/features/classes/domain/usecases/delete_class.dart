import '../../../../core/usecase/usecase.dart';
import '../repository/classes_repository.dart';

class DeleteClass implements UseCase<void, String> {
  const DeleteClass(this._repository);

  final ClassesRepository _repository;

  @override
  Future<void> call(String name) => _repository.delete(name);
}
