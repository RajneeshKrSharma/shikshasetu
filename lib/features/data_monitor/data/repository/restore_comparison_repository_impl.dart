import '../../../cloud_sync/domain/repository/cloud_sync_repositories.dart';
import '../../domain/entities/data_source_kind.dart';
import '../../domain/entities/restore_comparison.dart';
import '../../domain/entities/table_diff.dart';
import '../../domain/repository/restore_comparison_repository.dart';
import '../../domain/usecases/monitor_usecases.dart';
import 'backup_text_data_source.dart';
import 'data_source_registry_impl.dart';
import 'local_db_data_source.dart';

class RestoreComparisonRepositoryImpl implements RestoreComparisonRepository {
  RestoreComparisonRepositoryImpl(this._source, this._tracker);

  final SyncSourceRepository _source;
  final ChangeTrackerRepository _tracker;

  DataSourceRegistryImpl _registry(String jsonText) => DataSourceRegistryImpl([
    LocalDbDataSource(_source),
    BackupTextDataSource(jsonText, _source.tables),
  ], _source.tables);

  @override
  Future<RestoreComparison> compare(String jsonText) async {
    final registry = _registry(jsonText);
    final compare = CompareTable(registry);
    final backup = await registry.of(DataSourceKind.file).summary();
    final changes = <TableRestoreChange>[];
    for (final t in _source.tables) {
      final d = await compare(
        CompareParams(t, DataSourceKind.localDb, DataSourceKind.file),
      );
      changes.add(
        TableRestoreChange(
          table: t,
          now: d.same + d.onlyLeft + d.changed,
          backup: d.same + d.onlyRight + d.changed,
          added: d.onlyRight,
          removed: d.onlyLeft,
          changed: d.changed,
        ),
      );
    }
    return RestoreComparison(
      backupAt: backup.asOf,
      appChangedAt: await _tracker.lastChangedAt(),
      tables: changes,
    );
  }

  @override
  Future<TableDiff> diffTable(String jsonText, String table) => CompareTable(
    _registry(jsonText),
  )(CompareParams(table, DataSourceKind.localDb, DataSourceKind.file));
}
