import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/utils/date_range.dart';

void main() {
  // Thursday.
  final now = DateTime(2026, 10, 1, 15, 30);

  test('today is one whole day', () {
    final r = DateRanges.today(now);
    expect(DateRanges.contains(r, DateTime(2026, 10, 1, 0, 0)), isTrue);
    expect(DateRanges.contains(r, DateTime(2026, 10, 1, 23, 59)), isTrue);
    expect(DateRanges.contains(r, DateTime(2026, 10, 2)), isFalse);
  });

  test('this week runs Monday to Sunday', () {
    final r = DateRanges.thisWeek(now);
    expect(r.start, DateTime(2026, 9, 28));
    expect(r.end, DateTime(2026, 10, 4));
  });

  test('this month runs first to last day', () {
    final r = DateRanges.thisMonth(now);
    expect(
      r,
      DateTimeRange(start: DateTime(2026, 10), end: DateTime(2026, 10, 31)),
    );
  });
}
