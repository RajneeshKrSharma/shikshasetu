import '../../../../core/usecase/usecase.dart';
import '../entities/profile_entities.dart';
import '../repository/profiles_repository.dart';

class GetStudentProfile implements UseCase<StudentProfile?, String> {
  const GetStudentProfile(this._repository);

  final ProfilesRepository _repository;

  @override
  Future<StudentProfile?> call(String id) => _repository.student(id);
}

class GetTeacherProfile implements UseCase<TeacherProfile?, String> {
  const GetTeacherProfile(this._repository);

  final ProfilesRepository _repository;

  @override
  Future<TeacherProfile?> call(String id) => _repository.teacher(id);
}
