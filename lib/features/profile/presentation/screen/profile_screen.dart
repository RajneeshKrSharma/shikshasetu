import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/widgets/sign_out_dialog.dart';
import '../../../staff/presentation/bloc/staff_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/language_card.dart';
import '../widgets/profile_actions_card.dart';
import '../widgets/profile_dialogs.dart';

/// Role-specific profile, with account actions and language.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = context.select((AuthBloc b) => b.state.user);
    if (user == null) return const SizedBox.shrink();
    final myClass = context.select((StaffBloc b) => b.state.classOf(user.id));

    final subtitle = [
      user.employeeId,
      ?user.subject,
      if (myClass != null) '${l.profileClassTeacherOf} $myClass',
      user.email,
    ].join(' · ');

    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (a, b) => b.outcome != null && a.outcome != b.outcome,
      listener: (context, state) {
        final outcome = state.outcome!;
        switch (outcome.kind) {
          case ProfileOutcomeKind.profileUpdated:
            context.read<AuthBloc>().add(AuthUserChanged(outcome.user!));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l.messageProfileUpdated)));
          case ProfileOutcomeKind.passwordChanged:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l.messagePasswordChanged)));
          case ProfileOutcomeKind.emailChangeRequested:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l.messageEmailChangeSent)));
          case ProfileOutcomeKind.wrongPassword:
          case ProfileOutcomeKind.passwordFailed:
          case ProfileOutcomeKind.emailChangeFailed:
            break; // shown inside the dialog
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.profileTitle),
          actions: [
            TextButton(
              onPressed: () => showEditProfileDialog(context, user),
              child: Text(l.actionEditProfile),
            ),
            // Always in reach: no scrolling to sign out.
            IconButton(
              tooltip: l.actionSignOut,
              icon: const Icon(Icons.logout),
              onPressed: () => confirmSignOut(context),
            ),
          ],
        ),
        body: ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            Container(
              padding: AppSpacing.card,
              decoration: BoxDecoration(
                color: context.brand.primaryLight,
                borderRadius: AppRadius.lgAll,
                border: Border.all(color: context.brand.primary),
              ),
              child: Row(
                children: [
                  InitialsAvatar(user.name, radius: 24),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: context.text.titleMedium),
                        Text(subtitle, style: context.text.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ProfileActionsCard(user: user),
            const SizedBox(height: AppSpacing.md),
            const LanguageCard(),
          ],
        ),
      ),
    );
  }
}
