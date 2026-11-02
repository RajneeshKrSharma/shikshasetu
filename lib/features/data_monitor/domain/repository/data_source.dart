import '../entities/data_source_kind.dart';
import '../entities/source_summary.dart';

/// One place the school's data lives. Only ever read.
abstract interface class DataSource {
  DataSourceKind get kind;

  /// Rows per table (or why it could not be read).
  Future<SourceSummary> summary();

  /// row key → the row's values, for every row of [table]. What stays on the
  /// phone (passwords, file paths) is left out in every place alike.
  Future<Map<String, Map<String, Object?>>> rows(String table);

  /// A name a person recognises for the row [key] of [table], if this place
  /// can tell. Null when it cannot (the row is not here).
  Future<String?> nameOf(String table, String key);
}

/// Finds the [DataSource] of a kind.
abstract interface class DataSourceRegistry {
  DataSource of(DataSourceKind kind);

  /// The tables that are kept in every place.
  List<String> get tables;
}
