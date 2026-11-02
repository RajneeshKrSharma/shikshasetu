import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../../../core/data/local/day_key.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/entities/other_staff_mark.dart';
import '../../domain/repository/other_staff_attendance_repository.dart';

class OtherStaffAttendanceRepositoryImpl
    implements OtherStaffAttendanceRepository {
  OtherStaffAttendanceRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<List<OtherStaffMark>> getForDay(DateTime day) async {
    final until = DateTime(
      day.year,
      day.month,
      day.day + 1,
    ).millisecondsSinceEpoch;
    final rows = await _db.rawQuery(
      '''
SELECT s.id, s.name, s.role_title, a.status
FROM other_staff s
LEFT JOIN staff_attendance a ON a.staff_id = s.id AND a.day = ?
WHERE s.active = 1 AND s.registered_on < ?
ORDER BY s.role_title COLLATE NOCASE, s.name COLLATE NOCASE
''',
      [dayKey(day), until],
    );
    return [
      for (final r in rows)
        OtherStaffMark(
          staffId: r['id']! as String,
          name: r['name']! as String,
          role: r['role_title']! as String,
          status: r['status'] == null
              ? null
              : AttendanceStatus.values.byName(r['status']! as String),
        ),
    ];
  }

  @override
  Future<void> save(DateTime day, Map<String, AttendanceStatus> marks) =>
      _db.transaction((txn) async {
        final key = dayKey(day);
        for (final e in marks.entries) {
          await txn.insert('staff_attendance', {
            'staff_id': e.key,
            'day': key,
            'status': e.value.name,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
}
