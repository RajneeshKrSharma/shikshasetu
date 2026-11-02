import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../domain/entities/school.dart';
import '../../domain/usecases/school_usecases.dart';
import '../bloc/holidays_bloc.dart';

/// Adds a holiday, or changes (or removes) [existing].
Future<void> showHolidayDialog(
  BuildContext context, {
  Holiday? existing,
}) async {
  final bloc = context.read<HolidaysBloc>();
  final result = await showDialog<Object>(
    context: context,
    builder: (_) => _HolidayDialog(existing: existing),
  );
  if (result is HolidayDraft) bloc.add(HolidaySaved(result));
  if (result is String) bloc.add(HolidayRemoved(result));
}

class _HolidayDialog extends StatefulWidget {
  const _HolidayDialog({this.existing});

  final Holiday? existing;

  @override
  State<_HolidayDialog> createState() => _HolidayDialogState();
}

class _HolidayDialogState extends State<_HolidayDialog> {
  late final TextEditingController _name;
  late final ValueNotifier<DateTime> _first;
  late final ValueNotifier<DateTime> _last;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    final h = widget.existing;
    _name = TextEditingController(text: h?.name ?? '');
    _first = ValueNotifier(h?.startsOn ?? day);
    _last = ValueNotifier(h?.endsOn ?? day);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  Future<void> _pick(ValueNotifier<DateTime> which) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: which.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    which.value = picked;
    // Keep the last day from falling before the first.
    if (_last.value.isBefore(_first.value)) _last.value = _first.value;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.existing != null;
    return AlertDialog(
      title: Text(editing ? l.holidayEdit : l.holidayAdd),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: !editing,
                textCapitalization: TextCapitalization.words,
                maxLength: 120,
                decoration: InputDecoration(labelText: l.fieldHolidayName),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              ValueListenableBuilder<DateTime>(
                valueListenable: _first,
                builder: (context, day, _) => PickerField(
                  label: l.fieldFirstDay,
                  value: formatShortDate(context, day),
                  onTap: () => _pick(_first),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<DateTime>(
                valueListenable: _last,
                builder: (context, day, _) => PickerField(
                  label: l.fieldLastDay,
                  value: formatShortDate(context, day),
                  onTap: () => _pick(_last),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (editing)
          TextButton(
            onPressed: () => Navigator.pop(context, widget.existing!.id),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              minimumSize: AppSizes.dialogButton,
            ),
            child: Text(l.actionRemove),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_key.currentState!.validate()) return;
            Navigator.pop(
              context,
              HolidayDraft(
                id: widget.existing?.id,
                name: _name.text,
                startsOn: _first.value,
                endsOn: _last.value,
              ),
            );
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
