import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/usecases/classes_usecases.dart';
import '../bloc/classes_bloc.dart';
import 'class_level_label.dart';

/// Adds a class, or changes (or removes) [existing].
Future<void> showClassDialog(
  BuildContext context, {
  SchoolClass? existing,
}) async {
  final bloc = context.read<ClassesBloc>();
  final result = await showDialog<Object>(
    context: context,
    builder: (_) => _ClassDialog(existing: existing),
  );
  if (result is SaveClassParams) bloc.add(ClassSaved(result));
  if (result is String) bloc.add(ClassRemoved(result));
}

class _ClassDialog extends StatefulWidget {
  const _ClassDialog({this.existing});

  final SchoolClass? existing;

  @override
  State<_ClassDialog> createState() => _ClassDialogState();
}

class _ClassDialogState extends State<_ClassDialog> {
  late final ValueNotifier<ClassLevel> _level;
  late final TextEditingController _section;

  @override
  void initState() {
    super.initState();
    _level = ValueNotifier(widget.existing?.level ?? ClassLevel.one);
    _section = TextEditingController(text: widget.existing?.section ?? '');
  }

  @override
  void dispose() {
    _level.dispose();
    _section.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.existing != null;
    return AlertDialog(
      title: Text(editing ? l.actionEditClass : l.actionAddClass),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<ClassLevel>(
              valueListenable: _level,
              builder: (context, level, _) =>
                  DropdownButtonFormField<ClassLevel>(
                    initialValue: level,
                    decoration: InputDecoration(labelText: l.stuClassLevel),
                    items: [
                      for (final v in ClassLevel.values)
                        DropdownMenuItem(value: v, child: Text(v.label(l))),
                    ],
                    onChanged: (v) => _level.value = v ?? level,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _section,
              textCapitalization: TextCapitalization.characters,
              maxLength: 5,
              decoration: InputDecoration(labelText: l.stuClassSection),
            ),
          ],
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
          onPressed: () => Navigator.pop(
            context,
            SaveClassParams(
              id: widget.existing?.id,
              level: _level.value,
              section: _section.text,
            ),
          ),
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
