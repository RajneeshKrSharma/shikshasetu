import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../core/money.dart';
import '../../domain/entities/payments.dart';
import 'payment_labels.dart';

/// Asks how much was paid and how; null when cancelled.
Future<({Money amount, PaymentMode mode, String note})?> showPayDialog(
  BuildContext context, {
  required String title,
  required Money initial,
}) => showDialog<({Money amount, PaymentMode mode, String note})>(
  context: context,
  builder: (_) => _PayDialog(title: title, initial: initial),
);

class _PayDialog extends StatefulWidget {
  const _PayDialog({required this.title, required this.initial});

  final String title;
  final Money initial;

  @override
  State<_PayDialog> createState() => _PayDialogState();
}

class _PayDialogState extends State<_PayDialog> {
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late final ValueNotifier<PaymentMode> _mode;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(text: widget.initial.wire);
    _note = TextEditingController();
    _mode = ValueNotifier(PaymentMode.cash);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    _mode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amount,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.fieldAmount,
                  prefixText: '₹ ',
                ),
                validator: (v) {
                  final m = Money.tryParse(v ?? '');
                  return m == null || m.isZero ? l.errorAmountInvalid : null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<PaymentMode>(
                valueListenable: _mode,
                builder: (context, mode, _) =>
                    DropdownButtonFormField<PaymentMode>(
                      initialValue: mode,
                      decoration: InputDecoration(labelText: l.payMode),
                      items: [
                        for (final m in PaymentMode.values)
                          DropdownMenuItem(value: m, child: Text(m.label(l))),
                      ],
                      onChanged: (v) => _mode.value = v ?? mode,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _note,
                maxLength: 200,
                decoration: InputDecoration(labelText: l.feeNote),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_key.currentState!.validate()) return;
            Navigator.pop(context, (
              amount: Money.tryParse(_amount.text)!,
              mode: _mode.value,
              note: _note.text,
            ));
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.payPay),
        ),
      ],
    );
  }
}

/// Asks the monthly salary and the month it starts from; null when cancelled.
Future<({Money amount, String month})?> showSalaryDialog(
  BuildContext context, {
  Money? initial,
}) => showDialog<({Money amount, String month})>(
  context: context,
  builder: (_) => _SalaryDialog(initial: initial),
);

class _SalaryDialog extends StatefulWidget {
  const _SalaryDialog({this.initial});

  final Money? initial;

  @override
  State<_SalaryDialog> createState() => _SalaryDialogState();
}

class _SalaryDialogState extends State<_SalaryDialog> {
  late final TextEditingController _amount;
  late final ValueNotifier<DateTime> _month;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _amount = TextEditingController(text: widget.initial?.wire ?? '');
    _month = ValueNotifier(DateTime(now.year, now.month));
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _amount.dispose();
    _month.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.paySetSalary),
      content: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l.fieldAmount,
                prefixText: '₹ ',
              ),
              validator: (v) {
                final m = Money.tryParse(v ?? '');
                return m == null || m.isZero ? l.errorAmountInvalid : null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            ValueListenableBuilder<DateTime>(
              valueListenable: _month,
              builder: (context, month, _) => PickerField(
                label: l.paySalaryFrom,
                value: '${formatMonthShort(context, month)} ${month.year}',
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: month,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDatePickerMode: DatePickerMode.year,
                  );
                  if (picked != null) {
                    _month.value = DateTime(picked.year, picked.month);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_key.currentState!.validate()) return;
            final m = _month.value;
            Navigator.pop(context, (
              amount: Money.tryParse(_amount.text)!,
              month:
                  '${m.year.toString().padLeft(4, '0')}-'
                  '${m.month.toString().padLeft(2, '0')}',
            ));
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
