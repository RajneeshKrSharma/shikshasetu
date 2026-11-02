import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/exams_bloc.dart';
import '../widgets/exam_dialog.dart';
import '../widgets/exam_labels.dart';
import 'exam_detail_screen.dart';

/// Scheduled exams, by class; the Principal can also see the papers waiting.
class ExamsTab extends StatelessWidget {
  const ExamsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<ExamsBloc, ExamsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<ExamsBloc, ExamsState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: state.canSchedule
              ? FloatingActionButton.extended(
                  onPressed: state.busy ? null : () => showExamDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(l.exmSchedule),
                )
              : null,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
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
                      onChanged: (id) => context.read<ExamsBloc>().add(
                        ExamsFiltered(
                          classId: id,
                          awaitingApproval: state.awaitingApproval,
                        ),
                      ),
                    ),
                    if (state.canSchedule)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.exmAwaiting),
                        value: state.awaitingApproval,
                        onChanged: (v) => context.read<ExamsBloc>().add(
                          ExamsFiltered(
                            classId: state.classId,
                            awaitingApproval: v,
                          ),
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
                      context.read<ExamsBloc>().add(const ExamsStarted()),
                  isEmpty: state.shown.isEmpty,
                  emptyText: l.exmEmpty,
                  emptyIcon: Icons.description_outlined,
                  builder: (context) => ListView(
                    padding: AppSpacing.pageOf(context, fab: state.canSchedule),
                    children: [
                      for (final e in state.shown)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            onTap: () async {
                              final bloc = context.read<ExamsBloc>();
                              final changed = await Navigator.of(context)
                                  .push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) => ExamDetailScreen(exam: e),
                                    ),
                                  );
                              if (changed == true) {
                                bloc.add(
                                  ExamsFiltered(
                                    classId: state.classId,
                                    awaitingApproval: state.awaitingApproval,
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${e.subject} · ${e.className}',
                                        style: context.text.titleSmall,
                                      ),
                                      Text(
                                        '${e.type.label(l)} · '
                                        '${formatShortDate(context, e.heldOn)} · '
                                        '${e.maxMarks}',
                                        style: context.text.bodySmall,
                                      ),
                                      if (e.teacherName.isNotEmpty)
                                        Text(
                                          l.exmTeacher(e.teacherName),
                                          style: context.text.bodySmall,
                                        ),
                                    ],
                                  ),
                                ),
                                if (e.paperStatus != null)
                                  Text(
                                    e.paperStatus!.label(l),
                                    style: context.text.labelSmall,
                                  ),
                                if (state.canSchedule)
                                  IconButton(
                                    tooltip: l.exmEdit,
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () =>
                                        showExamDialog(context, existing: e),
                                  ),
                              ],
                            ),
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
}
