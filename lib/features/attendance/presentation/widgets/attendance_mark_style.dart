import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/attendance_record.dart';

extension AttendanceMarkStyle on AttendanceMark {
  String label(AppLocalizations l) => switch (this) {
    AttendanceMark.present => l.statusPresent,
    AttendanceMark.late => l.statusLate,
    AttendanceMark.absent => l.statusAbsent,
    AttendanceMark.notMarked => l.attMarkNotMarked,
  };

  Color get color => switch (this) {
    AttendanceMark.present => AppColors.present,
    AttendanceMark.late => AppColors.late,
    AttendanceMark.absent => AppColors.absent,
    AttendanceMark.notMarked => AppColors.pending,
  };

  Color get background => switch (this) {
    AttendanceMark.present => AppColors.presentLight,
    AttendanceMark.late => AppColors.lateLight,
    AttendanceMark.absent => AppColors.absentLight,
    AttendanceMark.notMarked => AppColors.pendingLight,
  };
}

extension AttendanceGroupLabel on AttendanceGroup {
  String label(AppLocalizations l) => switch (this) {
    AttendanceGroup.student => l.attGroupStudents,
    AttendanceGroup.teacher => l.attGroupTeachers,
    AttendanceGroup.other => l.attGroupOthers,
  };
}
