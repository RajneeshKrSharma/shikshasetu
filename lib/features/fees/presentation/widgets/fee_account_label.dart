import '../../../../l10n/class_label.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/fee_account.dart';

extension FeeAccountLabel on FeeAccount {
  /// "Class 5-A · Roll 12" for a student, otherwise the subject or role.
  String describe(AppLocalizations l) => classSection == null
      ? subtitle
      : [
          l.classLabel(classSection!),
          if (rollNo != null) l.feeRollNo(rollNo!),
        ].join(' · ');
}
