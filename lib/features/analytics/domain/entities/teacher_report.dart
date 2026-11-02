import 'package:equatable/equatable.dart';

class TeacherReport extends Equatable {
  const TeacherReport({
    required this.name,
    required this.presentDays,
    required this.openDays,
    this.avgCheckIn,
  });

  final String name;
  final int presentDays;

  /// School days approved in the reporting window.
  final int openDays;
  final Duration? avgCheckIn;

  double? get attendancePercent =>
      openDays == 0 ? null : presentDays * 100 / openDays;

  @override
  List<Object?> get props => [name, presentDays, openDays, avgCheckIn];
}
