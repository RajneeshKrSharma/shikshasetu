import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repository/auth_repository.dart';

/// Whether the person who just signed in must name the school first. Only the
/// Principal does that, and only while it has no name.
class NeedsSchoolSetup implements UseCase<bool, AppUser> {
  const NeedsSchoolSetup(this._repository);

  final AuthRepository _repository;

  @override
  Future<bool> call(AppUser user) async =>
      user.isPrincipal && (await _repository.schoolName()).isEmpty;
}
