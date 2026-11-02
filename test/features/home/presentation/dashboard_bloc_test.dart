import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/usecase/usecase.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';
import 'package:shiksha_setu/features/home/domain/entities/dashboard_summary.dart';
import 'package:shiksha_setu/features/home/domain/usecases/get_dashboard_summary.dart';
import 'package:shiksha_setu/features/home/presentation/bloc/dashboard_bloc.dart';

DashboardSummary _summary(int teachers) => DashboardSummary(
  dayStatus: SchoolDayStatus.approved,
  teachersPresent: teachers,
  teachersTotal: 5,
  classes: const [],
  upcomingExams: const [],
  attention: const [],
);

/// Answers each call from a queue of completers the test controls.
class ControlledSummary implements UseCase<DashboardSummary, DashboardQuery> {
  final calls = <Completer<DashboardSummary>>[];
  final queries = <DashboardQuery>[];

  @override
  Future<DashboardSummary> call(DashboardQuery q) {
    queries.add(q);
    final c = Completer<DashboardSummary>();
    calls.add(c);
    return c.future;
  }
}

void main() {
  final now = DateTime(2026, 9, 30);
  late ControlledSummary summary;

  DashboardBloc build() =>
      DashboardBloc(getDashboardSummary: summary, now: () => now);

  setUp(() => summary = ControlledSummary());

  test('starts in the loading state with no summary', () {
    final bloc = build();

    expect(bloc.state.loading, isTrue);
    expect(bloc.state.summary, isNull);
  });

  blocTest<DashboardBloc, DashboardState>(
    'DashboardRequested: emits the summary and stops loading',
    build: build,
    act: (b) async {
      b.add(const DashboardRequested(includeFees: true));
      await Future<void>.delayed(Duration.zero);
      summary.calls.single.complete(_summary(3));
    },
    expect: () => [DashboardState(loading: false, summary: _summary(3))],
  );

  blocTest<DashboardBloc, DashboardState>(
    'DashboardRequested: passes the time and whether fees are allowed',
    build: build,
    act: (b) async {
      b.add(const DashboardRequested(includeFees: false));
      await Future<void>.delayed(Duration.zero);
      summary.calls.single.complete(_summary(1));
    },
    verify: (_) {
      expect(summary.queries.single.now, now);
      expect(summary.queries.single.includeFees, isFalse);
    },
  );

  blocTest<DashboardBloc, DashboardState>(
    'a slow older request cannot overwrite a newer one',
    build: build,
    act: (b) async {
      b.add(const DashboardRequested(includeFees: true)); // slow
      await Future<void>.delayed(Duration.zero);
      b.add(const DashboardRequested(includeFees: true)); // newer
      await Future<void>.delayed(Duration.zero);

      summary.calls[1].complete(_summary(4)); // newer answers first
      await Future<void>.delayed(Duration.zero);
      summary.calls[0].complete(_summary(1)); // stale answer arrives late
      await Future<void>.delayed(Duration.zero);
    },
    verify: (b) => expect(b.state.summary?.teachersPresent, 4),
  );
}
