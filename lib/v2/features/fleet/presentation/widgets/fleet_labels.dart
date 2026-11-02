import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/fleet.dart';

extension FuelTypeLabel on FuelType {
  String label(AppLocalizations l) => switch (this) {
    FuelType.petrol => l.fltPetrol,
    FuelType.diesel => l.fltDiesel,
  };
}

extension BillStatusLabel on BillStatus {
  String label(AppLocalizations l) => switch (this) {
    BillStatus.pending => l.fltStatusPending,
    BillStatus.approved => l.fltStatusApproved,
    BillStatus.rejected => l.fltStatusRejected,
  };
}
