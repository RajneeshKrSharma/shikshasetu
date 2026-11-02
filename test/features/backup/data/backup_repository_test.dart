import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/attendance/data/repository/attendance_repository_impl.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';
import 'package:shiksha_setu/features/backup/data/repository/backup_repository_impl.dart';
import 'package:shiksha_setu/features/backup/domain/entities/backup_entities.dart';
import 'package:shiksha_setu/features/classes/data/repository/classes_repository_impl.dart';
import 'package:shiksha_setu/features/students/data/repository/students_repository_impl.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late BackupRepositoryImpl backup;
  late Directory tempDir;
  late Directory docsDir;
  late ClassesRepositoryImpl classes;
  late AttendanceRepositoryImpl attendance;

  final at = DateTime(2026, 9, 30, 10, 15);

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('backup_tmp');
    docsDir = await Directory.systemTemp.createTemp('backup_docs');
    database = await openTestDatabase();
    backup = BackupRepositoryImpl(
      database,
      temporaryDirectory: () async => tempDir,
      documentsDirectory: () async => docsDir,
    );
    classes = ClassesRepositoryImpl(database);
    attendance = AttendanceRepositoryImpl(database);

    await classes.add('6-A');
    await insertStudent(database, 's1', '6-A');
    await insertTeacher(database, 't1', name: 'Anita');
    await attendance.saveClassAttendance('6-A', at, {
      's1': AttendanceStatus.late,
    });
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
    await docsDir.delete(recursive: true);
  });

  /// The JSON text of a fresh backup of the current data.
  Future<String> backupJson() async {
    final files = await backup.createFiles(at);
    return File(files.jsonPath).readAsString();
  }

  test('preview: counts the rows in each table', () async {
    final preview = backup.preview(await backupJson());

    expect(preview.students, 1);
    expect(preview.accounts, 1);
    expect(preview.createdAt, at);
  });

  test('restore: brings back data that was deleted afterwards', () async {
    final json = await backupJson();
    await classes.delete('6-A');
    expect(await classes.getClasses(), isEmpty);

    await backup.restore(json);

    expect([for (final c in await classes.getClasses()) c.name], ['6-A']);
    expect(await attendance.getClassAttendance('6-A', at), {
      's1': AttendanceStatus.late,
    });
  });

  test('restore: replaces data added after the backup', () async {
    final json = await backupJson();
    await classes.add('9-Z');

    await backup.restore(json);

    expect([for (final c in await classes.getClasses()) c.name], ['6-A']);
  });

  test('restore: keeps passwords so people can still sign in', () async {
    final before = (await database.db.query('users')).single;
    final json = await backupJson();

    await backup.restore(json);

    final after = (await database.db.query('users')).single;
    expect(after['password_hash'], before['password_hash']);
  });

  test('preview: text that is not JSON → not a backup', () {
    expect(
      () => backup.preview('hello'),
      throwsA(
        isA<BackupException>().having(
          (e) => e.reason,
          'reason',
          BackupProblem.notABackup,
        ),
      ),
    );
  });

  test('preview: JSON from another app → not a backup', () {
    expect(
      () => backup.preview('{"format":"other"}'),
      throwsA(isA<BackupException>()),
    );
  });

  test('preview: a backup from a newer app version is refused', () async {
    final data = jsonDecode(await backupJson()) as Map<String, dynamic>;
    data['schemaVersion'] = AppDatabase.schemaVersion + 1;

    expect(
      () => backup.preview(jsonEncode(data)),
      throwsA(
        isA<BackupException>().having(
          (e) => e.reason,
          'reason',
          BackupProblem.newerVersion,
        ),
      ),
    );
  });

  test('preview: a backup missing a table is corrupt', () async {
    final data = jsonDecode(await backupJson()) as Map<String, dynamic>;
    (data['tables'] as Map).remove('students');

    expect(
      () => backup.preview(jsonEncode(data)),
      throwsA(
        isA<BackupException>().having(
          (e) => e.reason,
          'reason',
          BackupProblem.corrupt,
        ),
      ),
    );
  });

  test('restore: a failing row leaves existing data untouched', () async {
    final data = jsonDecode(await backupJson()) as Map<String, dynamic>;
    // A student pointing at a class that does not exist breaks the insert.
    ((data['tables'] as Map)['students'] as List).first['class_name'] = 'nope';

    await expectLater(backup.restore(jsonEncode(data)), throwsA(anything));

    expect(
      [
        for (final s in await StudentsRepositoryImpl(
          database,
        ).getByClass('6-A'))
          s.id,
      ],
      ['s1'],
      reason: 'transaction rolled back',
    );
  });

  test('createFiles: writes a JSON file and an Excel file', () async {
    final files = await backup.createFiles(at);

    expect(File(files.jsonPath).existsSync(), isTrue);
    expect(File(files.excelPath).lengthSync(), greaterThan(0));
    expect(
      files.jsonPath,
      endsWith('shiksha_setu_backup_2026-09-30_1015.json'),
    );
  });

  test('createSafetyCopy: keeps a copy in the documents folder', () async {
    await backup.createSafetyCopy(at);

    final copies = Directory('${docsDir.path}/pre_restore').listSync();
    expect(copies.length, 2, reason: 'one JSON and one Excel file');
  });
}
