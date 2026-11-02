import '../../../../../core/usecase/usecase.dart';
import '../entities/school_identity.dart';
import '../repository/logo_picker_repository.dart';
import '../repository/school_identity_repository.dart';

class LoadSchoolIdentity implements UseCase<SchoolIdentity, NoParams> {
  const LoadSchoolIdentity(this._repository);

  final SchoolIdentityRepository _repository;

  @override
  Future<SchoolIdentity> call(NoParams params) => _repository.load();
}

class SaveSchoolIdentity implements UseCase<SchoolIdentity, SchoolIdentity> {
  const SaveSchoolIdentity(this._repository);

  final SchoolIdentityRepository _repository;

  @override
  Future<SchoolIdentity> call(SchoolIdentity identity) =>
      _repository.save(identity);
}

class PickSchoolLogo implements UseCase<String?, NoParams> {
  const PickSchoolLogo(this._repository);

  final LogoPickerRepository _repository;

  @override
  Future<String?> call(NoParams params) => _repository.pick();
}
