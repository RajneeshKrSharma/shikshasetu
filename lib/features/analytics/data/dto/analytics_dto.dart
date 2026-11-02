/// Raw aggregate results for one class.
class ClassAnalyticsDto {
  const ClassAnalyticsDto({required this.trend, required this.subjects});

  final List<double?> trend;
  final Map<String, double> subjects;
}

/// Raw per-teacher aggregates over a reporting window.
class TeacherReportDto {
  const TeacherReportDto({
    required this.name,
    required this.presentDays,
    required this.openDays,
    this.avgCheckInMinutes,
  });

  final String name;
  final int presentDays;
  final int openDays;
  final int? avgCheckInMinutes;
}
