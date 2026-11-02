import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/bell_slot.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/repository/school_day_repositories.dart';
import '../dto/school_day_dto.dart';
import '../models/school_day_models.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  TimetableRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<List<BellSlot>> getSlots() async => [
    for (final r in await _db.query('bell_slots', orderBy: 'position'))
      BellSlotModel.fromDto(BellSlotDto.fromMap(r)),
  ];

  @override
  Future<void> saveSlot(BellSlot slot) => _db.insert(
    'bell_slots',
    BellSlotModel.toDto(slot).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  @override
  Future<void> deleteSlot(String id) => _db.transaction((txn) async {
    await txn.delete('bell_slots', where: 'id = ?', whereArgs: [id]);
    // The slots after it close the gap.
    final rest = await txn.query('bell_slots', orderBy: 'position');
    for (var i = 0; i < rest.length; i++) {
      await txn.update(
        'bell_slots',
        {'position': i},
        where: 'id = ?',
        whereArgs: [rest[i]['id']],
      );
    }
  });

  @override
  Future<List<TimetableEntry>> getEntries(String className) async {
    final rows = await _db.rawQuery(
      '''
SELECT e.*, u.name AS teacher_name
FROM timetable_entries e
LEFT JOIN users u ON u.id = e.teacher_id
WHERE e.class_name = ?
''',
      [className],
    );
    return [
      for (final r in rows)
        TimetableEntryModel.fromDto(TimetableEntryDto.fromMap(r)),
    ];
  }

  @override
  Future<void> saveEntry(TimetableEntry entry) async {
    final teacher = entry.teacherId;
    if (teacher != null) {
      final busy = await _db.rawQuery(
        '''
SELECT e.class_name, u.name AS teacher_name
FROM timetable_entries e
JOIN users u ON u.id = e.teacher_id
WHERE e.teacher_id = ? AND e.weekday = ? AND e.slot_id = ?
  AND e.class_name != ?
LIMIT 1
''',
        [teacher, entry.weekday, entry.slotId, entry.className],
      );
      if (busy.isNotEmpty) {
        final slot = (await getSlots()).firstWhere((s) => s.id == entry.slotId);
        throw TimetableConflict(
          teacherName: busy.first['teacher_name']! as String,
          className: busy.first['class_name']! as String,
          weekday: entry.weekday,
          slot: slot,
        );
      }
    }
    await _db.insert(
      'timetable_entries',
      TimetableEntryModel.toDto(entry).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> clearEntry(String className, int weekday, String slotId) =>
      _db.delete(
        'timetable_entries',
        where: 'class_name = ? AND weekday = ? AND slot_id = ?',
        whereArgs: [className, weekday, slotId],
      );

  @override
  Future<List<TeacherPeriod>> getTeacherPeriods(
    String teacherId,
    int weekday,
  ) async {
    final slots = await getSlots();
    final mine = await _db.query(
      'timetable_entries',
      where: 'teacher_id = ? AND weekday = ?',
      whereArgs: [teacherId, weekday],
    );
    var number = 0;
    final out = <TeacherPeriod>[];
    for (final s in slots) {
      if (!s.isPeriod) continue;
      number++;
      for (final r in mine) {
        if (r['slot_id'] == s.id) {
          out.add(
            TeacherPeriod(
              slot: s,
              number: number,
              className: r['class_name']! as String,
              subject: r['subject']! as String,
            ),
          );
        }
      }
    }
    return out;
  }

  @override
  Future<List<TeachingOption>> getOptions(String className) async {
    final rows = await _db.rawQuery(
      '''
SELECT t.subject, t.teacher_id, u.name AS teacher_name
FROM teacher_subjects t
JOIN users u ON u.id = t.teacher_id
WHERE t.class_name = ? AND t.status = 'approved' AND u.active = 1
ORDER BY t.subject COLLATE NOCASE, u.name COLLATE NOCASE
''',
      [className],
    );
    return [
      for (final r in rows)
        TeachingOption(
          subject: r['subject']! as String,
          teacherId: r['teacher_id']! as String,
          teacherName: r['teacher_name']! as String,
        ),
    ];
  }
}
