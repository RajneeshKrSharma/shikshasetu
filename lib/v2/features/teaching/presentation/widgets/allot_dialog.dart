import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/teaching.dart';
import '../bloc/allotments_bloc.dart';

/// Gives a class to a teacher for a subject.
Future<void> showAllotDialog(BuildContext context) async {
  final bloc = context.read<AllotmentsBloc>();
  final state = bloc.state;
  final draft = await showDialog<AllotmentDraft>(
    context: context,
    builder: (_) => _AllotDialog(state: state),
  );
  if (draft != null) bloc.add(ClassAllotted(draft));
}

class _AllotDialog extends StatefulWidget {
  const _AllotDialog({required this.state});

  final AllotmentsState state;

  @override
  State<_AllotDialog> createState() => _AllotDialogState();
}

class _AllotDialogState extends State<_AllotDialog> {
  late final TextEditingController _subject;
  late final ValueNotifier<String?> _teacher;
  late final ValueNotifier<String?> _class;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _subject = TextEditingController();
    _teacher = ValueNotifier(null);
    _class = ValueNotifier(null);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _subject.dispose();
    _teacher.dispose();
    _class.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? required(Object? v) =>
        (v == null || (v is String && v.trim().isEmpty))
        ? l.errorRequired
        : null;
    return AlertDialog(
      title: Text(l.tchAllot),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: _teacher,
                builder: (context, id, _) => DropdownButtonFormField<String>(
                  initialValue: id,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l.tchTeacher),
                  items: [
                    for (final t in widget.state.teachers)
                      DropdownMenuItem(value: t.id, child: Text(t.name)),
                  ],
                  onChanged: (v) => _teacher.value = v,
                  validator: required,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<String?>(
                valueListenable: _class,
                builder: (context, id, _) => DropdownButtonFormField<String>(
                  initialValue: id,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l.fieldClass),
                  items: [
                    for (final c in widget.state.classes)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (v) => _class.value = v,
                  validator: required,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _subject,
                textCapitalization: TextCapitalization.words,
                maxLength: 60,
                decoration: InputDecoration(labelText: l.tchSubject),
                validator: required,
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
            Navigator.pop(
              context,
              AllotmentDraft(
                teacherId: _teacher.value!,
                classId: _class.value!,
                subject: _subject.text,
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
