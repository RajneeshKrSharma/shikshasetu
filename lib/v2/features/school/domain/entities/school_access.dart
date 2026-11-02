import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

/// What a person may do with the school's own details.
class SchoolAccess {
  const SchoolAccess._(this.canEdit);

  factory SchoolAccess.of(Account account) =>
      SchoolAccess._(account.can(Permission.manageSchool));

  final bool canEdit;
}
