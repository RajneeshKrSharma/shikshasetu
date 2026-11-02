import '../../../cloud_sync/data/repository/sqlite_sync_repositories.dart';

/// The rows of a backup file, shaped the way the cloud and the phone's own
/// rows are (the same keys, without what stays on the phone), so they can be
/// compared with them.
class BackupRows {
  BackupRows(this.createdAt, this.tables);

  /// Reads a decoded backup, keeping only [tableNames].
  factory BackupRows.fromJson(
    Map<String, dynamic> json,
    List<String> tableNames,
  ) {
    final tablesJson = json['tables'] as Map<String, dynamic>;
    return BackupRows(DateTime.tryParse(json['createdAt'] as String? ?? ''), {
      for (final t in tableNames)
        t: {
          for (final r in (tablesJson[t] as List? ?? const []))
            ..._keyed(t, Map<String, Object?>.from(r as Map)),
        },
    });
  }

  final DateTime? createdAt;

  /// table → row key → row.
  final Map<String, Map<String, Map<String, Object?>>> tables;

  /// The row as the cloud holds it, under its key; nothing for settings that
  /// only describe the phone.
  static Map<String, Map<String, Object?>> _keyed(
    String table,
    Map<String, Object?> r,
  ) {
    if (table == 'app_settings' &&
        SqliteSyncSourceRepository.isLocalSetting(r['key']! as String)) {
      return const {};
    }
    final hidden =
        SqliteSyncSourceRepository.hiddenColumns[table] ?? const <String>{};
    final key = SqliteSyncSourceRepository.rowKey([
      for (final c in SqliteSyncSourceRepository.keyColumns[table]!) r[c],
    ]);
    return {
      key: {
        for (final e in r.entries)
          if (!hidden.contains(e.key)) e.key: e.value,
      },
    };
  }
}
