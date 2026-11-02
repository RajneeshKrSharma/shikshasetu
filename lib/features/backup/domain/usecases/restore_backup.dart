import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../data_monitor/domain/entities/restore_comparison.dart';
import '../../../data_monitor/domain/usecases/monitor_usecases.dart';
import '../entities/restore_record.dart';
import '../repository/backup_repository.dart';
import '../repository/external_copy_repository.dart';
import '../repository/restore_log_repository.dart';

/// Keeps the current data safe in Downloads (in the app's own folder only if
/// that fails), then restores the backup, and notes in the restore log what
/// it replaced.
class RestoreRequest extends Equatable {
  const RestoreRequest(this.jsonText, {required this.currentUserId});

  final String jsonText;

  /// The user doing the restore.
  final String? currentUserId;

  @override
  List<Object?> get props => [jsonText, currentUserId];
}

class RestoreBackup implements UseCase<bool, RestoreRequest> {
  RestoreBackup(
    this._backups,
    this._copies,
    this._log,
    this._compare, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final BackupRepository _backups;
  final ExternalCopyRepository _copies;
  final RestoreLogRepository _log;
  final CompareBackupWithApp _compare;
  final DateTime Function() _now;

  /// Returns true when the user must sign in again: the backup was not
  /// written by the Principal who is restoring it, so the accounts in it
  /// may be different. A Principal restoring their own file stays signed in.
  @override
  Future<bool> call(RestoreRequest request) async {
    final jsonText = request.jsonText;
    // Worked out before anything changes: what this restore overrides.
    RestoreComparison? comparison;
    try {
      comparison = await _compare(jsonText);
    } catch (_) {
      // The restore itself does not depend on this note.
    }
    final at = _now();
    final safety = await _backups.createSafetyCopy(at);

    // One file, replaced by each restore, so earlier copies do not pile up.
    const name = 'shiksha_setu_before_restore.json';
    String? kept;
    try {
      await _copies.save(safety, name);
      kept = name;
      // The copy outside the app is the one to use, so one copy is enough.
      await _backups.discardCopy(safety);
    } catch (_) {
      // The copy in the app's own folder stays, as the only one.
    }

    final writtenBy = _backups.preview(jsonText).writtenBy;
    await _backups.restore(jsonText);
    await _log.add(
      RestoreRecord(
        at: at,
        backupAt: comparison?.backupAt,
        added: comparison?.added ?? 0,
        changed: comparison?.changed ?? 0,
        removed: comparison?.removed ?? 0,
        appWasNewer: comparison?.appIsNewer ?? false,
        earlierDataFile: kept,
      ),
    );
    return writtenBy == null || writtenBy != request.currentUserId;
  }
}

/// The restores that were done, newest first.
class GetRestoreHistory implements UseCase<List<RestoreRecord>, NoParams> {
  const GetRestoreHistory(this._log);

  final RestoreLogRepository _log;

  @override
  Future<List<RestoreRecord>> call(NoParams params) => _log.recent();
}
