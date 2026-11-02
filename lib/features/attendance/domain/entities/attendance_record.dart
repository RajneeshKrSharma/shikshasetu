import 'package:equatable/equatable.dart';

import 'teacher_attendance.dart';

/// Whose attendance a row of the report is, and the ways someone in that
/// group can stand for the day.
enum AttendanceGroup {
  student([
    AttendanceMark.present,
    AttendanceMark.absent,
    AttendanceMark.late,
    AttendanceMark.notMarked,
  ]),
  teacher([AttendanceMark.present, AttendanceMark.absent]),
  other([
    AttendanceMark.present,
    AttendanceMark.absent,
    AttendanceMark.late,
    AttendanceMark.notMarked,
  ]);

  const AttendanceGroup(this.marks);

  /// The tabs of this group's attendance, in order.
  final List<AttendanceMark> marks;
}

/// How a person stands for the day.
enum AttendanceMark {
  present,
  late,
  absent,

  /// A student whose class, or a staff member who, has not been marked yet.
  notMarked,
}

/// One person's attendance on one day, for the report.
class AttendanceRecord extends Equatable {
  const AttendanceRecord({
    required this.id,
    required this.name,
    required this.group,
    required this.detail,
    required this.mark,
    this.checkIn,
    this.checkOut,
    this.teacher,
  });

  final String id;
  final String name;
  final AttendanceGroup group;

  /// Class for a student, subject for a teacher, role for other staff.
  final String detail;
  final AttendanceMark mark;

  /// A teacher's check-in and check-out that day.
  final DateTime? checkIn;
  final DateTime? checkOut;

  /// A teacher's whole check-in record, with where and how they checked in.
  final TeacherAttendance? teacher;

  @override
  List<Object?> get props => [
    id,
    name,
    group,
    detail,
    mark,
    checkIn,
    checkOut,
    teacher,
  ];
}
