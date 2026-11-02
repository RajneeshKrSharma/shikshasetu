import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/member.dart';
import '../bloc/member_detail_bloc.dart';
import 'member_form_screen.dart';
import '../widgets/member_kind_labels.dart';

/// One person: their details, and what the viewer may do about them.
class MemberDetailScreen extends StatelessWidget {
  const MemberDetailScreen({
    super.key,
    required this.kind,
    required this.memberId,
    this.extra,
  });

  final MemberKind kind;
  final String memberId;

  /// More that belongs under the details (a Vice Principal's permissions).
  final Widget Function(BuildContext, Member)? extra;

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) => sl<MemberDetailBloc>(
        param1: (kind: kind, id: memberId),
        param2: account,
      )..add(const MemberDetailStarted()),
      child: _View(kind: kind, extra: extra),
    );
  }
}

class _View extends StatelessWidget {
  const _View({required this.kind, this.extra});

  final MemberKind kind;
  final Widget Function(BuildContext, Member)? extra;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<MemberDetailBloc, MemberDetailState>(
      failureOf: (s) => s.failure,
      child: BlocConsumer<MemberDetailBloc, MemberDetailState>(
        listenWhen: (a, b) => b.passwordChanged > a.passwordChanged,
        listener: (context, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.memPasswordChanged))),
        builder: (context, state) {
          final m = state.member;
          return PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) Navigator.of(context).pop(state.changedCount > 0);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(m?.name ?? kind.title(l)),
                actions: [
                  if (state.canManage && m != null && m.isActive)
                    IconButton(
                      tooltip: kind.editLabel(l),
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _edit(context, m),
                    ),
                ],
              ),
              body: AsyncBody(
                status: state.status,
                failure: state.failure,
                onRetry: () => context.read<MemberDetailBloc>().add(
                  const MemberDetailStarted(),
                ),
                builder: (context) => ListView(
                  padding: AppSpacing.page,
                  children: [
                    Center(child: InitialsAvatar(m!.name, radius: 36)),
                    const SizedBox(height: AppSpacing.lg),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.email, style: context.text.bodyMedium),
                          if (m.jobTitle.isNotEmpty)
                            Text(m.jobTitle, style: context.text.bodyMedium),
                          if (!m.isActive)
                            Text(l.stuRemoved, style: context.text.labelLarge),
                        ],
                      ),
                    ),
                    if (state.canManage) ...[
                      const SizedBox(height: AppSpacing.lg),
                      if (m.isActive)
                        OutlinedButton.icon(
                          onPressed: state.busy
                              ? null
                              : () => _password(context),
                          icon: const Icon(Icons.lock_reset),
                          label: Text(l.memResetPassword),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: state.busy
                            ? null
                            : () => _toggle(context, m),
                        icon: Icon(
                          m.isActive
                              ? Icons.person_remove_outlined
                              : Icons.restore,
                        ),
                        label: Text(m.isActive ? l.memRemove : l.memRestore),
                      ),
                    ],
                    if (extra != null && m.isActive) ...[
                      const SizedBox(height: AppSpacing.lg),
                      extra!(context, m),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _edit(BuildContext context, Member m) async {
    final bloc = context.read<MemberDetailBloc>();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MemberFormScreen(kind: kind, existing: m),
      ),
    );
    if (saved == true) bloc.add(const MemberDetailStarted());
  }

  Future<void> _toggle(BuildContext context, Member m) async {
    final l = context.l10n;
    final bloc = context.read<MemberDetailBloc>();
    if (m.isActive) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(l.memRemoveAsk(m.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.actionCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.memRemove),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    bloc.add(const MemberActiveToggled());
  }

  Future<void> _password(BuildContext context) async {
    final l = context.l10n;
    final bloc = context.read<MemberDetailBloc>();
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.memResetPassword),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(labelText: l.fieldNewPassword),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l.actionSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && result.isNotEmpty) {
      bloc.add(MemberPasswordReset(result));
    }
  }
}
