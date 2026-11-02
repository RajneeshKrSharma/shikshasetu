import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/day_time.dart';
import '../../domain/entities/school_timing.dart';
import '../../domain/repository/school_day_repositories.dart';
import '../dto/school_day_dto.dart';
import '../models/school_day_models.dart';

class SchoolTimingRepositoryImpl implements SchoolTimingRepository {
  SchoolTimingRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  static const _startKey = 'school_start_min';
  static const _endKey = 'school_end_min';
  static const _daysKey = 'school_working_days';

  Future<Map<String, String>> _settings() async => {
    for (final r in await _db.query(
      'app_settings',
      where: 'key IN (?, ?, ?)',
      whereArgs: [_startKey, _endKey, _daysKey],
    ))
      r['key']! as String: r['value']! as String,
  };

  @override
  Future<SchoolTiming> get() async {
    final s = await _settings();
    final start = int.tryParse(s[_startKey] ?? '');
    final end = int.tryParse(s[_endKey] ?? '');
    return SchoolTiming(
      start: start == null ? null : DayTime(start),
      end: end == null ? null : DayTime(end),
      workingDays: {
        for (final d in (s[_daysKey] ?? '').split(','))
          if (int.tryParse(d) != null) int.parse(d),
      },
      rules: [
        for (final r in await _db.query('school_timings', orderBy: 'from_date'))
          TimingRuleModel.fromDto(TimingRuleDto.fromMap(r)),
      ],
    );
  }

  Future<void> _put(DatabaseExecutor db, String key, String? value) =>
      value == null
      ? db.delete('app_settings', where: 'key = ?', whereArgs: [key])
      : db.insert('app_settings', {
          'key': key,
          'value': value,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

  @override
  Future<void> saveBase(SchoolTiming base) => _db.transaction((txn) async {
    await _put(txn, _startKey, base.start?.minutes.toString());
    await _put(txn, _endKey, base.end?.minutes.toString());
    final days = base.workingDays.toList()..sort();
    await _put(txn, _daysKey, days.isEmpty ? null : days.join(','));
  });

  @override
  Future<void> saveRule(TimingRule rule) => _db.insert(
    'school_timings',
    TimingRuleModel.toDto(rule).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  @override
  Future<void> deleteRule(String id) =>
      _db.delete('school_timings', where: 'id = ?', whereArgs: [id]);
}
