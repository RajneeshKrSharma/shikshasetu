import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../proofs/presentation/widgets/proof_viewer.dart';
import '../../domain/entities/accessory_issue.dart';
import 'accessory_labels.dart';

/// One handing over, with its receipt number, what was given, who received
/// it, and buttons to see the proof.
class IssueLogCard extends StatelessWidget {
  const IssueLogCard({super.key, required this.issue, this.trailing});

  final AccessoryIssue issue;

  /// An extra action under the proof buttons, such as "Give remaining".
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${issue.receiptNo} · ${issue.kind.label(l)}',
                  style: context.text.titleSmall,
                ),
              ),
              if (issue.isSigned)
                StatusChip(
                  label: l.proofSignedTag,
                  color: AppColors.present,
                  background: AppColors.presentLight,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            [
              if (issue.size != null) l.accSizeLabel(issue.size!),
              if (issue.quantity > 1) '${l.accSets}: ${issue.quantity}',
              issue.items.join(', '),
            ].join(' · '),
            style: context.text.bodyMedium,
          ),
          Text(
            l.accLogReceived(
              issue.receivedBy,
              formatShortDate(context, issue.issuedAt),
            ),
            style: context.text.bodySmall,
          ),
          if (issue.isSigned || issue.photoPath != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                if (issue.isSigned)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, AppSizes.buttonCompact),
                    ),
                    onPressed: () =>
                        ProofViewer.show(context, issue.signaturePath!),
                    child: Text(l.accLogViewSignature),
                  ),
                if (issue.photoPath != null)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, AppSizes.buttonCompact),
                    ),
                    onPressed: () =>
                        ProofViewer.show(context, issue.photoPath!),
                    child: Text(l.accLogViewPhoto),
                  ),
              ],
            ),
          ],
          ?trailing,
        ],
      ),
    );
  }
}
