import '../../../../core/usecase/usecase.dart';
import '../entities/student.dart';
import '../repository/students_repository.dart';

class GetStudentsByClass implements UseCase<List<Student>, String> {
  const GetStudentsByClass(this._repository);

  final StudentsRepository _repository;

  @override
  Future<List<Student>> call(String classSection) =>
      _repository.getByClass(classSection);
}
