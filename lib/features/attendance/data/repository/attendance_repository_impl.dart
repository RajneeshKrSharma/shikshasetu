import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../../../core/data/local/day_key.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/entities/check_point.dart';
import '../../domain/entities/teacher_attendance.dart';
import '../../domain/repository/attendance_repository.dart';
import '../dto/student_attendance_dto.dart';
import '../dto/teacher_attendance_dto.dart';
import '../models/teacher_attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<SchoolDayStatus> getDayStatus(DateTime day) async {
    final rows = await _db.query(
      'school_days',
      where: 'day = ?',
      whereArgs: [dayKey(day)],
    );
    if (rows.isNotEmpty) {
      return SchoolDayStatus.values.byName(rows.first['status']! as String);
    }
    // Nothing was decided for the day: school is open, unless the school's
    // working days are set and this is not one of them.
    final set = await _db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: ['school_working_days'],
    );
    final working = set.isEmpty
        ? <int>{}
        : {
            for (final d in (set.first['value']! as String).split(','))
              if (int.tryParse(d) != null) int.parse(d),
          };
    return working.isEmpty || working.contains(day.weekday)
        ? SchoolDayStatus.approved
        : SchoolDayStatus.rejected;
  }

  @override
  Future<void> setDayStatus(
    DateTime day,
    SchoolDayStatus status,
    String decidedBy,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final old = await getDayStatus(day);
    if (status == SchoolDayStatus.pending) {
      await _db.delete(
        'school_days',
        where: 'day = ?',
        whereArgs: [dayKey(day)],
      );
    } else {
      await _db.insert('school_days', {
        'day': dayKey(day),
        'status': status.name,
        'decided_by': decidedBy,
        'decided_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    // Kept in the calendar's change log too (these decisions have no reason).
    if (old != status) {
      await _db.insert('school_day_changes', {
        'day': dayKey(day),
        'old_status': old.name,
        'new_status': status.name,
        'changed_by': decidedBy,
        'changed_at': now,
      });
    }
  }

  @override
  Future<List<TeacherAttendance>> getTeacherRecords(DateTime day) async {
    final rows = await _db.rawQuery(
      '''
SELECT u.id AS uid, u.name AS uname,
       a.check_in, a.check_out,
       a.in_lat, a.in_lon, a.in_distance, a.in_selfie, a.in_face_score,
       a.out_lat, a.out_lon, a.out_distance, a.out_selfie, a.out_face_score
FROM users u
LEFT JOIN teacher_attendance a ON a.teacher_id = u.id AND a.day = ?
WHERE u.role = 'teacher' AND u.active = 1
ORDER BY u.name
''',
      [dayKey(day)],
    );
    return [
      for (final r in rows)
        TeacherAttendanceModel.fromDto(TeacherAttendanceDto.fromMap(r)),
    ];
  }

  @override
  Future<void> checkIn(String teacherId, DateTime at, CheckPoint p) =>
      _db.insert('teacher_attendance', {
        'teacher_id': teacherId,
        'day': dayKey(at),
        'check_in': at.millisecondsSinceEpoch,
        'in_lat': p.latitude,
        'in_lon': p.longitude,
        'in_distance': p.distanceMeters,
        'in_selfie': p.selfiePath,
        'in_face_score': p.faceScore,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

  @override
  Future<void> checkOut(String teacherId, DateTime at, CheckPoint p) =>
      _db.update(
        'teacher_attendance',
        {
          'check_out': at.millisecondsSinceEpoch,
          'out_lat': p.latitude,
          'out_lon': p.longitude,
          'out_distance': p.distanceMeters,
          'out_selfie': p.selfiePath,
          'out_face_score': p.faceScore,
        },
        where: 'teacher_id = ? AND day = ?',
        whereArgs: [teacherId, dayKey(at)],
      );

  @override
  Future<Map<String, AttendanceStatus>?> getClassAttendance(
    String classSection,
    DateTime day,
  ) async {
    final rows = await _db.rawQuery(
      '''
SELECT sa.student_id, sa.status
FROM student_attendance sa
JOIN students s ON s.id = sa.student_id
WHERE s.class_name = ? AND sa.day = ?
''',
      [classSection, dayKey(day)],
    );
    if (rows.isEmpty) return null;
    return {
      for (final r in rows.map(StudentAttendanceDto.fromMap))
        r.studentId: AttendanceStatus.values.byName(r.status),
    };
  }

  @override
  Future<void> saveClassAttendance(
    String classSection,
    DateTime day,
    Map<String, AttendanceStatus> marks,
  ) async {
    final batch = _db.batch();
    for (final e in marks.entries) {
      batch.insert(
        'student_attendance',
        StudentAttendanceDto(
          studentId: e.key,
          day: dayKey(day),
          status: e.value.name,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
