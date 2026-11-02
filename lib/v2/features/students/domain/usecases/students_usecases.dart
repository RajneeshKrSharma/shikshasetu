import 'package:equatable/equatable.dart';

import '../entities/student.dart';
import '../repository/students_repository.dart';
import '../../../../../core/usecase/usecase.dart';

class GetStudentsParams extends Equatable {
  const GetStudentsParams({
    this.classId,
    this.query = '',
    this.onlyActive = true,
  });

  final String? classId;
  final String query;
  final bool onlyActive;

  @override
  List<Object?> get props => [classId, query, onlyActive];
}

class GetStudents implements UseCase<List<Student>, GetStudentsParams> {
  const GetStudents(this._repository);

  final StudentsRepository _repository;

  @override
  Future<List<Student>> call(GetStudentsParams p) => _repository.getStudents(
    classId: p.classId,
    query: p.query.trim(),
    onlyActive: p.onlyActive,
  );
}

class GetStudent implements UseCase<Student, String> {
  const GetStudent(this._repository);

  final StudentsRepository _repository;

  @override
  Future<Student> call(String id) => _repository.getStudent(id);
}

class SaveStudent implements UseCase<Student, StudentDraft> {
  const SaveStudent(this._repository);

  final StudentsRepository _repository;

  @override
  Future<Student> call(StudentDraft d) => _repository.save(
    StudentDraft(
      id: d.id,
      name: d.name.trim(),
      rollNumber: d.rollNumber.trim(),
      classId: d.classId,
      guardianName: d.guardianName.trim(),
      usesVan: d.usesVan,
    ),
  );
}

class SetStudentActiveParams extends Equatable {
  const SetStudentActiveParams(this.id, {required this.active});

  final String id;
  final bool active;

  @override
  List<Object?> get props => [id, active];
}

class SetStudentActive implements UseCase<Student, SetStudentActiveParams> {
  const SetStudentActive(this._repository);

  final StudentsRepository _repository;

  @override
  Future<Student> call(SetStudentActiveParams p) =>
      _repository.setActive(p.id, active: p.active);
}
