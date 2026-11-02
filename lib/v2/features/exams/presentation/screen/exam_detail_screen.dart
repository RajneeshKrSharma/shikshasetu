import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/exams.dart';
import '../bloc/exam_detail_bloc.dart';
import '../widgets/exam_labels.dart';
import 'marks_entry_screen.dart';
import 'paper_compose_screen.dart';

/// One exam: its results and marks, and its question paper.
class ExamDetailScreen extends StatelessWidget {
  const ExamDetailScreen({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<ExamDetailBloc>(param1: exam, param2: account)
            ..add(const ExamDetailStarted()),
      child: _View(exam: exam),
    );
  }
}

class _View extends StatelessWidget {
  const _View({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<ExamDetailBloc, ExamDetailState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<ExamDetailBloc, ExamDetailState>(
        builder: (context, state) {
          final access = state.access;
          return PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) Navigator.of(context).pop(state.changedCount > 0);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('${exam.subject} · ${exam.className}'),
              ),
              body: AsyncBody(
                status: state.status,
                failure: state.failure,
                onRetry: () => context.read<ExamDetailBloc>().add(
                  const ExamDetailStarted(),
                ),
                builder: (context) => ListView(
                  padding: AppSpacing.page,
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${exam.type.label(l)} · ${exam.maxMarks}',
                            style: context.text.titleSmall,
                          ),
                          Text(
                            formatShortDate(context, exam.heldOn),
                            style: context.text.bodySmall,
                          ),
                          if (exam.teacherName.isNotEmpty)
                            Text(
                              l.exmTeacher(exam.teacherName),
                              style: context.text.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    if (access != null &&
                        (access.canPrepare || access.canSchedule)) ...[
                      const SizedBox(height: AppSpacing.lg),
                      SectionTitle(l.exmPaper),
                      _PaperSection(state: state),
                    ],
                    if (state.results != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      SectionTitle(l.exmResults),
                      _ResultsSection(exam: exam, state: state),
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
}

class _ResultsSection extends StatelessWidget {
  const _ResultsSection({required this.exam, required this.state});

  final Exam exam;
  final ExamDetailState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = state.results!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.exmResultsStats('${r.entered}', r.absent)),
        if (r.average != null) Text(l.exmAverage(r.average!)),
        if (r.highest != null && r.lowest != null)
          Text(l.exmHighLow('${r.highest}', '${r.lowest}')),
        if (state.access?.canConduct ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: FilledButton.icon(
              onPressed: state.busy ? null : () => _enter(context, r),
              icon: const Icon(Icons.edit_note),
              label: Text(l.exmEnterMarks),
            ),
          ),
        for (final line in r.lines)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('${line.rollNumber}. ${line.name}'),
            trailing: Text(
              line.absent
                  ? l.exmAbsent
                  : line.entered
                  ? l.exmMarksOf(line.marks!, '${exam.maxMarks}')
                  : l.exmNotEntered,
            ),
          ),
      ],
    );
  }

  Future<void> _enter(BuildContext context, ExamResults results) async {
    final bloc = context.read<ExamDetailBloc>();
    final entries = await Navigator.of(context).push<List<MarkEntry>>(
      MaterialPageRoute(
        builder: (_) =>
            MarksEntryScreen(lines: results.lines, maxMarks: exam.maxMarks),
      ),
    );
    if (entries != null && entries.isNotEmpty)
      bloc.add(MarksSubmitted(entries));
  }
}

class _PaperSection extends StatelessWidget {
  const _PaperSection({required this.state});

  final ExamDetailState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<ExamDetailBloc>();
    final paper = state.paper;
    final access = state.access!;
    final canEdit = access.canPrepare && (paper == null || paper.isEditable);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (paper == null) Text(l.exmPaperNone),
        if (paper != null) ...[
          Text(
            '${paper.status.label(l)} · ${l.exmPaperTotal(paper.totalMarks)}',
            style: context.text.titleSmall,
          ),
          if (paper.decisionNote.isNotEmpty)
            Text(l.exmPaperNote(paper.decisionNote)),
          const SizedBox(height: AppSpacing.sm),
          for (final q in paper.questions)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Text('${q.position}.'),
              title: Text(q.text),
              trailing: Text('${q.marks}'),
            ),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            if (canEdit)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: AppSizes.dialogButton,
                ),
                onPressed: state.busy ? null : () => _compose(context, paper),
                child: Text(l.exmPaperCompose),
              ),
            if (canEdit && paper != null && paper.questions.isNotEmpty)
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: AppSizes.dialogButton,
                ),
                onPressed: state.busy
                    ? null
                    : () => bloc.add(const PaperSentForApproval()),
                child: Text(l.exmPaperSend),
              ),
            if (access.canSchedule &&
                paper != null &&
                paper.status == PaperStatus.sent) ...[
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: AppSizes.dialogButton,
                ),
                onPressed: state.busy
                    ? null
                    : () => bloc.add(const PaperApprovedEvent()),
                child: Text(l.exmPaperApprove),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: AppSizes.dialogButton,
                ),
                onPressed: state.busy ? null : () => _reject(context),
                child: Text(l.exmPaperReject),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _compose(BuildContext context, Paper? paper) async {
    final bloc = context.read<ExamDetailBloc>();
    final ids = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(
        builder: (_) => PaperComposeScreen(
          available: state.available,
          selected: [
            for (final q in paper?.questions ?? const <PaperQuestion>[])
              if (q.questionId != null) q.questionId!,
          ],
        ),
      ),
    );
    if (ids != null) bloc.add(PaperComposed(ids));
  }

  Future<void> _reject(BuildContext context) async {
    final l = context.l10n;
    final bloc = context.read<ExamDetailBloc>();
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.exmPaperReject),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l.exmReason),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: AppSizes.dialogButton),
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l.exmPaperReject),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason != null) bloc.add(PaperRejectedEvent(reason));
  }
}
