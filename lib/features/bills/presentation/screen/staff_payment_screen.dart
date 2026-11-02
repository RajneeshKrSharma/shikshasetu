import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../approvals/presentation/screen/approvals_screen.dart';
import '../bloc/settle_bloc.dart';
import '../bloc/staff_payment_bloc.dart';
import '../widgets/bill_labels.dart';
import 'settle_screen.dart';
import 'settlements_screen.dart';

/// What can be paid to one staff member now (approved bills, ticked), and
/// what is locked until the Principal approves it.
class StaffPaymentScreen extends StatelessWidget {
  const StaffPaymentScreen({
    super.key,
    required this.staffId,
    required this.staffName,
  });

  final String staffId;
  final String staffName;

  static Future<void> open(
    BuildContext context,
    String staffId,
    String staffName,
  ) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) =>
            sl<StaffPaymentBloc>(param1: staffId)
              ..add(const StaffPaymentStarted()),
        child: StaffPaymentScreen(staffId: staffId, staffName: staffName),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(staffName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Center(
              child: Text(l.staffPaymentTitle, style: context.text.bodySmall),
            ),
          ),
        ],
      ),
      body: BlocBuilder<StaffPaymentBloc, StaffPaymentState>(
        builder: (context, s) {
          if (s.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final bloc = context.read<StaffPaymentBloc>();
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              Container(
                width: double.infinity,
                padding: AppSpacing.card,
                decoration: BoxDecoration(
                  color: context.brand.primaryLight,
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(
                    color: context.brand.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.staffPayableNow, style: context.text.bodySmall),
                    Text(
                      formatRupees(context, s.payableTotal),
                      style: context.text.headlineMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (s.payable.isEmpty)
                Text(l.staffNothingPayable, style: context.text.bodyMedium)
              else ...[
                Text(l.staffEligible, style: context.text.labelLarge),
                for (final b in s.payable)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: s.selected.contains(b.id),
                    onChanged: (_) => bloc.add(BillToggled(b.id)),
                    title: Text(
                      l.billRowTitle(
                        b.kind.label(l),
                        formatRupees(context, b.amount),
                      ),
                    ),
                    subtitle: Text(
                      b.vehicleNumber ?? b.staffName,
                      style: context.text.bodySmall,
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  onPressed: s.chosen.isEmpty
                      ? null
                      : () async {
                          await SettleScreen.open(
                            context,
                            SettleArgs(
                              staffId: staffId,
                              staffName: staffName,
                              vehicleNumber: s.chosen.first.vehicleNumber,
                              bills: s.chosen,
                            ),
                          );
                          bloc.add(const StaffPaymentStarted());
                        },
                  child: Text(
                    l.staffSettle(formatRupees(context, s.chosenTotal)),
                  ),
                ),
              ],
              if (s.waiting.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(l.staffNotEligible, style: context.text.labelLarge),
                for (final b in s.waiting)
                  Opacity(
                    opacity: 0.65,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l.billRowTitle(
                          b.kind.label(l),
                          formatRupees(context, b.amount),
                        ),
                      ),
                      subtitle: Text(l.staffLockedWaiting),
                      trailing: StatusChip(
                        label: l.staffLocked,
                        color: AppColors.late,
                        background: AppColors.lateLight,
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await ApprovalsScreen.open(context);
                        bloc.add(const StaffPaymentStarted());
                      },
                      child: Text(l.staffGoApprovals),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          SettlementsScreen.open(context, staffId: staffId),
                      child: Text(l.staffPayHistory),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
