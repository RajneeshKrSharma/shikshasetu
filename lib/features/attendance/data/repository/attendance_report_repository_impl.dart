import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../../../core/data/local/day_key.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repository/attendance_report_repository.dart';
import '../../domain/repository/attendance_repository.dart';

class AttendanceReportRepositoryImpl implements AttendanceReportRepository {
  AttendanceReportRepositoryImpl(this._database, this._attendance);

  final AppDatabase _database;
  final AttendanceRepository _attendance;

  Database get _db => _database.db;

  @override
  Future<List<AttendanceRecord>> getReport(DateTime day) async {
    final key = dayKey(day);
    // Only people who were registered by the end of that day.
    final until = DateTime(
      day.year,
      day.month,
      day.day + 1,
    ).millisecondsSinceEpoch;

    final students = await _db.rawQuery(
      '''
SELECT s.id, s.name, s.class_name, sa.status
FROM students s
LEFT JOIN student_attendance sa ON sa.student_id = s.id AND sa.day = ?
WHERE s.registered_on < ?
ORDER BY s.class_name COLLATE NOCASE, s.roll_no
''',
      [key, until],
    );
    final teachers = await _db.rawQuery(
      '''
SELECT u.id, u.name, u.subject
FROM users u
WHERE u.role = 'teacher' AND u.active = 1 AND u.joined_on < ?
ORDER BY u.name COLLATE NOCASE
''',
      [until],
    );
    // Check-in and check-out, with where and how they were done.
    final records = {
      for (final t in await _attendance.getTeacherRecords(day)) t.teacherId: t,
    };
    final others = await _db.rawQuery(
      '''
SELECT s.id, s.name, s.role_title, a.status
FROM other_staff s
LEFT JOIN staff_attendance a ON a.staff_id = s.id AND a.day = ?
WHERE s.active = 1 AND s.registered_on < ?
ORDER BY s.name COLLATE NOCASE
''',
      [key, until],
    );

    return [
      for (final r in students)
        AttendanceRecord(
          id: r['id']! as String,
          name: r['name']! as String,
          group: AttendanceGroup.student,
          detail: r['class_name']! as String,
          mark: r['status'] == null
              ? AttendanceMark.notMarked
              : AttendanceMark.values.byName(r['status']! as String),
        ),
      for (final r in teachers)
        AttendanceRecord(
          id: r['id']! as String,
          name: r['name']! as String,
          group: AttendanceGroup.teacher,
          detail: (r['subject'] as String?) ?? '',
          mark: (records[r['id']]?.isPresent ?? false)
              ? AttendanceMark.present
              : AttendanceMark.absent,
          checkIn: records[r['id']]?.checkIn,
          checkOut: records[r['id']]?.checkOut,
          teacher: records[r['id']],
        ),
      for (final r in others)
        AttendanceRecord(
          id: r['id']! as String,
          name: r['name']! as String,
          group: AttendanceGroup.other,
          detail: r['role_title']! as String,
          mark: r['status'] == null
              ? AttendanceMark.notMarked
              : AttendanceMark.values.byName(r['status']! as String),
        ),
    ];
  }
}
