import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/context_ext.dart';
import '../view_failure.dart';
import 'failure_text.dart';

/// Shows a problem as a toast the moment a bloc reports one.
class FailureToast<B extends StateStreamable<S>, S> extends StatelessWidget {
  const FailureToast({super.key, required this.failureOf, required this.child});

  /// Reads the problem out of the bloc's state.
  final ViewFailure? Function(S state) failureOf;
  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<B, S>(
    listenWhen: (a, b) {
      final next = failureOf(b);
      return next != null && next != failureOf(a);
    },
    listener: (context, state) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.absent,
            duration: const Duration(seconds: 5),
            content: Text(
              failureOf(state)!.text(context.l10n),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
    },
    child: child,
  );
}
