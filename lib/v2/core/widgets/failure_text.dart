import '../../../l10n/generated/app_localizations.dart';
import '../server/server_exception.dart';
import '../view_failure.dart';

/// The words for a problem: the server's own sentence when it gave one, the
/// app's wording for the kind of problem otherwise.
extension ViewFailureText on ViewFailure {
  String text(AppLocalizations l) {
    final said = message;
    if (said != null && said.isNotEmpty) return said;
    return switch (kind) {
      ServerFailure.offline => l.srvOffline,
      ServerFailure.invalidCredentials => l.srvInvalidCredentials,
      ServerFailure.sessionExpired => l.srvSessionExpired,
      ServerFailure.forbidden => l.srvForbidden,
      ServerFailure.notFound => l.srvNotFound,
      ServerFailure.invalid => l.srvInvalid,
      ServerFailure.rejected => l.srvRejected,
      ServerFailure.tooManyRequests => l.srvTooManyRequests,
      ServerFailure.unavailable => l.srvUnavailable,
    };
  }
}
