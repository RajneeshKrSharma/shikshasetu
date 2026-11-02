import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../fees/presentation/widgets/fee_labels.dart';
import '../../../proofs/presentation/widgets/proof_viewer.dart';
import '../bloc/settlements_cubit.dart';

/// Every payment made to staff for their bills: its voucher, how it was
/// paid, what it was for, and the proof.
class SettlementsScreen extends StatelessWidget {
  const SettlementsScreen({super.key, this.staffId});

  final String? staffId;

  static Future<void> open(BuildContext context, {String? staffId}) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => sl<SettlementsCubit>(param1: staffId)..load(),
            child: SettlementsScreen(staffId: staffId),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.settlementsTitle)),
      body: BlocBuilder<SettlementsCubit, SettlementsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.settlements.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              message: l.settlementsEmpty,
            );
          }
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              for (final s in state.settlements) ...[
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${s.voucherNo} · ${formatRupees(context, s.amount)}',
                              style: context.text.titleSmall,
                            ),
                          ),
                          StatusChip(
                            label: s.hasProof
                                ? l.paymentProofYes
                                : l.paymentProofNo,
                            color: s.hasProof
                                ? AppColors.present
                                : AppColors.textMuted,
                            background: s.hasProof
                                ? AppColors.presentLight
                                : AppColors.pendingLight,
                          ),
                        ],
                      ),
                      Text(
                        [
                          if (staffId == null) s.staffName,
                          l.settlementLine(
                            s.mode.label(l),
                            formatShortDate(context, s.paidAt),
                          ),
                          if (s.reference != null)
                            l.settlementRef(s.reference!),
                        ].join(' · '),
                        style: context.text.bodySmall,
                      ),
                      Text(
                        l.settlementBills(s.billCount),
                        style: context.text.bodySmall,
                      ),
                      if (s.hasProof) ...[
                        const SizedBox(height: AppSpacing.sm),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, AppSizes.buttonCompact),
                          ),
                          onPressed: () =>
                              ProofViewer.show(context, s.proofPath!),
                          child: Text(l.settlementViewProof),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          );
        },
      ),
    );
  }
}
