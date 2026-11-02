import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../bloc/session_bloc.dart';

Future<void> showSignOutDialog(BuildContext context) async {
  final l = context.l10n;
  final bloc = context.read<SessionBloc>();
  final yes = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.dialogSignOutTitle),
      content: Text(l.dialogSignOutBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
          child: Text(l.actionSignOut),
        ),
      ],
    ),
  );
  if (yes ?? false) bloc.add(const SignOutRequested());
}
