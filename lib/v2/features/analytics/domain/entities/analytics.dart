import 'package:equatable/equatable.dart';

import '../../../../core/money.dart';
import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

/// The graphs the school can see. Each knows where its data lives and whether
/// it can be narrowed to one class.
enum GraphKind {
  studentAttendance('/analytics/students/attendance/', byClass: true),
  fees('/analytics/students/fees/'),
  exams('/analytics/students/exams/', byClass: true),
  staffAttendance('/analytics/staff/attendance/'),
  payments('/analytics/staff/payments/'),
  fuel('/analytics/staff/fuel/'),
  lessons('/analytics/teachers/lessons/');

  const GraphKind(this.path, {this.byClass = false});

  final String path;
  final bool byClass;
}

/// What a series shows, so the screen can name it.
enum SeriesId {
  attendancePercent,
  feesCollected,
  feesBalanceByClass,
  examAverage,
  staffPresent,
  staffAbsent,
  paidOut,
  fuelAmount,
  fuelMileage,
  lessonsPercent,
}

enum SummaryId { collected, balance, owed, paid }

enum SeriesShape { line, bar }

class ChartPoint extends Equatable {
  const ChartPoint({required this.label, required this.value, this.at});

  /// Shown under the point when [at] is null.
  final String label;
  final double value;

  /// The day or month of the point, when it is one.
  final DateTime? at;

  @override
  List<Object?> get props => [label, value, at];
}

class ChartSeries extends Equatable {
  const ChartSeries({
    required this.id,
    required this.shape,
    required this.points,
    this.isMoney = false,
  });

  final SeriesId id;
  final SeriesShape shape;
  final List<ChartPoint> points;
  final bool isMoney;

  @override
  List<Object?> get props => [id, shape, points, isMoney];
}

class SummaryItem extends Equatable {
  const SummaryItem(this.id, this.value);

  final SummaryId id;

  final Money value;

  @override
  List<Object?> get props => [id, value];
}

class GraphData extends Equatable {
  const GraphData({required this.series, this.summary = const []});

  final List<ChartSeries> series;
  final List<SummaryItem> summary;

  bool get isEmpty => series.every((s) => s.points.isEmpty);

  @override
  List<Object?> get props => [series, summary];
}

class AnalyticsAccess {
  const AnalyticsAccess._(this.canSee);

  factory AnalyticsAccess.of(Account account) =>
      AnalyticsAccess._(account.can(Permission.viewAnalytics));

  final bool canSee;
}
