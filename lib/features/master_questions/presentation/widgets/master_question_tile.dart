import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/presentation/widgets/question_type_style.dart';
import '../../domain/entities/master_question.dart';

/// A master question in a list: its type, text, a line of detail, and the
/// subject it belongs to.
class MasterQuestionTile extends StatelessWidget {
  const MasterQuestionTile({
    super.key,
    required this.item,
    required this.onTap,
    this.leading,
    this.trailing,
  });

  final MasterQuestion item;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;

  String _detail() {
    final q = item.question;
    return switch (q.type) {
      QuestionType.mcq => [
        for (var i = 0; i < q.options.length; i++)
          '${String.fromCharCode(0x61 + i)}) ${q.options[i]}',
      ].join('   '),
      QuestionType.matchFollowing => [
        for (final p in q.pairs) '${p.left} – ${p.right}',
      ].join('   '),
      QuestionType.fillBlank => q.answer,
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final q = item.question;
    final detail = _detail();
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ?leading,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      q.type.icon,
                      size: AppIconSize.sm,
                      color: context.brand.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      q.type.label(l),
                      style: context.text.labelMedium!.copyWith(
                        color: context.brand.primary,
                      ),
                    ),
                    if (item.subject != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        item.subject!,
                        style: context.text.labelSmall!.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                    if (q.marks > 0) ...[
                      const Spacer(),
                      StatusChip(
                        label: l.marksShort(q.marks),
                        color: context.brand.primary,
                        background: context.brand.primaryLight,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  q.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyLarge,
                ),
                if (detail.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
