import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/approval_request.dart';
import 'approval_l10n.dart';

/// One request as a compact row: what is asked, who and when, and the two
/// buttons to answer it (or the answer, with a way to change it).
class ApprovalCard extends StatelessWidget {
  const ApprovalCard({
    super.key,
    required this.request,
    required this.onDecide,
    this.onReview,
  });

  final ApprovalRequest request;
  final ValueChanged<ApprovalStatus> onDecide;

  /// For a question paper: opens it, where it is approved or sent back.
  final VoidCallback? onReview;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (color, tint) = switch (request.status) {
      ApprovalStatus.pending => (AppColors.late, AppColors.lateLight),
      ApprovalStatus.approved => (AppColors.present, AppColors.presentLight),
      ApprovalStatus.rejected => (AppColors.absent, AppColors.absentLight),
    };
    final compact = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        const Size(0, AppSizes.buttonCompact),
      ),
      padding: WidgetStatePropertyAll(
        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
    );
    final tag = request.category.tag(l);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(request.icon, color: context.brand.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            request.title ?? '',
                            style: context.text.titleSmall,
                          ),
                        ),
                        if (tag != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          StatusChip(
                            label: tag,
                            color: AppColors.textMuted,
                            background: AppColors.pendingLight,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(request.question(l), style: context.text.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      formatLongDate(context, request.date),
                      style: context.text.labelSmall,
                    ),
                  ],
                ),
              ),
              if (!request.isPending)
                StatusChip(
                  label: request.status.label(l),
                  color: color,
                  background: tint,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (request.isPending && onReview != null)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onReview,
                style: compact,
                child: Text(l.actionReviewPaper),
              ),
            )
          else if (request.isPending)
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => onDecide(ApprovalStatus.approved),
                    style: compact,
                    child: Text(request.category.approveLabel(l)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onDecide(ApprovalStatus.rejected),
                    style: compact,
                    child: Text(request.category.rejectLabel(l)),
                  ),
                ),
              ],
            )
          else
            Align(
              alignment: Alignment.centerRight,
              child: onReview != null
                  ? TextButton(
                      onPressed: onReview,
                      child: Text(l.actionReviewPaper),
                    )
                  : TextButton(
                      onPressed: () => onDecide(ApprovalStatus.pending),
                      child: Text(l.actionChangeDecision),
                    ),
            ),
        ],
      ),
    );
  }
}
