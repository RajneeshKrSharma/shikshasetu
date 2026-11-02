import '../../../../core/usecase/usecase.dart';
import '../../../classes/domain/repository/classes_repository.dart';
import '../../../students/domain/repository/students_repository.dart';
import '../entities/attendance_overview.dart';
import '../entities/class_attendance.dart';
import '../repository/attendance_repository.dart';

/// Loads the day's status, teacher check-ins and every class's marks.
class GetAttendanceOverview implements UseCase<AttendanceOverview, DateTime> {
  const GetAttendanceOverview(this._attendance, this._classes, this._students);

  final AttendanceRepository _attendance;
  final ClassesRepository _classes;
  final StudentsRepository _students;

  @override
  Future<AttendanceOverview> call(DateTime day) async {
    final dayStatus = await _attendance.getDayStatus(day);
    final teachers = await _attendance.getTeacherRecords(day);
    final classes = <ClassAttendance>[];
    for (final c in await _classes.getClasses()) {
      classes.add(
        ClassAttendance(
          className: c.name,
          students: await _students.getByClass(c.name),
          marks: await _attendance.getClassAttendance(c.name, day),
        ),
      );
    }
    return AttendanceOverview(
      dayStatus: dayStatus,
      teachers: teachers,
      classes: classes,
    );
  }
}
