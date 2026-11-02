import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../domain/usecases/fees_usecases.dart';
import '../bloc/fee_accounts_bloc.dart';
import 'student_fees_screen.dart';

/// Every student's fee account, narrowed by class, name or what is due.
class FeesTab extends StatelessWidget {
  const FeesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<FeeAccountsBloc, FeeAccountsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<FeeAccountsBloc, FeeAccountsState>(
        builder: (context, state) {
          final filter = state.filter;
          void filtered(FeeAccountsParams next) =>
              context.read<FeeAccountsBloc>().add(FeeAccountsFiltered(next));
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (v) => filtered(
                        FeeAccountsParams(
                          classId: filter.classId,
                          query: v,
                          onlyDue: filter.onlyDue,
                        ),
                      ),
                      decoration: InputDecoration(
                        hintText: l.stuSearch,
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonFormField<String?>(
                      initialValue: filter.classId,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l.fieldClass),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l.stuAllClasses),
                        ),
                        for (final c in state.classes)
                          DropdownMenuItem<String?>(
                            value: c.id,
                            child: Text(c.name),
                          ),
                      ],
                      onChanged: (id) => filtered(
                        FeeAccountsParams(
                          classId: id,
                          query: filter.query,
                          onlyDue: filter.onlyDue,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.feeOnlyDue),
                      value: filter.onlyDue,
                      onChanged: (v) => filtered(
                        FeeAccountsParams(
                          classId: filter.classId,
                          query: filter.query,
                          onlyDue: v,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AsyncBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: () => context.read<FeeAccountsBloc>().add(
                    const FeeAccountsStarted(),
                  ),
                  isEmpty: state.accounts.isEmpty,
                  emptyText: l.feeAccountsEmpty,
                  emptyIcon: Icons.account_balance_wallet_outlined,
                  builder: (context) => ListView(
                    padding: AppSpacing.page,
                    children: [
                      for (final a in state.accounts)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            onTap: () async {
                              final bloc = context.read<FeeAccountsBloc>();
                              final changed = await Navigator.of(context)
                                  .push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) => StudentFeesScreen(
                                        studentId: a.studentId,
                                      ),
                                    ),
                                  );
                              if (changed == true) {
                                bloc.add(FeeAccountsFiltered(filter));
                              }
                            },
                            child: Row(
                              children: [
                                InitialsAvatar(a.studentName),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        a.studentName,
                                        style: context.text.titleSmall,
                                      ),
                                      Text(
                                        '${a.className} · ${l.stuRoll(a.rollNumber)}',
                                        style: context.text.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  a.hasDue
                                      ? l.feeBalanceOf(a.balance.format())
                                      : a.totalPaid.format(),
                                  style: context.text.labelLarge,
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
          );
        },
      ),
    );
  }
}
