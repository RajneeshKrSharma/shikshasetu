import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/cloud_entities.dart';
import '../../domain/repository/cloud_sync_repositories.dart';
import 'record_describer.dart';

/// Reads the synced tables out of the phone's database.
class SqliteSyncSourceRepository implements SyncSourceRepository {
  SqliteSyncSourceRepository(this._database, {String Function()? newId})
    : _newId = newId ?? (() => const Uuid().v4());

  final AppDatabase _database;
  final String Function() _newId;

  Database get _db => _database.db;

  static const _schoolIdKey = 'cloud_school_id';

  /// The columns that identify a row, per synced table.
  static const keyColumns = {
    'app_settings': ['key'],
    'users': ['id'],
    'classes': ['name'],
    'students': ['id'],
    'other_staff': ['id'],
    'school_days': ['day'],
    'school_day_changes': ['id'],
    'teacher_attendance': ['teacher_id', 'day'],
    'student_attendance': ['student_id', 'day'],
    'staff_attendance': ['staff_id', 'day'],
    'exam_papers': ['id'],
    'exam_questions': ['id'],
    'exam_marks': ['paper_id', 'student_id'],
    'fee_accounts': ['id'],
    'fee_payments': ['id'],
    'fee_structure': ['class_name', 'head'],
    'accessory_items': ['id'],
    'accessory_issues': ['id'],
    'school_timings': ['id'],
    'staff_bills': ['id'],
    'staff_settlements': ['id'],
    'bell_slots': ['id'],
    'assembly_duty': ['weekday'],
    'timetable_entries': ['class_name', 'weekday', 'slot_id'],
    'notices': ['id'],
    'master_questions': ['id'],
    'question_units': ['id'],
    'teacher_subjects': ['id'],
  };

  /// Never leave the phone: password material, and paths to files that only
  /// exist on this phone.
  static const hiddenColumns = {
    'users': {'password_hash', 'password_salt'},
    'teacher_attendance': {'in_selfie', 'out_selfie'},
    'fee_payments': {'proof_path'},
    'accessory_issues': {'signature_path', 'photo_path'},
    'staff_bills': {'photo_path'},
    'staff_settlements': {'proof_path'},
  };

  /// Settings that describe this phone, not the school.
  /// Whether a setting only describes this phone, so it is never sent.
  static bool isLocalSetting(String key) =>
      key.startsWith('cloud_') || key == 'school_logo';

  @override
  Future<String> schoolId() async {
    final rows = await _db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [_schoolIdKey],
    );
    if (rows.isNotEmpty) return rows.first['value']! as String;
    final id = _newId();
    await _db.insert('app_settings', {'key': _schoolIdKey, 'value': id});
    return id;
  }

  @override
  Future<String> schoolName() async {
    final rows = await _db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: ['school_name'],
    );
    return rows.isEmpty ? '' : rows.first['value']! as String;
  }

  @override
  Future<SchoolAccess> access() async {
    final teachers = await _db.query(
      'users',
      columns: ['id'],
      where: "role = 'teacher' AND active = 1",
      orderBy: 'id',
    );
    final ids = [for (final t in teachers) t['id']! as String];
    final classes = await _db.query(
      'classes',
      columns: ['name', 'class_teacher_id'],
      where: 'class_teacher_id IS NOT NULL',
    );
    return SchoolAccess(
      teacherUids: ids,
      classOfTeacher: {
        for (final c in classes)
          if (ids.contains(c['class_teacher_id']))
            c['class_teacher_id']! as String: c['name']! as String,
      },
    );
  }

  /// A document id for a row. Document ids cannot contain "/".
  static String rowKey(List<Object?> parts) =>
      parts.map((p) => '$p'.replaceAll('/', '%2F')).join('|');

  @override
  List<String> get tables => keyColumns.keys.toList(growable: false);

  @override
  Future<String> describe(String table, Map<String, Object?> row) =>
      RecordDescriber.label(_db, table, row);

  @override
  Future<SyncTableRows> table(String table) async {
    final keys = keyColumns[table]!;
    final hidden = hiddenColumns[table] ?? const <String>{};
    final rows = <String, Map<String, Object?>>{};
    for (final row in await _db.query(table)) {
      if (table == 'app_settings' && isLocalSetting(row['key']! as String)) {
        continue;
      }
      rows[rowKey([for (final c in keys) row[c]])] = {
        for (final e in row.entries)
          if (!hidden.contains(e.key)) e.key: e.value,
      };
    }
    return rows;
  }
}

/// Remembers, in the phone's database, what the cloud already has.
class SqliteSyncStateRepository implements SyncStateRepository {
  SqliteSyncStateRepository(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  static const _lastRunKey = 'cloud_last_sync';
  static const _lastChangeKey = 'cloud_last_change';

  @override
  Future<Map<String, String>> hashesOf(String table) async => {
    for (final r in await _db.query(
      'sync_state',
      where: 'table_name = ?',
      whereArgs: [table],
    ))
      r['row_key']! as String: r['hash']! as String,
  };

  @override
  Future<Map<String, String>> snapshotsOf(String table) async => {
    for (final r in await _db.query(
      'sync_state',
      where: 'table_name = ? AND snapshot IS NOT NULL',
      whereArgs: [table],
    ))
      r['row_key']! as String: r['snapshot']! as String,
  };

  @override
  Future<void> apply(
    String table, {
    Map<String, String> upserts = const {},
    Map<String, String> snapshots = const {},
    Set<String> deletes = const {},
  }) => _db.transaction((txn) async {
    for (final k in deletes) {
      await txn.delete(
        'sync_state',
        where: 'table_name = ? AND row_key = ?',
        whereArgs: [table, k],
      );
    }
    for (final e in upserts.entries) {
      await txn.insert('sync_state', {
        'table_name': table,
        'row_key': e.key,
        'hash': e.value,
        'snapshot': snapshots[e.key],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  });

  @override
  Future<SyncRun?> lastRun() => _read(_lastRunKey);

  @override
  Future<SyncRun?> lastChangeRun() => _read(_lastChangeKey);

  @override
  Future<void> saveRun(SyncRun run) async {
    await _write(_lastRunKey, run);
    if (!run.isEmpty) await _write(_lastChangeKey, run);
  }

  Future<SyncRun?> _read(String key) async {
    final rows = await _db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (rows.isEmpty) return null;
    final json = jsonDecode(rows.first['value']! as String) as Map;
    Map<String, int> counts(Object? m) => {
      for (final e in (m as Map? ?? const {}).entries)
        e.key as String: e.value as int,
    };
    return SyncRun(
      at: DateTime.fromMillisecondsSinceEpoch(json['at'] as int),
      uploaded: counts(json['uploaded']),
      deleted: counts(json['deleted']),
    );
  }

  Future<void> _write(String key, SyncRun run) => _db.insert('app_settings', {
    'key': key,
    'value': jsonEncode({
      'at': run.at.millisecondsSinceEpoch,
      'uploaded': run.uploaded,
      'deleted': run.deleted,
    }),
  }, conflictAlgorithm: ConflictAlgorithm.replace);
}

/// Keeps the automatic-sync choice in the phone's database. The `cloud_` key
/// prefix keeps it out of what is sent to the cloud.
class SqliteSyncSettingsRepository implements SyncSettingsRepository {
  SqliteSyncSettingsRepository(this._database);

  final AppDatabase _database;

  static const _key = 'cloud_sync_minutes';

  @override
  Future<int> intervalMinutes() async {
    final rows = await _database.db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [_key],
    );
    return rows.isEmpty
        ? kDefaultSyncIntervalMinutes
        : int.tryParse(rows.first['value']! as String) ??
              kDefaultSyncIntervalMinutes;
  }

  @override
  Future<void> saveIntervalMinutes(int minutes) => _database.db.insert(
    'app_settings',
    {'key': _key, 'value': '$minutes'},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
