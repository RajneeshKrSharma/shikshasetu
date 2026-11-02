import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/cloud_entities.dart';
import '../../domain/entities/sync_activity.dart';
import '../../domain/repository/cloud_sync_repositories.dart';
import '../../domain/usecases/pull_school_updates.dart';
import '../../domain/usecases/school_exchange_usecases.dart';

/// Keeps the two sides of the school talking while the app is open.
///
/// A Teacher's phone sends what the teacher recorded and the papers they sent
/// for approval, and fetches what the Principal changed. The Principal's phone
/// fetches what teachers sent, and tells the Principal about new requests.
///
/// [SchoolExchangeState.round] goes up each time new data arrived, so screens
/// can reload; the rest says when the last round ran, when the next one is
/// due, and what each moved.
class SchoolExchangeState extends Equatable {
  const SchoolExchangeState({
    this.round = 0,
    this.running = false,
    this.lastAt,
    this.nextAt,
    this.last,
    this.lastChange,
  });

  final int round;
  final bool running;

  /// When the last round finished, and when the next one is due.
  final DateTime? lastAt;
  final DateTime? nextAt;

  /// What the last round moved, and the last one that moved anything.
  final SyncActivity? last;
  final SyncActivity? lastChange;

  SchoolExchangeState copyWith({
    int? round,
    bool? running,
    DateTime? lastAt,
    DateTime? nextAt,
    SyncActivity? last,
    SyncActivity? lastChange,
  }) => SchoolExchangeState(
    round: round ?? this.round,
    running: running ?? this.running,
    lastAt: lastAt ?? this.lastAt,
    nextAt: nextAt ?? this.nextAt,
    last: last ?? this.last,
    lastChange: lastChange ?? this.lastChange,
  );

  @override
  List<Object?> get props => [round, running, lastAt, nextAt, last, lastChange];
}

class SchoolRefreshCubit extends Cubit<SchoolExchangeState> {
  SchoolRefreshCubit({
    required PullSchoolUpdates pullSchoolUpdates,
    required PushTeacherWork pushTeacherWork,
    required SendPaperRequests sendPaperRequests,
    required ApplyPaperDecisions applyPaperDecisions,
    required ImportPaperRequests importPaperRequests,
    required ImportTeacherWork importTeacherWork,
    required SendSubjectRequests sendSubjectRequests,
    required ImportSubjectRequests importSubjectRequests,
    required SyncNotifier notifier,
    required SyncActivityLog activityLog,
  }) : _pull = pullSchoolUpdates,
       _push = pushTeacherWork,
       _send = sendPaperRequests,
       _apply = applyPaperDecisions,
       _importRequests = importPaperRequests,
       _importWork = importTeacherWork,
       _sendSubjects = sendSubjectRequests,
       _importSubjects = importSubjectRequests,
       _notifier = notifier,
       _log = activityLog,
       super(const SchoolExchangeState());

  final PullSchoolUpdates _pull;
  final PushTeacherWork _push;
  final SendPaperRequests _send;
  final ApplyPaperDecisions _apply;
  final ImportPaperRequests _importRequests;
  final ImportTeacherWork _importWork;
  final SendSubjectRequests _sendSubjects;
  final ImportSubjectRequests _importSubjects;
  final SyncNotifier _notifier;
  final SyncActivityLog _log;

  static const every = Duration(seconds: 30);

  Timer? _timer;
  bool _running = false;
  bool _principal = false;
  int _tick = 0;

  /// Checks now, then every half minute while the app is open.
  void start({required bool principal}) {
    _principal = principal;
    _tick = 0;
    _timer?.cancel();
    if (principal) unawaited(_notifier.requestPermission());
    _timer = Timer.periodic(every, (_) => refresh());
    emit(state.copyWith(nextAt: DateTime.now().add(every)));
    refresh();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// One round. Failures (no internet, signed out) are quiet: the phone keeps
  /// what it has and tries again on the next round.
  Future<void> refresh() async {
    if (_running || _timer == null) return;
    _running = true;
    _log.take(DateTime.now()); // Start the round with nothing counted.
    emit(state.copyWith(running: true));
    var changed = false;
    try {
      changed = _principal ? await _principalRound() : await _teacherRound();
    } on CloudSyncException catch (e) {
      debugPrint('School refresh stopped: ${e.reason}');
    } catch (e, st) {
      debugPrint('School refresh failed: $e\n$st');
    } finally {
      _running = false;
      if (!isClosed) {
        final now = DateTime.now();
        final activity = _log.take(now);
        emit(
          state.copyWith(
            round: changed ? state.round + 1 : null,
            running: false,
            lastAt: now,
            nextAt: now.add(every),
            last: activity,
            lastChange: activity.isEmpty ? null : activity,
          ),
        );
      }
    }
  }

  Future<bool> _principalRound() async {
    final fresh = [
      ...await _importRequests(const NoParams()),
      ...await _importSubjects(const NoParams()),
    ];
    if (fresh.isNotEmpty) await _notifier.approvalRequested(fresh);
    // Marks are heavier to read, so only on the first round and now and then.
    final withMarks = _tick++ % 10 == 0;
    final work = await _importWork(withMarks);
    return fresh.isNotEmpty || work;
  }

  Future<bool> _teacherRound() async {
    // Each step on its own, so one failing does not stop the others.
    var changed = false;
    Future<void> step(Future<void> Function() action) async {
      try {
        await action();
      } on CloudSyncException catch (e) {
        debugPrint('School refresh step stopped: ${e.reason}');
      }
    }

    await step(() => _push(const NoParams()));
    await step(() => _send(const NoParams()));
    await step(() => _sendSubjects(const NoParams()));
    await step(() async {
      await _pull(const NoParams());
      changed = true;
    });
    await step(() async {
      if (await _apply(const NoParams())) changed = true;
    });
    return changed;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
