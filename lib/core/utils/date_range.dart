import 'package:flutter/material.dart' show DateTimeRange;

/// Ready-made ranges for filters. A range covers whole days: it runs from the
/// start of its first day to the end of its last, so a single day works.
class DateRanges {
  DateRanges._();

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTimeRange today(DateTime now) =>
      DateTimeRange(start: _day(now), end: _day(now));

  /// Monday to Sunday of the week containing [now].
  static DateTimeRange thisWeek(DateTime now) {
    final monday = _day(now).subtract(Duration(days: now.weekday - 1));
    return DateTimeRange(
      start: monday,
      end: monday.add(const Duration(days: 6)),
    );
  }

  static DateTimeRange thisMonth(DateTime now) => DateTimeRange(
    start: DateTime(now.year, now.month),
    end: DateTime(now.year, now.month + 1, 0),
  );

  /// Is [t] on one of the days of [range]?
  static bool contains(DateTimeRange range, DateTime t) {
    final d = _day(t);
    return !d.isBefore(_day(range.start)) && !d.isAfter(_day(range.end));
  }
}
