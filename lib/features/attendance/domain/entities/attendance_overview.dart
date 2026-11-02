import 'package:equatable/equatable.dart';

import 'attendance_status.dart';
import 'class_attendance.dart';
import 'teacher_attendance.dart';

/// Everything the attendance screens need for one day.
class AttendanceOverview extends Equatable {
  const AttendanceOverview({
    required this.dayStatus,
    required this.teachers,
    required this.classes,
  });

  final SchoolDayStatus dayStatus;
  final List<TeacherAttendance> teachers;
  final List<ClassAttendance> classes;

  @override
  List<Object?> get props => [dayStatus, teachers, classes];
}
