import '../../../cloud_sync/domain/repository/cloud_sync_repositories.dart';
import '../../domain/entities/data_source_kind.dart';
import '../../domain/entities/source_summary.dart';
import '../../domain/repository/data_source.dart';

/// The phone's own database.
class LocalDbDataSource implements DataSource {
  LocalDbDataSource(this._source);

  final SyncSourceRepository _source;

  /// The rows of the table last asked about, so naming many rows does not
  /// read the table many times.
  String? _cachedTable;
  SyncTableRows _cache = const {};

  @override
  DataSourceKind get kind => DataSourceKind.localDb;

  Future<SyncTableRows> _rows(String table) async {
    if (_cachedTable != table) {
      _cache = await _source.table(table);
      _cachedTable = table;
    }
    return _cache;
  }

  @override
  Future<SourceSummary> summary() async {
    _cachedTable = null;
    final counts = <String, int>{};
    for (final t in _source.tables) {
      counts[t] = (await _source.table(t)).length;
    }
    return SourceSummary(kind: kind, counts: counts, asOf: DateTime.now());
  }

  @override
  Future<Map<String, Map<String, Object?>>> rows(String table) async {
    _cachedTable = null;
    return _rows(table);
  }

  @override
  Future<String?> nameOf(String table, String key) async {
    final row = (await _rows(table))[key];
    return row == null ? null : _source.describe(table, row);
  }
}
