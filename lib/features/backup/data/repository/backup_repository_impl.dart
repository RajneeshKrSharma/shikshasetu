import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/backup_entities.dart';
import '../../domain/repository/backup_repository.dart';
import '../dto/backup_dto.dart';
import '../models/backup_preview_model.dart';

/// Writes the whole database to a JSON file (used for restore), keeps the data
/// file beside the database, and restores from the JSON.
class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl(
    this._database, {
    Future<Directory> Function()? documentsDirectory,
    Future<Directory> Function()? temporaryDirectory,
  }) : _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory,
       _documentsDirectory =
           documentsDirectory ?? getApplicationDocumentsDirectory;

  final AppDatabase _database;
  final Future<Directory> Function() _documentsDirectory;
  final Future<Directory> Function() _temporaryDirectory;

  Database get _db => _database.db;

  Future<BackupDto> _snapshot(DateTime at) async {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final t in AppDatabase.backupTables) {
      tables[t] = await _db.query(t);
    }
    final principal = await _db.query(
      'users',
      columns: ['id'],
      where: "role = 'principal'",
      limit: 1,
    );
    return BackupDto(
      writtenBy: principal.isEmpty ? null : principal.first['id'] as String?,
      format: BackupDto.formatName,
      schemaVersion: AppDatabase.schemaVersion,
      createdAt: at.toIso8601String(),
      tables: tables,
    );
  }

  /// Writes the data as a JSON file in [dir] and checks it by reading it
  /// back.
  Future<String> _write(Directory dir, DateTime at) async {
    await dir.create(recursive: true);
    final stamp = DateFormat('yyyy-MM-dd_HHmm').format(at);
    final data = await _snapshot(at);

    final file = File(p.join(dir.path, 'shiksha_setu_backup_$stamp.json'));
    await file.writeAsString(jsonEncode(data.toJson()));
    // Read it back: a backup is only a backup if it matches the data.
    try {
      final back = _parse(await file.readAsString());
      if (!_sameCounts(back.counts, data.counts) ||
          back.computeChecksum() != data.computeChecksum()) {
        throw const BackupException(BackupProblem.verifyFailed);
      }
    } catch (_) {
      if (await file.exists()) await file.delete();
      rethrow;
    }
    return file.path;
  }

  @override
  Future<String> writeMirror(DateTime at) async {
    final dir = Directory(
      p.join((await _documentsDirectory()).path, mirrorFolder),
    );
    await dir.create(recursive: true);
    final data = await _snapshot(at);
    final temp = File(p.join(dir.path, '$mirrorFile.tmp'));
    await temp.writeAsString(jsonEncode(data.toJson()));
    try {
      final back = _parse(await temp.readAsString());
      if (!_sameCounts(back.counts, data.counts) ||
          back.computeChecksum() != data.computeChecksum()) {
        throw const BackupException(BackupProblem.verifyFailed);
      }
    } catch (_) {
      if (await temp.exists()) await temp.delete();
      rethrow;
    }
    // The previous file stays until the new one is complete.
    final done = await temp.rename(p.join(dir.path, mirrorFile));
    return done.path;
  }

  @override
  Future<String> createZip(DateTime at) async {
    // Written fresh, so the ZIP has the very latest change.
    final jsonPath = await writeMirror(at);
    final stamp = DateFormat('yyyy-MM-dd_HHmm').format(at);
    final bytes = await File(jsonPath).readAsBytes();
    final archive = Archive()
      ..addFile(
        ArchiveFile('shiksha_setu_backup_$stamp.json', bytes.length, bytes),
      );
    final dir = Directory(
      p.join((await _temporaryDirectory()).path, 'backups'),
    );
    await dir.create(recursive: true);
    final zip = File(p.join(dir.path, 'shiksha_setu_backup_$stamp.zip'));
    await zip.writeAsBytes(ZipEncoder().encode(archive)!);
    return zip.path;
  }

  /// Where the data file is kept, inside the app's documents folder.
  static const mirrorFolder = 'data_mirror';
  static const mirrorFile = 'latest.json';

  @override
  Future<void> discardCopy(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<String> createSafetyCopy(DateTime at) async {
    final dir = Directory(
      p.join((await _documentsDirectory()).path, 'pre_restore'),
    );
    return _write(dir, at);
  }

  BackupDto _parse(String jsonText) {
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(jsonText) as Map<String, dynamic>;
    } catch (_) {
      throw const BackupException(BackupProblem.notABackup);
    }
    if (json['format'] != BackupDto.formatName) {
      throw const BackupException(BackupProblem.notABackup);
    }
    if ((json['schemaVersion'] as int? ?? 0) > AppDatabase.schemaVersion) {
      throw const BackupException(BackupProblem.newerVersion);
    }
    final tables = json['tables'];
    final version = json['schemaVersion'] as int? ?? 0;
    // A backup from an older app simply lacks the tables added since.
    final required = AppDatabase.backupTables.where(
      (t) => (AppDatabase.tableAddedIn[t] ?? 1) <= version,
    );
    if (tables is! Map<String, dynamic> ||
        !required.every(tables.containsKey)) {
      throw const BackupException(BackupProblem.corrupt);
    }
    final dto = BackupDto.fromJson(json);
    // Newer backups carry what they should hold; older ones have nothing to
    // check against and are accepted as before.
    final sum = dto.checksum;
    if (sum != null && sum != dto.computeChecksum()) {
      throw const BackupException(BackupProblem.corrupt);
    }
    final counts = json['counts'];
    if (counts is Map &&
        !_sameCounts(dto.counts, Map<String, int>.from(counts))) {
      throw const BackupException(BackupProblem.corrupt);
    }
    return dto;
  }

  bool _sameCounts(Map<String, int> a, Map<String, int> b) =>
      a.length == b.length && a.entries.every((e) => b[e.key] == e.value);

  @override
  BackupPreview preview(String jsonText) =>
      BackupPreviewModel.fromDto(_parse(jsonText));

  @override
  Future<void> restore(String jsonText) async {
    final data = _parse(jsonText);
    await _db.transaction((txn) async {
      for (final t in AppDatabase.backupTables.reversed) {
        await txn.delete(t);
      }
      for (final t in AppDatabase.backupTables) {
        for (final row in data.tables[t] ?? const <Map<String, Object?>>[]) {
          await txn.insert(t, row);
        }
      }
      // Rolls everything back unless every table holds what the backup had.
      for (final t in AppDatabase.backupTables) {
        final have = Sqflite.firstIntValue(
          await txn.rawQuery('SELECT COUNT(*) FROM $t'),
        );
        if (have != (data.tables[t]?.length ?? 0)) {
          throw const BackupException(BackupProblem.verifyFailed);
        }
      }
    });
  }
}
