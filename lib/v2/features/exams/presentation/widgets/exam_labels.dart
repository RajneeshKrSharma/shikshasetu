import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/exams.dart';

extension ExamTypeLabel on ExamType {
  String label(AppLocalizations l) => switch (this) {
    ExamType.unitTest => l.exmTypeUnitTest,
    ExamType.midTerm => l.exmTypeMidTerm,
    ExamType.annual => l.exmTypeAnnual,
  };
}

extension QuestionTypeLabel on QuestionType {
  String label(AppLocalizations l) => switch (this) {
    QuestionType.mcq => l.qbTypeMcq,
    QuestionType.short => l.qbTypeShort,
    QuestionType.long => l.qbTypeLong,
  };
}

extension PaperStatusLabel on PaperStatus {
  String label(AppLocalizations l) => switch (this) {
    PaperStatus.draft => l.exmPaperStatusDraft,
    PaperStatus.sent => l.exmPaperStatusSent,
    PaperStatus.approved => l.exmPaperStatusApproved,
    PaperStatus.rejected => l.exmPaperStatusRejected,
  };
}
