import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class ChangePasswordParams extends Equatable {
  const ChangePasswordParams({
    required this.userId,
    required this.current,
    required this.next,
  });

  final String userId;
  final String current;
  final String next;

  @override
  List<Object?> get props => [userId, current, next];
}

class ChangePassword implements UseCase<void, ChangePasswordParams> {
  const ChangePassword(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(ChangePasswordParams p) => _repository.changePassword(
    userId: p.userId,
    current: p.current,
    next: p.next,
  );
}
