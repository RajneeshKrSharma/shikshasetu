import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/validation/email_rule.dart';
import '../../../../../features/auth/presentation/widgets/brand_header.dart';
import '../../../../../features/auth/presentation/widgets/password_field.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/session_bloc.dart';

/// Sign in with the email and password the Principal gave. Accounts are made
/// by the Principal (or the school's administrator), never here.
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
    context.read<SessionBloc>().add(
      SignInSubmitted(_email.text.trim(), _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<SessionBloc, SessionState>(
      failureOf: (s) => s.failure,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxFormWidth,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandHeader(),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.sheet),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: AutofillGroup(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l.loginWelcome,
                                style: context.text.headlineSmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                l.loginSubtitle,
                                style: context.text.bodyMedium!.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                autocorrect: false,
                                enableSuggestions: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: l.fieldEmail,
                                  prefixIcon: const Icon(Icons.mail_outline),
                                ),
                                validator: (v) => const EmailRule().isValid(v)
                                    ? null
                                    : l.errorEmailInvalid,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              PasswordField(
                                controller: _password,
                                label: l.fieldPassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                onSubmitted: (_) => _submit(),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? l.errorPasswordRequired
                                    : null,
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              BlocBuilder<SessionBloc, SessionState>(
                                buildWhen: (a, b) => a.busy != b.busy,
                                builder: (context, state) => FilledButton(
                                  onPressed: state.busy ? null : _submit,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: AppIconSize.md,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l.loginAdminNote,
                            style: context.text.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
