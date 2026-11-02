import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/repository/cloud_sync_repositories.dart';

/// Reads the change counter that the database keeps by itself (see
/// `sync_flag` in [AppDatabase]); it survives the app being closed.
class SqliteChangeTracker implements ChangeTrackerRepository {
  SqliteChangeTracker(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<int> latest() async {
    final r = await _db.query('sync_flag', columns: ['seq']);
    return r.isEmpty ? 0 : r.first['seq']! as int;
  }

  @override
  Future<bool> hasPending() async {
    final r = await _db.rawQuery(
      'SELECT seq > synced_seq AS pending FROM sync_flag',
    );
    return r.isNotEmpty && r.first['pending'] == 1;
  }

  @override
  Future<DateTime?> lastChangedAt() async {
    final r = await _db.query('sync_flag', columns: ['changed_at']);
    final ms = r.isEmpty ? 0 : r.first['changed_at']! as int;
    return ms == 0 ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  @override
  Future<bool> hasUnmirrored() async {
    final r = await _db.rawQuery(
      'SELECT seq > mirrored_seq AS pending FROM sync_flag',
    );
    return r.isNotEmpty && r.first['pending'] == 1;
  }

  @override
  Future<void> markMirrored(int seq) => _db.rawUpdate(
    'UPDATE sync_flag SET mirrored_seq = ? WHERE mirrored_seq < ?',
    [seq, seq],
  );

  @override
  Future<void> markSent(int seq) => _db.rawUpdate(
    'UPDATE sync_flag SET synced_seq = ? WHERE synced_seq < ?',
    [seq, seq],
  );
}
