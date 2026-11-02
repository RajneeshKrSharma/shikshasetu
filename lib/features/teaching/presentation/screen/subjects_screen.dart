import '../../../../l10n/class_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../domain/entities/teaching_assignment.dart';
import '../../domain/usecases/teaching_usecases.dart';
import '../bloc/teaching_bloc.dart';
import '../widgets/subject_sheet.dart';

/// The subjects one teacher teaches, class by class. A teacher sees their own
/// and can ask for more; the Principal sees any teacher's and can give or
/// remove subjects.
class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({
    super.key,
    required this.teacherId,
    required this.teacherName,
    this.registeredSubject,
    this.embedded = false,
  });

  /// Shown inside another screen's tab: no bar of its own.
  final bool embedded;

  final String teacherId;
  final String teacherName;

  /// The subject the teacher was registered with, before subjects were given
  /// class by class.
  final String? registeredSubject;

  static Future<void> open(
    BuildContext context, {
    required String teacherId,
    required String teacherName,
    String? registeredSubject,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => SubjectsScreen(
        teacherId: teacherId,
        teacherName: teacherName,
        registeredSubject: registeredSubject,
      ),
    ),
  );

  Future<void> _add(BuildContext context, {required bool principal}) async {
    final l = context.l10n;
    final bloc = context.read<TeachingBloc>();
    final messenger = ScaffoldMessenger.of(context);
    context.read<ClassesBloc>().add(const ClassesLoaded());
    final classes = [
      for (final c in context.read<ClassesBloc>().state.classes) c.name,
    ];
    final choice = await SubjectSheet.show(
      context,
      classes: classes,
      title: principal
          ? l.subjectSheetGiveTitle(teacherName)
          : l.subjectSheetAskTitle,
      actionLabel: principal ? l.subjectGive : l.subjectSend,
    );
    if (choice == null) return;
    final params = TeachingParams(
      teacherId: teacherId,
      className: choice.className,
      subject: choice.subject,
    );
    bloc.add(principal ? SubjectAllotted(params) : SubjectRequested(params));
    messenger.showSnackBar(
      SnackBar(
        content: Text(principal ? l.subjectGiven : l.subjectRequestSent),
      ),
    );
  }

  Future<void> _remove(BuildContext context, TeachingAssignment a) async {
    final l = context.l10n;
    final bloc = context.read<TeachingBloc>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.subjectRemoveTitle),
        content: Text(l.subjectRemoveBody(a.subject, a.className)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.actionRemove),
          ),
        ],
      ),
    );
    if (ok == true) bloc.add(AssignmentRemoved(a.id));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final principal = context.select(
      (AuthBloc b) => b.state.user?.isPrincipal ?? false,
    );
    final mine = principal
        ? teacherName
        : context.select((AuthBloc b) => b.state.user?.name ?? '');
    return Scaffold(
      appBar: embedded
          ? null
          : AppBar(
              title: Text(
                principal ? l.subjectsTitleFor(mine) : l.moduleMySubjects,
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _add(context, principal: principal),
        icon: const Icon(Icons.add),
        label: Text(principal ? l.subjectGiveButton : l.subjectAskButton),
      ),
      body: BlocBuilder<TeachingBloc, TeachingState>(
        builder: (context, state) {
          final items = state.of(teacherId)
            ..sort((a, b) {
              final byClass = a.className.compareTo(b.className);
              return byClass != 0 ? byClass : a.subject.compareTo(b.subject);
            });
          final registered = registeredSubject?.trim() ?? '';
          return ListView(
            padding: AppSpacing.pageOf(context, fab: true),
            children: [
              if (registered.isNotEmpty) ...[
                AppCard(
                  child: Row(
                    children: [
                      Icon(Icons.badge_outlined, color: context.brand.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          l.subjectRegistered(registered),
                          style: context.text.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (items.isEmpty)
                EmptyState(
                  icon: Icons.menu_book_outlined,
                  message: principal
                      ? l.subjectEmptyPrincipal
                      : l.subjectEmptyTeacher,
                )
              else
                for (final a in items) ...[
                  _AssignmentCard(
                    assignment: a,
                    // The Principal can take any away; a teacher can only
                    // cancel what is still waiting or was turned down.
                    onRemove: principal || !a.isApproved
                        ? () => _remove(context, a)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
            ],
          );
        },
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.assignment, this.onRemove});

  final TeachingAssignment assignment;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, color, bg) = switch (assignment.status) {
      AssignmentStatus.approved => (
        l.subjectStatusApproved,
        AppColors.present,
        AppColors.presentLight,
      ),
      AssignmentStatus.pending => (
        l.subjectStatusPending,
        AppColors.late,
        AppColors.lateLight,
      ),
      AssignmentStatus.rejected => (
        l.subjectStatusRejected,
        AppColors.absent,
        AppColors.absentLight,
      ),
    };
    return AppCard(
      child: Row(
        children: [
          Icon(Icons.menu_book_outlined, color: context.brand.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assignment.subject, style: context.text.titleMedium),
                Text(
                  l.classLabel(assignment.className),
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          StatusChip(label: label, color: color, background: bg),
          if (onRemove != null)
            IconButton(
              tooltip: l.actionRemove,
              icon: const Icon(Icons.close),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
