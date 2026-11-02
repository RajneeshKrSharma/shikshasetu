import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/staff_repository.dart';

class AssignClassTeacherParams extends Equatable {
  const AssignClassTeacherParams(this.staffId, this.classSection);

  final String staffId;

  /// Null removes the teacher's current class.
  final String? classSection;

  @override
  List<Object?> get props => [staffId, classSection];
}

class AssignClassTeacher implements UseCase<void, AssignClassTeacherParams> {
  const AssignClassTeacher(this._repository);

  final StaffRepository _repository;

  @override
  Future<void> call(AssignClassTeacherParams p) =>
      _repository.assignClass(p.staffId, p.classSection);
}
