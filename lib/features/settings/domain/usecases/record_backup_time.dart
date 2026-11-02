import '../../../../core/usecase/usecase.dart';
import '../repository/settings_repository.dart';

class RecordBackupTime implements UseCase<void, DateTime> {
  const RecordBackupTime(this._repository);

  final SettingsRepository _repository;

  @override
  Future<void> call(DateTime at) => _repository.setLastBackup(at);
}
