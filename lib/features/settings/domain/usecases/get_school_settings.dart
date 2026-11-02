import '../../../../core/usecase/usecase.dart';
import '../entities/school_settings.dart';
import '../repository/settings_repository.dart';

class GetSchoolSettings implements UseCase<SchoolSettings, NoParams> {
  const GetSchoolSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<SchoolSettings> call(NoParams params) => _repository.get();
}
