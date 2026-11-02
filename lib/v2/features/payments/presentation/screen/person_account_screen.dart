import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../domain/entities/payments.dart';
import '../../domain/usecases/payments_usecases.dart';
import '../bloc/person_account_bloc.dart';
import '../widgets/account_view.dart';
import '../widgets/pay_dialogs.dart';

/// One teacher's or staff member's account, with salary and payments.
class PersonAccountScreen extends StatelessWidget {
  const PersonAccountScreen({
    super.key,
    required this.personId,
    required this.name,
    required this.canManage,
  });

  final String personId;
  final String name;
  final bool canManage;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        sl<PersonAccountBloc>(param1: personId, param2: canManage)
          ..add(const PersonAccountStarted()),
    child: _View(name: name),
  );
}

class _View extends StatelessWidget {
  const _View({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<PersonAccountBloc, PersonAccountState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<PersonAccountBloc, PersonAccountState>(
        builder: (context, state) => PopScope<Object?>(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) Navigator.of(context).pop(state.changedCount > 0);
          },
          child: Scaffold(
            appBar: AppBar(title: Text(name)),
            body: AsyncBody(
              status: state.status,
              failure: state.failure,
              onRetry: () => context.read<PersonAccountBloc>().add(
                const PersonAccountStarted(),
              ),
              builder: (context) {
                final account = state.account!;
                final bloc = context.read<PersonAccountBloc>();
                return AccountView(
                  account: account,
                  history: state.history,
                  onSetSalary: state.canManage
                      ? () async {
                          final set = await showSalaryDialog(
                            context,
                            initial: account.currentSalary,
                          );
                          if (set != null) {
                            bloc.add(
                              SalarySet(
                                SetSalaryParams(
                                  account.personId,
                                  set.amount,
                                  set.month,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  onPaySalary: state.canManage
                      ? (s) async {
                          final paid = await showPayDialog(
                            context,
                            title: '${l.paySalary} · ${s.month}',
                            initial: s.balance,
                          );
                          if (paid != null) {
                            bloc.add(
                              PaymentMade(
                                PaymentDraft(
                                  personId: account.personId,
                                  kind: PaymentKind.salary,
                                  amount: paid.amount,
                                  mode: paid.mode,
                                  month: s.month,
                                  note: paid.note,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  onPayFuel: state.canManage
                      ? (f) async {
                          final paid = await showPayDialog(
                            context,
                            title: l.payFuelBill,
                            initial: f.balance,
                          );
                          if (paid != null) {
                            bloc.add(
                              PaymentMade(
                                PaymentDraft(
                                  personId: account.personId,
                                  kind: PaymentKind.fuelBill,
                                  amount: paid.amount,
                                  mode: paid.mode,
                                  fuelBillId: f.billId,
                                  note: paid.note,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
