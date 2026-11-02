import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/usecase/stream_usecase.dart';
import '../entities/account.dart';
import '../repository/session_repository.dart';

class SignInParams extends Equatable {
  const SignInParams(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignIn implements UseCase<Account, SignInParams> {
  const SignIn(this._repository);

  final SessionRepository _repository;

  @override
  Future<Account> call(SignInParams p) =>
      _repository.signIn(p.email.trim().toLowerCase(), p.password);
}

class RestoreSession implements UseCase<Account?, NoParams> {
  const RestoreSession(this._repository);

  final SessionRepository _repository;

  @override
  Future<Account?> call(NoParams params) => _repository.restore();
}

class SignOut implements UseCase<void, NoParams> {
  const SignOut(this._repository);

  final SessionRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.signOut();
}

class ChangePasswordParams extends Equatable {
  const ChangePasswordParams({required this.current, required this.next});

  final String current;
  final String next;

  @override
  List<Object?> get props => [current, next];
}

class ChangePassword implements UseCase<void, ChangePasswordParams> {
  const ChangePassword(this._repository);

  final SessionRepository _repository;

  @override
  Future<void> call(ChangePasswordParams p) =>
      _repository.changePassword(current: p.current, next: p.next);
}

class RenameMe implements UseCase<Account, String> {
  const RenameMe(this._repository);

  final SessionRepository _repository;

  @override
  Future<Account> call(String name) => _repository.rename(name.trim());
}

class WatchSessionEnd implements StreamUseCase<void, NoParams> {
  const WatchSessionEnd(this._repository);

  final SessionRepository _repository;

  @override
  Stream<void> call(NoParams params) => _repository.sessionEnded;
}
