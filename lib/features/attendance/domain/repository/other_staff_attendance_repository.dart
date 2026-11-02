import '../entities/attendance_status.dart';
import '../entities/other_staff_mark.dart';

abstract interface class OtherStaffAttendanceRepository {
  /// Every active staff member, with their mark for [day] (null if none).
  Future<List<OtherStaffMark>> getForDay(DateTime day);

  /// Replaces [day]'s marks with [marks], by staff id.
  Future<void> save(DateTime day, Map<String, AttendanceStatus> marks);
}
