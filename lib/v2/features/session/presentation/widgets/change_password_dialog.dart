import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../features/auth/presentation/widgets/password_field.dart';
import '../bloc/session_bloc.dart';

Future<void> showChangePasswordDialog(BuildContext context) async {
  final bloc = context.read<SessionBloc>();
  final result = await showDialog<(String, String)>(
    context: context,
    builder: (_) => const _ChangePasswordDialog(),
  );
  if (result != null) {
    bloc.add(PasswordChangeRequested(current: result.$1, next: result.$2));
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  late final TextEditingController _current;
  late final TextEditingController _next;
  late final TextEditingController _again;
  late final GlobalKey<FormState> _key;

  static const _minLength = 8;

  @override
  void initState() {
    super.initState();
    _current = TextEditingController();
    _next = TextEditingController();
    _again = TextEditingController();
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _again.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.actionChangePassword),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PasswordField(
                controller: _current,
                label: l.fieldCurrentPassword,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.isEmpty) ? l.errorPasswordRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),
              PasswordField(
                controller: _next,
                label: l.fieldNewPassword,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.length < _minLength)
                    ? l.errorPasswordShort(_minLength)
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              PasswordField(
                controller: _again,
                label: l.fieldConfirmPassword,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    v == _next.text ? null : l.errorPasswordMismatch,
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
            if (_key.currentState!.validate()) {
              Navigator.pop(context, (_current.text, _next.text));
            }
          },
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
