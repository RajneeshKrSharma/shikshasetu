import '../../domain/entities/data_source_kind.dart';
import '../../domain/repository/data_source.dart';

class DataSourceRegistryImpl implements DataSourceRegistry {
  DataSourceRegistryImpl(Iterable<DataSource> sources, this.tables)
    : _sources = {for (final s in sources) s.kind: s};

  final Map<DataSourceKind, DataSource> _sources;

  @override
  final List<String> tables;

  @override
  DataSource of(DataSourceKind kind) => _sources[kind]!;
}
