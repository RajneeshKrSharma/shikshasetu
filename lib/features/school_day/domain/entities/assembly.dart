import 'package:equatable/equatable.dart';

import 'day_time.dart';

/// When and where the morning assembly is, and what is done in it.
class AssemblySettings extends Equatable {
  const AssemblySettings({
    this.start,
    this.end,
    this.place = '',
    this.days = const {},
    this.order = const [],
  });

  final DayTime? start;
  final DayTime? end;
  final String place;

  /// Weekdays it is held (1 = Monday).
  final Set<int> days;

  /// What is done, in order: prayer, pledge...
  final List<String> order;

  @override
  List<Object?> get props => [start, end, place, days, order];
}

/// Which class, and which teacher, leads the assembly on a weekday.
class AssemblyDuty extends Equatable {
  const AssemblyDuty({
    required this.weekday,
    this.className,
    this.teacherId,
    this.teacherName,
  });

  final int weekday;
  final String? className;
  final String? teacherId;
  final String? teacherName;

  bool get isSet => className != null || teacherId != null;

  @override
  List<Object?> get props => [weekday, className, teacherId, teacherName];
}
