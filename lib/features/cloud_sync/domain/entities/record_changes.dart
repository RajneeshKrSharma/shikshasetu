import 'dart:convert';

import '../repository/cloud_sync_repositories.dart';
import 'sync_record_change.dart';

/// What changed in the rows of [table] between what was last sent (kept as
/// JSON snapshots) and what is on the phone now.
class RecordChanges {
  RecordChanges._();

  static Map<String, Object?>? decode(String? snapshot) {
    if (snapshot == null) return null;
    try {
      return (jsonDecode(snapshot) as Map).cast<String, Object?>();
    } catch (_) {
      return null;
    }
  }

  static String encode(Map<String, Object?> row) => jsonEncode(row);

  /// A row that is new or changed since it was last sent. [hadBefore] says the
  /// row was sent earlier (so, with no snapshot, its old value is unknown).
  static Future<SyncRecordChange> sent({
    required SyncSourceRepository source,
    required String table,
    required String key,
    required Map<String, Object?> row,
    required String? snapshot,
    required bool hadBefore,
  }) async => SyncRecordChange.diff(
    table: table,
    key: key,
    label: await source.describe(table, row),
    before: decode(snapshot),
    after: row,
    beforeKnown: !hadBefore || snapshot != null,
  );

  /// A row removed from the cloud because it is gone from the phone.
  static Future<SyncRecordChange> removed({
    required SyncSourceRepository source,
    required String table,
    required String key,
    required String? snapshot,
  }) async {
    final before = decode(snapshot);
    return SyncRecordChange.diff(
      table: table,
      key: key,
      label: before == null ? key : await source.describe(table, before),
      before: before ?? const {},
      after: null,
    );
  }
}
