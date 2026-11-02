import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../domain/entities/exams.dart';
import '../bloc/exams_bloc.dart';
import 'exam_labels.dart';

/// Schedules an exam, or changes (or removes) [existing].
Future<void> showExamDialog(BuildContext context, {Exam? existing}) async {
  final bloc = context.read<ExamsBloc>();
  final result = await showDialog<Object>(
    context: context,
    builder: (_) => _ExamDialog(
      existing: existing,
      classes: [for (final c in bloc.state.classes) (id: c.id, name: c.name)],
    ),
  );
  if (result is ExamDraft) bloc.add(ExamSaved(result));
  if (result is String) bloc.add(ExamRemoved(result));
}

class _ExamDialog extends StatefulWidget {
  const _ExamDialog({required this.classes, this.existing});

  final Exam? existing;
  final List<({String id, String name})> classes;

  @override
  State<_ExamDialog> createState() => _ExamDialogState();
}

class _ExamDialogState extends State<_ExamDialog> {
  late final TextEditingController _subject;
  late final TextEditingController _marks;
  late final ValueNotifier<ExamType> _type;
  late final ValueNotifier<String?> _class;
  late final ValueNotifier<DateTime> _day;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final now = DateTime.now();
    _subject = TextEditingController(text: e?.subject ?? '');
    _marks = TextEditingController(text: e == null ? '' : '${e.maxMarks}');
    _type = ValueNotifier(e?.type ?? ExamType.unitTest);
    _class = ValueNotifier(e?.classId);
    _day = ValueNotifier(e?.heldOn ?? DateTime(now.year, now.month, now.day));
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _subject.dispose();
    _marks.dispose();
    _type.dispose();
    _class.dispose();
    _day.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.existing != null;
    String? required(Object? v) =>
        (v == null || (v is String && v.trim().isEmpty))
        ? l.errorRequired
        : null;
    return AlertDialog(
      title: Text(editing ? l.exmEdit : l.exmSchedule),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<ExamType>(
                valueListenable: _type,
                builder: (context, t, _) => DropdownButtonFormField<ExamType>(
                  initialValue: t,
                  decoration: InputDecoration(labelText: l.exmType),
                  items: [
                    for (final v in ExamType.values)
                      DropdownMenuItem(value: v, child: Text(v.label(l))),
                  ],
                  onChanged: (v) => _type.value = v ?? t,
                ),
              ),
              if (!editing) ...[
                const SizedBox(height: AppSpacing.md),
                ValueListenableBuilder<String?>(
                  valueListenable: _class,
                  builder: (context, id, _) => DropdownButtonFormField<String>(
                    initialValue: id,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.fieldClass),
                    items: [
                      for (final c in widget.classes)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: (v) => _class.value = v,
                    validator: required,
                  ),
                ),
                TextFormField(
                  controller: _subject,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 60,
                  decoration: InputDecoration(labelText: l.exmSubject),
                  validator: required,
                ),
              ],
              ValueListenableBuilder<DateTime>(
                valueListenable: _day,
                builder: (context, d, _) => PickerField(
                  label: l.exmHeldOn,
                  value: formatShortDate(context, d),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: d,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) _day.value = picked;
                  },
                ),
              ),
              TextFormField(
                controller: _marks,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.exmMaxMarks),
                validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0
                    ? l.errorAmountInvalid
                    : null,
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
              ExamDraft(
                id: widget.existing?.id,
                type: _type.value,
                classId: _class.value ?? '',
                subject: _subject.text,
                heldOn: _day.value,
                maxMarks: int.parse(_marks.text),
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
