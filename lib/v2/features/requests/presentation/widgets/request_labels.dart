import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/request.dart';

extension RequestKindLabel on RequestKind {
  String label(AppLocalizations l) => switch (this) {
    RequestKind.leave => l.reqKindLeave,
    RequestKind.meeting => l.reqKindMeeting,
  };

  String raiseLabel(AppLocalizations l) => switch (this) {
    RequestKind.leave => l.reqRaiseLeave,
    RequestKind.meeting => l.reqRaiseMeeting,
  };
}

extension RequestStatusLabel on RequestStatus {
  String label(AppLocalizations l) => switch (this) {
    RequestStatus.pending => l.reqStatusPending,
    RequestStatus.approved => l.reqStatusApproved,
    RequestStatus.rejected => l.reqStatusRejected,
    RequestStatus.withdrawn => l.reqStatusWithdrawn,
  };
}
