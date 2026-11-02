import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/attendance_record.dart';
import '../../domain/usecases/get_attendance_report.dart';

sealed class AttendanceReportEvent extends Equatable {
  const AttendanceReportEvent();

  @override
  List<Object?> get props => const [];
}

final class ReportStarted extends AttendanceReportEvent {
  const ReportStarted();
}

final class ReportDayChosen extends AttendanceReportEvent {
  const ReportDayChosen(this.day);

  final DateTime day;

  @override
  List<Object?> get props => [day];
}

/// Students, teachers or others; null is all of them.
final class ReportGroupChosen extends AttendanceReportEvent {
  const ReportGroupChosen(this.group);

  final AttendanceGroup? group;

  @override
  List<Object?> get props => [group];
}

/// Present, absent...; null is every status.
final class ReportMarkChosen extends AttendanceReportEvent {
  const ReportMarkChosen(this.mark);

  final AttendanceMark? mark;

  @override
  List<Object?> get props => [mark];
}

/// A class, subject or role; null is all.
final class ReportDetailChosen extends AttendanceReportEvent {
  const ReportDetailChosen(this.detail);

  final String? detail;

  @override
  List<Object?> get props => [detail];
}

final class ReportQueryChanged extends AttendanceReportEvent {
  const ReportQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ReportFiltersCleared extends AttendanceReportEvent {
  const ReportFiltersCleared();
}

class AttendanceReportState extends Equatable {
  const AttendanceReportState({
    required this.day,
    this.records = const [],
    this.loading = true,
    this.group,
    this.mark,
    this.detail,
    this.query = '',
    this.lockedGroup,
  });

  final DateTime day;
  final List<AttendanceRecord> records;
  final bool loading;
  final AttendanceGroup? group;
  final AttendanceMark? mark;
  final String? detail;
  final String query;

  /// Set when the report is about one group only (the Students, Teachers or
  /// Others screen), so the group cannot be changed.
  final AttendanceGroup? lockedGroup;

  bool get hasFilters =>
      (lockedGroup == null && group != null) ||
      mark != null ||
      detail != null ||
      query.isNotEmpty;

  /// Rows that pass every filter.
  List<AttendanceRecord> get visible {
    final q = query.trim().toLowerCase();
    return [
      for (final r in records)
        if ((group == null || r.group == group) &&
            (mark == null || r.mark == mark) &&
            (detail == null || r.detail == detail) &&
            (q.isEmpty || r.name.toLowerCase().contains(q)))
          r,
    ];
  }

  /// Rows of the chosen group that pass every filter except the status, so
  /// each status tab can say how many it holds.
  List<AttendanceRecord> get _beforeMark {
    final q = query.trim().toLowerCase();
    return [
      for (final r in records)
        if ((group == null || r.group == group) &&
            (detail == null || r.detail == detail) &&
            (q.isEmpty || r.name.toLowerCase().contains(q)))
          r,
    ];
  }

  /// How many rows each status tab holds; null counts all of them.
  int countOfMark(AttendanceMark? m) => m == null
      ? _beforeMark.length
      : _beforeMark.where((r) => r.mark == m).length;

  /// How many people each group has (before the other filters).
  int countOf(AttendanceGroup? g) =>
      g == null ? records.length : records.where((r) => r.group == g).length;

  /// The classes, subjects or roles of the chosen group, to filter by.
  List<String> get details {
    final set = <String>{
      for (final r in records)
        if ((group == null || r.group == group) && r.detail.isNotEmpty)
          r.detail,
    };
    return set.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  /// The statuses that someone in the chosen group has, in a fixed order.
  List<AttendanceMark> get marks => [
    for (final m in AttendanceMark.values)
      if (records.any(
        (r) => (group == null || r.group == group) && r.mark == m,
      ))
        m,
  ];

  AttendanceReportState copyWith({
    DateTime? day,
    List<AttendanceRecord>? records,
    bool? loading,
    AttendanceGroup? group,
    bool clearGroup = false,
    AttendanceMark? mark,
    bool clearMark = false,
    String? detail,
    bool clearDetail = false,
    String? query,
  }) => AttendanceReportState(
    lockedGroup: lockedGroup,
    day: day ?? this.day,
    records: records ?? this.records,
    loading: loading ?? this.loading,
    group: clearGroup ? null : (group ?? this.group),
    mark: clearMark ? null : (mark ?? this.mark),
    detail: clearDetail ? null : (detail ?? this.detail),
    query: query ?? this.query,
  );

  @override
  List<Object?> get props => [
    day,
    records,
    loading,
    group,
    mark,
    detail,
    query,
    lockedGroup,
  ];
}

/// The attendance report: one day's attendance of students, teachers and
/// other staff, and the filters on it.
class AttendanceReportBloc
    extends Bloc<AttendanceReportEvent, AttendanceReportState> {
  AttendanceReportBloc({
    required GetAttendanceReport getReport,
    AttendanceGroup? lockedGroup,
    DateTime Function()? now,
  }) : _get = getReport,
       _now = now ?? DateTime.now,
       super(
         AttendanceReportState(
           day: _dayOf((now ?? DateTime.now)()),
           group: lockedGroup,
           lockedGroup: lockedGroup,
         ),
       ) {
    on<ReportStarted>((e, emit) => _load(state.day, emit));
    on<ReportDayChosen>((e, emit) => _load(_dayOf(e.day), emit));
    on<ReportGroupChosen>((e, emit) {
      if (state.lockedGroup != null) return;
      emit(
        // The class / subject / role belongs to a group, so it is cleared.
        e.group == null
            ? state.copyWith(clearGroup: true, clearDetail: true)
            : state.copyWith(group: e.group, clearDetail: true),
      );
    });
    on<ReportMarkChosen>(
      (e, emit) => emit(
        e.mark == null
            ? state.copyWith(clearMark: true)
            : state.copyWith(mark: e.mark),
      ),
    );
    on<ReportDetailChosen>(
      (e, emit) => emit(
        e.detail == null
            ? state.copyWith(clearDetail: true)
            : state.copyWith(detail: e.detail),
      ),
    );
    on<ReportQueryChanged>((e, emit) => emit(state.copyWith(query: e.query)));
    on<ReportFiltersCleared>(
      (e, emit) => emit(
        state.copyWith(
          clearGroup: state.lockedGroup == null,
          clearMark: true,
          clearDetail: true,
          query: '',
        ),
      ),
    );
  }

  final GetAttendanceReport _get;
  final DateTime Function() _now;

  static DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Today, for the screen to know the latest day it may show.
  DateTime get today => _dayOf(_now());

  Future<void> _load(DateTime day, Emitter<AttendanceReportState> emit) async {
    emit(state.copyWith(day: day, loading: true));
    final records = await _get(day);
    emit(state.copyWith(records: records, loading: false));
  }
}
