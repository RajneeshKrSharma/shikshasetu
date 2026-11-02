import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../../exams/presentation/screen/student_results_screen.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/school_class.dart';
import '../bloc/student_detail_bloc.dart';
import 'student_form_screen.dart';

/// One student, with what the viewer may do about them.
class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({
    super.key,
    required this.studentId,
    required this.classes,
  });

  final String studentId;
  final List<SchoolClass> classes;

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<StudentDetailBloc>(param1: studentId, param2: account)
            ..add(const StudentDetailStarted()),
      child: _DetailView(classes: classes),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.classes});

  final List<SchoolClass> classes;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<StudentDetailBloc, StudentDetailState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<StudentDetailBloc, StudentDetailState>(
        builder: (context, state) {
          final student = state.student;
          final canManage = state.access?.canManageStudents ?? false;
          return PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) Navigator.of(context).pop(state.changedCount > 0);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(student?.name ?? l.stuTitle),
                actions: [
                  if (canManage && student != null && student.isActive)
                    IconButton(
                      tooltip: l.stuEdit,
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _edit(context, state),
                    ),
                ],
              ),
              body: AsyncBody(
                status: state.status,
                failure: state.failure,
                onRetry: () => context.read<StudentDetailBloc>().add(
                  const StudentDetailStarted(),
                ),
                builder: (context) => ListView(
                  padding: AppSpacing.page,
                  children: [
                    Center(child: InitialsAvatar(student!.name, radius: 36)),
                    const SizedBox(height: AppSpacing.lg),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Row(l.fieldClass, student.className),
                          _Row(l.stuRoll(student.rollNumber), ''),
                          _Row(l.stuGuardianField, student.guardianName),
                          _Row('', student.usesVan ? l.stuVanYes : l.stuVanNo),
                          if (!student.isActive)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.sm,
                              ),
                              child: Text(
                                l.stuRemoved,
                                style: context.text.labelLarge,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (state.access?.canSeeResults ?? false) ...[
                      const SizedBox(height: AppSpacing.lg),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                StudentResultsScreen(studentId: student.id),
                          ),
                        ),
                        icon: const Icon(Icons.description_outlined),
                        label: Text(l.exmStudentResults),
                      ),
                    ],
                    if (canManage) ...[
                      const SizedBox(height: AppSpacing.lg),
                      OutlinedButton.icon(
                        onPressed: state.busy
                            ? null
                            : () => _toggle(context, state),
                        icon: Icon(
                          student.isActive
                              ? Icons.person_remove_outlined
                              : Icons.restore,
                        ),
                        label: Text(
                          student.isActive ? l.stuRemove : l.stuRestore,
                        ),
                      ),
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

  Future<void> _edit(BuildContext context, StudentDetailState state) async {
    final detail = context.read<StudentDetailBloc>();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            StudentFormScreen(classes: classes, existing: state.student),
      ),
    );
    if (saved == true) detail.add(const StudentDetailStarted());
  }

  Future<void> _toggle(BuildContext context, StudentDetailState state) async {
    final l = context.l10n;
    final student = state.student!;
    final bloc = context.read<StudentDetailBloc>();
    if (student.isActive) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(l.stuRemoveAsk(student.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.actionCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.actionRemove),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    bloc.add(const StudentActiveToggled());
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Text(
      [label, value].where((t) => t.isNotEmpty).join(': '),
      style: context.text.bodyMedium,
    ),
  );
}
