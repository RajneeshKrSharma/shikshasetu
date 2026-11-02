import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../screen/school_plans_screen.dart';
import 'needs_you_card.dart';
import 'quick_actions_row.dart';
import 'today_in_school.dart';

/// The Principal's home, top to bottom: what needs an answer, today's
/// numbers, the notice, and the school's plans. The people (Students,
/// Teachers, Others) are the tabs below, so they are not repeated here, and
/// each thing is opened from one place only.
class PrincipalHomeBody extends StatelessWidget {
  const PrincipalHomeBody({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const gap = SizedBox(height: AppSpacing.xl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NeedsYouCard(),
        gap,
        TodayInSchool(summary: summary),
        gap,
        const QuickActionsRow(),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          onTap: () => SchoolPlansScreen.open(context),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.brand.primaryLight,
                child: Icon(
                  Icons.event_note_outlined,
                  color: context.brand.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.homeSchoolPlans, style: context.text.titleSmall),
                    Text(l.homeSchoolPlansHint, style: context.text.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ],
    );
  }
}
