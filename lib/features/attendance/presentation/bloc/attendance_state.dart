import 'package:equatable/equatable.dart';

import '../../../students/domain/entities/student.dart';
import '../../domain/entities/attendance_overview.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/entities/check_result.dart';
import '../../domain/entities/class_attendance.dart';
import '../../domain/entities/teacher_attendance.dart';

/// Why a check-in/out was refused. [id] changes each time so that listeners
/// fire again even for the same reason.
class CheckProblem extends Equatable {
  const CheckProblem({required this.failure, required this.id, this.distance});

  final CheckFailure failure;
  final int id;
  final double? distance;

  @override
  List<Object?> get props => [failure, id, distance];
}

class AttendanceState extends Equatable {
  const AttendanceState({
    this.loading = true,
    this.overview,
    this.checking = false,
    this.problem,
  });

  final bool loading;
  final AttendanceOverview? overview;

  /// A check-in/out is being verified (location + selfie).
  final bool checking;
  final CheckProblem? problem;

  SchoolDayStatus get dayStatus =>
      overview?.dayStatus ?? SchoolDayStatus.pending;
  bool get isSchoolOpen => dayStatus == SchoolDayStatus.approved;
  List<TeacherAttendance> get teachers => overview?.teachers ?? const [];
  List<ClassAttendance> get classes => overview?.classes ?? const [];

  int get teachersPresent => teachers.where((t) => t.isPresent).length;
  int get classesMarked => classes.where((c) => c.isMarked).length;

  TeacherAttendance? recordOf(String teacherId) {
    for (final t in teachers) {
      if (t.teacherId == teacherId) return t;
    }
    return null;
  }

  ClassAttendance? classOf(String name) {
    for (final c in classes) {
      if (c.className == name) return c;
    }
    return null;
  }

  List<Student> studentsOf(String name) => classOf(name)?.students ?? const [];
  Map<String, AttendanceStatus>? marksOf(String name) => classOf(name)?.marks;

  /// Present + late count across every class marked today.
  ({int present, int total}) get studentTotals {
    var present = 0;
    var total = 0;
    for (final c in classes.where((c) => c.isMarked)) {
      total += c.marks!.length;
      present += c.presentCount;
    }
    return (present: present, total: total);
  }

  AttendanceState copyWith({
    bool? loading,
    AttendanceOverview? overview,
    bool? checking,
    CheckProblem? problem,
    bool clearProblem = false,
  }) => AttendanceState(
    loading: loading ?? this.loading,
    overview: overview ?? this.overview,
    checking: checking ?? this.checking,
    problem: clearProblem ? null : (problem ?? this.problem),
  );

  @override
  List<Object?> get props => [loading, overview, checking, problem];
}
