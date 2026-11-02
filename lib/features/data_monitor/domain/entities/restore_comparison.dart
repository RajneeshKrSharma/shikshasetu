import 'package:equatable/equatable.dart';

/// What restoring a backup would do to one table.
class TableRestoreChange extends Equatable {
  const TableRestoreChange({
    required this.table,
    required this.now,
    required this.backup,
    required this.added,
    required this.removed,
    required this.changed,
  });

  final String table;

  /// Rows in the app now, and in the backup.
  final int now;
  final int backup;

  /// Rows only the backup has (they would appear).
  final int added;

  /// Rows only the app has (they would be lost).
  final int removed;

  /// Rows both have, with different values (the backup's would be kept).
  final int changed;

  bool get differs => added + removed + changed > 0;

  @override
  List<Object?> get props => [table, now, backup, added, removed, changed];
}

/// The app's data side by side with a backup, table by table.
class RestoreComparison extends Equatable {
  const RestoreComparison({
    required this.backupAt,
    required this.tables,
    this.appChangedAt,
  });

  final DateTime? backupAt;

  /// When the app's data last changed.
  final DateTime? appChangedAt;
  final List<TableRestoreChange> tables;

  int get added => tables.fold(0, (a, t) => a + t.added);
  int get removed => tables.fold(0, (a, t) => a + t.removed);
  int get changed => tables.fold(0, (a, t) => a + t.changed);
  bool get noChange => added + removed + changed == 0;

  /// The app has changes made after this backup was taken, which restoring
  /// would override.
  bool get appIsNewer {
    final a = appChangedAt;
    final b = backupAt;
    return a != null && b != null && a.isAfter(b);
  }

  /// Rows the app has that the backup would replace or remove.
  int get overridden => removed + changed;

  @override
  List<Object?> get props => [backupAt, appChangedAt, tables];
}
