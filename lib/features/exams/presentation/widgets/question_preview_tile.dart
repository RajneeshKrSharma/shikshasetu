import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/exam_paper.dart';
import 'question_type_style.dart';

/// A finished question as it reads on the paper: its number, text, marks, and
/// whatever its type adds (options, columns, the right answer).
class QuestionPreviewTile extends StatelessWidget {
  const QuestionPreviewTile({
    super.key,
    required this.number,
    required this.question,
    this.trailing,
  });

  final int number;
  final Question question;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final q = question;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.questionNumber(number),
                style: context.text.titleSmall!.copyWith(
                  color: context.brand.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: Text(q.text, style: context.text.bodyLarge)),
              const SizedBox(width: AppSpacing.lg),
              StatusChip(
                label: l.marksShort(q.marks),
                color: context.brand.primary,
                background: context.brand.primaryLight,
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                q.type.icon,
                size: AppIconSize.sm,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(q.type.label(l), style: context.text.labelSmall),
            ],
          ),
          ..._body(context),
        ],
      ),
    );
  }

  List<Widget> _body(BuildContext context) {
    final l = context.l10n;
    final q = question;
    switch (q.type) {
      case QuestionType.mcq:
        return [
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < q.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    i == q.correctIndex
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    size: AppIconSize.sm,
                    color: i == q.correctIndex
                        ? AppColors.present
                        : AppColors.textMuted,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      '(${String.fromCharCode(0x61 + i)}) ${q.options[i]}',
                      style: context.text.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        ];
      case QuestionType.trueFalse:
        return [
          if (q.correctIndex != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                '${l.qCorrectAnswer}: ${q.correctIndex == 0 ? l.qTrue : l.qFalse}',
                style: context.text.bodySmall,
              ),
            ),
        ];
      case QuestionType.fillBlank:
        return [
          if (q.answer.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                '${l.qCorrectAnswer}: ${q.answer}',
                style: context.text.bodySmall,
              ),
            ),
        ];
      case QuestionType.matchFollowing:
        return [
          const SizedBox(height: AppSpacing.md),
          for (final p in q.pairs)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Expanded(child: Text(p.left, style: context.text.bodyMedium)),
                  const Icon(Icons.compare_arrows, size: AppIconSize.sm),
                  Expanded(
                    child: Text(
                      p.right,
                      textAlign: TextAlign.end,
                      style: context.text.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        ];
      case QuestionType.shortAnswer:
      case QuestionType.longAnswer:
        return const [];
    }
  }
}
