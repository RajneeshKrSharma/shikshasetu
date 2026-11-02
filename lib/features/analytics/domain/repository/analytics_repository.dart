import '../entities/class_analytics.dart';
import '../entities/teacher_report.dart';

abstract interface class AnalyticsRepository {
  Future<ClassAnalytics> getClassAnalytics(String classSection, DateTime today);

  /// Per-teacher attendance over the last [days] days up to [today].
  Future<List<TeacherReport>> getTeacherReports(DateTime today, int days);
}
