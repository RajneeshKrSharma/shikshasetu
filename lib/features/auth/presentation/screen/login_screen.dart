import '../../../../core/theme/app_colors.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/validation/email_rule.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_error_toast.dart';
import '../widgets/brand_header.dart';
import '../widgets/login_banner.dart';
import '../widgets/password_field.dart';

/// The first screen: sign in with email and password. Accounts are created by
/// the school's administrator, not here.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      AuthLoginSubmitted(_email.text.trim(), _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = _LoginContent(
      formKey: _formKey,
      email: _email,
      password: _password,
      onSubmit: _submit,
    );
    return AuthErrorToast(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, box) {
            // The screen's own height, not the space left above the keyboard,
            // so the banner does not jump when the keyboard opens.
            final screenHeight = MediaQuery.sizeOf(context).height;
            final sideBySide =
                box.maxWidth >= _sideBySideWidth &&
                box.maxWidth > screenHeight * 1.15;
            return sideBySide
                ? _SideBySide(screenHeight: screenHeight, form: form)
                : _Stacked(
                    maxWidth: box.maxWidth,
                    height: box.maxHeight,
                    screenHeight: screenHeight,
                    form: form,
                  );
          },
        ),
      ),
    );
  }

  /// From this width, when also wider than tall (a tablet, or a phone on its
  /// side), the banner and the form sit next to each other.
  static const _sideBySideWidth = 640.0;
}

/// Phones and tablets held upright: the banner on top, the form below it.
class _Stacked extends StatelessWidget {
  const _Stacked({
    required this.maxWidth,
    required this.height,
    required this.screenHeight,
    required this.form,
  });

  static const _maxBannerWidth = 520.0;

  final double maxWidth;
  final double height;
  final double screenHeight;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    // On a screen wider than the picture it becomes a rounded card.
    final card = maxWidth > _maxBannerWidth;
    final top = card ? MediaQuery.paddingOf(context).top + AppSpacing.lg : 0.0;
    final fit = BannerFit(
      width: math.min(maxWidth, _maxBannerWidth),
      maxHeight: screenHeight * 0.38,
    );
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Stack(
          children: [
            Positioned(
              top: top,
              left: 0,
              right: 0,
              child: Center(
                child: LoginBanner(fit: fit, rounded: card),
              ),
            ),
            SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    top + fit.contentTop,
                    AppSpacing.xl,
                    AppSpacing.xxl,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.maxFormWidth,
                    ),
                    child: form,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wide screens held sideways: the banner on the left, the form on the right.
class _SideBySide extends StatelessWidget {
  const _SideBySide({required this.screenHeight, required this.form});

  final double screenHeight;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 11,
          child: SafeArea(
            right: false,
            child: LayoutBuilder(
              builder: (context, pane) => Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: LoginBanner(
                    rounded: true,
                    fit: BannerFit(
                      width: math.min(pane.maxWidth - AppSpacing.xl * 2, 560),
                      maxHeight: pane.maxHeight - AppSpacing.xl * 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: SafeArea(
            left: false,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.maxFormWidth,
                  ),
                  child: form,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The logo and name, the sign-in card and the note about accounts.
class _LoginContent extends StatelessWidget {
  const _LoginContent({
    required this.formKey,
    required this.email,
    required this.password,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController password;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BrandHeader(),
        const SizedBox(height: AppSpacing.xl),
        _SignInCard(
          formKey: formKey,
          email: email,
          password: password,
          onSubmit: onSubmit,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 18, color: AppColors.textMuted),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l.loginAdminNote,
                style: context.text.bodySmall!.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The form: a heading, the two fields and the Sign In button, in a bordered
/// card. The button stays off until the email looks right and a password is
/// typed.
class _SignInCard extends StatelessWidget {
  const _SignInCard({
    required this.formKey,
    required this.email,
    required this.password,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController password;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sheet),
        border: Border.all(color: AppColors.border),
      ),
      child: AutofillGroup(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.loginWelcome, style: context.text.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.loginSubtitle,
                style: context.text.bodyMedium!.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                enableSuggestions: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: l.fieldEmail,
                  prefixIcon: const Icon(Icons.mail_outline),
                ),
                validator: (v) =>
                    const EmailRule().isValid(v) ? null : l.errorEmailInvalid,
              ),
              const SizedBox(height: AppSpacing.lg),
              PasswordField(
                controller: password,
                label: l.fieldPassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onSubmitted: (_) => onSubmit(),
                validator: (v) =>
                    (v == null || v.isEmpty) ? l.errorPasswordRequired : null,
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (a, b) => a.busy != b.busy,
                builder: (context, state) => ListenableBuilder(
                  listenable: Listenable.merge([email, password]),
                  builder: (context, _) {
                    final ready =
                        const EmailRule().isValid(email.text) &&
                        password.text.isNotEmpty;
                    return FilledButton(
                      onPressed: ready && !state.busy ? onSubmit : null,
                      child: state.busy
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: context.brand.onPrimary,
                              ),
                            )
                          : Text(l.actionSignIn),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
