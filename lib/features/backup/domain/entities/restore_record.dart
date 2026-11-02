import 'package:equatable/equatable.dart';

/// One restore that was done: what it replaced, so it is always clear that
/// data was overridden, and where the earlier data was kept.
class RestoreRecord extends Equatable {
  const RestoreRecord({
    required this.at,
    required this.added,
    required this.changed,
    required this.removed,
    required this.appWasNewer,
    this.backupAt,
    this.earlierDataFile,
  });

  /// When the restore was done.
  final DateTime at;

  /// When the backup that was restored was made.
  final DateTime? backupAt;

  /// Rows the restore brought in, replaced, and took away.
  final int added;
  final int changed;
  final int removed;

  /// The app had newer changes than the backup, and they were overridden.
  final bool appWasNewer;

  /// Name of the file (in Downloads/ShikshaSetu) holding the data as it was
  /// before; null if it could not be kept there.
  final String? earlierDataFile;

  @override
  List<Object?> get props => [
    at,
    backupAt,
    added,
    changed,
    removed,
    appWasNewer,
    earlierDataFile,
  ];
}
