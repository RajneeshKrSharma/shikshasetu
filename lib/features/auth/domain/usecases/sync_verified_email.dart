import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repository/auth_repository.dart';

/// After the user opened the verification link, copies the new email onto this
/// phone. Returns the updated user, or null when nothing changed.
class SyncVerifiedEmail implements UseCase<AppUser?, NoParams> {
  const SyncVerifiedEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppUser?> call(NoParams params) => _repository.syncVerifiedEmail();
}
