import 'package:equatable/equatable.dart';

import 'check_point.dart';

class TeacherAttendance extends Equatable {
  const TeacherAttendance({
    required this.teacherId,
    required this.teacherName,
    this.checkIn,
    this.checkOut,
    this.checkInPoint,
    this.checkOutPoint,
  });

  final String teacherId;
  final String teacherName;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final CheckPoint? checkInPoint;
  final CheckPoint? checkOutPoint;

  bool get isCheckedIn => checkIn != null && checkOut == null;
  bool get isPresent => checkIn != null;

  /// Time at school so far, or in total once checked out.
  Duration? workedAt(DateTime now) =>
      checkIn == null ? null : (checkOut ?? now).difference(checkIn!);

  @override
  List<Object?> get props => [
    teacherId,
    teacherName,
    checkIn,
    checkOut,
    checkInPoint,
    checkOutPoint,
  ];
}
