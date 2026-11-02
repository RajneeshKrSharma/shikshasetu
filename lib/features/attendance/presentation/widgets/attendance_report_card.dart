import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../screen/attendance_report_screen.dart';

/// A card that opens the attendance table of students, teachers and others.
class AttendanceReportCard extends StatelessWidget {
  const AttendanceReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      onTap: () => AttendanceReportScreen.open(context),
      child: Row(
        children: [
          const IconBadge(Icons.table_chart_outlined),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.attReportCardTitle, style: context.text.titleSmall),
                const SizedBox(height: 2),
                Text(l.attReportCardHint, style: context.text.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
