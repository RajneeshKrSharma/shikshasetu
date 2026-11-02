import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/data_source_kind.dart';
import '../../domain/entities/restore_comparison.dart';
import '../../domain/entities/source_summary.dart';
import '../../domain/entities/table_diff.dart';
import '../../domain/usecases/monitor_usecases.dart';

class DataMonitorState extends Equatable {
  const DataMonitorState({
    this.check = DataSourceKind.file,
    this.against = DataSourceKind.localDb,
    this.summaries = const {},
    this.reading = const {},
    this.table,
    this.diff,
    this.diffLoading = false,
    this.diffFailed = false,
    this.showAll = false,
    this.comparison,
    this.comparisonFailed = false,
  });

  /// The two places being compared.
  final DataSourceKind check;
  final DataSourceKind against;

  /// What each place holds, once read.
  final Map<DataSourceKind, SourceSummary> summaries;
  final Set<DataSourceKind> reading;

  /// The table opened for a row-by-row comparison, and its result.
  final String? table;
  final TableDiff? diff;
  final bool diffLoading;
  final bool diffFailed;

  /// Show every row of the open table, not only the ones that differ.
  final bool showAll;

  /// For a backup about to be restored: what restoring would change.
  final RestoreComparison? comparison;
  final bool comparisonFailed;

  /// Whether [table] has the same number of rows in both chosen places;
  /// null until both are read.
  bool? countsMatch(String table) {
    final a = summaries[check];
    final b = summaries[against];
    if (a == null || b == null || !a.available || !b.available) return null;
    return (a.counts[table] ?? 0) == (b.counts[table] ?? 0);
  }

  DataMonitorState copyWith({
    DataSourceKind? check,
    DataSourceKind? against,
    Map<DataSourceKind, SourceSummary>? summaries,
    Set<DataSourceKind>? reading,
    String? table,
    TableDiff? diff,
    bool clearDiff = false,
    bool? diffLoading,
    bool? diffFailed,
    bool? showAll,
    RestoreComparison? comparison,
    bool? comparisonFailed,
  }) => DataMonitorState(
    check: check ?? this.check,
    against: against ?? this.against,
    summaries: summaries ?? this.summaries,
    reading: reading ?? this.reading,
    table: clearDiff ? null : (table ?? this.table),
    diff: clearDiff ? null : (diff ?? this.diff),
    diffLoading: diffLoading ?? this.diffLoading,
    diffFailed: diffFailed ?? this.diffFailed,
    showAll: showAll ?? this.showAll,
    comparison: comparison ?? this.comparison,
    comparisonFailed: comparisonFailed ?? this.comparisonFailed,
  );

  @override
  List<Object?> get props => [
    check,
    against,
    summaries,
    reading,
    table,
    diff,
    diffLoading,
    diffFailed,
    showAll,
    comparison,
    comparisonFailed,
  ];
}

/// Shows what each place (cloud, data file, phone database) holds and where
/// they differ. Only reads.
class DataMonitorCubit extends Cubit<DataMonitorState> {
  DataMonitorCubit({
    required GetSourceSummary getSummary,
    required CompareTable compareTable,
    required CompareBackupWithApp compareBackup,
    required DiffBackupTable diffBackupTable,
  }) : _getSummary = getSummary,
       _compare = compareTable,
       _compareBackup = compareBackup,
       _diffBackup = diffBackupTable,
       super(const DataMonitorState());

  final GetSourceSummary _getSummary;
  final CompareTable _compare;
  final CompareBackupWithApp _compareBackup;
  final DiffBackupTable _diffBackup;

  /// Reads the two places being compared. The cloud costs reads, so it is
  /// read only when it is one of them.
  Future<void> load() async {
    await Future.wait([read(state.check), read(state.against)]);
  }

  Future<void> read(DataSourceKind kind) async {
    emit(state.copyWith(reading: {...state.reading, kind}));
    final summary = await _getSummary(kind);
    if (isClosed) return;
    emit(
      state.copyWith(
        summaries: {...state.summaries, kind: summary},
        reading: {...state.reading}..remove(kind),
      ),
    );
  }

  Future<void> checkChanged(DataSourceKind kind) async {
    emit(state.copyWith(check: kind));
    if (!state.summaries.containsKey(kind)) await read(kind);
  }

  Future<void> againstChanged(DataSourceKind kind) async {
    emit(state.copyWith(against: kind));
    if (!state.summaries.containsKey(kind)) await read(kind);
  }

  Future<void> openTable(String table) async {
    emit(
      state.copyWith(
        table: table,
        diffLoading: true,
        diffFailed: false,
        showAll: false,
        clearDiff: false,
      ),
    );
    try {
      final diff = await _compare(
        CompareParams(table, state.check, state.against),
      );
      // When nothing differs there is nothing to filter: show the rows.
      if (!isClosed) {
        emit(
          state.copyWith(diff: diff, diffLoading: false, showAll: diff.matches),
        );
      }
    } catch (_) {
      if (!isClosed) emit(state.copyWith(diffLoading: false, diffFailed: true));
    }
  }

  /// Reads a backup file's text and works out what restoring it would change.
  Future<void> loadRestore(String jsonText) async {
    try {
      final comparison = await _compareBackup(jsonText);
      if (!isClosed) emit(state.copyWith(comparison: comparison));
    } catch (_) {
      if (!isClosed) emit(state.copyWith(comparisonFailed: true));
    }
  }

  /// One table of the backup against the app, row by row.
  Future<void> openBackupTable(String jsonText, String table) async {
    emit(
      state.copyWith(
        table: table,
        diffLoading: true,
        diffFailed: false,
        showAll: false,
        clearDiff: false,
      ),
    );
    try {
      final diff = await _diffBackup(BackupTableParams(jsonText, table));
      if (!isClosed) {
        emit(
          state.copyWith(diff: diff, diffLoading: false, showAll: diff.matches),
        );
      }
    } catch (_) {
      if (!isClosed) emit(state.copyWith(diffLoading: false, diffFailed: true));
    }
  }

  void showAllRows(bool all) => emit(state.copyWith(showAll: all));

  void closeTable() => emit(state.copyWith(clearDiff: true, diffFailed: false));
}
