import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_payment.dart';
import '../../domain/entities/payment_draft.dart';

extension FeeHeadLabel on FeeHead {
  String label(AppLocalizations l) => switch (this) {
    FeeHead.academic => l.feeHeadAcademic,
    FeeHead.dress => l.feeHeadDress,
    FeeHead.books => l.feeHeadBooks,
    FeeHead.van => l.feeHeadVan,
    FeeHead.payment => l.feeHeadPayment,
  };
}

extension PaymentModeLabel on PaymentMode {
  String label(AppLocalizations l) => switch (this) {
    PaymentMode.cash => l.payModeCash,
    PaymentMode.upi => l.payModeUpi,
    PaymentMode.cheque => l.payModeCheque,
    PaymentMode.bank => l.payModeBank,
  };

  /// What the reference field is called for this way of paying.
  String referenceLabel(AppLocalizations l) => switch (this) {
    PaymentMode.cash => l.fieldReferenceCash,
    PaymentMode.upi => l.fieldReferenceUpi,
    PaymentMode.cheque => l.fieldReferenceCheque,
    PaymentMode.bank => l.fieldReferenceBank,
  };
}

extension PaymentProblemMessage on PaymentProblem {
  String message(AppLocalizations l) => switch (this) {
    PaymentProblem.amountInvalid => l.errorAmountInvalid,
    PaymentProblem.amountExceeds => l.errorAmountExceeds,
    PaymentProblem.referenceMissing => l.errorReferenceRequired,
    PaymentProblem.proofMissing => l.errorProofRequired,
  };
}
