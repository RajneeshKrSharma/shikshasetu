import '../../domain/entities/app_user.dart';
import '../dto/user_dto.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.phone,
    required super.employeeId,
    required super.joinedOn,
    super.subject,
  });

  factory UserModel.fromDto(UserDto d) => UserModel(
    id: d.id,
    name: d.name,
    email: d.email,
    role: UserRole.values.byName(d.role),
    phone: d.phone,
    employeeId: d.employeeId,
    joinedOn: DateTime.fromMillisecondsSinceEpoch(d.joinedOn),
    subject: d.subject,
  );
}
