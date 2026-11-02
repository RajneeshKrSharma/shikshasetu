import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repository/auth_repository.dart';

class RestoreSession implements UseCase<AppUser?, NoParams> {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppUser?> call(NoParams params) => _repository.restoreSession();
}
