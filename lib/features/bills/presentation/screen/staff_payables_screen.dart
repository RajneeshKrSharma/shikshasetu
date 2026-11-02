import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../bloc/staff_payment_bloc.dart';
import 'staff_payment_screen.dart';

/// Who has bills, and how much of it can be paid now. Opening one goes to
/// that person's payment.
class StaffPayablesScreen extends StatelessWidget {
  const StaffPayablesScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<StaffPayablesCubit>()..load(),
        child: const StaffPayablesScreen(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.staffPaymentTitle)),
      body: BlocBuilder<StaffPayablesCubit, StaffPayablesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.staff.isEmpty) {
            return EmptyState(
              icon: Icons.payments_outlined,
              message: l.billsEmpty,
            );
          }
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              for (final s in state.staff)
                InkWell(
                  onTap: () async {
                    final cubit = context.read<StaffPayablesCubit>();
                    await StaffPaymentScreen.open(context, s.staffId, s.name);
                    await cubit.load();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        InitialsAvatar(s.name, radius: 18),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.name, style: context.text.titleSmall),
                              Text(
                                [
                                  s.role,
                                  if (s.waitingCount > 0)
                                    l.staffBillsWaiting(s.waitingCount),
                                ].join(' · '),
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          s.payableAmount > 0
                              ? l.staffPayableLine(
                                  formatRupees(context, s.payableAmount),
                                )
                              : '–',
                          style: context.text.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
