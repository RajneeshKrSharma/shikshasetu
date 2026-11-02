import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/bill_drafts.dart';
import '../../domain/entities/staff_bill.dart';

extension FuelKindLabel on FuelKind {
  String label(AppLocalizations l) => switch (this) {
    FuelKind.petrol => l.fuelPetrol,
    FuelKind.diesel => l.fuelDiesel,
  };
}

extension BillPhaseLabel on BillPhase {
  String label(AppLocalizations l) => switch (this) {
    BillPhase.pending => l.billPhasePending,
    BillPhase.approved => l.billPhaseApproved,
    BillPhase.rejected => l.billPhaseRejected,
    BillPhase.paid => l.billPhasePaid,
  };
}

extension BillProblemMessage on BillProblem {
  String message(AppLocalizations l) => switch (this) {
    BillProblem.amountInvalid => l.errBillAmount,
    BillProblem.photoMissing => l.errBillPhoto,
  };
}

extension SettleProblemMessage on SettleProblem {
  String message(AppLocalizations l) => switch (this) {
    SettleProblem.nothingChosen => l.settleNothing,
    SettleProblem.notApproved => l.settleNotApproved,
  };
}
