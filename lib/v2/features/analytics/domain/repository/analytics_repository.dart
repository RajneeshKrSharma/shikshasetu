import '../entities/analytics.dart';

abstract interface class AnalyticsRepository {
  Future<GraphData> graph(
    GraphKind kind, {
    required DateTime from,
    required DateTime to,
    String? classId,
  });
}
