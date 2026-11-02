import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repository/auth_repository.dart';

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({
    required this.userId,
    required this.name,
    required this.phone,
  });

  final String userId;
  final String name;
  final String phone;

  @override
  List<Object?> get props => [userId, name, phone];
}

class UpdateProfile implements UseCase<AppUser, UpdateProfileParams> {
  const UpdateProfile(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppUser> call(UpdateProfileParams p) =>
      _repository.updateProfile(userId: p.userId, name: p.name, phone: p.phone);
}
