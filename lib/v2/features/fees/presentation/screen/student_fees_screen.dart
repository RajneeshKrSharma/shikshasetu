import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../../accessories/presentation/widgets/sell_item_sheet.dart';
import '../../domain/entities/fees.dart';
import '../../domain/usecases/fees_usecases.dart';
import '../bloc/student_fees_bloc.dart';
import '../widgets/amount_dialog.dart';
import '../widgets/fee_head_label.dart';

/// One student's dues, what is paid, and the payments; money is received and
/// dress or books are sold from here.
class StudentFeesScreen extends StatelessWidget {
  const StudentFeesScreen({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        sl<StudentFeesBloc>(param1: studentId)..add(const StudentFeesStarted()),
    child: const _View(),
  );
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<StudentFeesBloc, StudentFeesState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<StudentFeesBloc, StudentFeesState>(
        builder: (context, state) {
          final s = state.statement;
          return PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) Navigator.of(context).pop(state.changedCount > 0);
            },
            child: Scaffold(
              appBar: AppBar(title: Text(s?.studentName ?? l.feeTab)),
              body: AsyncBody(
                status: state.status,
                failure: state.failure,
                onRetry: () => context.read<StudentFeesBloc>().add(
                  const StudentFeesStarted(),
                ),
                builder: (context) => ListView(
                  padding: AppSpacing.page,
                  children: [
                    Text(
                      '${s!.className} · ${l.stuRoll(s.rollNumber)}',
                      style: context.text.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    for (final line in s.lines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      line.head.label(l),
                                      style: context.text.titleSmall,
                                    ),
                                    Text(
                                      '${l.feeDue} ${line.due.format()} · '
                                      '${l.feePaid} ${line.paid.format()}',
                                      style: context.text.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                line.balance.format(),
                                style: context.text.titleSmall,
                              ),
                              if (line.balance.isPositive)
                                IconButton(
                                  tooltip: l.feeReceive,
                                  icon: const Icon(Icons.payments_outlined),
                                  onPressed: state.busy
                                      ? null
                                      : () => _receive(context, s, line.head),
                                ),
                            ],
                          ),
                        ),
                      ),
                    AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.feeBalance,
                              style: context.text.titleMedium,
                            ),
                          ),
                          Text(
                            s.balance.format(),
                            style: context.text.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: () => _sell(context, s),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: Text(l.feeSell),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SectionTitle(l.feePayments),
                    if (s.payments.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Text(l.feeNoPayments),
                      ),
                    for (final p in s.payments)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${p.head.label(l)} · ${p.amount.format()}',
                        ),
                        subtitle: Text(
                          '${l.feeReceipt(p.receiptNo)} · '
                          '${formatShortDate(context, p.paidOn)}',
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _receive(
    BuildContext context,
    FeeStatement s,
    FeeHead head,
  ) async {
    final l = context.l10n;
    final bloc = context.read<StudentFeesBloc>();
    final line = s.lines.firstWhere((x) => x.head == head);
    final result = await showAmountDialog(
      context,
      title: '${l.feeReceive} · ${head.label(l)}',
      initial: line.balance,
      withNote: true,
    );
    if (result == null) return;
    bloc.add(
      FeeReceived(
        ReceiveFeeParams(
          studentId: s.studentId,
          head: head,
          amount: result.amount,
          note: result.note,
        ),
      ),
    );
  }

  Future<void> _sell(BuildContext context, FeeStatement s) async {
    final bloc = context.read<StudentFeesBloc>();
    final sold = await showSellItemSheet(
      context,
      studentId: s.studentId,
      classId: s.classId,
    );
    if (sold == true) bloc.add(const StudentFeesStarted());
  }
}
