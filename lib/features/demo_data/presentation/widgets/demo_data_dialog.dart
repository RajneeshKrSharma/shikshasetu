import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../di/injector.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/demo_data_cubit.dart';

/// Lets the Principal fill the school with made-up data, or clear it again.
class DemoDataDialog extends StatelessWidget {
  const DemoDataDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => sl<DemoDataCubit>(),
      child: const DemoDataDialog(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<DemoDataCubit, DemoDataState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        final message = switch (state.status) {
          DemoDataStatus.loaded => l.demoDataLoaded,
          DemoDataStatus.removed => l.demoDataRemoved,
          DemoDataStatus.failed => l.demoDataFailed,
          _ => null,
        };
        if (message == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        if (state.status == DemoDataStatus.failed) return;
        // Every screen has to read the school again, so sign in again.
        context.read<AuthBloc>().add(const AuthLogoutRequested());
        Navigator.of(context).popUntil((r) => r.isFirst);
      },
      builder: (context, state) => AlertDialog(
        title: Text(l.demoDataTitle),
        content: state.working
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  heightFactor: 1,
                  child: CircularProgressIndicator(),
                ),
              )
            : Text(l.demoDataBody, style: context.text.bodyMedium),
        actions: [
          TextButton(
            onPressed: state.working ? null : () => Navigator.of(context).pop(),
            child: Text(l.actionCancel),
          ),
          TextButton(
            onPressed: state.working
                ? null
                : () => context.read<DemoDataCubit>().remove(),
            child: Text(l.demoDataRemove),
          ),
          FilledButton(
            onPressed: state.working
                ? null
                : () => context.read<DemoDataCubit>().load(),
            child: Text(l.demoDataLoad),
          ),
        ],
      ),
    );
  }
}
