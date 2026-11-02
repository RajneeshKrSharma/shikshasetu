import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/approval_request.dart';

extension ApprovalCategoryL10n on ApprovalCategory {
  String label(AppLocalizations l) => switch (this) {
    ApprovalCategory.examPaper => l.categoryExamPaper,
    ApprovalCategory.teachingSubject => l.categoryTeachingSubject,
    ApprovalCategory.staffBill => l.categoryStaffBill,
  };
}

extension ApprovalCategoryActions on ApprovalCategory {
  /// The small tag on a card; the school day needs none.
  String? tag(AppLocalizations l) => switch (this) {
    ApprovalCategory.examPaper => l.categoryTagExam,
    ApprovalCategory.teachingSubject => l.categoryTagSubject,
    ApprovalCategory.staffBill => l.categoryTagBill,
  };

  String approveLabel(AppLocalizations l) => switch (this) {
    ApprovalCategory.examPaper => l.actionApprove,
    ApprovalCategory.teachingSubject => l.approvalAllow,
    ApprovalCategory.staffBill => l.actionApprove,
  };

  String rejectLabel(AppLocalizations l) => switch (this) {
    ApprovalCategory.examPaper => l.actionReject,
    ApprovalCategory.teachingSubject => l.approvalDecline,
    ApprovalCategory.staffBill => l.actionReject,
  };
}

extension ApprovalStatusL10n on ApprovalStatus {
  String label(AppLocalizations l) => switch (this) {
    ApprovalStatus.pending => l.sectionPendingApprovals,
    ApprovalStatus.approved => l.statusApproved,
    ApprovalStatus.rejected => l.statusRejected,
  };
}

extension ApprovalRequestL10n on ApprovalRequest {
  String question(AppLocalizations l) => switch (category) {
    ApprovalCategory.examPaper => detail ?? l.approvalExamQuestion,
    ApprovalCategory.teachingSubject => l.approvalSubjectQuestion(detail ?? ''),
    ApprovalCategory.staffBill => detail ?? '',
  };

  IconData get icon => switch (category) {
    ApprovalCategory.examPaper => Icons.description_outlined,
    ApprovalCategory.teachingSubject => Icons.menu_book_outlined,
    ApprovalCategory.staffBill => Icons.receipt_long_outlined,
  };
}
