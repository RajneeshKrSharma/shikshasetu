import '../../../../core/usecase/usecase.dart';
import '../entities/backup_entities.dart';
import '../repository/backup_repository.dart';

/// Throws [BackupException] when the text is not a restorable backup.
class PreviewBackup implements UseCase<BackupPreview, String> {
  const PreviewBackup(this._repository);

  final BackupRepository _repository;

  @override
  Future<BackupPreview> call(String jsonText) async =>
      _repository.preview(jsonText);
}
