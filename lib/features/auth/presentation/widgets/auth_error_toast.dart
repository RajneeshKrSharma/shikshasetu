import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/context_ext.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'auth_l10n.dart';

/// Shows a sign-in problem as a toast, in the server's own words when it gave
/// some (the phone's own wording otherwise).
class AuthErrorToast extends StatelessWidget {
  const AuthErrorToast({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthState>(
    listenWhen: (a, b) =>
        b.failure != null &&
        (a.failure != b.failure || a.failureMessage != b.failureMessage),
    listener: (context, state) {
      final text = state.failureMessage ?? state.failure!.message(context.l10n);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.absent,
            duration: const Duration(seconds: 5),
            content: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        );
    },
    child: child,
  );
}
