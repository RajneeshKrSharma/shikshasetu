import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/analytics.dart';
import '../../domain/repository/analytics_repository.dart';
import '../models/graph_mappers.dart';

class ServerAnalyticsRepository implements AnalyticsRepository {
  ServerAnalyticsRepository(this._client);

  final ServerClient _client;

  @override
  Future<GraphData> graph(
    GraphKind kind, {
    required DateTime from,
    required DateTime to,
    String? classId,
  }) async => GraphMapper.of(kind).map(
    jsonObject(
      await _client.send(
        'GET',
        kind.path,
        query: {
          'from': WireFormat.day(from),
          'to': WireFormat.day(to),
          if (kind.byClass) 'class_id': classId,
        },
      ),
    ),
  );
}
