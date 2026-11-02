import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../bloc/fee_ledger_bloc.dart';
import '../bloc/fees_bloc.dart';
import '../widgets/change_fee_dates_sheet.dart';
import '../widgets/fee_amount.dart';
import '../widgets/fee_head_card.dart';
import 'record_payment_screen.dart';

/// Everything one person owes, fee by fee: a student's academic, dress, books
/// and van fees, or a teacher's or other staff member's payment.
class FeeLedgerScreen extends StatelessWidget {
  const FeeLedgerScreen({super.key, required this.personId});

  final String personId;

  static Future<void> open(BuildContext context, String personId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<FeeLedgerBloc>(param1: personId)
                  ..add(const FeeLedgerLoaded()),
            child: FeeLedgerScreen(personId: personId),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<FeesBloc, FeesState>(
      builder: (context, fees) {
        final ledger = fees.ledgerOf(personId);
        if (ledger == null) {
          return Scaffold(
            appBar: AppBar(),
            body: EmptyState(
              icon: Icons.receipt_long_outlined,
              message: l.feeAccountNotFound,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(ledger.name)),
          body: BlocBuilder<FeeLedgerBloc, FeeLedgerState>(
            builder: (context, state) => ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: FeeAmount(
                          label: l.feesTotal,
                          value: formatRupees(context, ledger.total),
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Expanded(
                        child: FeeAmount(
                          label: l.feesCollected,
                          value: formatRupees(context, ledger.paid),
                          color: AppColors.present,
                        ),
                      ),
                      Expanded(
                        child: FeeAmount(
                          label: l.feesPending,
                          value: formatRupees(context, ledger.pending),
                          color: AppColors.absent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final a in ledger.accounts) ...[
                  FeeHeadCard(
                    account: a,
                    payments: state.of(a.id),
                    onRecord: () async {
                      final bloc = context.read<FeeLedgerBloc>();
                      final fees = context.read<FeesBloc>();
                      await RecordPaymentScreen.open(context, a.id);
                      fees.add(const FeesLoaded());
                      bloc.add(const FeeLedgerLoaded());
                    },
                    onChangeDates: () async {
                      final fees = context.read<FeesBloc>();
                      await ChangeFeeDatesSheet.show(context, a);
                      fees.add(const FeesLoaded());
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
