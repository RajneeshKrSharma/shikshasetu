import '../../domain/entities/class_analytics.dart';
import '../../domain/entities/teacher_report.dart';
import '../dto/analytics_dto.dart';

class ClassAnalyticsModel extends ClassAnalytics {
  const ClassAnalyticsModel({
    required super.attendanceTrend,
    required super.subjectAverages,
  });

  factory ClassAnalyticsModel.fromDto(ClassAnalyticsDto d) =>
      ClassAnalyticsModel(
        attendanceTrend: d.trend,
        subjectAverages: d.subjects,
      );
}

class TeacherReportModel extends TeacherReport {
  const TeacherReportModel({
    required super.name,
    required super.presentDays,
    required super.openDays,
    super.avgCheckIn,
  });

  factory TeacherReportModel.fromDto(TeacherReportDto d) => TeacherReportModel(
    name: d.name,
    presentDays: d.presentDays,
    openDays: d.openDays,
    avgCheckIn: d.avgCheckInMinutes == null
        ? null
        : Duration(minutes: d.avgCheckInMinutes!),
  );
}
