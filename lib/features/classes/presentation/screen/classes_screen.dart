import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../staff/presentation/bloc/staff_bloc.dart';
import '../bloc/classes_bloc.dart';
import '../widgets/class_card.dart';
import '../widgets/class_dialogs.dart';

/// Principal adds, renames and deletes classes.
class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  Future<void> _addOrEdit(BuildContext context, {String? existing}) async {
    final bloc = context.read<ClassesBloc>();
    final name = await showClassNameDialog(
      context,
      existing: existing,
      isTaken: (n) => bloc.state.exists(n, except: existing),
    );
    if (name == null) return;
    if (existing == null) {
      bloc.add(ClassAdded(name));
    } else if (name != existing) {
      bloc.add(ClassRenamed(existing, name));
    }
  }

  Future<void> _delete(BuildContext context, String name, int count) async {
    final bloc = context.read<ClassesBloc>();
    if (await confirmDeleteClass(context, name: name, studentCount: count)) {
      bloc.add(ClassDeleted(name));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<ClassesBloc, ClassesState>(
      listenWhen: (a, b) => a.change != b.change && b.change != null,
      listener: (context, state) {
        // Other screens show class data too, so they reload.
        context.read<StaffBloc>().add(const StaffLoaded());
        context.read<AttendanceBloc>().add(const AttendanceRefreshed());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(switch (state.change!.kind) {
              ClassChangeKind.added => l.messageClassAdded,
              ClassChangeKind.renamed => l.messageClassUpdated,
              ClassChangeKind.deleted => l.messageClassDeleted,
            }),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.classesTitle)),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () => _addOrEdit(context),
          icon: const Icon(Icons.add),
          label: Text(l.actionAddClass),
        ),
        body: BlocBuilder<ClassesBloc, ClassesState>(
          builder: (context, state) {
            if (state.classes.isEmpty) {
              return EmptyState(
                icon: Icons.class_outlined,
                message: l.emptyClasses,
              );
            }
            return ListView.separated(
              padding: AppSpacing.pageOf(context, fab: true),
              itemCount: state.classes.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) {
                final c = state.classes[i];
                return ClassCard(
                  summary: c,
                  onAction: (a) => switch (a) {
                    ClassAction.edit => _addOrEdit(context, existing: c.name),
                    ClassAction.delete => _delete(
                      context,
                      c.name,
                      c.studentCount,
                    ),
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
