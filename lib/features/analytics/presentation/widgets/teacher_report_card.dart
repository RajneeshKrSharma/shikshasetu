import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/teacher_report.dart';

class TeacherReportCard extends StatelessWidget {
  const TeacherReportCard({super.key, required this.report});

  final TeacherReport report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final percent = report.attendancePercent;
    final avg = report.avgCheckIn;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InitialsAvatar(report.name, radius: 16),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(report.name, style: context.text.titleSmall),
              ),
              Text(
                percent == null ? '–' : l.percentValue(percent.round()),
                style: context.text.titleSmall!.copyWith(
                  color: context.brand.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.smAll,
            child: LinearProgressIndicator(
              value: (percent ?? 0) / 100,
              minHeight: 6,
              backgroundColor: context.brand.primaryLight,
              color: context.brand.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            avg == null
                ? l.noCheckInsYet
                : l.avgCheckInLabel(
                    formatTime(
                      context,
                      DateTime(
                        2000,
                        1,
                        1,
                        avg.inHours,
                        avg.inMinutes.remainder(60),
                      ),
                    ),
                  ),
            style: context.text.labelSmall,
          ),
        ],
      ),
    );
  }
}
