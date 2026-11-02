import 'package:equatable/equatable.dart';

import '../../../students/domain/entities/student.dart';
import 'attendance_status.dart';

/// A class's roster with today's marks (null until marked).
class ClassAttendance extends Equatable {
  const ClassAttendance({
    required this.className,
    required this.students,
    this.marks,
  });

  final String className;
  final List<Student> students;
  final Map<String, AttendanceStatus>? marks;

  bool get isMarked => marks != null;

  int get presentCount =>
      marks?.values.where((s) => s != AttendanceStatus.absent).length ?? 0;

  @override
  List<Object?> get props => [className, students, marks];
}
