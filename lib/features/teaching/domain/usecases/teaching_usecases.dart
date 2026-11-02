import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/teaching_assignment.dart';
import '../repository/teaching_repository.dart';

class GetTeachingAssignments
    implements UseCase<List<TeachingAssignment>, NoParams> {
  const GetTeachingAssignments(this._repository);

  final TeachingRepository _repository;

  @override
  Future<List<TeachingAssignment>> call(NoParams params) =>
      _repository.getAll();
}

class TeachingParams extends Equatable {
  const TeachingParams({
    required this.teacherId,
    required this.className,
    required this.subject,
  });

  final String teacherId;
  final String className;
  final String subject;

  @override
  List<Object?> get props => [teacherId, className, subject];
}

class RequestSubject implements UseCase<void, TeachingParams> {
  const RequestSubject(this._repository);

  final TeachingRepository _repository;

  @override
  Future<void> call(TeachingParams p) => _repository.request(
    teacherId: p.teacherId,
    className: p.className,
    subject: p.subject,
  );
}

class AllotSubject implements UseCase<void, TeachingParams> {
  const AllotSubject(this._repository);

  final TeachingRepository _repository;

  @override
  Future<void> call(TeachingParams p) => _repository.allot(
    teacherId: p.teacherId,
    className: p.className,
    subject: p.subject,
  );
}

class RemoveTeachingAssignment implements UseCase<void, String> {
  const RemoveTeachingAssignment(this._repository);

  final TeachingRepository _repository;

  @override
  Future<void> call(String id) => _repository.remove(id);
}
