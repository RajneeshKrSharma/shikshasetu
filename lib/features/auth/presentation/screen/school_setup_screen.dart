import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_error_toast.dart';

/// Right after sign-up: the Principal names the school.
class SchoolSetupScreen extends StatefulWidget {
  const SchoolSetupScreen({super.key});

  @override
  State<SchoolSetupScreen> createState() => _SchoolSetupScreenState();
}

class _SchoolSetupScreenState extends State<SchoolSetupScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _school;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _school = TextEditingController();
  }

  @override
  void dispose() {
    _school.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthSchoolNamed(_school.text));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AuthErrorToast(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxFormWidth,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l.schoolSetupTitle,
                        style: context.text.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l.schoolSetupSubtitle,
                        style: context.text.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      TextFormField(
                        controller: _school,
                        textCapitalization: TextCapitalization.words,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: l.fieldSchoolName,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l.errorRequired
                            : null,
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        buildWhen: (a, b) =>
                            a.failure != b.failure || a.busy != b.busy,
                        builder: (context, state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSpacing.xl),
                            FilledButton(
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
                                  : Text(l.actionContinue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
