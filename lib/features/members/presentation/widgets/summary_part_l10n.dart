import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/member_summary.dart';

/// Words each fact on a person's card in the app's language.
extension SummaryPartL10n on SummaryPart {
  String text(AppLocalizations l) => switch (field) {
    SummaryField.className => value,
    SummaryField.rollNo => l.feeRollNo(int.tryParse(value) ?? 0),
    SummaryField.subject => value,
    SummaryField.role => value,
    SummaryField.vehicleNumber => l.summaryVan(value),
    SummaryField.classTeacherOf => l.summaryClassTeacher(value),
  };
}

extension MemberSummaryL10n on MemberSummary {
  /// "Class 3 · Roll 4", "English · Class teacher, Class 4", ...
  String subtitle(AppLocalizations l) =>
      parts.map((p) => p.text(l)).join('  ·  ');
}
