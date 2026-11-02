import 'package:equatable/equatable.dart';

import 'day_time.dart';

/// A timing for some classes, or from a date, instead of the school's own.
class TimingRule extends Equatable {
  const TimingRule({
    required this.id,
    required this.start,
    required this.end,
    this.classNames = const [],
    this.fromDate,
  });

  final String id;
  final DayTime start;
  final DayTime end;

  /// The classes it is for; none means every class.
  final List<String> classNames;

  /// A seasonal timing starts on this day.
  final DateTime? fromDate;

  bool get isSeasonal => fromDate != null;

  @override
  List<Object?> get props => [id, start, end, classNames, fromDate];
}

/// When the school starts and ends, on which days, and any other timings.
class SchoolTiming extends Equatable {
  const SchoolTiming({
    this.start,
    this.end,
    this.workingDays = const {},
    this.rules = const [],
  });

  /// Null until the Principal sets them.
  final DayTime? start;
  final DayTime? end;

  /// Weekdays the school is open (1 = Monday ... 7 = Sunday).
  final Set<int> workingDays;
  final List<TimingRule> rules;

  List<TimingRule> get classRules => [
    for (final r in rules)
      if (!r.isSeasonal) r,
  ];

  List<TimingRule> get seasonalRules => [
    for (final r in rules)
      if (r.isSeasonal) r,
  ];

  @override
  List<Object?> get props => [start, end, workingDays, rules];
}
