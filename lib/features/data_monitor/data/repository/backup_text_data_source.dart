import 'dart:convert';

import '../../domain/entities/data_source_kind.dart';
import '../../domain/entities/source_summary.dart';
import '../../domain/repository/data_source.dart';
import 'backup_rows.dart';

/// A backup file's text, read as if it were a place the data is kept (to
/// compare it with the app before it is restored).
class BackupTextDataSource implements DataSource {
  BackupTextDataSource(String jsonText, List<String> tables)
    : _read = BackupRows.fromJson(
        jsonDecode(jsonText) as Map<String, dynamic>,
        tables,
      );

  final BackupRows _read;

  @override
  DataSourceKind get kind => DataSourceKind.file;

  @override
  Future<SourceSummary> summary() async => SourceSummary(
    kind: kind,
    counts: {for (final e in _read.tables.entries) e.key: e.value.length},
    asOf: _read.createdAt,
  );

  @override
  Future<Map<String, Map<String, Object?>>> rows(String table) async =>
      _read.tables[table] ?? const {};

  @override
  Future<String?> nameOf(String table, String key) async {
    final row = _read.tables[table]?[key];
    if (row == null) return null;
    for (final c in const ['name', 'title', 'text', 'key', 'day']) {
      final v = row[c];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }
}
