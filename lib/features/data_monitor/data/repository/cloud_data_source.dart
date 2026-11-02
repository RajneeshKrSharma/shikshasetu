import '../../domain/entities/data_source_kind.dart';
import '../../domain/entities/source_summary.dart';
import '../../domain/repository/data_source.dart';

/// The school's data on the server. Not connected yet, so it reports that
/// nobody is signed in and has no rows.
class CloudDataSource implements DataSource {
  const CloudDataSource();

  @override
  DataSourceKind get kind => DataSourceKind.cloud;

  @override
  Future<SourceSummary> summary() async =>
      SourceSummary.unavailable(kind, SourceProblem.notSignedIn);

  @override
  Future<Map<String, Map<String, Object?>>> rows(String table) async =>
      const {};

  @override
  Future<String?> nameOf(String table, String key) async => null;
}
