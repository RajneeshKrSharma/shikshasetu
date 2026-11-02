import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../school_calendar/presentation/screen/holidays_screen.dart';
import '../../../school_calendar/presentation/screen/school_calendar_screen.dart';
import '../../../school_day/presentation/screen/school_day_screens.dart';

/// Everything the Principal plans and runs for the school, as one plain list:
/// each with what it is for.
class SchoolPlansScreen extends StatelessWidget {
  const SchoolPlansScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const SchoolPlansScreen()));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.homeSchoolPlans)),
      body: ListView(
        padding: AppSpacing.pageOf(context),
        children: [
          _PlanRow(
            icon: Icons.schedule_outlined,
            title: l.homeTileTiming,
            hint: l.planTimingHint,
            onTap: () => SchoolTimingScreen.open(context),
          ),
          _PlanRow(
            icon: Icons.flag_outlined,
            title: l.homeTileAssembly,
            hint: l.planAssemblyHint,
            onTap: () => SchoolAssemblyScreen.open(context),
          ),
          _PlanRow(
            icon: Icons.view_timeline_outlined,
            title: l.homeTilePeriods,
            hint: l.planPeriodsHint,
            onTap: () => PeriodScheduleScreen.open(context),
          ),
          _PlanRow(
            icon: Icons.calendar_month_outlined,
            title: l.homeTileCalendar,
            hint: l.planCalendarHint,
            onTap: () => SchoolCalendarScreen.open(context),
          ),
          _PlanRow(
            icon: Icons.beach_access_outlined,
            title: l.holidaysTitle,
            hint: l.planHolidaysHint,
            onTap: () => HolidaysScreen.open(context),
          ),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.icon,
    required this.title,
    required this.hint,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: context.brand.primaryLight,
            child: Icon(
              icon,
              size: AppIconSize.md,
              color: context.brand.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall),
                Text(hint, style: context.text.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    ),
  );
}
