import '../../../../core/server/json.dart';
import '../../../../core/server/server_exception.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/permission.dart';

class AccountModel extends Account {
  const AccountModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.joinedOn,
    required super.permissions,
  });

  /// From `/auth/me/`. A person with no school role (an administrator of the
  /// server) cannot use the app.
  factory AccountModel.fromJson(Json json) {
    final role = AccountRole.fromCode(json.stringOrNull('role'));
    if (role == null) throw const ServerException(ServerFailure.forbidden);
    return AccountModel(
      id: json.string('id'),
      name: json.string('name'),
      email: json.string('email'),
      role: role,
      joinedOn: json.momentOrNull('joined_on') ?? DateTime.now(),
      permissions: {
        for (final code in json.strings('capabilities'))
          ?Permission.fromCode(code),
      },
    );
  }
}
