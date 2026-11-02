import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/attendance_status.dart';
import '../entities/other_staff_mark.dart';
import '../repository/other_staff_attendance_repository.dart';

class GetOtherStaffAttendance
    implements UseCase<List<OtherStaffMark>, DateTime> {
  const GetOtherStaffAttendance(this._repository);

  final OtherStaffAttendanceRepository _repository;

  @override
  Future<List<OtherStaffMark>> call(DateTime day) => _repository.getForDay(day);
}

class SaveOtherStaffAttendanceParams extends Equatable {
  const SaveOtherStaffAttendanceParams({
    required this.day,
    required this.marks,
  });

  final DateTime day;
  final Map<String, AttendanceStatus> marks;

  @override
  List<Object?> get props => [day, marks];
}

class SaveOtherStaffAttendance
    implements UseCase<void, SaveOtherStaffAttendanceParams> {
  const SaveOtherStaffAttendance(this._repository);

  final OtherStaffAttendanceRepository _repository;

  @override
  Future<void> call(SaveOtherStaffAttendanceParams p) =>
      _repository.save(p.day, p.marks);
}
