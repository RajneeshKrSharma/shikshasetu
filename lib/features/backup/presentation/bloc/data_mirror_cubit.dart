import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../cloud_sync/domain/usecases/cloud_usecases.dart';
import '../../domain/usecases/publish_mirror_copy.dart';
import '../../domain/usecases/write_data_mirror.dart';

class DataMirrorState extends Equatable {
  const DataMirrorState({
    this.lastWrittenAt,
    this.failed = false,
    this.copyWrittenAt,
    this.copyFailed = false,
  });

  /// When the data file last matched the database.
  final DateTime? lastWrittenAt;

  /// The last attempt to write it failed (it is tried again).
  final bool failed;

  /// When the copy outside the app (Downloads) was last written, and whether
  /// the last try failed.
  final DateTime? copyWrittenAt;
  final bool copyFailed;

  @override
  List<Object?> get props => [lastWrittenAt, failed, copyWrittenAt, copyFailed];
}

/// Keeps the data file beside the database up to date: a second after any
/// change it writes the whole file again, checked by reading it back. A
/// copy outside the app (which survives removing the app) follows, at most
/// every [copyEvery].
class DataMirrorCubit extends Cubit<DataMirrorState> {
  DataMirrorCubit({
    required GetMirrorPending getPending,
    required MarkMirrored markMirrored,
    required WriteDataMirror writeMirror,
    required PublishMirrorCopy publishCopy,
    DateTime Function()? now,
    this.copyEvery = const Duration(seconds: 30),
  }) : _getPending = getPending,
       _markMirrored = markMirrored,
       _write = writeMirror,
       _publish = publishCopy,
       _now = now ?? DateTime.now,
       super(const DataMirrorState());

  final GetMirrorPending _getPending;
  final MarkMirrored _markMirrored;
  final WriteDataMirror _write;
  final PublishMirrorCopy _publish;
  final DateTime Function() _now;
  final Duration copyEvery;

  Timer? _timer;
  bool _busy = false;

  /// The outside copy is behind the data file, and when it was last tried.
  bool _copyDue = false;
  DateTime? _copyTriedAt;
  String? _path;

  /// Starts watching while the Principal is signed in.
  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _check());
    unawaited(_check());
  }

  void stop() {
    _timer?.cancel();
    emit(const DataMirrorState());
  }

  Future<void> _check() async {
    if (_busy) return;
    _busy = true;
    try {
      await _writeFile();
      await _publishCopy();
    } finally {
      _busy = false;
    }
  }

  Future<void> _writeFile() async {
    try {
      final pending = await _getPending(const NoParams());
      if (!pending.hasPending && state.lastWrittenAt != null) return;
      final at = _now();
      _path = await _write(at);
      // Only up to what the file was made from; later changes go next round.
      await _markMirrored(pending.latest);
      _copyDue = true;
      if (!isClosed) {
        emit(
          DataMirrorState(
            lastWrittenAt: at,
            copyWrittenAt: state.copyWrittenAt,
            copyFailed: state.copyFailed,
          ),
        );
      }
    } catch (e) {
      debugPrint('Data file not written: $e');
      if (!isClosed) {
        emit(
          DataMirrorState(
            lastWrittenAt: state.lastWrittenAt,
            failed: true,
            copyWrittenAt: state.copyWrittenAt,
            copyFailed: state.copyFailed,
          ),
        );
      }
    }
  }

  Future<void> _publishCopy() async {
    final path = _path;
    final now = _now();
    final tried = _copyTriedAt;
    if (!_copyDue || path == null) return;
    if (tried != null && now.difference(tried) < copyEvery) return;
    _copyTriedAt = now;
    try {
      await _publish(PublishMirrorParams(path, now));
      _copyDue = false;
      if (!isClosed) {
        emit(
          DataMirrorState(
            lastWrittenAt: state.lastWrittenAt,
            failed: state.failed,
            copyWrittenAt: now,
          ),
        );
      }
    } catch (e) {
      debugPrint('Copy outside the app not written: $e');
      if (!isClosed) {
        emit(
          DataMirrorState(
            lastWrittenAt: state.lastWrittenAt,
            failed: state.failed,
            copyWrittenAt: state.copyWrittenAt,
            copyFailed: true,
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
