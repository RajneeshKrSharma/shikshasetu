import '../entities/attendance_status.dart';
import '../entities/check_point.dart';
import '../entities/teacher_attendance.dart';

abstract interface class AttendanceRepository {
  Future<SchoolDayStatus> getDayStatus(DateTime day);
  Future<void> setDayStatus(
    DateTime day,
    SchoolDayStatus status,
    String decidedBy,
  );

  /// One entry per active teacher for [day].
  Future<List<TeacherAttendance>> getTeacherRecords(DateTime day);
  Future<void> checkIn(String teacherId, DateTime at, CheckPoint point);
  Future<void> checkOut(String teacherId, DateTime at, CheckPoint point);

  /// [day]'s marks for a class, or null when not marked yet.
  Future<Map<String, AttendanceStatus>?> getClassAttendance(
    String classSection,
    DateTime day,
  );
  Future<void> saveClassAttendance(
    String classSection,
    DateTime day,
    Map<String, AttendanceStatus> marks,
  );
}
