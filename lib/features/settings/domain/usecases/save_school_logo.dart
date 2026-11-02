import '../../../../core/usecase/usecase.dart';
import '../repository/settings_repository.dart';

/// The school logo: a picture's path to keep as the logo, or null to remove it.
class SaveSchoolLogo implements UseCase<void, String?> {
  const SaveSchoolLogo(this._repository);

  final SettingsRepository _repository;

  @override
  Future<void> call(String? sourcePath) => _repository.setLogo(sourcePath);
}
