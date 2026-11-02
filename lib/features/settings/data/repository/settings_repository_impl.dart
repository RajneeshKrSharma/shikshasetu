import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/school_settings.dart';
import '../../domain/repository/settings_repository.dart';
import '../dto/settings_dto.dart';
import '../models/school_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(
    this._database, {
    Future<Directory> Function()? documentsDirectory,
  }) : _documentsDirectory =
           documentsDirectory ?? getApplicationDocumentsDirectory;

  final AppDatabase _database;
  final Future<Directory> Function() _documentsDirectory;

  Future<void> _put(String key, String value) => _database.db.insert(
    'app_settings',
    {'key': key, 'value': value},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  @override
  Future<SchoolSettings> get() async {
    final rows = await _database.db.query('app_settings');
    final kv = {
      for (final r in rows) r['key']! as String: r['value']! as String,
    };
    return SchoolSettingsModel.fromDto(SettingsDto.fromKeyValues(kv));
  }

  @override
  Future<void> saveSchool({
    required String schoolName,
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    await _put('school_name', schoolName.trim());
    await _put('school_lat', '$latitude');
    await _put('school_lon', '$longitude');
    await _put('school_radius_m', '$radiusMeters');
  }

  @override
  Future<void> setAnnouncement(String? text) {
    final t = text?.trim();
    return (t == null || t.isEmpty)
        ? _database.db.delete(
            'app_settings',
            where: 'key = ?',
            whereArgs: ['announcement'],
          )
        : _put('announcement', t);
  }

  @override
  Future<void> setLogo(String? sourcePath) async {
    final rows = await _database.db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: ['school_logo'],
    );
    final old = rows.isEmpty ? null : rows.first['value']! as String;

    if (sourcePath == null) {
      await _database.db.delete(
        'app_settings',
        where: 'key = ?',
        whereArgs: ['school_logo'],
      );
    } else {
      // A new name each time, so a changed logo is not shown from the cache.
      final dir = Directory(p.join((await _documentsDirectory()).path, 'logo'));
      await dir.create(recursive: true);
      final copy = p.join(
        dir.path,
        'school_logo_${DateTime.now().microsecondsSinceEpoch}'
        '${p.extension(sourcePath).toLowerCase()}',
      );
      await File(sourcePath).copy(copy);
      await _put('school_logo', copy);
    }
    if (old != null) {
      final f = File(old);
      if (await f.exists()) await f.delete();
    }
  }

  @override
  Future<void> setLastBackup(DateTime at) =>
      _put('last_backup_at', '${at.millisecondsSinceEpoch}');
}
