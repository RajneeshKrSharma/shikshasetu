import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

/// The one "Sign out?" question, the same for the Principal and for every
/// teacher. Signs out only when the user says yes.
Future<void> confirmSignOut(BuildContext context) async {
  final l = context.l10n;
  final bloc = context.read<AuthBloc>();
  final yes = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      icon: const Icon(Icons.logout),
      title: Text(l.dialogSignOutTitle),
      content: Text(l.dialogSignOutBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(false),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialog).pop(true),
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSignOut),
        ),
      ],
    ),
  );
  if (yes == true) bloc.add(const AuthLogoutRequested());
}
