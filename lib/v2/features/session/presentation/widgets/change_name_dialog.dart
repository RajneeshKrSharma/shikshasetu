import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../bloc/session_bloc.dart';

Future<void> showChangeNameDialog(BuildContext context, String current) async {
  final bloc = context.read<SessionBloc>();
  final name = await showDialog<String>(
    context: context,
    builder: (_) => _ChangeNameDialog(current: current),
  );
  if (name != null && name != current) bloc.add(NameChanged(name));
}

class _ChangeNameDialog extends StatefulWidget {
  const _ChangeNameDialog({required this.current});

  final String current;

  @override
  State<_ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<_ChangeNameDialog> {
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
      title: Text(l.profileChangeName),
      content: Form(
        key: _key,
        child: TextFormField(
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l.fieldFullName),
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
