import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/exam_paper.dart';

extension ExamKindStyle on ExamKind {
  String label(AppLocalizations l) => switch (this) {
    ExamKind.weekly => l.kindWeekly,
    ExamKind.midMonthly => l.kindMidMonthly,
    ExamKind.unitTest => l.kindUnitTest,
    ExamKind.halfYearly => l.kindHalfYearly,
    ExamKind.yearlyFinal => l.kindYearlyFinal,
  };
}
