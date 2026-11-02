import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/data_source_kind.dart';
import '../entities/source_summary.dart';
import '../entities/table_diff.dart';
import '../../../cloud_sync/domain/entities/row_hash.dart';
import '../entities/restore_comparison.dart';
import '../repository/data_source.dart';
import '../repository/restore_comparison_repository.dart';

class GetSourceSummary implements UseCase<SourceSummary, DataSourceKind> {
  const GetSourceSummary(this._registry);

  final DataSourceRegistry _registry;

  @override
  Future<SourceSummary> call(DataSourceKind kind) =>
      _registry.of(kind).summary();
}

class CompareParams extends Equatable {
  const CompareParams(this.table, this.left, this.right);

  final String table;
  final DataSourceKind left;
  final DataSourceKind right;

  @override
  List<Object?> get props => [table, left, right];
}

/// Compares one table in two places row by row: what only one of them has,
/// and what both have but with different values.
class CompareTable implements UseCase<TableDiff, CompareParams> {
  const CompareTable(this._registry);

  final DataSourceRegistry _registry;

  /// How many rows are listed (the ones that differ first).
  static const _maxDiffering = 200;
  static const _maxSame = 100;

  @override
  Future<TableDiff> call(CompareParams p) async {
    final left = _registry.of(p.left);
    final right = _registry.of(p.right);
    final a = await left.rows(p.table);
    final b = await right.rows(p.table);

    final keys = {...a.keys, ...b.keys}.toList()..sort();
    final differing = <_Pair>[];
    final alike = <_Pair>[];
    var onlyLeft = 0;
    var onlyRight = 0;
    var changed = 0;
    for (final k in keys) {
      final x = a[k];
      final y = b[k];
      if (x == null) {
        onlyRight++;
        differing.add(_Pair(k, null, y, RowStatus.onlyRight));
      } else if (y == null) {
        onlyLeft++;
        differing.add(_Pair(k, x, null, RowStatus.onlyLeft));
      } else if (rowHash(x) != rowHash(y)) {
        changed++;
        differing.add(_Pair(k, x, y, RowStatus.changed));
      } else {
        alike.add(_Pair(k, x, y, RowStatus.same));
      }
    }

    final shown = [...differing.take(_maxDiffering), ...alike.take(_maxSame)];
    final entries = <RowEntry>[];
    for (final e in shown) {
      var name = '';
      for (final s in [left, right]) {
        name = await s.nameOf(p.table, e.key) ?? '';
        if (name.isNotEmpty) break;
      }
      entries.add(
        RowEntry(
          key: e.key,
          name: name.isEmpty ? e.key : name,
          status: e.status,
          left: e.left,
          right: e.right,
          changedColumns: e.status == RowStatus.changed
              ? [
                  for (final c in {...e.left!.keys, ...e.right!.keys})
                    if (e.left![c] != e.right![c]) c,
                ]
              : const [],
        ),
      );
    }
    return TableDiff(
      table: p.table,
      left: p.left,
      right: p.right,
      entries: entries,
      same: alike.length,
      onlyLeft: onlyLeft,
      onlyRight: onlyRight,
      changed: changed,
    );
  }
}

class _Pair {
  const _Pair(this.key, this.left, this.right, this.status);

  final String key;
  final Map<String, Object?>? left;
  final Map<String, Object?>? right;
  final RowStatus status;
}

/// What restoring a backup would change in the app.
class CompareBackupWithApp implements UseCase<RestoreComparison, String> {
  const CompareBackupWithApp(this._repository);

  final RestoreComparisonRepository _repository;

  @override
  Future<RestoreComparison> call(String jsonText) =>
      _repository.compare(jsonText);
}

class BackupTableParams extends Equatable {
  const BackupTableParams(this.jsonText, this.table);

  final String jsonText;
  final String table;

  @override
  List<Object?> get props => [jsonText, table];
}

/// One table of a backup against the app, row by row.
class DiffBackupTable implements UseCase<TableDiff, BackupTableParams> {
  const DiffBackupTable(this._repository);

  final RestoreComparisonRepository _repository;

  @override
  Future<TableDiff> call(BackupTableParams p) =>
      _repository.diffTable(p.jsonText, p.table);
}
