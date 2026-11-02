import '../../../../core/usecase/usecase.dart';
import '../repository/backup_repository.dart';

/// Makes a ZIP of the data as it is now, to share.
class CreateBackupZip implements UseCase<String, DateTime> {
  const CreateBackupZip(this._repository);

  final BackupRepository _repository;

  @override
  Future<String> call(DateTime at) => _repository.createZip(at);
}
