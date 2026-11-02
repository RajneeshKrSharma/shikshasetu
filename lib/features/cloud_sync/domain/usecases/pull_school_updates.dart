import '../../../../core/usecase/usecase.dart';
import '../repository/cloud_sync_repositories.dart';

/// A Teacher's phone fetches what the Principal changed (school day approval,
/// notices, settings, their class). Throws `CloudSyncException`.
class PullSchoolUpdates implements UseCase<void, NoParams> {
  const PullSchoolUpdates(this._puller);

  final SchoolPullRepository _puller;

  @override
  Future<void> call(NoParams params) => _puller.pull();
}
