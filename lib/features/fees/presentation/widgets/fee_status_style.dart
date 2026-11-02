import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/fee_account.dart';

extension FeeStatusStyle on FeeStatus {
  String label(AppLocalizations l) => switch (this) {
    FeeStatus.paid => l.feeStatusPaid,
    FeeStatus.partial => l.feeStatusPartial,
    FeeStatus.overdue => l.feeStatusOverdue,
    FeeStatus.due => l.feeStatusDue,
  };

  Color get color => switch (this) {
    FeeStatus.paid => AppColors.present,
    FeeStatus.partial => AppColors.late,
    FeeStatus.overdue => AppColors.absent,
    FeeStatus.due => AppColors.pending,
  };

  Color get background => switch (this) {
    FeeStatus.paid => AppColors.presentLight,
    FeeStatus.partial => AppColors.lateLight,
    FeeStatus.overdue => AppColors.absentLight,
    FeeStatus.due => AppColors.pendingLight,
  };
}
