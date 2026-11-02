import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../domain/entities/payments.dart';
import '../bloc/payees_bloc.dart';
import 'person_account_screen.dart';

/// The people of one group, with what each is owed.
class PayeesTab extends StatelessWidget {
  const PayeesTab({super.key, required this.group});

  final PayeeGroup group;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<PayeesBloc>(param1: group)..add(const PayeesStarted()),
    child: _View(group: group),
  );
}

class _View extends StatelessWidget {
  const _View({required this.group});

  final PayeeGroup group;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<PayeesBloc, PayeesState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<PayeesBloc, PayeesState>(
        builder: (context, state) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: TextField(
                onChanged: (v) =>
                    context.read<PayeesBloc>().add(PayeesSearched(v)),
                decoration: InputDecoration(
                  hintText: l.stuSearch,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: AsyncBody(
                status: state.status,
                failure: state.failure,
                onRetry: () =>
                    context.read<PayeesBloc>().add(const PayeesStarted()),
                isEmpty: state.payees.isEmpty,
                emptyText: l.payEmpty,
                emptyIcon: Icons.payments_outlined,
                builder: (context) => ListView(
                  padding: AppSpacing.page,
                  children: [
                    for (final p in state.payees)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          onTap: () async {
                            final bloc = context.read<PayeesBloc>();
                            final changed = await Navigator.of(context)
                                .push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => PersonAccountScreen(
                                      personId: p.personId,
                                      name: p.name,
                                      canManage: true,
                                    ),
                                  ),
                                );
                            if (changed == true)
                              bloc.add(const PayeesStarted());
                          },
                          child: Row(
                            children: [
                              InitialsAvatar(p.name),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: context.text.titleSmall,
                                    ),
                                    Text(
                                      p.currentSalary == null
                                          ? l.paySalaryNone
                                          : l.paySalaryNow(
                                              p.currentSalary!.format(),
                                            ),
                                      style: context.text.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                p.balance.format(),
                                style: context.text.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
