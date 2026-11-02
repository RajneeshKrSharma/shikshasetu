import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/review.dart';

extension ReviewFlagStyle on ReviewFlag {
  String label(AppLocalizations l) => switch (this) {
    ReviewFlag.ready => l.flagReady,
    ReviewFlag.answerMissing => l.flagAnswerMissing,
    ReviewFlag.checkPairs => l.flagCheckPairs,
    ReviewFlag.leftOut => l.flagLeftOut,
  };

  Color get color => switch (this) {
    ReviewFlag.ready => AppColors.present,
    ReviewFlag.leftOut => AppColors.pending,
    _ => AppColors.late,
  };

  Color get background => switch (this) {
    ReviewFlag.ready => AppColors.presentLight,
    ReviewFlag.leftOut => AppColors.pendingLight,
    _ => AppColors.lateLight,
  };
}
