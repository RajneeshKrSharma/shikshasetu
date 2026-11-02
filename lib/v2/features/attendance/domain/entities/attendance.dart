import 'package:equatable/equatable.dart';

import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

/// How a student was marked for a day.
enum StudentMark {
  present('present'),
  late('late'),
  absent('absent');

  const StudentMark(this.code);

  final String code;

  static StudentMark? fromCode(String? code) {
    for (final m in values) {
      if (m.code == code) return m;
    }
    return null;
  }
}

/// A student on the class list, with the mark for the day (none yet).
class RosterLine extends Equatable {
  const RosterLine({
    required this.studentId,
    required this.name,
    required this.rollNumber,
    required this.mark,
  });

  final String studentId;
  final String name;
  final String rollNumber;
  final StudentMark? mark;

  RosterLine marked(StudentMark? next) => RosterLine(
    studentId: studentId,
    name: name,
    rollNumber: rollNumber,
    mark: next,
  );

  @override
  List<Object?> get props => [studentId, name, rollNumber, mark];
}

/// A student's days over a period.
class StudentTally extends Equatable {
  const StudentTally({
    required this.studentId,
    required this.name,
    required this.rollNumber,
    required this.present,
    required this.late,
    required this.absent,
  });

  final String studentId;
  final String name;
  final String rollNumber;
  final int present;
  final int late;
  final int absent;

  @override
  List<Object?> get props => [
    studentId,
    name,
    rollNumber,
    present,
    late,
    absent,
  ];
}

/// How a teacher's or staff member's day looks.
enum DayStatus {
  present('present'),
  late('late'),
  absent('absent'),
  leave('leave'),
  holiday('holiday'),
  notInYet('not_in_yet');

  const DayStatus(this.code);

  final String code;

  static DayStatus fromCode(String? code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return DayStatus.absent;
  }
}

/// One day's check-in and check-out of a person (minutes since midnight).
class WorkRecord extends Equatable {
  const WorkRecord({
    required this.id,
    required this.personId,
    required this.personName,
    required this.day,
    required this.checkedInAt,
    required this.checkedOutAt,
    required this.late,
    required this.corrected,
  });

  final String id;
  final String personId;
  final String personName;
  final DateTime day;
  final int checkedInAt;
  final int? checkedOutAt;
  final bool late;
  final bool corrected;

  @override
  List<Object?> get props => [
    id,
    personId,
    personName,
    day,
    checkedInAt,
    checkedOutAt,
    late,
    corrected,
  ];
}

class BoardLine extends Equatable {
  const BoardLine({
    required this.personId,
    required this.name,
    required this.role,
    required this.status,
    required this.checkedInAt,
    required this.checkedOutAt,
  });

  final String personId;
  final String name;
  final String role;
  final DayStatus status;
  final int? checkedInAt;
  final int? checkedOutAt;

  @override
  List<Object?> get props => [
    personId,
    name,
    role,
    status,
    checkedInAt,
    checkedOutAt,
  ];
}

class DayBoard extends Equatable {
  const DayBoard({
    required this.day,
    required this.isHoliday,
    required this.people,
  });

  final DateTime day;
  final bool isHoliday;
  final List<BoardLine> people;

  @override
  List<Object?> get props => [day, isHoliday, people];
}

class CorrectionDraft extends Equatable {
  const CorrectionDraft({
    required this.personId,
    required this.day,
    required this.checkedInAt,
    this.checkedOutAt,
  });

  final String personId;
  final DateTime day;
  final int checkedInAt;
  final int? checkedOutAt;

  @override
  List<Object?> get props => [personId, day, checkedInAt, checkedOutAt];
}

class AttendanceAccess {
  const AttendanceAccess._({
    required this.canMarkStudents,
    required this.canViewStudents,
    required this.canRecordOwn,
    required this.canViewPeople,
    required this.canCorrect,
  });

  factory AttendanceAccess.of(Account account) => AttendanceAccess._(
    canMarkStudents: account.can(Permission.markStudentAttendance),
    canViewStudents: account.canAny(const [
      Permission.markStudentAttendance,
      Permission.viewAttendance,
    ]),
    canRecordOwn: account.can(Permission.recordOwnAttendance),
    canViewPeople: account.can(Permission.viewAttendance),
    canCorrect: account.can(Permission.correctAttendance),
  );

  final bool canMarkStudents;
  final bool canViewStudents;
  final bool canRecordOwn;
  final bool canViewPeople;
  final bool canCorrect;
}
