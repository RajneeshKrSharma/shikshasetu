import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../domain/entities/dashboard_summary.dart';

/// How many of each group are in school today, as three plain cards.
class TodayInSchool extends StatelessWidget {
  const TodayInSchool({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final marked = summary.studentTotals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.homeTodayInSchool, style: context.text.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _Count(
                value: marked.total == 0
                    ? '–'
                    : '${marked.present}/${summary.studentsTotal}',
                label: l.tabStudents,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Count(
                value: '${summary.teachersPresent}/${summary.teachersTotal}',
                label: l.tabTeachers,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Count(
                value: '${summary.othersPresent}/${summary.othersTotal}',
                label: l.tabOthers,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.pendingLight.withValues(alpha: 0.6),
      borderRadius: AppRadius.mdAll,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: context.text.titleMedium),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.bodySmall,
        ),
      ],
    ),
  );
}
