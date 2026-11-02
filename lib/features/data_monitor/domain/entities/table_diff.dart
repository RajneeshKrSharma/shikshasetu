import 'package:equatable/equatable.dart';

import 'data_source_kind.dart';

/// How a row compares between two places.
enum RowStatus { same, onlyLeft, onlyRight, changed }

/// One row, as it is in each place.
class RowEntry extends Equatable {
  const RowEntry({
    required this.key,
    required this.name,
    required this.status,
    this.left,
    this.right,
    this.changedColumns = const [],
  });

  final String key;

  /// What a person would call it (a student's name, a notice's title...).
  final String name;
  final RowStatus status;

  /// The row's values in the left and right place (null where it is absent).
  final Map<String, Object?>? left;
  final Map<String, Object?>? right;

  /// For a changed row: the columns whose values differ.
  final List<String> changedColumns;

  @override
  List<Object?> get props => [key, name, status, left, right, changedColumns];
}

/// One table compared between two places, row by row.
class TableDiff extends Equatable {
  const TableDiff({
    required this.table,
    required this.left,
    required this.right,
    required this.entries,
    required this.same,
    required this.onlyLeft,
    required this.onlyRight,
    required this.changed,
  });

  final String table;
  final DataSourceKind left;
  final DataSourceKind right;

  /// The rows to show: the ones that differ first, then some that match.
  final List<RowEntry> entries;

  /// How many rows are in each state (entries may hold only some of them).
  final int same;
  final int onlyLeft;
  final int onlyRight;
  final int changed;

  int get total => same + onlyLeft + onlyRight + changed;
  bool get matches => onlyLeft == 0 && onlyRight == 0 && changed == 0;
  bool get truncated => entries.length < total;

  @override
  List<Object?> get props => [
    table,
    left,
    right,
    entries,
    same,
    onlyLeft,
    onlyRight,
    changed,
  ];
}
