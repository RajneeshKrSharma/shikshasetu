import '../../../../core/usecase/usecase.dart';
import '../entities/cloud_entities.dart';
import '../entities/record_changes.dart';
import '../entities/row_hash.dart';
import '../entities/sync_activity.dart';
import '../repository/cloud_sync_repositories.dart';

/// Teacher: sends what they recorded (their check-ins, their class's
/// attendance and marks) to the cloud. Only changed rows are sent. Throws
/// [CloudSyncException].
class PushTeacherWork implements UseCase<void, NoParams> {
  PushTeacherWork({
    required SyncSourceRepository source,
    required SyncStateRepository state,
    required CloudStoreRepository cloud,
    SyncActivityLog? log,
  }) : _source = source,
       _state = state,
       _cloud = cloud,
       _log = log;

  final SyncSourceRepository _source;
  final SyncStateRepository _state;
  final CloudStoreRepository _cloud;
  final SyncActivityLog? _log;

  static const tables = [
    'teacher_attendance',
    'student_attendance',
    'exam_marks',
  ];

  @override
  Future<void> call(NoParams params) async {
    final connection = await _cloud.connection();
    if (!connection.isReady) {
      throw const CloudSyncException(CloudSyncFailure.signedOut);
    }
    final schoolId = await _source.schoolId();
    for (final table in tables) {
      final rows = await _source.table(table);
      final now = {for (final r in rows.entries) r.key: rowHash(r.value)};
      final before = await _state.hashesOf(table);
      final snapshots = await _state.snapshotsOf(table);
      final changed = [
        for (final k in now.keys)
          if (before[k] != now[k]) k,
      ];
      if (changed.isEmpty) continue;
      await _cloud.write(
        schoolId,
        table,
        upserts: {for (final k in changed) k: rows[k]!},
        deletes: const {},
      );
      await _state.apply(
        table,
        upserts: {for (final k in changed) k: now[k]!},
        snapshots: {for (final k in changed) k: RecordChanges.encode(rows[k]!)},
      );
      for (final k in changed) {
        _log?.recordSent(
          await RecordChanges.sent(
            source: _source,
            table: table,
            key: k,
            row: rows[k]!,
            snapshot: snapshots[k],
            hadBefore: before.containsKey(k),
          ),
        );
      }
    }
  }
}

class SendPaperRequests implements UseCase<void, NoParams> {
  const SendPaperRequests(this._repository);

  final PaperRequestsRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.sendSubmitted();
}

class ApplyPaperDecisions implements UseCase<bool, NoParams> {
  const ApplyPaperDecisions(this._repository);

  final PaperRequestsRepository _repository;

  @override
  Future<bool> call(NoParams params) => _repository.applyDecisions();
}

class ImportPaperRequests implements UseCase<List<PaperRequest>, NoParams> {
  const ImportPaperRequests(this._repository);

  final PaperRequestsRepository _repository;

  @override
  Future<List<PaperRequest>> call(NoParams params) =>
      _repository.importRequests();
}

class SendSubjectRequests implements UseCase<void, NoParams> {
  const SendSubjectRequests(this._repository);

  final SubjectRequestsRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.sendPending();
}

class ImportSubjectRequests implements UseCase<List<PaperRequest>, NoParams> {
  const ImportSubjectRequests(this._repository);

  final SubjectRequestsRepository _repository;

  @override
  Future<List<PaperRequest>> call(NoParams params) =>
      _repository.importRequests();
}

class ImportTeacherWork implements UseCase<bool, bool> {
  const ImportTeacherWork(this._repository);

  final TeacherWorkRepository _repository;

  /// [withMarks]: also bring in exam marks (heavier, so not on every check).
  @override
  Future<bool> call(bool withMarks) =>
      _repository.importWork(withMarks: withMarks);
}
