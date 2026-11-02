import '../../../../core/usecase/usecase.dart';
import '../entities/cloud_entities.dart';
import '../entities/record_changes.dart';
import '../entities/row_hash.dart';
import '../entities/sync_activity.dart';
import '../entities/sync_record_change.dart';
import '../repository/cloud_sync_repositories.dart';

/// Sends what changed on the phone since the last sync to the cloud.
///
/// Each row is fingerprinted; only rows whose fingerprint differs from what
/// was last sent are written, and rows that disappeared are removed. The phone
/// stays the source of truth, so this is safe to run as often as wanted.
/// Throws [CloudSyncException].
class SyncToCloud implements UseCase<SyncRun, NoParams> {
  SyncToCloud({
    required SyncSourceRepository source,
    required SyncStateRepository state,
    required CloudStoreRepository cloud,
    DateTime Function()? now,
  }) : _source = source,
       _state = state,
       _cloud = cloud,
       _now = now ?? DateTime.now;

  final SyncSourceRepository _source;
  final SyncStateRepository _state;
  final CloudStoreRepository _cloud;
  final DateTime Function() _now;

  @override
  Future<SyncRun> call(NoParams params) => run();

  /// Syncs now, reporting [onProgress] after each table.
  Future<SyncRun> run({void Function(SyncProgress)? onProgress}) async {
    final connection = await _cloud.connection();
    switch (connection.status) {
      case CloudStatus.notConfigured:
        throw const CloudSyncException(CloudSyncFailure.notConfigured);
      case CloudStatus.signedOut:
        throw const CloudSyncException(CloudSyncFailure.signedOut);
      case CloudStatus.ready:
        break;
    }

    final schoolId = await _source.schoolId();
    await _cloud.ensureSchool(
      schoolId,
      await _source.schoolName(),
      await _source.access(),
    );

    final tables = _source.tables;
    final uploaded = <String, int>{};
    final deleted = <String, int>{};
    final changes = <SyncRecordChange>[];
    onProgress?.call(SyncProgress(0, tables.length));

    for (var i = 0; i < tables.length; i++) {
      onProgress?.call(SyncProgress(i, tables.length, table: tables[i]));
      await _syncTable(schoolId, tables[i], uploaded, deleted, changes);
    }

    onProgress?.call(SyncProgress(tables.length, tables.length));
    final run = SyncRun(
      at: _now(),
      uploaded: uploaded,
      deleted: deleted,
      changes: changes,
    );
    await _state.saveRun(run);
    return run;
  }

  Future<void> _syncTable(
    String schoolId,
    String table,
    Map<String, int> uploaded,
    Map<String, int> deleted,
    List<SyncRecordChange> changes,
  ) async {
    final rows = await _source.table(table);
    final now = {for (final r in rows.entries) r.key: rowHash(r.value)};
    final before = await _state.hashesOf(table);
    final snapshots = await _state.snapshotsOf(table);

    final changed = [
      for (final k in now.keys)
        if (before[k] != now[k]) k,
    ];
    final gone = {
      for (final k in before.keys)
        if (!now.containsKey(k)) k,
    };
    if (changed.isEmpty && gone.isEmpty) return;

    await _cloud.write(
      schoolId,
      table,
      upserts: {for (final k in changed) k: rows[k]!},
      deletes: gone,
    );
    // Only after the cloud accepted them is it remembered as sent.
    await _state.apply(
      table,
      upserts: {for (final k in changed) k: now[k]!},
      snapshots: {for (final k in changed) k: RecordChanges.encode(rows[k]!)},
      deletes: gone,
    );
    for (final k in changed) {
      if (changes.length >= SyncActivityLog.maxRecords) break;
      changes.add(
        await RecordChanges.sent(
          source: _source,
          table: table,
          key: k,
          row: rows[k]!,
          snapshot: snapshots[k],
          hadBefore: before.containsKey(k),
        ),
      );
    }
    for (final k in gone) {
      if (changes.length >= SyncActivityLog.maxRecords) break;
      changes.add(
        await RecordChanges.removed(
          source: _source,
          table: table,
          key: k,
          snapshot: snapshots[k],
        ),
      );
    }
    if (changed.isNotEmpty) uploaded[table] = changed.length;
    if (gone.isNotEmpty) deleted[table] = gone.length;
  }
}
