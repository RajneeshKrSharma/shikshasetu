import 'package:equatable/equatable.dart';

class ClassAnalytics extends Equatable {
  const ClassAnalytics({
    required this.attendanceTrend,
    required this.subjectAverages,
  });

  /// Attendance percentage for each of the last 7 days, oldest first. A day
  /// with no attendance marked is null.
  final List<double?> attendanceTrend;

  /// Average marks percentage per subject, from recorded exam marks.
  final Map<String, double> subjectAverages;

  bool get hasAttendance => attendanceTrend.any((v) => v != null);

  @override
  List<Object?> get props => [attendanceTrend, subjectAverages];
}
