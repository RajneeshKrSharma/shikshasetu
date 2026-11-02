import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/check_result.dart';

extension CheckFailureL10n on CheckFailure {
  String message(AppLocalizations l, double? distance) => switch (this) {
    CheckFailure.schoolClosed => l.checkErrSchoolClosed,
    CheckFailure.locationNotConfigured => l.checkErrNotConfigured,
    CheckFailure.servicesOff => l.checkErrServicesOff,
    CheckFailure.permissionDenied => l.checkErrPermissionDenied,
    CheckFailure.permissionDeniedForever => l.checkErrPermissionForever,
    CheckFailure.locationUnavailable => l.checkErrUnavailable,
    CheckFailure.mockLocation => l.checkErrMockLocation,
    CheckFailure.outsideSchool => l.checkErrOutside((distance ?? 0).round()),
    CheckFailure.selfieCancelled => l.checkErrSelfie,
    CheckFailure.faceMismatch => l.checkErrFaceMismatch,
    CheckFailure.faceNotFound => l.checkErrFaceNotFound,
    CheckFailure.faceUnavailable => l.checkErrFaceUnavailable,
  };
}
