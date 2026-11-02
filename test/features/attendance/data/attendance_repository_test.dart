import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/attendance/data/repository/attendance_repository_impl.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/check_point.dart';
import 'package:shiksha_setu/features/classes/data/repository/classes_repository_impl.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late AttendanceRepositoryImpl repo;

  final monday = DateTime(2026, 9, 28, 8, 30);
  final tuesday = DateTime(2026, 9, 29, 8, 30);

  setUp(() async {
    database = await openTestDatabase();
    repo = AttendanceRepositoryImpl(database);
  });

  tearDown(() => database.close());

  group('student attendance', () {
    setUp(() async {
      await ClassesRepositoryImpl(database).add('6-A');
      await insertStudent(database, 's1', '6-A', roll: 1);
      await insertStudent(database, 's2', '6-A', roll: 2);
    });

    test('getClassAttendance: nothing saved for that day → null', () async {
      expect(await repo.getClassAttendance('6-A', monday), isNull);
    });

    test('saveClassAttendance: marks are kept per day', () async {
      await repo.saveClassAttendance('6-A', monday, {
        's1': AttendanceStatus.present,
        's2': AttendanceStatus.absent,
      });
      await repo.saveClassAttendance('6-A', tuesday, {
        's1': AttendanceStatus.absent,
        's2': AttendanceStatus.absent,
      });

      final mon = await repo.getClassAttendance('6-A', monday);
      final tue = await repo.getClassAttendance('6-A', tuesday);
      expect(mon!['s1'], AttendanceStatus.present);
      expect(
        tue!['s1'],
        AttendanceStatus.absent,
        reason: 'history is separate',
      );
    });

    test('saveClassAttendance: saving again the same day overwrites', () async {
      await repo.saveClassAttendance('6-A', monday, {
        's1': AttendanceStatus.absent,
        's2': AttendanceStatus.absent,
      });
      await repo.saveClassAttendance('6-A', monday, {
        's1': AttendanceStatus.present,
        's2': AttendanceStatus.absent,
      });

      expect(
        (await repo.getClassAttendance('6-A', monday))!['s1'],
        AttendanceStatus.present,
      );
    });
  });

  group('school day', () {
    test('getDayStatus: no decision yet → pending', () async {
      expect(await repo.getDayStatus(monday), SchoolDayStatus.pending);
    });

    test('setDayStatus: approval is stored for that day only', () async {
      await repo.setDayStatus(monday, SchoolDayStatus.approved, 'p1');

      expect(await repo.getDayStatus(monday), SchoolDayStatus.approved);
      expect(await repo.getDayStatus(tuesday), SchoolDayStatus.pending);
    });

    test('setDayStatus: back to pending clears the decision', () async {
      await repo.setDayStatus(monday, SchoolDayStatus.approved, 'p1');

      await repo.setDayStatus(monday, SchoolDayStatus.pending, 'p1');

      expect(await repo.getDayStatus(monday), SchoolDayStatus.pending);
    });
  });

  group('teacher attendance', () {
    const point = CheckPoint(
      latitude: 12.97,
      longitude: 77.59,
      distanceMeters: 42,
      selfiePath: '/tmp/selfie.jpg',
    );

    setUp(() async {
      await insertTeacher(database, 't1', name: 'Anita');
      await insertTeacher(database, 't2', name: 'Bela', active: false);
    });

    test('getTeacherRecords: only active teachers, not yet in', () async {
      final records = await repo.getTeacherRecords(monday);

      expect(records.map((r) => r.teacherName), ['Anita']);
      expect(records.single.isPresent, isFalse);
    });

    test('checkIn: time, distance and selfie are stored', () async {
      await repo.checkIn('t1', monday, point);

      final r = (await repo.getTeacherRecords(monday)).single;
      expect(r.checkIn, monday);
      expect(r.checkInPoint?.distanceMeters, 42);
      expect(r.checkInPoint?.selfiePath, '/tmp/selfie.jpg');
    });

    test('checkOut: completes the same day’s record', () async {
      await repo.checkIn('t1', monday, point);
      final out = monday.add(const Duration(hours: 7));

      await repo.checkOut('t1', out, point);

      final r = (await repo.getTeacherRecords(monday)).single;
      expect(r.checkOut, out);
      expect(r.workedAt(DateTime(2030)), const Duration(hours: 7));
    });

    test('getTeacherRecords: another day starts fresh', () async {
      await repo.checkIn('t1', monday, point);

      expect((await repo.getTeacherRecords(tuesday)).single.isPresent, isFalse);
    });
  });
}
