import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/attendance_status.dart';

extension AttendanceStatusStyle on AttendanceStatus {
  String label(AppLocalizations l) => switch (this) {
    AttendanceStatus.present => l.statusPresent,
    AttendanceStatus.absent => l.statusAbsent,
    AttendanceStatus.late => l.statusLate,
  };

  String shortLabel(AppLocalizations l) => switch (this) {
    AttendanceStatus.present => l.statusPresentShort,
    AttendanceStatus.absent => l.statusAbsentShort,
    AttendanceStatus.late => l.statusLateShort,
  };

  Color get color => switch (this) {
    AttendanceStatus.present => AppColors.present,
    AttendanceStatus.absent => AppColors.absent,
    AttendanceStatus.late => AppColors.late,
  };

  Color get background => switch (this) {
    AttendanceStatus.present => AppColors.presentLight,
    AttendanceStatus.absent => AppColors.absentLight,
    AttendanceStatus.late => AppColors.lateLight,
  };
}
