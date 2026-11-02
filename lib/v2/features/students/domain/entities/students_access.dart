import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

/// What a person may do in the students area. Each flag decides a tab or a
/// button, so the screens never look at roles.
class StudentsAccess {
  const StudentsAccess._({
    required this.canSeeStudents,
    required this.canManageStudents,
    required this.canManageClasses,
    required this.canSeeFees,
    required this.canSeeAccessories,
    required this.canSeeResults,
  });

  factory StudentsAccess.of(Account account) => StudentsAccess._(
    canSeeStudents: account.canAny(const [
      Permission.viewStudents,
      Permission.manageStudents,
      Permission.manageClasses,
    ]),
    canManageStudents: account.can(Permission.manageStudents),
    canManageClasses: account.can(Permission.manageClasses),
    canSeeFees: account.can(Permission.manageFees),
    canSeeAccessories: account.can(Permission.manageAccessories),
    canSeeResults: account.canAny(const [
      Permission.viewResults,
      Permission.scheduleExams,
      Permission.conductExams,
    ]),
  );

  final bool canSeeStudents;
  final bool canManageStudents;
  final bool canManageClasses;
  final bool canSeeFees;
  final bool canSeeAccessories;
  final bool canSeeResults;
}
