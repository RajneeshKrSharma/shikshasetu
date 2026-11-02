import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/view_failure.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../bloc/grants_bloc.dart';

/// Switches for what one Vice Principal may do; giving one asks why.
class PermissionsSection extends StatelessWidget {
  const PermissionsSection({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<GrantsBloc>(param1: userId)..add(const GrantsStarted()),
    child: const _View(),
  );
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<GrantsBloc, GrantsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<GrantsBloc, GrantsState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(l.perTitle),
            if (state.status == ViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (state.status == ViewStatus.failed)
              OutlinedButton.icon(
                onPressed: () =>
                    context.read<GrantsBloc>().add(const GrantsStarted()),
                icon: const Icon(Icons.refresh),
                label: Text(l.actionRetry),
              ),
            for (final c in state.capabilities)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(c.label),
                subtitle: state.grantOf(c.code) == null
                    ? null
                    : Text(l.perReasonShown(state.grantOf(c.code)!.reason)),
                value: state.grantOf(c.code) != null,
                onChanged: state.busy
                    ? null
                    : (on) => on
                          ? _give(context, c.code, c.label)
                          : _takeBack(
                              context,
                              state.grantOf(c.code)!.id,
                              c.label,
                            ),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Future<void> _give(BuildContext context, String code, String label) async {
    final l = context.l10n;
    final bloc = context.read<GrantsBloc>();
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 200,
          decoration: InputDecoration(labelText: l.perReason),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l.perGive),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason != null) bloc.add(PermissionGiven(code, reason));
  }

  Future<void> _takeBack(
    BuildContext context,
    String grantId,
    String label,
  ) async {
    final l = context.l10n;
    final bloc = context.read<GrantsBloc>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(l.perTakeBackAsk(label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.perTakeBack),
          ),
        ],
      ),
    );
    if (ok == true) bloc.add(PermissionTakenBack(grantId));
  }
}
