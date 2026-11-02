import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/entities/student.dart';
import '../bloc/students_bloc.dart';
import 'student_detail_screen.dart';
import 'student_form_screen.dart';

/// The students, narrowed by class or by name.
class StudentsTab extends StatelessWidget {
  const StudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<StudentsBloc, StudentsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: state.canManage
              ? FloatingActionButton.extended(
                  onPressed: () => _add(context, state),
                  icon: const Icon(Icons.add),
                  label: Text(l.stuAdd),
                )
              : null,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (v) => context.read<StudentsBloc>().add(
                        StudentsFiltered(classId: state.classId, query: v),
                      ),
                      decoration: InputDecoration(
                        hintText: l.stuSearch,
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonFormField<String?>(
                      initialValue: state.classId,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l.fieldClass),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l.stuAllClasses),
                        ),
                        for (final c in state.classes)
                          DropdownMenuItem<String?>(
                            value: c.id,
                            child: Text(c.name),
                          ),
                      ],
                      onChanged: (id) => context.read<StudentsBloc>().add(
                        id == null
                            ? const StudentsFilterCleared()
                            : StudentsFiltered(classId: id, query: state.query),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AsyncBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: () =>
                      context.read<StudentsBloc>().add(const StudentsStarted()),
                  isEmpty: state.students.isEmpty,
                  emptyText: l.stuEmpty,
                  emptyIcon: Icons.school_outlined,
                  builder: (context) => ListView(
                    padding: AppSpacing.pageOf(context, fab: state.canManage),
                    children: [
                      for (final s in state.students)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _StudentTile(
                            student: s,
                            classes: state.classes,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context, StudentsState state) async {
    final bloc = context.read<StudentsBloc>();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => StudentFormScreen(classes: state.classes),
      ),
    );
    if (saved == true) bloc.add(const StudentsStarted());
  }
}

class _StudentTile extends StatelessWidget {
  const _StudentTile({required this.student, required this.classes});

  final Student student;
  final List<SchoolClass> classes;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      onTap: () async {
        final bloc = context.read<StudentsBloc>();
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) =>
                StudentDetailScreen(studentId: student.id, classes: classes),
          ),
        );
        if (changed == true) bloc.add(const StudentsStarted());
      },
      child: Row(
        children: [
          InitialsAvatar(student.name),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: context.text.titleSmall),
                Text(
                  '${student.className} · ${l.stuRoll(student.rollNumber)}',
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          if (student.usesVan)
            Icon(Icons.directions_bus_outlined, color: context.brand.primary),
        ],
      ),
    );
  }
}
