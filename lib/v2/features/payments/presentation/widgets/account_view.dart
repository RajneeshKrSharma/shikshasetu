import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/money.dart';
import '../../domain/entities/payments.dart';
import 'payment_labels.dart';

/// A person's money with the school: salary, fuel dues, what is paid.
/// [onPaySalary], [onPayFuel] and [onSetSalary] show their buttons only when
/// given.
class AccountView extends StatelessWidget {
  const AccountView({
    super.key,
    required this.account,
    this.history = const [],
    this.onSetSalary,
    this.onPaySalary,
    this.onPayFuel,
  });

  final PersonAccount account;
  final List<SalaryRate> history;
  final VoidCallback? onSetSalary;
  final ValueChanged<SalaryMonth>? onPaySalary;
  final ValueChanged<FuelDue>? onPayFuel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dues = [
      for (final s in account.salary)
        if (s.balance.isPositive) s,
    ];
    final fuel = [
      for (final f in account.fuel)
        if (f.balance.isPositive) f,
    ];
    return ListView(
      padding: AppSpacing.page,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.currentSalary == null
                    ? l.paySalaryNone
                    : l.paySalaryNow(account.currentSalary!.format()),
                style: context.text.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.payBalance(account.balance.format()),
                style: context.text.titleMedium,
              ),
              Text(
                l.payTotals(
                  account.totalDue.format(),
                  account.totalPaid.format(),
                ),
                style: context.text.bodySmall,
              ),
              if (onSetSalary != null)
                TextButton.icon(
                  onPressed: onSetSalary,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l.paySetSalary),
                ),
            ],
          ),
        ),
        if (dues.isEmpty && fuel.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(l.payNothingDue, textAlign: TextAlign.center),
          ),
        for (final s in dues)
          _DueTile(
            label: '${l.paySalary} · ${s.month}',
            due: s.due,
            paid: s.paid,
            balance: s.balance,
            onPay: onPaySalary == null ? null : () => onPaySalary!(s),
          ),
        for (final f in fuel)
          _DueTile(
            label:
                '${l.payFuelBill} · '
                '${l.payFuelOn(f.vanName, formatShortDate(context, f.billedOn))}',
            due: f.due,
            paid: f.paid,
            balance: f.balance,
            onPay: onPayFuel == null ? null : () => onPayFuel!(f),
          ),
        if (history.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          SectionTitle(l.paySalaryHistory),
          for (final r in history)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(r.amount.format()),
              trailing: Text(l.payFrom(r.effectiveFrom)),
            ),
        ],
        const SizedBox(height: AppSpacing.lg),
        SectionTitle(l.payHistory),
        if (account.payments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(l.payHistoryEmpty),
          ),
        for (final p in account.payments)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('${p.kind.label(l)} · ${p.amount.format()}'),
            subtitle: Text(
              '${l.payReceipt(p.receiptNo)} · ${p.mode.label(l)} · '
              '${formatShortDate(context, p.paidOn)}',
            ),
          ),
      ],
    );
  }
}

class _DueTile extends StatelessWidget {
  const _DueTile({
    required this.label,
    required this.due,
    required this.paid,
    required this.balance,
    this.onPay,
  });

  final String label;
  final Money due;
  final Money paid;
  final Money balance;
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.text.titleSmall),
                  Text(
                    l.payTotals(due.format(), paid.format()),
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            Text(balance.format(), style: context.text.titleSmall),
            if (onPay != null)
              IconButton(
                tooltip: l.payPay,
                icon: const Icon(Icons.payments_outlined),
                onPressed: onPay,
              ),
          ],
        ),
      ),
    );
  }
}
