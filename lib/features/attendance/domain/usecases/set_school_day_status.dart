import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/attendance_status.dart';
import '../repository/attendance_repository.dart';

class SetSchoolDayStatusParams extends Equatable {
  const SetSchoolDayStatusParams({
    required this.day,
    required this.status,
    required this.decidedBy,
  });

  final DateTime day;
  final SchoolDayStatus status;
  final String decidedBy;

  @override
  List<Object?> get props => [day, status, decidedBy];
}

class SetSchoolDayStatus implements UseCase<void, SetSchoolDayStatusParams> {
  const SetSchoolDayStatus(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<void> call(SetSchoolDayStatusParams p) =>
      _repository.setDayStatus(p.day, p.status, p.decidedBy);
}
