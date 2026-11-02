import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../proofs/presentation/widgets/proof_viewer.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_payment.dart';
import '../bloc/fee_ledger_bloc.dart';
import 'fee_labels.dart';
import 'fee_status_style.dart';

/// One fee of a person (academic, dress, books, van...): paid or not, its
/// dates, and every payment against it with its receipt and proof.
class FeeHeadCard extends StatelessWidget {
  const FeeHeadCard({
    super.key,
    required this.account,
    required this.payments,
    required this.onRecord,
    required this.onChangeDates,
  });

  final FeeAccount account;
  final List<FeePayment> payments;
  final VoidCallback onRecord;
  final VoidCallback onChangeDates;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    final status = account.statusAt(now);
    final ratio = account.total == 0 ? 0.0 : account.paid / account.total;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: status.color.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  account.head.label(l),
                  style: context.text.titleSmall,
                ),
              ),
              StatusChip(
                label: status.label(l),
                color: status.color,
                background: status.background,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.feePaidOfTotal(
              formatRupees(context, account.paid),
              formatRupees(context, account.total),
            ),
            style: context.text.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.smAll,
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: status.background,
              color: status == FeeStatus.paid
                  ? AppColors.present
                  : status.color,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            account.lastDate == null
                ? l.feeDueOn(formatShortDate(context, account.dueDate))
                : l.feeDueLast(
                    formatShortDate(context, account.dueDate),
                    formatShortDate(context, account.lastDate!),
                  ),
            style: context.text.bodySmall,
          ),
          if (account.dateNote != null && account.dateNote!.isNotEmpty)
            Text(
              l.feeDatesNote(account.dateNote!),
              style: context.text.bodySmall!.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          if (payments.isEmpty)
            Text(l.feeNoPaymentYet, style: context.text.bodySmall)
          else
            for (final p in payments)
              _PaymentLine(account: account, payment: p),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              if (account.pending > 0)
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, AppSizes.buttonCompact),
                    ),
                    onPressed: onRecord,
                    child: Text(l.actionRecordPayment),
                  ),
                ),
              if (account.pending > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, AppSizes.buttonCompact),
                  ),
                  onPressed: onChangeDates,
                  child: Text(l.feeChangeDates),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentLine extends StatelessWidget {
  const _PaymentLine({required this.account, required this.payment});

  final FeeAccount account;
  final FeePayment payment;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final detail = [
      formatShortDate(context, payment.paidAt),
      payment.mode.label(l),
      if (payment.reference != null) payment.reference!,
      payment.receiptNo,
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatRupees(context, payment.amount),
                  style: context.text.titleSmall,
                ),
                Text(detail, style: context.text.bodySmall),
              ],
            ),
          ),
          InkWell(
            onTap: payment.hasProof
                ? () => ProofViewer.show(context, payment.proofPath!)
                : null,
            borderRadius: AppRadius.pillAll,
            child: StatusChip(
              label: payment.hasProof ? l.paymentProofYes : l.paymentProofNo,
              color: payment.hasProof ? AppColors.present : AppColors.textMuted,
              background: payment.hasProof
                  ? AppColors.presentLight
                  : AppColors.pendingLight,
            ),
          ),
          IconButton(
            tooltip: l.actionShareReceipt,
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => context.read<FeeLedgerBloc>().add(
              ReceiptRequested(
                account: account,
                payment: payment,
                schoolName: context
                    .read<SettingsBloc>()
                    .state
                    .settings
                    .schoolName,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
