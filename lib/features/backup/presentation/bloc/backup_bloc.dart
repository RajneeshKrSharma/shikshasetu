import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../sharing/domain/usecases/share_files.dart';
import '../../domain/entities/backup_entities.dart';
import '../../domain/entities/restore_record.dart';
import '../../domain/usecases/create_backup_zip.dart';
import '../../domain/usecases/download_backup.dart';
import '../../domain/usecases/pick_backup_file.dart';
import '../../domain/usecases/preview_backup.dart';
import '../../domain/usecases/restore_backup.dart';

enum BackupNoticeKind {
  backupDownloaded,
  backupFailed,
  restoreFailed,
  notABackup,
  newerVersion,
  corrupt,
}

/// A message to show once; [id] makes each one distinct.
class BackupNotice extends Equatable {
  const BackupNotice(this.kind, this.id);

  final BackupNoticeKind kind;
  final int id;

  @override
  List<Object?> get props => [kind, id];
}

/// A backup the user picked, waiting for their confirmation.
class RestoreOffer extends Equatable {
  const RestoreOffer({required this.preview, required this.jsonText});

  final BackupPreview preview;
  final String jsonText;

  @override
  List<Object?> get props => [preview, jsonText];
}

sealed class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => const [];
}

/// The screen opened: loads the restore history.
final class BackupStarted extends BackupEvent {
  const BackupStarted();
}

final class BackupShareRequested extends BackupEvent {
  const BackupShareRequested();
}

final class BackupDownloadRequested extends BackupEvent {
  const BackupDownloadRequested();
}

final class RestoreFilePickRequested extends BackupEvent {
  const RestoreFilePickRequested();
}

final class RestoreConfirmed extends BackupEvent {
  const RestoreConfirmed({this.userId});

  /// The signed-in user, who is restoring.
  final String? userId;

  @override
  List<Object?> get props => [userId];
}

final class RestoreDeclined extends BackupEvent {
  const RestoreDeclined();
}

class BackupState extends Equatable {
  const BackupState({
    this.busy = false,
    this.notice,
    this.offer,
    this.restored = false,
    this.signInAgain = false,
    this.history = const [],
  });

  final bool busy;
  final BackupNotice? notice;
  final RestoreOffer? offer;

  final bool restored;

  /// After a restore: the accounts may have changed, so sign in again.
  final bool signInAgain;

  /// The restores done so far, newest first.
  final List<RestoreRecord> history;

  BackupState copyWith({
    bool? busy,
    BackupNotice? notice,
    RestoreOffer? offer,
    bool clearOffer = false,
    bool? restored,
    bool? signInAgain,
    List<RestoreRecord>? history,
  }) => BackupState(
    busy: busy ?? this.busy,
    notice: notice ?? this.notice,
    offer: clearOffer ? null : (offer ?? this.offer),
    restored: restored ?? this.restored,
    signInAgain: signInAgain ?? this.signInAgain,
    history: history ?? this.history,
  );

  @override
  List<Object?> get props => [
    busy,
    notice,
    offer,
    restored,
    signInAgain,
    history,
  ];
}

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  BackupBloc({
    required CreateBackupZip createBackupZip,
    required ShareFiles shareFiles,
    required DownloadBackup downloadBackup,
    DateTime Function()? now,
    required PickBackupFile pickBackupFile,
    required PreviewBackup previewBackup,
    required RestoreBackup restoreBackup,
    required GetRestoreHistory getRestoreHistory,
  }) : _createZip = createBackupZip,
       _share = shareFiles,
       _download = downloadBackup,
       _now = now ?? DateTime.now,
       _pick = pickBackupFile,
       _preview = previewBackup,
       _restore = restoreBackup,
       _history = getRestoreHistory,
       super(const BackupState()) {
    on<BackupStarted>(
      (e, emit) async =>
          emit(state.copyWith(history: await _history(const NoParams()))),
    );
    on<BackupShareRequested>(_onShare);
    on<BackupDownloadRequested>(_onDownload);
    on<RestoreFilePickRequested>(_onPick);
    on<RestoreConfirmed>(_onRestore);
    on<RestoreDeclined>((e, emit) => emit(state.copyWith(clearOffer: true)));
  }

  final CreateBackupZip _createZip;
  final ShareFiles _share;
  final DownloadBackup _download;
  final DateTime Function() _now;
  final PickBackupFile _pick;
  final PreviewBackup _preview;
  final RestoreBackup _restore;
  final GetRestoreHistory _history;

  int _noticeId = 0;

  BackupNotice _notice(BackupNoticeKind k) => BackupNotice(k, ++_noticeId);

  /// Writes the latest data, packs it into a ZIP and hands it to the share
  /// sheet.
  Future<void> _onShare(
    BackupShareRequested e,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(busy: true));
    try {
      final zip = await _createZip(_now());
      await _share(ShareFilesParams([zip]));
      emit(state.copyWith(busy: false));
    } catch (_) {
      emit(
        state.copyWith(
          busy: false,
          notice: _notice(BackupNoticeKind.backupFailed),
        ),
      );
    }
  }

  /// Writes the latest data and keeps a copy of it in Downloads.
  Future<void> _onDownload(
    BackupDownloadRequested e,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(busy: true));
    try {
      // Nothing to say when the user cancels the "save as" window.
      final saved = await _download(_now());
      emit(
        state.copyWith(
          busy: false,
          notice: saved ? _notice(BackupNoticeKind.backupDownloaded) : null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          busy: false,
          notice: _notice(BackupNoticeKind.backupFailed),
        ),
      );
    }
  }

  Future<void> _onPick(
    RestoreFilePickRequested e,
    Emitter<BackupState> emit,
  ) async {
    final text = await _pick(const NoParams());
    if (text == null) return;
    try {
      final preview = await _preview(text);
      emit(
        state.copyWith(
          offer: RestoreOffer(preview: preview, jsonText: text),
        ),
      );
    } on BackupException catch (ex) {
      emit(
        state.copyWith(
          notice: _notice(switch (ex.reason) {
            BackupProblem.notABackup => BackupNoticeKind.notABackup,
            BackupProblem.newerVersion => BackupNoticeKind.newerVersion,
            BackupProblem.corrupt ||
            BackupProblem.verifyFailed => BackupNoticeKind.corrupt,
          }),
        ),
      );
    }
  }

  Future<void> _onRestore(RestoreConfirmed e, Emitter<BackupState> emit) async {
    final offer = state.offer;
    if (offer == null) return;
    emit(state.copyWith(busy: true, clearOffer: true));
    try {
      final signInAgain = await _restore(
        RestoreRequest(offer.jsonText, currentUserId: e.userId),
      );
      emit(
        state.copyWith(busy: false, restored: true, signInAgain: signInAgain),
      );
    } catch (_) {
      emit(
        state.copyWith(
          busy: false,
          notice: _notice(BackupNoticeKind.restoreFailed),
        ),
      );
    }
  }
}
