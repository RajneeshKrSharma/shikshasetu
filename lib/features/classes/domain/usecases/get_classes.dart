import '../../../../core/usecase/usecase.dart';
import '../entities/class_summary.dart';
import '../repository/classes_repository.dart';

class GetClasses implements UseCase<List<ClassSummary>, NoParams> {
  const GetClasses(this._repository);

  final ClassesRepository _repository;

  @override
  Future<List<ClassSummary>> call(NoParams params) => _repository.getClasses();
}
