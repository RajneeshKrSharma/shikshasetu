import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../../features/profile/presentation/widgets/language_card.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/session_bloc.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/change_name_dialog.dart';
import '../widgets/role_label.dart';
import '../widgets/sign_out_dialog.dart';

/// Who is signed in, with the few things they can change about themselves.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<SessionBloc, SessionState>(
      failureOf: (s) => s.failure,
      child: BlocListener<SessionBloc, SessionState>(
        listenWhen: (a, b) => a.savedCount != b.savedCount,
        listener: (context, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageSaved))),
        child: Scaffold(
          appBar: AppBar(title: Text(l.profileTitle)),
          body: BlocBuilder<SessionBloc, SessionState>(
            builder: (context, state) {
              final account = state.account;
              if (account == null) return const SizedBox.shrink();
              return ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  Center(child: InitialsAvatar(account.name, radius: 36)),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      account.name,
                      style: context.text.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      account.role.label(l),
                      style: context.text.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppCard(
                    child: Column(
                      children: [
                        _Row(l.profileEmail, account.email),
                        _Row(
                          l.profileJoined,
                          formatShortDate(context, account.joinedOn),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const LanguageCard(),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: state.busy
                        ? null
                        : () => showChangeNameDialog(context, account.name),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l.profileChangeName),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: state.busy
                        ? null
                        : () => showChangePasswordDialog(context),
                    icon: const Icon(Icons.lock_outline),
                    label: Text(l.actionChangePassword),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: () => showSignOutDialog(context),
                    icon: const Icon(Icons.logout),
                    label: Text(l.actionSignOut),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      children: [
        Expanded(child: Text(label, style: context.text.bodySmall)),
        Flexible(
          child: Text(
            value,
            style: context.text.bodyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
