import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/fee_account.dart';
import '../bloc/fee_dates_cubit.dart';
import 'fee_labels.dart';

/// Gives one student's fee dates of its own, with the reason.
class ChangeFeeDatesSheet extends StatefulWidget {
  const ChangeFeeDatesSheet({super.key, required this.account});

  final FeeAccount account;

  static Future<void> show(BuildContext context, FeeAccount account) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => BlocProvider(
          create: (_) => sl<FeeDatesCubit>(param1: account.id),
          child: ChangeFeeDatesSheet(account: account),
        ),
      );

  @override
  State<ChangeFeeDatesSheet> createState() => _ChangeFeeDatesSheetState();
}

class _ChangeFeeDatesSheetState extends State<ChangeFeeDatesSheet> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _note;

  /// The two dates picked so far; plain form values, so notifiers hold them.
  late final ValueNotifier<DateTime> _due;
  late final ValueNotifier<DateTime?> _last;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _note = TextEditingController();
    _due = ValueNotifier(widget.account.dueDate);
    _last = ValueNotifier(widget.account.lastDate);
  }

  @override
  void dispose() {
    _note.dispose();
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
    context.read<FeeDatesCubit>().save(
      dueDate: _due.value,
      lastDate: _last.value,
      note: _note.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<FeeDatesCubit, FeeDatesState>(
      listenWhen: (a, b) => !a.saved && b.saved,
      listener: (context, state) => Navigator.of(context).pop(),
      child: SafeArea(
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
                Text(
                  '${l.feeChangeDates} · ${widget.account.head.label(l)}',
                  style: context.text.titleMedium,
                ),
                Text(widget.account.name, style: context.text.bodySmall),
                const SizedBox(height: AppSpacing.lg),
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
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _note,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: l.fieldReason),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? l.errorRequired : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<FeeDatesCubit, FeeDatesState>(
                  buildWhen: (a, b) => a.saving != b.saving,
                  builder: (context, s) => FilledButton(
                    onPressed: s.saving ? null : _save,
                    child: Text(l.actionSave),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
