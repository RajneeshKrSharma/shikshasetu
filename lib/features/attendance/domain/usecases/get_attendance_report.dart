import '../../../../core/usecase/usecase.dart';
import '../entities/attendance_record.dart';
import '../repository/attendance_report_repository.dart';

/// The attendance of students, teachers and other staff for one day.
class GetAttendanceReport implements UseCase<List<AttendanceRecord>, DateTime> {
  const GetAttendanceReport(this._repository);

  final AttendanceReportRepository _repository;

  @override
  Future<List<AttendanceRecord>> call(DateTime day) =>
      _repository.getReport(day);
}
