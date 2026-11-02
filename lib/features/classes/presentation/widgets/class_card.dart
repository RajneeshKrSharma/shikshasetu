import '../../../../l10n/class_label.dart';
import '../../../../core/widgets/info_banner.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/class_summary.dart';

enum ClassAction { edit, delete }

class ClassCard extends StatelessWidget {
  const ClassCard({super.key, required this.summary, required this.onAction});

  final ClassSummary summary;
  final ValueChanged<ClassAction> onAction;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          const IconBadge(Icons.class_outlined),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.classLabel(summary.name),
                  style: context.text.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  l.classStudentCount(summary.studentCount),
                  style: context.text.bodySmall,
                ),
                Text(
                  summary.classTeacherName ?? l.classNoTeacher,
                  style: context.text.labelSmall,
                ),
              ],
            ),
          ),
          PopupMenuButton<ClassAction>(
            tooltip: l.actionMore,
            onSelected: onAction,
            itemBuilder: (_) => [
              PopupMenuItem(value: ClassAction.edit, child: Text(l.actionEdit)),
              PopupMenuItem(
                value: ClassAction.delete,
                child: Text(
                  l.actionDelete,
                  style: const TextStyle(color: AppColors.absent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
