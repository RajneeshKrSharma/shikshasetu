import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../domain/entities/member.dart';
import '../bloc/member_editor_bloc.dart';
import '../widgets/member_kind_labels.dart';

/// Registers a person with an email login, or changes [existing].
class MemberFormScreen extends StatelessWidget {
  const MemberFormScreen({super.key, required this.kind, this.existing});

  final MemberKind kind;
  final Member? existing;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<MemberEditorBloc>(param1: kind),
    child: _Form(kind: kind, existing: existing),
  );
}

class _Form extends StatefulWidget {
  const _Form({required this.kind, this.existing});

  final MemberKind kind;
  final Member? existing;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _title;
  late final ValueNotifier<bool> _hidden;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    _name = TextEditingController(text: m?.name ?? '');
    _email = TextEditingController(text: m?.email ?? '');
    _password = TextEditingController();
    _title = TextEditingController(text: m?.jobTitle ?? '');
    _hidden = ValueNotifier(true);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _title.dispose();
    _hidden.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.existing != null;
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l.errorRequired : null;
    return FailureToast<MemberEditorBloc, MemberEditorState>(
      failureOf: (s) => s.failure,
      child: BlocConsumer<MemberEditorBloc, MemberEditorState>(
        listenWhen: (a, b) => b.saved != null,
        listener: (context, _) => Navigator.of(context).pop(true),
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              editing ? widget.kind.editLabel(l) : widget.kind.addLabel(l),
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxFormWidth,
              ),
              child: SingleChildScrollView(
                padding: AppSpacing.page,
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: l.fieldFullName),
                        validator: required,
                      ),
                      if (widget.kind.hasJobTitle) ...[
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          controller: _title,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(labelText: l.memJobTitle),
                          validator: required,
                        ),
                      ],
                      if (!editing) ...[
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: l.fieldLoginEmail,
                            helperText: l.memEmailHint,
                          ),
                          validator: (v) => (v == null || !v.contains('@'))
                              ? l.errorEmailInvalid
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ValueListenableBuilder<bool>(
                          valueListenable: _hidden,
                          builder: (context, hidden, _) => TextFormField(
                            controller: _password,
                            obscureText: hidden,
                            decoration: InputDecoration(
                              labelText: l.fieldTempPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidden
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => _hidden.value = !hidden,
                              ),
                            ),
                            validator: required,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton(
                        onPressed: state.busy ? null : () => _submit(context),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            AppSizes.buttonHeight,
                          ),
                        ),
                        child: state.busy
                            ? const SizedBox.square(
                                dimension: AppIconSize.sm,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l.actionSave),
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

  void _submit(BuildContext context) {
    if (!_key.currentState!.validate()) return;
    context.read<MemberEditorBloc>().add(
      MemberSubmitted(
        MemberDraft(
          id: widget.existing?.id,
          name: _name.text,
          email: _email.text,
          password: _password.text,
          jobTitle: _title.text,
        ),
      ),
    );
  }
}
