import 'package:equatable/equatable.dart';

import 'attendance_status.dart';

/// One other staff member (driver, helper...) and how they stand for a day.
class OtherStaffMark extends Equatable {
  const OtherStaffMark({
    required this.staffId,
    required this.name,
    required this.role,
    this.status,
  });

  final String staffId;
  final String name;
  final String role;

  /// Null until the Principal has marked the day.
  final AttendanceStatus? status;

  @override
  List<Object?> get props => [staffId, name, role, status];
}
