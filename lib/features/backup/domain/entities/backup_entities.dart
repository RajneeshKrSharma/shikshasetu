import 'package:equatable/equatable.dart';

enum BackupProblem {
  notABackup,
  newerVersion,

  /// The file is damaged: its contents do not match what was written.
  corrupt,

  /// A backup was written but reading it back did not match the data, or a
  /// restore did not give back the same number of rows.
  verifyFailed,
}

class BackupException implements Exception {
  const BackupException(this.reason);
  final BackupProblem reason;
}

/// What a backup file contains, shown before restoring.
class BackupPreview extends Equatable {
  const BackupPreview({
    required this.createdAt,
    required this.counts,
    this.writtenBy,
  });

  final DateTime createdAt;

  /// The Principal whose phone wrote the file, if it says.
  final String? writtenBy;

  /// Row count per table.
  final Map<String, int> counts;

  int get students => counts['students'] ?? 0;
  int get accounts => counts['users'] ?? 0;

  @override
  List<Object?> get props => [createdAt, counts, writtenBy];
}
