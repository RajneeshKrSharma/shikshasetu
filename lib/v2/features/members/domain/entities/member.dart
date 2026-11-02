import 'package:equatable/equatable.dart';

import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

/// A kind of person the Principal registers with an email login. Each kind
/// says where it lives on the server and who may do what with it.
sealed class MemberKind {
  const MemberKind(this.path);

  /// The server path of the kind: `/teachers/`.
  final String path;

  /// True when the person also has a job title (staff).
  bool get hasJobTitle => false;

  Permission get managePermission;

  Set<Permission> get readPermissions => {managePermission};

  bool canManage(Account account) => account.can(managePermission);

  bool canSee(Account account) => account.canAny(readPermissions);
}

final class TeacherKind extends MemberKind {
  const TeacherKind() : super('/teachers/');

  @override
  Permission get managePermission => Permission.manageTeachers;

  @override
  Set<Permission> get readPermissions => {
    Permission.manageTeachers,
    Permission.allotClasses,
  };
}

final class StaffKind extends MemberKind {
  const StaffKind() : super('/staff/');

  @override
  bool get hasJobTitle => true;

  @override
  Permission get managePermission => Permission.manageStaff;

  @override
  Set<Permission> get readPermissions => {
    Permission.manageStaff,
    Permission.allotVans,
  };
}

final class VicePrincipalKind extends MemberKind {
  const VicePrincipalKind() : super('/auth/vice-principal/');

  @override
  Permission get managePermission => Permission.appointVicePrincipal;
}

class Member extends Equatable {
  const Member({
    required this.id,
    required this.name,
    required this.email,
    required this.jobTitle,
    required this.isActive,
  });

  final String id;
  final String name;
  final String email;
  final String jobTitle;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, email, jobTitle, isActive];
}

/// What the form collects. [email] and [password] are only used when adding
/// (and [password] when a new one is set).
class MemberDraft extends Equatable {
  const MemberDraft({
    this.id,
    required this.name,
    this.email = '',
    this.password = '',
    this.jobTitle = '',
  });

  final String? id;
  final String name;
  final String email;
  final String password;
  final String jobTitle;

  @override
  List<Object?> get props => [id, name, email, password, jobTitle];
}
