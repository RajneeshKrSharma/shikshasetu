import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/assembly.dart';
import '../../domain/entities/day_time.dart';
import '../../domain/repository/school_day_repositories.dart';
import '../dto/school_day_dto.dart';
import '../models/school_day_models.dart';

class AssemblyRepositoryImpl implements AssemblyRepository {
  AssemblyRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  static const _keys = [
    'assembly_start_min',
    'assembly_end_min',
    'assembly_place',
    'assembly_days',
    'assembly_order',
  ];

  @override
  Future<AssemblySettings> get() async {
    final s = {
      for (final r in await _db.query(
        'app_settings',
        where: 'key IN (${_keys.map((_) => '?').join(',')})',
        whereArgs: _keys,
      ))
        r['key']! as String: r['value']! as String,
    };
    final start = int.tryParse(s['assembly_start_min'] ?? '');
    final end = int.tryParse(s['assembly_end_min'] ?? '');
    return AssemblySettings(
      start: start == null ? null : DayTime(start),
      end: end == null ? null : DayTime(end),
      place: s['assembly_place'] ?? '',
      days: {
        for (final d in (s['assembly_days'] ?? '').split(','))
          if (int.tryParse(d) != null) int.parse(d),
      },
      order: s['assembly_order'] == null
          ? const []
          : [for (final o in jsonDecode(s['assembly_order']!) as List) '$o'],
    );
  }

  Future<void> _put(DatabaseExecutor db, String key, String? value) =>
      value == null || value.isEmpty
      ? db.delete('app_settings', where: 'key = ?', whereArgs: [key])
      : db.insert('app_settings', {
          'key': key,
          'value': value,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

  @override
  Future<void> save(AssemblySettings a) => _db.transaction((txn) async {
    await _put(txn, 'assembly_start_min', a.start?.minutes.toString());
    await _put(txn, 'assembly_end_min', a.end?.minutes.toString());
    await _put(txn, 'assembly_place', a.place.trim());
    final days = a.days.toList()..sort();
    await _put(txn, 'assembly_days', days.join(','));
    await _put(
      txn,
      'assembly_order',
      a.order.isEmpty ? null : jsonEncode(a.order),
    );
  });

  @override
  Future<List<AssemblyDuty>> getDuties() async {
    final rows = await _db.rawQuery('''
SELECT d.weekday, d.class_name, d.teacher_id, u.name AS teacher_name
FROM assembly_duty d
LEFT JOIN users u ON u.id = d.teacher_id
ORDER BY d.weekday
''');
    return [
      for (final r in rows)
        AssemblyDutyModel.fromDto(AssemblyDutyDto.fromMap(r)),
    ];
  }

  @override
  Future<void> saveDuty(AssemblyDuty duty) => duty.isSet
      ? _db.insert(
          'assembly_duty',
          AssemblyDutyModel.toDto(duty).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
      : _db.delete(
          'assembly_duty',
          where: 'weekday = ?',
          whereArgs: [duty.weekday],
        );
}
