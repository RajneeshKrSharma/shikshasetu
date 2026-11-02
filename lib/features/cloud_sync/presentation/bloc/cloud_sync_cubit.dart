import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/cloud_entities.dart';
import '../../domain/repository/cloud_sync_repositories.dart';
import '../../domain/usecases/cloud_usecases.dart';
import '../../domain/usecases/sync_to_cloud.dart';

/// What happened, so the screen can say so. Shown once per [CloudSyncState.noticeId].
enum CloudNotice { synced, upToDate, needSignIn, notOwner, offline, failed }

class CloudSyncState extends Equatable {
  const CloudSyncState({
    this.connection,
    this.schoolId,
    this.lastRun,
    this.lastChangeRun,
    this.syncing = false,
    this.hasPending = false,
    this.failing = false,
    this.progress,
    this.intervalMinutes = kDefaultSyncIntervalMinutes,
    this.nextSyncAt,
    this.notice,
    this.noticeId = 0,
  });

  /// Null until first read.
  final CloudConnection? connection;
  final String? schoolId;
  final SyncRun? lastRun;

  /// The last sync that sent or removed something.
  final SyncRun? lastChangeRun;
  final bool syncing;

  /// Something changed that has not reached the cloud yet.
  final bool hasPending;

  /// The last try to send failed (it is tried again).
  final bool failing;

  /// How far the running sync has got.
  final SyncProgress? progress;

  /// Minutes between automatic syncs; 0 is off.
  final int intervalMinutes;

  /// When the next automatic sync is due; null when it is off or the app is
  /// not on screen.
  final DateTime? nextSyncAt;
  final CloudNotice? notice;
  final int noticeId;

  CloudSyncState copyWith({
    CloudConnection? connection,
    String? schoolId,
    SyncRun? lastRun,
    SyncRun? lastChangeRun,
    bool? syncing,
    bool? hasPending,
    bool? failing,
    SyncProgress? progress,
    bool clearProgress = false,
    int? intervalMinutes,
    DateTime? nextSyncAt,
    bool clearNext = false,
    CloudNotice? notice,
    int? noticeId,
  }) => CloudSyncState(
    connection: connection ?? this.connection,
    schoolId: schoolId ?? this.schoolId,
    lastRun: lastRun ?? this.lastRun,
    lastChangeRun: lastChangeRun ?? this.lastChangeRun,
    syncing: syncing ?? this.syncing,
    hasPending: hasPending ?? this.hasPending,
    failing: failing ?? this.failing,
    progress: clearProgress ? null : (progress ?? this.progress),
    intervalMinutes: intervalMinutes ?? this.intervalMinutes,
    nextSyncAt: clearNext ? null : (nextSyncAt ?? this.nextSyncAt),
    notice: notice ?? this.notice,
    noticeId: noticeId ?? this.noticeId,
  );

  @override
  List<Object?> get props => [
    connection,
    schoolId,
    lastRun,
    lastChangeRun,
    syncing,
    hasPending,
    failing,
    progress,
    intervalMinutes,
    nextSyncAt,
    notice,
    noticeId,
  ];
}

/// Keeps the cloud copy up to date while the Principal is signed in: at
/// every few minutes while the app is open (see [setInterval]), once
/// more when the app is left, and whenever asked. The cloud account is the one
/// the Principal signed in to the app with.
class CloudSyncCubit extends Cubit<CloudSyncState> {
  CloudSyncCubit({
    required GetCloudConnection getCloudConnection,
    required SyncToCloud syncToCloud,
    required GetSyncInterval getSyncInterval,
    required SetSyncInterval setSyncInterval,
    required SyncNotifier syncNotifier,
    required GetLastSyncRun getLastSyncRun,
    required GetLastChangeRun getLastChangeRun,
    required GetCloudSchoolId getCloudSchoolId,
    required GetPendingChanges getPendingChanges,
    required MarkChangesSent markChangesSent,
  }) : _connection = getCloudConnection,
       _sync = syncToCloud,
       _getInterval = getSyncInterval,
       _setInterval = setSyncInterval,
       _notifier = syncNotifier,
       _lastRun = getLastSyncRun,
       _lastChangeRun = getLastChangeRun,
       _schoolId = getCloudSchoolId,
       _pending = getPendingChanges,
       _markSent = markChangesSent,
       super(const CloudSyncState());

  final GetCloudConnection _connection;
  final SyncToCloud _sync;
  final GetSyncInterval _getInterval;
  final SetSyncInterval _setInterval;
  final SyncNotifier _notifier;

  Timer? _timer;
  bool _foreground = true;
  final GetLastSyncRun _lastRun;
  final GetLastChangeRun _lastChangeRun;
  final GetCloudSchoolId _schoolId;
  final GetPendingChanges _pending;
  final MarkChangesSent _markSent;

  /// Looks for unsent changes every second while the app is open, so a save
  /// reaches the cloud at once.
  Timer? _watcher;
  bool _checking = false;

  /// After a failed send (no internet) wait a little before trying again.
  DateTime? _retryAfter;

  int _noticeCounter = 0;

  void _tell(CloudNotice notice) => emit(
    state.copyWith(notice: notice, noticeId: ++_noticeCounter, syncing: false),
  );

  /// Reads the connection and, when signed in, starts syncing every
  /// [CloudSyncState.intervalMinutes] while the app is open. The first sync
  /// comes after that time, not when the screen loads.
  Future<void> start() async {
    final connection = await _connection(const NoParams());
    debugPrint('Cloud sync start: ${connection.status}');
    final minutes = await _getInterval(const NoParams());
    emit(
      state.copyWith(
        connection: connection,
        intervalMinutes: minutes,
        lastRun: await _lastRun(const NoParams()),
        lastChangeRun: await _lastChangeRun(const NoParams()),
        schoolId: connection.status == CloudStatus.notConfigured
            ? null
            : await _schoolId(const NoParams()),
      ),
    );
    if (connection.isReady) {
      if (minutes > 0) unawaited(_notifier.requestPermission());
      _schedule();
      _watchChanges();
    }
  }

  /// Picks how often the app syncs by itself, in minutes; 0 turns it off.
  Future<void> setInterval(int minutes) async {
    emit(state.copyWith(intervalMinutes: minutes));
    await _setInterval(minutes);
    if (minutes > 0) unawaited(_notifier.requestPermission());
    _schedule();
  }

  /// The app came back to the screen: the timer starts again. Nothing is sent
  /// right away; what was pending went out when the app was left.
  void onForeground() {
    _foreground = true;
    if (state.connection?.isReady == true) {
      _schedule();
      _watchChanges();
    }
  }

  /// The app left the screen: stop the timer (it costs battery for nothing)
  /// and send whatever is still waiting right away.
  Future<void> onBackground() async {
    _foreground = false;
    _timer?.cancel();
    _watcher?.cancel();
    emit(state.copyWith(clearNext: true));
    if (state.connection?.isReady == true) await syncNow(quiet: true);
  }

  void _watchChanges() {
    _watcher?.cancel();
    if (!_foreground || state.connection?.isReady != true) return;
    _watcher = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _sendPending(),
    );
  }

  /// Sends changes the moment they appear (nothing happens when there are none).
  Future<void> _sendPending() async {
    if (_checking || state.syncing) return;
    final wait = _retryAfter;
    if (wait != null && DateTime.now().isBefore(wait)) return;
    _checking = true;
    try {
      final p = await _pending(const NoParams());
      if (p.hasPending != state.hasPending) {
        emit(state.copyWith(hasPending: p.hasPending));
      }
      if (p.hasPending) await syncNow(quiet: true, instant: true);
    } finally {
      _checking = false;
    }
  }

  void _schedule() {
    _timer?.cancel();
    if (!_foreground || state.intervalMinutes <= 0) {
      emit(state.copyWith(clearNext: true));
      return;
    }
    final every = Duration(minutes: state.intervalMinutes);
    emit(state.copyWith(nextSyncAt: DateTime.now().add(every)));
    _timer = Timer.periodic(every, (_) {
      emit(state.copyWith(nextSyncAt: DateTime.now().add(every)));
      syncNow(quiet: true);
    });
  }

  /// Sends what changed. A [quiet] run (the automatic ones) only speaks up
  /// about problems the Principal can fix.
  ///
  /// An [instant] run is the quick one after a save: it does not put up the
  /// phone's notification.
  Future<void> syncNow({bool quiet = false, bool instant = false}) async {
    if (state.syncing) return;
    emit(state.copyWith(syncing: true, clearProgress: true));
    var succeeded = false;
    try {
      // Changes made while this runs are not covered by it.
      final upTo = (await _pending(const NoParams())).latest;
      final run = await _sync.run(
        onProgress: (p) {
          emit(state.copyWith(progress: p));
          if (!instant) _notifier.show(p);
        },
      );
      await _markSent(upTo);
      _retryAfter = null;
      debugPrint('Cloud sync done: ${run.uploaded} deleted ${run.deleted}');
      succeeded = true;
      // The screen updates the moment the sync is done. The phone's own
      // notification keeps its minimum time on show in the background, without
      // holding the screen back.
      emit(
        state.copyWith(
          syncing: false,
          failing: false,
          clearProgress: true,
          lastRun: run,
          lastChangeRun: run.isEmpty ? null : run,
        ),
      );
      if (!instant) {
        unawaited(
          _notifier.done(
            run,
            nextInMinutes: state.intervalMinutes > 0
                ? state.intervalMinutes
                : null,
          ),
        );
      }
      emit(
        state.copyWith(
          hasPending: (await _pending(const NoParams())).hasPending,
        ),
      );
      if (!quiet) {
        _tell(run.isEmpty ? CloudNotice.upToDate : CloudNotice.synced);
      }
    } on CloudSyncException catch (e) {
      debugPrint('Cloud sync stopped: ${e.reason}');
      emit(state.copyWith(syncing: false, failing: true, clearProgress: true));
      _retryAfter = DateTime.now().add(const Duration(seconds: 30));
      switch (e.reason) {
        case CloudSyncFailure.notConfigured:
          break;
        case CloudSyncFailure.signedOut:
          emit(state.copyWith(connection: await _connection(const NoParams())));
          if (!quiet) _tell(CloudNotice.needSignIn);
        case CloudSyncFailure.notOwner:
          _tell(CloudNotice.notOwner);
        case CloudSyncFailure.offline:
          // The automatic runs retry on their own; no need to nag.
          if (!quiet) _tell(CloudNotice.offline);
        case CloudSyncFailure.other:
          if (!quiet) _tell(CloudNotice.failed);
      }
    } catch (e, st) {
      debugPrint('Cloud sync failed: $e\n$st');
      _retryAfter = DateTime.now().add(const Duration(seconds: 30));
      emit(state.copyWith(syncing: false, failing: true, clearProgress: true));
      if (!quiet) _tell(CloudNotice.failed);
    } finally {
      if (!succeeded) await _notifier.hide();
    }
  }

  /// The app signed out: stop syncing and forget the connection.
  void stop() {
    _timer?.cancel();
    _watcher?.cancel();
    emit(const CloudSyncState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _watcher?.cancel();
    return super.close();
  }
}
