import '../../../../core/usecase/usecase.dart';
import '../repository/backup_storage_repository.dart';

class PickBackupFile implements UseCase<String?, NoParams> {
  const PickBackupFile(this._storage);

  final BackupStorageRepository _storage;

  @override
  Future<String?> call(NoParams params) => _storage.pickBackupText();
}
