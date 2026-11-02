import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  const SignOut(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.signOut();
}
