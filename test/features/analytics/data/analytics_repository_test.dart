import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/analytics/data/repository/analytics_repository_impl.dart';
import 'package:shiksha_setu/features/classes/data/repository/classes_repository_impl.dart';
import 'package:shiksha_setu/features/attendance/data/repository/attendance_repository_impl.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/check_point.dart';
import 'package:shiksha_setu/features/exams/data/repository/exams_repository_impl.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late AnalyticsRepositoryImpl analytics;
  late AttendanceRepositoryImpl attendance;

  final today = DateTime(2026, 9, 30, 9);
  DateTime daysAgo(int n) => DateTime(2026, 9, 30 - n, 9);

  setUp(() async {
    database = await openTestDatabase();
    analytics = AnalyticsRepositoryImpl(database);
    attendance = AttendanceRepositoryImpl(database);
    await ClassesRepositoryImpl(database).add('6-A');
    await insertStudent(database, 's1', '6-A', roll: 1);
    await insertStudent(database, 's2', '6-A', roll: 2);
  });

  tearDown(() => database.close());

  group('class analytics', () {
    test(
      'attendance trend: seven entries, oldest first, null when unmarked',
      () async {
        final result = await analytics.getClassAnalytics('6-A', today);

        expect(result.attendanceTrend.length, 7);
        expect(result.attendanceTrend.every((v) => v == null), isTrue);
        expect(result.hasAttendance, isFalse);
      },
    );

    test('attendance trend: late counts as present, absent does not', () async {
      await attendance.saveClassAttendance('6-A', today, {
        's1': AttendanceStatus.late,
        's2': AttendanceStatus.absent,
      });
      await attendance.saveClassAttendance('6-A', daysAgo(1), {
        's1': AttendanceStatus.present,
        's2': AttendanceStatus.present,
      });

      final trend = (await analytics.getClassAnalytics(
        '6-A',
        today,
      )).attendanceTrend;

      expect(trend.last, 50, reason: 'today: 1 of 2');
      expect(trend[5], 100, reason: 'yesterday: 2 of 2');
      expect(trend.first, isNull);
    });

    test(
      'subject averages: marks as a percentage of the paper total',
      () async {
        final exams = ExamsRepositoryImpl(database);
        await exams.savePaper(
          ExamPaper(
            id: 'p1',
            title: 'T',
            subject: 'Maths',
            classSection: '6-A',
            date: today,
            durationMinutes: 60,
            status: PaperStatus.conducted,
            questions: const [Question(text: 'a', marks: 10)],
          ),
          'u',
        );
        await exams.saveMarks('p1', {'s1': 8, 's2': 6});

        final result = await analytics.getClassAnalytics('6-A', today);

        expect(result.subjectAverages['Maths'], closeTo(70, 0.001));
      },
    );

    test('subject averages: a class with no marks → empty', () async {
      expect(
        (await analytics.getClassAnalytics('6-A', today)).subjectAverages,
        isEmpty,
      );
    });
  });

  group('teacher report', () {
    const point = CheckPoint(latitude: 0, longitude: 0, distanceMeters: 1);

    setUp(() async {
      await insertTeacher(database, 't1', name: 'Anita');
    });

    test('no approved school days → attendance percent is unknown', () async {
      final r = (await analytics.getTeacherReports(today, 30)).single;

      expect(r.attendancePercent, isNull);
    });

    test('percent = days present ÷ approved school days', () async {
      for (var i = 0; i < 4; i++) {
        await attendance.setDayStatus(
          daysAgo(i),
          SchoolDayStatus.approved,
          'p',
        );
      }
      await attendance.checkIn('t1', DateTime(2026, 9, 30, 8, 0), point);
      await attendance.checkIn('t1', DateTime(2026, 9, 29, 8, 30), point);

      final r = (await analytics.getTeacherReports(today, 30)).single;

      expect((r.presentDays, r.openDays), (2, 4));
      expect(r.attendancePercent, 50);
      expect(r.avgCheckIn, const Duration(hours: 8, minutes: 15));
    });

    test('a check-in on a day that was not approved is not counted', () async {
      await attendance.setDayStatus(daysAgo(0), SchoolDayStatus.approved, 'p');
      await attendance.setDayStatus(daysAgo(1), SchoolDayStatus.rejected, 'p');
      await attendance.checkIn('t1', daysAgo(1), point);

      final r = (await analytics.getTeacherReports(today, 30)).single;

      expect(r.presentDays, 0);
    });

    test('days outside the window are ignored', () async {
      await attendance.setDayStatus(daysAgo(40), SchoolDayStatus.approved, 'p');

      final r = (await analytics.getTeacherReports(today, 30)).single;

      expect(r.openDays, 0);
    });
  });
}
