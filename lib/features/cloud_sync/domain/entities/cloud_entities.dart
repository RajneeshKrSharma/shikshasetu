import 'package:equatable/equatable.dart';

import 'sync_feature.dart';
import 'sync_record_change.dart';

/// Whether this build can reach the cloud, and whether the Principal is
/// signed in to the app (which is also the cloud account).
enum CloudStatus {
  /// No server is connected to this build.
  notConfigured,

  /// A server is there but nobody is signed in.
  signedOut,
  ready,
}

class CloudConnection extends Equatable {
  const CloudConnection(this.status, {this.email, this.projectId});

  final CloudStatus status;

  /// The cloud account that owns this school's data.
  final String? email;

  /// The server project the data goes to.
  final String? projectId;

  bool get isReady => status == CloudStatus.ready;

  @override
  List<Object?> get props => [status, email, projectId];
}

/// Who besides the Principal may read this school's cloud data, and which
/// class each of them teaches. Kept on the school's cloud record, where the
/// security rules read it.
class SchoolAccess extends Equatable {
  const SchoolAccess({
    this.teacherUids = const [],
    this.classOfTeacher = const {},
  });

  /// Accounts of the active teachers (sorted, so equal access compares equal).
  final List<String> teacherUids;

  /// teacher account id → name of the class they are class teacher of.
  final Map<String, String> classOfTeacher;

  @override
  List<Object?> get props => [teacherUids, classOfTeacher];
}

/// A question paper a teacher sent for the Principal's approval.
class PaperRequest extends Equatable {
  const PaperRequest({
    required this.paperId,
    required this.title,
    required this.teacherName,
  });

  final String paperId;
  final String title;
  final String teacherName;

  @override
  List<Object?> get props => [paperId, title, teacherName];
}

/// What one sync sent: rows written and removed, per table.
class SyncRun extends Equatable {
  const SyncRun({
    required this.at,
    this.uploaded = const {},
    this.deleted = const {},
    this.changes = const [],
  });

  final DateTime at;
  final Map<String, int> uploaded;
  final Map<String, int> deleted;

  /// The records sent or removed, with what changed in each. Kept only while
  /// the app runs, not saved; the counts above are.
  final List<SyncRecordChange> changes;

  /// Records sent / removed, added up per feature.
  Map<SyncFeature, int> get uploadedByFeature => _byFeature(uploaded);
  Map<SyncFeature, int> get deletedByFeature => _byFeature(deleted);

  static Map<SyncFeature, int> _byFeature(Map<String, int> perTable) {
    final result = <SyncFeature, int>{};
    for (final e in perTable.entries) {
      result.update(
        SyncFeature.ofTable(e.key),
        (n) => n + e.value,
        ifAbsent: () => e.value,
      );
    }
    return result;
  }

  int get totalUploaded => uploaded.values.fold(0, (a, b) => a + b);
  int get totalDeleted => deleted.values.fold(0, (a, b) => a + b);

  /// Nothing had changed since the last sync.
  bool get isEmpty => totalUploaded == 0 && totalDeleted == 0;

  @override
  List<Object?> get props => [at, uploaded, deleted, changes];
}

/// How far a sync has got: [done] of [total] tables (one per feature's data).
class SyncProgress extends Equatable {
  const SyncProgress(this.done, this.total, {this.table});

  final int done;
  final int total;

  /// The table being worked on, if one is.
  final String? table;

  SyncFeature? get feature =>
      table == null ? null : SyncFeature.ofTable(table!);

  /// 0..1, for a progress bar.
  double get fraction => total == 0 ? 0 : done / total;

  @override
  List<Object?> get props => [done, total, table];
}

/// Minutes between automatic syncs the Principal can pick from (0 = off is
/// always available). Syncing only happens while the app is open (that is the
/// only time data changes) and once more when the app is left.
const kSyncIntervalChoices = [1, 3, 5, 10, 15, 30, 60, 120];

/// Used until the Principal picks one.
const kDefaultSyncIntervalMinutes = 3;

enum CloudSyncFailure {
  /// No server is connected to this build.
  notConfigured,
  signedOut,

  /// The school's cloud data belongs to a different account.
  notOwner,

  /// No answer from the cloud in time (usually no internet).
  offline,
  other,
}

class CloudSyncException implements Exception {
  const CloudSyncException(this.reason);

  final CloudSyncFailure reason;

  @override
  String toString() => 'CloudSyncException($reason)';
}
