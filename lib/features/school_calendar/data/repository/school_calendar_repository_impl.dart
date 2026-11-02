import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../../../core/data/local/day_key.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../domain/entities/calendar_entities.dart';
import '../../domain/repository/school_calendar_repository.dart';

class SchoolCalendarRepositoryImpl implements SchoolCalendarRepository {
  SchoolCalendarRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<DateTime?> schoolStart() async {
    final rows = await _db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: ['school_registered_on'],
    );
    final ms = rows.isEmpty
        ? null
        : int.tryParse(rows.first['value']! as String);
    if (ms == null) return null;
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateTime(d.year, d.month, d.day);
  }

  @override
  Future<List<SchoolDay>> days(DateTime start, DateTime end) async {
    final rows = await _db.query(
      'school_days',
      where: 'day >= ? AND day <= ?',
      whereArgs: [dayKey(start), dayKey(end)],
      orderBy: 'day',
    );
    return [
      for (final r in rows)
        SchoolDay(
          day: DateTime.parse(r['day']! as String),
          status: SchoolDayStatus.values.byName(r['status']! as String),
          reason: r['reason'] as String?,
          isHoliday: r['kind'] == 'holiday',
          decidedBy: r['decided_by'] as String?,
          decidedAt: r['decided_at'] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(r['decided_at']! as int),
        ),
    ];
  }

  @override
  Future<void> setDay({
    required DateTime day,
    required SchoolDayStatus status,
    required String reason,
    required String changedBy,
    required DateTime at,
  }) => _db.transaction((txn) async {
    final key = dayKey(day);
    final before = await txn.query(
      'school_days',
      where: 'day = ?',
      whereArgs: [key],
    );
    final old = before.isEmpty
        ? SchoolDayStatus.pending
        : SchoolDayStatus.values.byName(before.first['status']! as String);

    if (status == SchoolDayStatus.pending) {
      await txn.delete('school_days', where: 'day = ?', whereArgs: [key]);
    } else {
      await txn.insert('school_days', {
        'day': key,
        'status': status.name,
        'decided_by': changedBy,
        'decided_at': at.millisecondsSinceEpoch,
        'reason': reason,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await txn.insert('school_day_changes', {
      'day': key,
      'old_status': old.name,
      'new_status': status.name,
      'reason': reason,
      'changed_by': changedBy,
      'changed_at': at.millisecondsSinceEpoch,
    });
  });

  @override
  Future<List<SchoolDay>> holidayDays() async {
    final rows = await _db.query(
      'school_days',
      // Every day the school is closed counts, however it was marked (from
      // the holiday form or by tapping the day), so the list and the calendar
      // never disagree and any of them can be removed from here.
      where: "status = 'rejected'",
      orderBy: 'day',
    );
    return [
      for (final r in rows)
        SchoolDay(
          day: DateTime.parse(r['day']! as String),
          status: SchoolDayStatus.values.byName(r['status']! as String),
          reason: r['reason'] as String?,
          isHoliday: true,
          decidedBy: r['decided_by'] as String?,
          decidedAt: r['decided_at'] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(r['decided_at']! as int),
        ),
    ];
  }

  @override
  Future<AddHolidaysResult> addHolidays({
    required List<HolidayEntry> holidays,
    required String changedBy,
    required DateTime at,
  }) => _db.transaction((txn) async {
    var added = 0, skipped = 0;
    for (final h in holidays) {
      for (final day in h.days) {
        final key = dayKey(day);
        final before = await txn.query(
          'school_days',
          where: 'day = ?',
          whereArgs: [key],
        );
        final old = before.isEmpty
            ? SchoolDayStatus.pending
            : SchoolDayStatus.values.byName(before.first['status']! as String);
        // School already ran on that day: a holiday cannot be added to it.
        if (old == SchoolDayStatus.approved) {
          skipped++;
          continue;
        }
        await txn.insert('school_days', {
          'day': key,
          'status': SchoolDayStatus.rejected.name,
          'decided_by': changedBy,
          'decided_at': at.millisecondsSinceEpoch,
          'reason': h.reason,
          'kind': 'holiday',
        }, conflictAlgorithm: ConflictAlgorithm.replace);
        await txn.insert('school_day_changes', {
          'day': key,
          'old_status': old.name,
          'new_status': SchoolDayStatus.rejected.name,
          'reason': h.reason,
          'changed_by': changedBy,
          'changed_at': at.millisecondsSinceEpoch,
        });
        added++;
      }
    }
    return AddHolidaysResult(added: added, skipped: skipped);
  });

  @override
  Future<List<SchoolDayChange>> history(DateTime day) async {
    final rows = await _db.rawQuery(
      '''
SELECT c.*, u.name AS by_name
FROM school_day_changes c
LEFT JOIN users u ON u.id = c.changed_by
WHERE c.day = ?
ORDER BY c.changed_at DESC, c.id DESC
''',
      [dayKey(day)],
    );
    return [
      for (final r in rows)
        SchoolDayChange(
          day: day,
          from: SchoolDayStatus.values.byName(r['old_status']! as String),
          to: SchoolDayStatus.values.byName(r['new_status']! as String),
          changedAt: DateTime.fromMillisecondsSinceEpoch(
            r['changed_at']! as int,
          ),
          reason: r['reason'] as String?,
          changedByName: r['by_name'] as String?,
        ),
    ];
  }
}
