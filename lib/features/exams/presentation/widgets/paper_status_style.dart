import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/exam_paper.dart';

extension PaperStatusStyle on PaperStatus {
  String label(AppLocalizations l) => switch (this) {
    PaperStatus.draft => l.paperStatusDraft,
    PaperStatus.submitted => l.paperStatusSubmitted,
    PaperStatus.changesRequested => l.paperStatusChanges,
    PaperStatus.approved => l.paperStatusApproved,
    PaperStatus.conducted => l.paperStatusConducted,
  };

  Color color(BrandColors brand) => switch (this) {
    PaperStatus.draft => AppColors.pending,
    PaperStatus.submitted => AppColors.late,
    PaperStatus.changesRequested => AppColors.absent,
    PaperStatus.approved => brand.primary,
    PaperStatus.conducted => AppColors.present,
  };

  Color background(BrandColors brand) => switch (this) {
    PaperStatus.draft => AppColors.pendingLight,
    PaperStatus.submitted => AppColors.lateLight,
    PaperStatus.changesRequested => AppColors.absentLight,
    PaperStatus.approved => brand.primaryLight,
    PaperStatus.conducted => AppColors.presentLight,
  };
}
