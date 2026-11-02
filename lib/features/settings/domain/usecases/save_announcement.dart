import '../../../../core/usecase/usecase.dart';
import '../repository/settings_repository.dart';

/// The text that runs along everyone's Dashboard, or null to stop it.
class SaveAnnouncement implements UseCase<void, String?> {
  const SaveAnnouncement(this._repository);

  final SettingsRepository _repository;

  @override
  Future<void> call(String? text) => _repository.setAnnouncement(text);
}
