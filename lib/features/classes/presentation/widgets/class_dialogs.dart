import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/context_ext.dart';

/// Asks for a class name; returns it, or null if cancelled.
Future<String?> showClassNameDialog(
  BuildContext context, {
  String? existing,
  required bool Function(String name) isTaken,
}) => showDialog<String>(
  context: context,
  builder: (_) => _ClassNameDialog(existing: existing, isTaken: isTaken),
);

/// Asks the Principal to confirm deleting a class.
Future<bool> confirmDeleteClass(
  BuildContext context, {
  required String name,
  required int studentCount,
}) async {
  final l = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.dialogDeleteClassTitle(name)),
      content: Text(l.dialogDeleteClassBody(studentCount)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.absent),
          child: Text(l.actionDelete),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

class _ClassNameDialog extends StatefulWidget {
  const _ClassNameDialog({required this.existing, required this.isTaken});

  final String? existing;
  final bool Function(String) isTaken;

  @override
  State<_ClassNameDialog> createState() => _ClassNameDialogState();
}

class _ClassNameDialogState extends State<_ClassNameDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _name = TextEditingController(text: widget.existing);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_name.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(
        widget.existing == null ? l.actionAddClass : l.actionEditClass,
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _name,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: l.fieldClassName,
            hintText: l.hintClassName,
          ),
          validator: (v) {
            final n = (v ?? '').trim();
            if (n.isEmpty) return l.errorRequired;
            if (widget.isTaken(n)) return l.errorClassExists;
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          onPressed: _submit,
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
