import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/attendance.dart';

extension StudentMarkLook on StudentMark {
  String label(AppLocalizations l) => switch (this) {
    StudentMark.present => l.attPresent,
    StudentMark.late => l.attLate,
    StudentMark.absent => l.attAbsent,
  };

  Color get color => switch (this) {
    StudentMark.present => AppColors.present,
    StudentMark.late => AppColors.late,
    StudentMark.absent => AppColors.absent,
  };
}

extension DayStatusLook on DayStatus {
  String label(AppLocalizations l) => switch (this) {
    DayStatus.present => l.attPresent,
    DayStatus.late => l.attLate,
    DayStatus.absent => l.attAbsent,
    DayStatus.leave => l.attLeave,
    DayStatus.holiday => l.attHoliday,
    DayStatus.notInYet => l.attNotInYet,
  };

  Color get color => switch (this) {
    DayStatus.present => AppColors.present,
    DayStatus.late => AppColors.late,
    DayStatus.absent => AppColors.absent,
    _ => AppColors.textMuted,
  };
}
