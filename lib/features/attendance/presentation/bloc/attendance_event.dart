import 'package:equatable/equatable.dart';

import '../../domain/entities/attendance_status.dart';

sealed class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => const [];
}

/// First load of today's attendance.
final class AttendanceStarted extends AttendanceEvent {
  const AttendanceStarted();
}

/// Re-reads today's attendance (after other data changed).
final class AttendanceRefreshed extends AttendanceEvent {
  const AttendanceRefreshed();
}

final class SchoolDayDecided extends AttendanceEvent {
  const SchoolDayDecided({required this.status, required this.decidedBy});

  final SchoolDayStatus status;
  final String decidedBy;

  @override
  List<Object?> get props => [status, decidedBy];
}

final class CheckInRequested extends AttendanceEvent {
  const CheckInRequested(this.teacherId, {this.teacherName = ''});

  final String teacherId;

  /// Shown on the Face ID camera screen.
  final String teacherName;

  @override
  List<Object?> get props => [teacherId, teacherName];
}

final class CheckOutRequested extends AttendanceEvent {
  const CheckOutRequested(this.teacherId, {this.teacherName = ''});

  final String teacherId;

  /// Shown on the Face ID camera screen.
  final String teacherName;

  @override
  List<Object?> get props => [teacherId, teacherName];
}
