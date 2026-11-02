import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/repository/demo_data_repository.dart';
import '../dto/demo_data_dto.dart';

/// Writes the demo school into the phone's database.
///
/// What it adds is kept apart from real data: every id starts with
/// [demoIdPrefix], and the few things that have no id of their own (classes,
/// school days, settings) are remembered in `app_settings` so [remove] can
/// take out exactly those.
class DemoDataRepositoryImpl implements DemoDataRepository {
  DemoDataRepositoryImpl(this._database, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _database;
  final DateTime Function() _clock;

  static const _classesKey = 'demo_classes';
  static const _daysKey = 'demo_days';
  static const _registeredKey = 'school_registered_on';
  static const _previousRegisteredKey = 'demo_prev_registered_on';
  static const _announcementKey = 'demo_announcement';
  static const _locationKey = 'demo_location';
  static const _dayKeysKey = 'demo_day_settings';
  static const _locationKeys = ['school_lat', 'school_lon', 'school_radius_m'];

  @override
  Future<void> load() => _database.db.transaction((txn) async {
    await _remove(txn);

    final principal = (await txn.query(
      'users',
      where: "role = 'principal'",
      limit: 1,
    )).firstOrNull;
    if (principal == null) {
      throw StateError('Demo data needs a Principal account to belong to.');
    }
    final settings = await _settings(txn);
    final data = DemoDataDto.build(
      principalId: principal['id']! as String,
      principalName: principal['name']! as String,
      now: _clock(),
      lat: double.tryParse(settings['school_lat'] ?? '') ?? demoSchoolLat,
      lon: double.tryParse(settings['school_lon'] ?? '') ?? demoSchoolLon,
    );

    // A class the Principal already has is left as it is, and not removed
    // with the demo data later.
    final have = {
      for (final c in await txn.query('classes'))
        (c['name']! as String).toLowerCase(),
    };
    final newClasses = [
      for (final c in data.classes)
        if (!have.contains((c['name']! as String).toLowerCase())) c,
    ];
    final days = {
      for (final d in await txn.query('school_days')) d['day']! as String,
    };
    final newDays = [
      for (final d in data.schoolDays)
        if (!days.contains(d['day'])) d,
    ];
    final newDayKeys = {for (final d in newDays) d['day']! as String};

    final batch = txn.batch();
    void insert(String table, Iterable<DemoRow> rows) {
      for (final r in rows) {
        batch.insert(table, r);
      }
    }

    insert('users', data.users);
    insert('classes', newClasses);
    insert('students', data.students);
    insert('other_staff', data.otherStaff);
    insert('teacher_subjects', data.teacherSubjects);
    insert('school_days', newDays);
    insert(
      'school_day_changes',
      data.schoolDayChanges.where((c) => newDayKeys.contains(c['day'])),
    );
    insert('teacher_attendance', data.teacherAttendance);
    insert('student_attendance', data.studentAttendance);
    insert('staff_attendance', data.staffAttendance);
    insert('exam_papers', data.examPapers);
    insert('exam_questions', data.examQuestions);
    insert('exam_marks', data.examMarks);
    insert('fee_accounts', data.feeAccounts);
    insert('fee_payments', data.feePayments);
    // What a class pays and is given is only added for classes made here, so
    // taking the demo data out leaves no setup behind on a class that was
    // already there.
    final madeNames = {for (final c in newClasses) c['name']! as String};
    insert(
      'fee_structure',
      data.feeStructure.where((r) => madeNames.contains(r['class_name'])),
    );
    insert(
      'accessory_items',
      data.accessoryItems.where((r) => madeNames.contains(r['class_name'])),
    );
    insert('accessory_issues', data.accessoryIssues);
    insert('staff_settlements', data.staffSettlements);
    insert('staff_bills', data.staffBills);

    // The school day is only filled in where the Principal has not done it.
    final haveSlots = (await txn.query('bell_slots', limit: 1)).isNotEmpty;
    if (!haveSlots) {
      insert('bell_slots', data.bellSlots);
      insert(
        'timetable_entries',
        data.timetableEntries.where((r) => madeNames.contains(r['class_name'])),
      );
      insert('school_timings', data.schoolTimings);
    }
    final haveDuty = (await txn.query('assembly_duty', limit: 1)).isNotEmpty;
    if (!haveDuty) insert('assembly_duty', data.assemblyDuty);
    insert('notices', data.notices);
    insert('master_questions', data.masterQuestions);
    insert('question_units', data.questionUnits);
    await batch.commit(noResult: true);

    // Only classes made here may have the demo class teacher, and only ones
    // made here are removed again.
    await _put(txn, _classesKey, jsonEncode(madeNames.toList()));
    await _put(txn, _daysKey, jsonEncode(newDayKeys.toList()));

    // The calendar starts where the demo year starts.
    final registered = int.tryParse(settings[_registeredKey] ?? '');
    final start = data.yearStart.millisecondsSinceEpoch;
    if (registered == null || registered > start) {
      if (registered != null) {
        await _put(txn, _previousRegisteredKey, '$registered');
      }
      await _put(txn, _registeredKey, '$start');
    }
    if (_locationKeys.any((k) => settings[k] == null)) {
      // Only what is missing is filled in, and only that is taken out later.
      await _put(txn, _locationKey, '1');
      for (final entry in {
        'school_lat': '$demoSchoolLat',
        'school_lon': '$demoSchoolLon',
        'school_radius_m': '$demoSchoolRadiusMeters',
      }.entries) {
        if (settings[entry.key] == null) {
          await _put(txn, entry.key, entry.value);
        }
      }
    }
    final daySet = <String>[];
    for (final e in data.daySettings.entries) {
      if (settings[e.key] == null) {
        await _put(txn, e.key, e.value);
        daySet.add(e.key);
      }
    }
    if (daySet.isNotEmpty) {
      await _put(txn, _dayKeysKey, jsonEncode(daySet));
    }
    if (settings['announcement'] == null) {
      await _put(txn, 'announcement', DemoDataDto.announcement);
      await _put(txn, _announcementKey, DemoDataDto.announcement);
    }
  });

  @override
  Future<void> remove() => _database.db.transaction(_remove);

  Future<void> _remove(Transaction txn) async {
    final settings = await _settings(txn);
    const like = '$demoIdPrefix%';

    // Before the teachers go, or the duty would lose its mark.
    await txn.delete(
      'assembly_duty',
      where: 'teacher_id LIKE ?',
      whereArgs: [like],
    );

    // Rows below these go with them (questions, marks, payments, attendance,
    // subjects), because the database cascades deletes.
    for (final table in [
      'bell_slots',
      'school_timings',
      'exam_papers',
      'fee_accounts',
      'notices',
      'master_questions',
      'question_units',
      'students',
      'other_staff',
      'users',
    ]) {
      await txn.delete(table, where: 'id LIKE ?', whereArgs: [like]);
    }

    for (final key in _decodeList(settings[_dayKeysKey])) {
      await txn.delete('app_settings', where: 'key = ?', whereArgs: [key]);
    }
    for (final name in _decodeList(settings[_classesKey])) {
      await txn.delete('classes', where: 'name = ?', whereArgs: [name]);
    }
    for (final day in _decodeList(settings[_daysKey])) {
      await txn.delete('school_days', where: 'day = ?', whereArgs: [day]);
      await txn.delete(
        'school_day_changes',
        where: 'day = ?',
        whereArgs: [day],
      );
    }

    // Put back what the demo data moved or filled in.
    final previous = settings[_previousRegisteredKey];
    if (previous != null) await _put(txn, _registeredKey, previous);
    if (settings[_announcementKey] != null &&
        settings['announcement'] == settings[_announcementKey]) {
      await txn.delete(
        'app_settings',
        where: 'key = ?',
        whereArgs: ['announcement'],
      );
    }
    if (settings[_locationKey] != null) {
      for (final key in _locationKeys) {
        await txn.delete('app_settings', where: 'key = ?', whereArgs: [key]);
      }
    }
    await txn.delete(
      'app_settings',
      where: 'key IN (?, ?, ?, ?, ?, ?)',
      whereArgs: [
        _classesKey,
        _daysKey,
        _previousRegisteredKey,
        _announcementKey,
        _locationKey,
        _dayKeysKey,
      ],
    );
  }

  Future<Map<String, String>> _settings(Transaction txn) async => {
    for (final r in await txn.query('app_settings'))
      r['key']! as String: r['value']! as String,
  };

  List<String> _decodeList(String? json) => json == null
      ? const []
      : [for (final v in jsonDecode(json) as List) '$v'];

  Future<void> _put(Transaction txn, String key, String value) => txn.insert(
    'app_settings',
    {'key': key, 'value': value},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
