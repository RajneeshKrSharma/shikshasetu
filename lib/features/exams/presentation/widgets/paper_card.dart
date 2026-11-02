import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/exam_paper.dart';
import 'paper_setter.dart';
import 'paper_status_style.dart';

class PaperCard extends StatelessWidget {
  const PaperCard({super.key, required this.paper, required this.onTap});

  final ExamPaper paper;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final setter = paperSetterName(context, paper);
    return AppCard(
      onTap: onTap,
      borderColor: paper.status.color(context.brand).withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(paper.title, style: context.text.titleMedium),
              ),
              StatusChip(
                label: paper.status.label(l),
                color: paper.status.color(context.brand),
                background: paper.status.background(context.brand),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.paperSubjectClass(paper.subject, paper.classSection),
            style: context.text.bodyMedium,
          ),
          if (setter.isNotEmpty)
            Text(l.paperSetBy(setter), style: context.text.bodySmall),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${formatShortDate(context, paper.date)}  ·  '
            '${l.paperMarksDuration(paper.totalMarks, paper.durationMinutes)}',
            style: context.text.bodySmall,
          ),
        ],
      ),
    );
  }
}
