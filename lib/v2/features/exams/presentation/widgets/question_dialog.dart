import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/exams.dart';
import '../bloc/unit_questions_bloc.dart';
import 'exam_labels.dart';

/// Adds a question to [unitId], or changes (or removes) [existing].
Future<void> showQuestionDialog(
  BuildContext context, {
  required String unitId,
  Question? existing,
}) async {
  final bloc = context.read<UnitQuestionsBloc>();
  final result = await showDialog<Object>(
    context: context,
    builder: (_) => _QuestionDialog(unitId: unitId, existing: existing),
  );
  if (result is QuestionDraft) bloc.add(QuestionSaved(result));
  if (result is String) bloc.add(QuestionRemoved(result));
}

class _QuestionDialog extends StatefulWidget {
  const _QuestionDialog({required this.unitId, this.existing});

  final String unitId;
  final Question? existing;

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  late final TextEditingController _text;
  late final TextEditingController _marks;
  late final ValueNotifier<QuestionType> _type;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    final q = widget.existing;
    _text = TextEditingController(text: q?.text ?? '');
    _marks = TextEditingController(text: q == null ? '' : '${q.marks}');
    _type = ValueNotifier(q?.type ?? QuestionType.short);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _text.dispose();
    _marks.dispose();
    _type.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.existing != null;
    return AlertDialog(
      title: Text(editing ? l.qbQuestionEdit : l.qbQuestionAdd),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _text,
                maxLength: 1000,
                maxLines: 4,
                minLines: 2,
                decoration: InputDecoration(labelText: l.qbQuestionText),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              ValueListenableBuilder<QuestionType>(
                valueListenable: _type,
                builder: (context, t, _) =>
                    DropdownButtonFormField<QuestionType>(
                      initialValue: t,
                      decoration: InputDecoration(labelText: l.qbQuestionType),
                      items: [
                        for (final v in QuestionType.values)
                          DropdownMenuItem(value: v, child: Text(v.label(l))),
                      ],
                      onChanged: (v) => _type.value = v ?? t,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _marks,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.qbQuestionMarks),
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
              QuestionDraft(
                id: widget.existing?.id,
                unitId: widget.unitId,
                text: _text.text,
                marks: int.parse(_marks.text),
                type: _type.value,
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
