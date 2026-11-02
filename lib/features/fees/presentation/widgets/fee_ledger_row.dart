import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/class_label.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/fee_ledger.dart';
import 'fee_status_style.dart';

/// One person on the Fees list: who, how much is paid of all their fees, and
/// how they stand. Their separate fees are on the screen it opens.
class FeeLedgerRow extends StatelessWidget {
  const FeeLedgerRow({super.key, required this.ledger, required this.onTap});

  final FeeLedger ledger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final status = ledger.statusAt(DateTime.now());
    final subtitle = ledger.classSection == null
        ? ledger.subtitle
        : [
            l.classLabel(ledger.classSection!),
            if (ledger.rollNo != null) l.feeRollNo(ledger.rollNo!),
          ].join(' · ');
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              InitialsAvatar(ledger.name, radius: 18),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ledger.name, style: context.text.titleSmall),
                    Text(
                      '$subtitle · ${l.feePaidOfTotal(formatRupees(context, ledger.paid), formatRupees(context, ledger.total))}',
                      style: context.text.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: status.label(l),
                color: status.color,
                background: status.background,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
