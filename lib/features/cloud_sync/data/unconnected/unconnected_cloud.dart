import '../../domain/entities/cloud_entities.dart';
import '../../domain/repository/cloud_sync_repositories.dart';

const _notConfigured = CloudSyncException(CloudSyncFailure.notConfigured);

/// The cloud side of syncing, until the school's server is connected. Each
/// class answers the way an unconfigured build always did, so the screens
/// keep showing their "not connected" state.
class UnconnectedCloudStore implements CloudStoreRepository {
  const UnconnectedCloudStore();

  @override
  Future<CloudConnection> connection() async =>
      const CloudConnection(CloudStatus.notConfigured);

  @override
  Future<void> ensureSchool(
    String schoolId,
    String schoolName,
    SchoolAccess access,
  ) => Future.error(_notConfigured);

  @override
  Future<void> write(
    String schoolId,
    String table, {
    required Map<String, Map<String, Object?>> upserts,
    required Set<String> deletes,
  }) => Future.error(_notConfigured);
}

class UnconnectedSchoolPull implements SchoolPullRepository {
  const UnconnectedSchoolPull();

  @override
  Future<void> pull() => Future.error(_notConfigured);
}

class UnconnectedPaperRequests implements PaperRequestsRepository {
  const UnconnectedPaperRequests();

  @override
  Future<void> sendSubmitted() => Future.error(_notConfigured);

  @override
  Future<bool> applyDecisions() => Future.error(_notConfigured);

  @override
  Future<List<PaperRequest>> importRequests() => Future.error(_notConfigured);
}

class UnconnectedSubjectRequests implements SubjectRequestsRepository {
  const UnconnectedSubjectRequests();

  @override
  Future<void> sendPending() => Future.error(_notConfigured);

  @override
  Future<List<PaperRequest>> importRequests() => Future.error(_notConfigured);
}

class UnconnectedTeacherWork implements TeacherWorkRepository {
  const UnconnectedTeacherWork();

  @override
  Future<bool> importWork({bool withMarks = false}) =>
      Future.error(_notConfigured);
}
