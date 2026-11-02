import '../../../../l10n/class_label.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_structure_item.dart';
import 'fee_labels.dart';

/// Sets what a class pays for one kind of fee, and its dates. Closes with the
/// [FeeStructureItem] to save, or nothing if it was dismissed.
class FeeHeadSheet extends StatefulWidget {
  const FeeHeadSheet({
    super.key,
    required this.className,
    required this.head,
    this.existing,
  });

  final String className;
  final FeeHead head;
  final FeeStructureItem? existing;

  static Future<FeeStructureItem?> show(
    BuildContext context, {
    required String className,
    required FeeHead head,
    FeeStructureItem? existing,
  }) => showModalBottomSheet<FeeStructureItem>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        FeeHeadSheet(className: className, head: head, existing: existing),
  );

  @override
  State<FeeHeadSheet> createState() => _FeeHeadSheetState();
}

class _FeeHeadSheetState extends State<FeeHeadSheet> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _amount;
  late final ValueNotifier<DateTime> _due;
  late final ValueNotifier<DateTime?> _last;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _formKey = GlobalKey<FormState>();
    _amount = TextEditingController(text: e == null ? '' : '${e.amount}');
    _due = ValueNotifier(
      e?.dueDate ?? DateTime.now().add(const Duration(days: 30)),
    );
    _last = ValueNotifier(e?.lastDate);
  }

  @override
  void dispose() {
    _amount.dispose();
    _due.dispose();
    _last.dispose();
    super.dispose();
  }

  Future<DateTime?> _pick(DateTime initial) => showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
  );

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      FeeStructureItem(
        className: widget.className,
        head: widget.head,
        amount: int.parse(_amount.text.trim()),
        dueDate: _due.value,
        lastDate: _last.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.head.label(l), style: context.text.titleMedium),
              Text(
                l.classLabel(widget.className),
                style: context.text.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l.feeSetupAmount,
                  prefixText: '₹ ',
                ),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  return n == null || n <= 0 ? l.errorAmountInvalid : null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<DateTime>(
                valueListenable: _due,
                builder: (context, due, _) => PickerField(
                  label: l.feeSetupDue,
                  prefixIcon: Icons.event,
                  value: formatShortDate(context, due),
                  onTap: () async {
                    final d = await _pick(due);
                    if (d != null) _due.value = d;
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<DateTime?>(
                valueListenable: _last,
                builder: (context, last, _) => PickerField(
                  label: l.feeSetupLast,
                  prefixIcon: Icons.event_busy_outlined,
                  value: last == null ? null : formatShortDate(context, last),
                  onTap: () async {
                    final d = await _pick(last ?? _due.value);
                    if (d != null) _last.value = d;
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: _save, child: Text(l.actionSave)),
            ],
          ),
        ),
      ),
    );
  }
}
