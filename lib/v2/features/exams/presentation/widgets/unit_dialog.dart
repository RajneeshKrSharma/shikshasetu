import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/exams.dart';
import '../bloc/question_bank_bloc.dart';

/// Adds a unit, or renames (or removes) [existing].
Future<void> showUnitDialog(
  BuildContext context, {
  QuestionUnit? existing,
}) async {
  final bloc = context.read<QuestionBankBloc>();
  final result = await showDialog<Object>(
    context: context,
    builder: (_) => _UnitDialog(
      existing: existing,
      classes: [for (final c in bloc.state.classes) (id: c.id, name: c.name)],
    ),
  );
  if (result is UnitDraft) bloc.add(UnitSaved(result));
  if (result is String) bloc.add(UnitRemoved(result));
}

class _UnitDialog extends StatefulWidget {
  const _UnitDialog({required this.classes, this.existing});

  final QuestionUnit? existing;
  final List<({String id, String name})> classes;

  @override
  State<_UnitDialog> createState() => _UnitDialogState();
}

class _UnitDialogState extends State<_UnitDialog> {
  late final TextEditingController _name;
  late final TextEditingController _subject;
  late final ValueNotifier<String?> _class;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _subject = TextEditingController(text: widget.existing?.subject ?? '');
    _class = ValueNotifier(widget.existing?.classId);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    _subject.dispose();
    _class.dispose();
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
      title: Text(editing ? l.qbUnitEdit : l.qbUnitAdd),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!editing) ...[
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
                  maxLength: 60,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l.exmSubject),
                  validator: required,
                ),
              ],
              TextFormField(
                controller: _name,
                maxLength: 80,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l.qbUnitName),
                validator: required,
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
              UnitDraft(
                id: widget.existing?.id,
                classId: _class.value ?? '',
                subject: _subject.text,
                name: _name.text,
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
