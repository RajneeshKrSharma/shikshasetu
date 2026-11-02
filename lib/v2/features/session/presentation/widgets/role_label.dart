import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/account.dart';

extension AccountRoleLabel on AccountRole {
  String label(AppLocalizations l) => switch (this) {
    AccountRole.principal => l.roleLabelPrincipal,
    AccountRole.vicePrincipal => l.roleLabelVicePrincipal,
    AccountRole.teacher => l.roleLabelTeacher,
    AccountRole.staff => l.roleLabelStaff,
  };
}
