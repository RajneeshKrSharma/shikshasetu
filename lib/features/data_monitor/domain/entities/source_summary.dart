import 'package:equatable/equatable.dart';

import 'data_source_kind.dart';

/// What one place holds: rows per table, and how recent that is.
class SourceSummary extends Equatable {
  const SourceSummary({
    required this.kind,
    required this.counts,
    this.asOf,
    this.problem,
  });

  /// A source that could not be read, and why.
  const SourceSummary.unavailable(this.kind, this.problem)
    : counts = const {},
      asOf = null;

  final DataSourceKind kind;

  /// Rows per table.
  final Map<String, int> counts;

  /// When this copy was made (the file) or read (the others).
  final DateTime? asOf;

  /// Why it could not be read, if it could not.
  final SourceProblem? problem;

  bool get available => problem == null;
  int get total => counts.values.fold(0, (a, b) => a + b);

  @override
  List<Object?> get props => [kind, counts, asOf, problem];
}

enum SourceProblem {
  /// No such copy yet (for example no data file written).
  missing,
  notSignedIn,
  offline,
  other,
}
