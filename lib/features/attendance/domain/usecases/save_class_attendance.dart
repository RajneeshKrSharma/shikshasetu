import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/attendance_status.dart';
import '../repository/attendance_repository.dart';

class SaveClassAttendanceParams extends Equatable {
  const SaveClassAttendanceParams({
    required this.classSection,
    required this.day,
    required this.marks,
  });

  final String classSection;
  final DateTime day;
  final Map<String, AttendanceStatus> marks;

  @override
  List<Object?> get props => [classSection, day, marks];
}

class SaveClassAttendance implements UseCase<void, SaveClassAttendanceParams> {
  const SaveClassAttendance(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<void> call(SaveClassAttendanceParams p) =>
      _repository.saveClassAttendance(p.classSection, p.day, p.marks);
}
