import '../../../../core/validation/email_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../auth/presentation/widgets/auth_l10n.dart';
import '../../../auth/presentation/widgets/password_field.dart';
import '../bloc/profile_bloc.dart';

/// Shows the edit-profile dialog, sharing the screen's [ProfileBloc].
Future<void> showEditProfileDialog(BuildContext context, AppUser user) {
  final bloc = context.read<ProfileBloc>();
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: _EditProfileDialog(user: user),
    ),
  );
}

/// Shows the change-password dialog, sharing the screen's [ProfileBloc].
Future<void> showChangePasswordDialog(BuildContext context, String userId) {
  final bloc = context.read<ProfileBloc>();
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: _ChangePasswordDialog(userId: userId),
    ),
  );
}

/// Shows the change-email dialog, sharing the screen's [ProfileBloc].
Future<void> showChangeEmailDialog(BuildContext context) {
  final bloc = context.read<ProfileBloc>();
  return showDialog<void>(
    context: context,
    builder: (_) =>
        BlocProvider.value(value: bloc, child: const _ChangeEmailDialog()),
  );
}

class _ChangeEmailDialog extends StatefulWidget {
  const _ChangeEmailDialog();

  @override
  State<_ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<_ChangeEmailDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileBloc>().add(
      EmailChangeSubmitted(password: _password.text, newEmail: _email.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (a, b) => a.outcome != b.outcome && b.outcome != null,
      listener: (context, state) {
        switch (state.outcome!.kind) {
          case ProfileOutcomeKind.emailChangeRequested:
            Navigator.of(context).pop();
          case ProfileOutcomeKind.emailChangeFailed:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.outcome!.failure!.message(l))),
            );
          case ProfileOutcomeKind.profileUpdated:
          case ProfileOutcomeKind.passwordChanged:
          case ProfileOutcomeKind.wrongPassword:
          case ProfileOutcomeKind.passwordFailed:
            break;
        }
      },
      child: AlertDialog(
        title: Text(l.actionChangeEmail),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.changeEmailHint, style: context.text.bodySmall),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: l.fieldNewEmail),
                  validator: (v) => (v == null || !const EmailRule().isValid(v))
                      ? l.errorEmailInvalid
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                PasswordField(
                  controller: _password,
                  label: l.fieldCurrentPassword,
                  validator: (v) => (v ?? '').isEmpty ? l.errorRequired : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.actionCancel),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (a, b) => a.busy != b.busy,
            builder: (context, state) => FilledButton(
              style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
              onPressed: state.busy ? null : _save,
              child: Text(l.actionSend),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.user});

  final AppUser user;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _name;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _name = TextEditingController(text: widget.user.name);
    _phone = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileBloc>().add(
      ProfileEdited(
        userId: widget.user.id,
        name: _name.text,
        phone: _phone.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (a, b) =>
          b.outcome?.kind == ProfileOutcomeKind.profileUpdated &&
          a.outcome != b.outcome,
      listener: (context, state) => Navigator.of(context).pop(),
      child: AlertDialog(
        title: Text(l.actionEditProfile),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l.fieldFullName),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: l.fieldPhone),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.actionCancel),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (a, b) => a.busy != b.busy,
            builder: (context, state) => FilledButton(
              style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
              onPressed: state.busy ? null : _save,
              child: Text(l.actionSave),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog({required this.userId});

  final String userId;

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _current;
  late final TextEditingController _next;
  late final TextEditingController _confirm;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _current = TextEditingController();
    _next = TextEditingController();
    _confirm = TextEditingController();
  }

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileBloc>().add(
      PasswordChangeSubmitted(
        userId: widget.userId,
        current: _current.text,
        next: _next.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (a, b) => a.outcome != b.outcome && b.outcome != null,
      listener: (context, state) {
        switch (state.outcome!.kind) {
          case ProfileOutcomeKind.passwordChanged:
            Navigator.of(context).pop();
          case ProfileOutcomeKind.wrongPassword:
            _formKey.currentState!.validate();
          case ProfileOutcomeKind.passwordFailed:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.outcome!.failure!.message(l))),
            );
          case ProfileOutcomeKind.profileUpdated:
          case ProfileOutcomeKind.emailChangeRequested:
          case ProfileOutcomeKind.emailChangeFailed:
            break;
        }
      },
      child: AlertDialog(
        title: Text(l.actionChangePassword),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PasswordField(
                  controller: _current,
                  label: l.fieldCurrentPassword,
                  validator: (v) {
                    final wrong =
                        context.read<ProfileBloc>().state.outcome?.kind ==
                        ProfileOutcomeKind.wrongPassword;
                    if (wrong) return l.errorWrongCurrentPassword;
                    return (v ?? '').isEmpty ? l.errorRequired : null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                PasswordField(
                  controller: _next,
                  label: l.fieldNewPassword,
                  validator: (v) => (v ?? '').length < kMinPasswordLength
                      ? l.errorPasswordShort(kMinPasswordLength)
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                PasswordField(
                  controller: _confirm,
                  label: l.fieldConfirmPassword,
                  validator: (v) =>
                      v == _next.text ? null : l.errorPasswordMismatch,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.actionCancel),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (a, b) => a.busy != b.busy,
            builder: (context, state) => FilledButton(
              style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
              onPressed: state.busy ? null : _save,
              child: Text(l.actionSave),
            ),
          ),
        ],
      ),
    );
  }
}
