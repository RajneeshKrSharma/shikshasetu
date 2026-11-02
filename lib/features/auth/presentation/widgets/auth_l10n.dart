import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repository/auth_repository.dart';

extension UserRoleL10n on UserRole {
  String label(AppLocalizations l) => switch (this) {
    UserRole.principal => l.roleLabelPrincipal,
    UserRole.teacher => l.roleLabelTeacher,
  };
}

extension AuthFailureL10n on AuthFailure {
  String message(AppLocalizations l) => switch (this) {
    AuthFailure.invalidCredentials => l.errorInvalidCredentials,
    AuthFailure.inactiveAccount => l.errorInactiveAccount,
    AuthFailure.wrongCurrentPassword => l.errorWrongCurrentPassword,
    AuthFailure.emailTaken => l.errorEmailTaken,
    AuthFailure.weakPassword => l.errorPasswordWeak,
    AuthFailure.invalidEmail => l.errorEmailInvalid,
    AuthFailure.tooManyRequests => l.errorTooManyAttempts,
    AuthFailure.offline => l.errorAuthOffline,
    AuthFailure.profileMissing => l.errorProfileMissing,
    AuthFailure.unavailable => l.errorAuthUnavailable,
    AuthFailure.schoolNotFound => l.errorSchoolNotFound,
  };
}
