import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/staff_bill.dart';
import 'bill_labels.dart';

/// One bill in a list: what and how much, when, and where it stands.
class BillRow extends StatelessWidget {
  const BillRow({
    super.key,
    required this.bill,
    this.showStaff = false,
    this.onTap,
  });

  final StaffBill bill;

  /// Names the staff member too, for a list of everyone's bills.
  final bool showStaff;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (color, tint) = switch (bill.phase) {
      BillPhase.pending => (AppColors.late, AppColors.lateLight),
      BillPhase.approved => (AppColors.present, AppColors.presentLight),
      BillPhase.rejected => (AppColors.absent, AppColors.absentLight),
      BillPhase.paid => (AppColors.textMuted, AppColors.pendingLight),
    };
    final proof = bill.photoPath == null ? l.billPhotoNo : l.billPhotoYes;
    final date = formatShortDate(context, bill.date);
    final sub = bill.litres == null
        ? l.billRowSubNoLitres(date, proof)
        : l.billRowSub(
            date,
            '${bill.litres}'.replaceFirst(RegExp(r'\.0$'), ''),
            proof,
          );
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.billRowTitle(
                        bill.kind.label(l),
                        formatRupees(context, bill.amount),
                      ),
                      style: context.text.titleSmall,
                    ),
                    Text(
                      showStaff ? '${bill.staffName} · $sub' : sub,
                      style: context.text.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: bill.phase.label(l),
                color: color,
                background: tint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
