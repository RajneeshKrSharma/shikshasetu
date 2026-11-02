import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/entities/student.dart';
import '../bloc/student_editor_bloc.dart';

/// Registers a student, or changes [existing].
class StudentFormScreen extends StatelessWidget {
  const StudentFormScreen({super.key, required this.classes, this.existing});

  final List<SchoolClass> classes;
  final Student? existing;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<StudentEditorBloc>(),
    child: _StudentForm(classes: classes, existing: existing),
  );
}

class _StudentForm extends StatefulWidget {
  const _StudentForm({required this.classes, this.existing});

  final List<SchoolClass> classes;
  final Student? existing;

  @override
  State<_StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<_StudentForm> {
  late final TextEditingController _name;
  late final TextEditingController _roll;
  late final TextEditingController _guardian;
  late final ValueNotifier<String?> _classId;
  late final ValueNotifier<bool> _van;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    final s = widget.existing;
    _name = TextEditingController(text: s?.name ?? '');
    _roll = TextEditingController(text: s?.rollNumber ?? '');
    _guardian = TextEditingController(text: s?.guardianName ?? '');
    _classId = ValueNotifier(s?.classId);
    _van = ValueNotifier(s?.usesVan ?? false);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    _roll.dispose();
    _guardian.dispose();
    _classId.dispose();
    _van.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_key.currentState!.validate()) return;
    context.read<StudentEditorBloc>().add(
      StudentSubmitted(
        StudentDraft(
          id: widget.existing?.id,
          name: _name.text,
          rollNumber: _roll.text,
          classId: _classId.value!,
          guardianName: _guardian.text,
          usesVan: _van.value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l.errorRequired : null;
    return FailureToast<StudentEditorBloc, StudentEditorState>(
      failureOf: (s) => s.failure,
      child: BlocConsumer<StudentEditorBloc, StudentEditorState>(
        listenWhen: (a, b) => b.saved != null,
        listener: (context, state) => Navigator.of(context).pop(true),
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(widget.existing == null ? l.stuAdd : l.stuEdit),
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
                      const SizedBox(height: AppSpacing.md),
                      ValueListenableBuilder<String?>(
                        valueListenable: _classId,
                        builder: (context, id, _) =>
                            DropdownButtonFormField<String>(
                              initialValue: id,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: l.fieldClass,
                              ),
                              items: [
                                for (final c in widget.classes)
                                  DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                              ],
                              onChanged: (v) => _classId.value = v,
                              validator: required,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _roll,
                        decoration: InputDecoration(labelText: l.stuRollField),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _guardian,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: l.stuGuardianField,
                        ),
                        validator: required,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _van,
                        builder: (context, on, _) => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l.stuUsesVan),
                          value: on,
                          onChanged: (v) => _van.value = v,
                        ),
                      ),
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
}
