import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/cloud_entities.dart';
import '../repository/cloud_sync_repositories.dart';

class GetCloudConnection implements UseCase<CloudConnection, NoParams> {
  const GetCloudConnection(this._cloud);

  final CloudStoreRepository _cloud;

  @override
  Future<CloudConnection> call(NoParams params) => _cloud.connection();
}

class GetLastSyncRun implements UseCase<SyncRun?, NoParams> {
  const GetLastSyncRun(this._state);

  final SyncStateRepository _state;

  @override
  Future<SyncRun?> call(NoParams params) => _state.lastRun();
}

/// The id under which this school's data is kept in the cloud.
class GetCloudSchoolId implements UseCase<String, NoParams> {
  const GetCloudSchoolId(this._source);

  final SyncSourceRepository _source;

  @override
  Future<String> call(NoParams params) => _source.schoolId();
}

class GetLastChangeRun implements UseCase<SyncRun?, NoParams> {
  const GetLastChangeRun(this._state);

  final SyncStateRepository _state;

  @override
  Future<SyncRun?> call(NoParams params) => _state.lastChangeRun();
}

class GetSyncInterval implements UseCase<int, NoParams> {
  const GetSyncInterval(this._settings);

  final SyncSettingsRepository _settings;

  @override
  Future<int> call(NoParams params) => _settings.intervalMinutes();
}

/// Saves how often to sync by itself, in minutes; 0 is off.
class SetSyncInterval implements UseCase<void, int> {
  const SetSyncInterval(this._settings);

  final SyncSettingsRepository _settings;

  @override
  Future<void> call(int minutes) => _settings.saveIntervalMinutes(minutes);
}

/// What the cloud still has to be sent: whether something changed, and the
/// number of the latest change.
class PendingChanges extends Equatable {
  const PendingChanges({required this.hasPending, required this.latest});

  final bool hasPending;
  final int latest;

  @override
  List<Object?> get props => [hasPending, latest];
}

class GetPendingChanges implements UseCase<PendingChanges, NoParams> {
  const GetPendingChanges(this._tracker);

  final ChangeTrackerRepository _tracker;

  @override
  Future<PendingChanges> call(NoParams params) async => PendingChanges(
    hasPending: await _tracker.hasPending(),
    latest: await _tracker.latest(),
  );
}

/// Whether the data file is behind, and the number of the latest change.
class GetMirrorPending implements UseCase<PendingChanges, NoParams> {
  const GetMirrorPending(this._tracker);

  final ChangeTrackerRepository _tracker;

  @override
  Future<PendingChanges> call(NoParams params) async => PendingChanges(
    hasPending: await _tracker.hasUnmirrored(),
    latest: await _tracker.latest(),
  );
}

/// Records that the data file holds everything up to a change number.
class MarkMirrored implements UseCase<void, int> {
  const MarkMirrored(this._tracker);

  final ChangeTrackerRepository _tracker;

  @override
  Future<void> call(int seq) => _tracker.markMirrored(seq);
}

/// Records that everything up to a change number reached the cloud.
class MarkChangesSent implements UseCase<void, int> {
  const MarkChangesSent(this._tracker);

  final ChangeTrackerRepository _tracker;

  @override
  Future<void> call(int seq) => _tracker.markSent(seq);
}
