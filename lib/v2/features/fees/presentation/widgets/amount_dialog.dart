import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../core/money.dart';

/// Asks for an amount in rupees (and, when [withNote], a note); closes with
/// the amount, or null when cancelled.
Future<({Money amount, String note})?> showAmountDialog(
  BuildContext context, {
  required String title,
  Money? initial,
  bool withNote = false,
}) => showDialog<({Money amount, String note})>(
  context: context,
  builder: (_) =>
      _AmountDialog(title: title, initial: initial, withNote: withNote),
);

class _AmountDialog extends StatefulWidget {
  const _AmountDialog({
    required this.title,
    required this.initial,
    required this.withNote,
  });

  final String title;
  final Money? initial;
  final bool withNote;

  @override
  State<_AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<_AmountDialog> {
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(text: widget.initial?.wire ?? '');
    _note = TextEditingController();
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(widget.title),
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
                final money = Money.tryParse(v ?? '');
                return money == null || money.isZero
                    ? l.errorAmountInvalid
                    : null;
              },
            ),
            if (widget.withNote) ...[
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _note,
                maxLength: 200,
                decoration: InputDecoration(labelText: l.feeNote),
              ),
            ],
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
            Navigator.pop(context, (
              amount: Money.tryParse(_amount.text)!,
              note: _note.text,
            ));
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
