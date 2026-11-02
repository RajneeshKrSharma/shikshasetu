import '../../../../core/usecase/usecase.dart';
import '../repository/backup_repository.dart';
import '../repository/backup_storage_repository.dart';

/// Writes the data as it is now and lets the user choose where to save a copy
/// of it, under its own date and time. True if it was saved.
class DownloadBackup implements UseCase<bool, DateTime> {
  const DownloadBackup(this._backups, this._storage);

  final BackupRepository _backups;
  final BackupStorageRepository _storage;

  @override
  Future<bool> call(DateTime at) async {
    String two(int n) => n.toString().padLeft(2, '0');
    final stamp =
        '${at.year}-${two(at.month)}-${two(at.day)}_${two(at.hour)}${two(at.minute)}';
    final path = await _backups.writeMirror(at);
    return _storage.saveToDevice(path, 'shiksha_setu_backup_$stamp.json');
  }
}
