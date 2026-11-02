import '../../../../core/data/local/app_database.dart';
import '../../../../core/data/local/day_key.dart';
import '../../domain/entities/class_analytics.dart';
import '../../domain/entities/teacher_report.dart';
import '../../domain/repository/analytics_repository.dart';
import '../dto/analytics_dto.dart';
import '../models/analytics_models.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<ClassAnalytics> getClassAnalytics(
    String classSection,
    DateTime today,
  ) async {
    final db = _database.db;

    final trend = <double?>[];
    for (var i = 6; i >= 0; i--) {
      final day = DateTime(today.year, today.month, today.day - i);
      final rows = await db.rawQuery(
        '''
SELECT COUNT(*) AS total,
       COALESCE(SUM(CASE WHEN sa.status != 'absent' THEN 1 ELSE 0 END), 0)
         AS present
FROM student_attendance sa
JOIN students s ON s.id = sa.student_id
WHERE s.class_name = ? AND sa.day = ?
''',
        [classSection, dayKey(day)],
      );
      final total = rows.first['total']! as int;
      trend.add(
        total == 0 ? null : (rows.first['present']! as int) * 100 / total,
      );
    }

    final scores = await db.rawQuery(
      '''
SELECT p.subject AS subject,
       AVG(m.marks_obtained * 100.0 / t.total) AS avg
FROM exam_marks m
JOIN exam_papers p ON p.id = m.paper_id
JOIN (SELECT paper_id, SUM(marks) AS total
      FROM exam_questions GROUP BY paper_id) t ON t.paper_id = p.id
WHERE p.class_name = ? AND t.total > 0
GROUP BY p.subject
ORDER BY p.subject
''',
      [classSection],
    );

    return ClassAnalyticsModel.fromDto(
      ClassAnalyticsDto(
        trend: trend,
        subjects: {
          for (final r in scores)
            r['subject']! as String: (r['avg']! as num).toDouble(),
        },
      ),
    );
  }

  @override
  Future<List<TeacherReport>> getTeacherReports(
    DateTime today,
    int days,
  ) async {
    final db = _database.db;
    final from = dayKey(
      DateTime(today.year, today.month, today.day - days + 1),
    );
    final to = dayKey(today);

    final open = await db.rawQuery(
      "SELECT COUNT(*) AS n FROM school_days "
      "WHERE status = 'approved' AND day BETWEEN ? AND ?",
      [from, to],
    );
    final openDays = open.first['n']! as int;

    final teachers = await db.query(
      'users',
      where: "role = 'teacher' AND active = 1",
      orderBy: 'name',
    );

    final reports = <TeacherReport>[];
    for (final t in teachers) {
      final rows = await db.rawQuery(
        '''
SELECT a.check_in
FROM teacher_attendance a
JOIN school_days d ON d.day = a.day AND d.status = 'approved'
WHERE a.teacher_id = ? AND a.check_in IS NOT NULL
  AND a.day BETWEEN ? AND ?
''',
        [t['id'], from, to],
      );

      int? avgMinutes;
      if (rows.isNotEmpty) {
        final minutes = rows.map((r) {
          final at = DateTime.fromMillisecondsSinceEpoch(r['check_in']! as int);
          return at.hour * 60 + at.minute;
        });
        avgMinutes = (minutes.reduce((a, b) => a + b) / rows.length).round();
      }
      reports.add(
        TeacherReportModel.fromDto(
          TeacherReportDto(
            name: t['name']! as String,
            presentDays: rows.length,
            openDays: openDays,
            avgCheckInMinutes: avgMinutes,
          ),
        ),
      );
    }
    return reports;
  }
}
