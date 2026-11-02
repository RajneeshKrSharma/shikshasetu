import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../domain/entities/fee_account.dart';
import '../bloc/fee_filter_cubit.dart';
import '../widgets/add_fee_sheet.dart';
import '../widgets/fee_group_view.dart';
import 'fee_setup_screen.dart';
import 'payment_history_screen.dart';

/// The fees of one group of people (Principal only): students' fees, a
/// teacher's payment, or other staff's payment.
class FeesScreen extends StatelessWidget {
  const FeesScreen({super.key, required this.group});

  final FeeGroup group;

  static Future<void> open(BuildContext context, FeeGroup group) =>
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => FeesScreen(group: group)));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (group) {
          FeeGroup.student => l.feesTitle,
          FeeGroup.teacher => l.featureTeacherPayment,
          FeeGroup.other => l.featureStaffPayment,
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, AppSizes.buttonCompact),
              ),
              onPressed: () => AddFeeSheet.show(context),
              child: Text(l.actionAssignFee),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => FeeFilterCubit(),
        child: FeeGroupView(group: group),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              // What each class pays is set up for students only.
              if (group == FeeGroup.student) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => FeeSetupScreen.open(context),
                    child: Text(l.feeSetupTitle),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: OutlinedButton(
                  onPressed: () => PaymentHistoryScreen.open(context),
                  child: Text(l.modulePayments),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
