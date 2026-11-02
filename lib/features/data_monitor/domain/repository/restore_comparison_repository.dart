import '../entities/restore_comparison.dart';
import '../entities/table_diff.dart';

/// Compares a backup file with the data in the app. Only reads.
abstract interface class RestoreComparisonRepository {
  /// What restoring [jsonText] would do, table by table.
  Future<RestoreComparison> compare(String jsonText);

  /// One table row by row: the app now (left) and the backup (right).
  Future<TableDiff> diffTable(String jsonText, String table);
}
