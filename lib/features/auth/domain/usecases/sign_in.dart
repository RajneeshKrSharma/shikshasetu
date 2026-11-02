import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repository/auth_repository.dart';

class SignInParams extends Equatable {
  const SignInParams(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignIn implements UseCase<AppUser, SignInParams> {
  const SignIn(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppUser> call(SignInParams p) =>
      _repository.signIn(p.email, p.password);
}
