import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/payments.dart';

extension PaymentModeLabel on PaymentMode {
  String label(AppLocalizations l) => switch (this) {
    PaymentMode.cash => l.payModeCash,
    PaymentMode.bank => l.payModeBank,
    PaymentMode.upi => l.payModeUpi,
  };
}

extension PaymentKindLabel on PaymentKind {
  String label(AppLocalizations l) => switch (this) {
    PaymentKind.salary => l.paySalary,
    PaymentKind.fuelBill => l.payFuelBill,
  };
}
