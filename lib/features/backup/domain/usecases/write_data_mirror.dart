import '../../../../core/usecase/usecase.dart';
import '../repository/backup_repository.dart';

/// Writes the data file kept beside the database.
class WriteDataMirror implements UseCase<String, DateTime> {
  const WriteDataMirror(this._repository);

  final BackupRepository _repository;

  @override
  Future<String> call(DateTime at) => _repository.writeMirror(at);
}
