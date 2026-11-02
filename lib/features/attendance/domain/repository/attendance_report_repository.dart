import '../entities/attendance_record.dart';

abstract interface class AttendanceReportRepository {
  /// Every student, active teacher and other staff member registered by the
  /// end of [day], with how each stood that day.
  Future<List<AttendanceRecord>> getReport(DateTime day);
}
