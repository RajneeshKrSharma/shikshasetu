import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class RequestEmailChangeParams extends Equatable {
  const RequestEmailChangeParams({
    required this.password,
    required this.newEmail,
  });

  final String password;
  final String newEmail;

  @override
  List<Object?> get props => [password, newEmail];
}

class RequestEmailChange implements UseCase<void, RequestEmailChangeParams> {
  const RequestEmailChange(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(RequestEmailChangeParams p) => _repository
      .requestEmailChange(password: p.password, newEmail: p.newEmail);
}
