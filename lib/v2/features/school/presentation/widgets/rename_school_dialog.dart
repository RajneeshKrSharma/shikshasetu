import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../bloc/school_bloc.dart';

Future<void> showRenameSchoolDialog(
  BuildContext context,
  String current,
) async {
  final bloc = context.read<SchoolBloc>();
  final name = await showDialog<String>(
    context: context,
    builder: (_) => _RenameDialog(current: current),
  );
  if (name != null && name != current) bloc.add(SchoolRenamed(name));
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.current});

  final String current;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _name;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.current);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.fieldSchoolName),
      content: Form(
        key: _key,
        child: TextFormField(
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          maxLength: 120,
          decoration: InputDecoration(labelText: l.fieldSchoolName),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? l.errorRequired : null,
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
            if (_key.currentState!.validate()) {
              Navigator.pop(context, _name.text.trim());
            }
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
