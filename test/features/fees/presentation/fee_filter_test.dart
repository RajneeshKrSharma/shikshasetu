import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_account.dart';
import 'package:shiksha_setu/features/fees/presentation/bloc/fee_filter_cubit.dart';

FeeAccount _acct(
  String name, {
  required String cls,
  required int total,
  int paid = 0,
  required DateTime due,
}) => FeeAccount(
  id: name,
  name: name,
  group: FeeGroup.student,
  personId: name,
  subtitle: cls,
  classSection: cls,
  total: total,
  paid: paid,
  dueDate: due,
);

void main() {
  final now = DateTime(2026, 10, 10);
  final asha = _acct(
    'Asha',
    cls: '5-A',
    total: 1000,
    due: DateTime(2026, 10, 1),
  );
  final ravi = _acct(
    'Ravi',
    cls: '6-B',
    total: 1000,
    paid: 400,
    due: DateTime(2026, 12, 5),
  );
  final meena = _acct(
    'Meena',
    cls: '5-A',
    total: 1000,
    paid: 1000,
    due: DateTime(2026, 12, 5),
  );
  final all = [asha, ravi, meena];
  List<String> names(FeeFilterState f) => [
    for (final a in f.apply(all, now)) a.name,
  ];

  test('no filter: everyone, most urgent first', () {
    expect(names(const FeeFilterState()), ['Asha', 'Ravi', 'Meena']);
  });

  test('several statuses together are OR-ed', () {
    final f = const FeeFilterState().copyWith(
      statuses: {FeeStatus.overdue, FeeStatus.paid},
    );
    expect(names(f), ['Asha', 'Meena']);
  });

  test('class and status are AND-ed; several classes are OR-ed', () {
    final byClass = const FeeFilterState().copyWith(classes: {'5-A'});
    expect(names(byClass), ['Asha', 'Meena']);

    final both = byClass.copyWith(statuses: {FeeStatus.paid});
    expect(names(both), ['Meena']);

    final twoClasses = const FeeFilterState().copyWith(classes: {'5-A', '6-B'});
    expect(names(twoClasses), hasLength(3));
  });

  test('a single day is a valid due-date range', () {
    final f = const FeeFilterState().copyWith(
      dueRange: DateTimeRange(
        start: DateTime(2026, 12, 5),
        end: DateTime(2026, 12, 5),
      ),
    );
    expect(names(f), ['Ravi', 'Meena']);
  });

  test('a longer range includes both end days', () {
    final f = const FeeFilterState().copyWith(
      dueRange: DateTimeRange(
        start: DateTime(2026, 10, 1),
        end: DateTime(2026, 12, 5),
      ),
    );
    expect(names(f), hasLength(3));
  });

  test('search and sort by highest pending', () {
    expect(names(const FeeFilterState(query: 'an')), isEmpty);
    expect(names(const FeeFilterState(query: 'ra')), ['Ravi']);
    final sorted = const FeeFilterState().copyWith(sort: FeeSort.pending);
    expect(names(sorted), ['Asha', 'Ravi', 'Meena']);
  });

  test('activeCount counts filters, not search or sort', () {
    final f = const FeeFilterState(query: 'x').copyWith(
      statuses: {FeeStatus.due},
      classes: {'5-A', '6-B'},
      dueRange: DateTimeRange(start: now, end: now),
    );
    expect(f.activeCount, 4);
  });

  test('cubit: toggling twice removes the filter; clear keeps the sort', () {
    final c = FeeFilterCubit()
      ..toggleStatus(FeeStatus.overdue)
      ..toggleStatus(FeeStatus.overdue)
      ..toggleClass('5-A')
      ..setSort(FeeSort.name);
    expect(c.state.statuses, isEmpty);
    expect(c.state.classes, {'5-A'});

    c.clear();
    expect(c.state.activeCount, 0);
    expect(c.state.sort, FeeSort.name);
  });
}
