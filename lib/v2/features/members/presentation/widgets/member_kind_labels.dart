import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/member.dart';

/// The words for each kind of member.
extension MemberKindLabels on MemberKind {
  String title(AppLocalizations l) => switch (this) {
    TeacherKind() => l.memTeachers,
    StaffKind() => l.memStaff,
    VicePrincipalKind() => l.memVicePrincipals,
  };

  String addLabel(AppLocalizations l) => switch (this) {
    TeacherKind() => l.memTeacherAdd,
    StaffKind() => l.memStaffAdd,
    VicePrincipalKind() => l.memVpAdd,
  };

  String editLabel(AppLocalizations l) => switch (this) {
    TeacherKind() => l.memTeacherEdit,
    StaffKind() => l.memStaffEdit,
    VicePrincipalKind() => l.memVpEdit,
  };

  String emptyLabel(AppLocalizations l) => switch (this) {
    TeacherKind() => l.memTeachersEmpty,
    StaffKind() => l.memStaffEmpty,
    VicePrincipalKind() => l.memVpEmpty,
  };
}
