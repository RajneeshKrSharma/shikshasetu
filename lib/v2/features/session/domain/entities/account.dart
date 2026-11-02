import 'package:equatable/equatable.dart';

import 'permission.dart';

enum AccountRole {
  principal('principal'),
  vicePrincipal('vice_principal'),
  teacher('teacher'),
  staff('staff');

  const AccountRole(this.code);

  final String code;

  static AccountRole? fromCode(String? code) {
    for (final r in values) {
      if (r.code == code) return r;
    }
    return null;
  }
}

/// The signed-in person, and what they may do.
class Account extends Equatable {
  const Account({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedOn,
    required this.permissions,
  });

  final String id;
  final String name;
  final String email;
  final AccountRole role;
  final DateTime joinedOn;
  final Set<Permission> permissions;

  bool can(Permission permission) => permissions.contains(permission);

  bool canAny(Iterable<Permission> any) => any.any(permissions.contains);

  Account renamed(String newName) => Account(
    id: id,
    name: newName,
    email: email,
    role: role,
    joinedOn: joinedOn,
    permissions: permissions,
  );

  @override
  List<Object?> get props => [id, name, email, role, joinedOn, permissions];
}
