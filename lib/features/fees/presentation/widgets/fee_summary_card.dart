import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../domain/entities/fee_account.dart';
import '../bloc/fees_bloc.dart';

/// What has come in and what is still to come, as two cards.
class FeeSummaryCard extends StatelessWidget {
  const FeeSummaryCard({super.key, required this.group});

  final FeeGroup group;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<FeesBloc, FeesState>(
      builder: (context, state) => Row(
        children: [
          Expanded(
            child: _Figure(
              label: l.feesCollected,
              value: formatRupeesCompact(context, state.paidOf(group)),
              color: AppColors.present,
              tint: AppColors.presentLight,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _Figure(
              label: l.feesPending,
              value: formatRupeesCompact(context, state.pendingOf(group)),
              color: AppColors.late,
              tint: AppColors.lateLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    required this.color,
    required this.tint,
  });

  final String label;
  final String value;
  final Color color;
  final Color tint;

  @override
  Widget build(BuildContext context) => Container(
    padding: AppSpacing.card,
    decoration: BoxDecoration(
      color: tint,
      borderRadius: AppRadius.lgAll,
      border: Border.all(color: color.withValues(alpha: 0.6)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: context.text.headlineSmall),
      ],
    ),
  );
}
