import '../../../../core/widgets/info_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/exam_paper.dart';
import '../bloc/exams_bloc.dart';
import '../widgets/paper_builder_dialogs.dart';
import '../widgets/paper_setter.dart';
import '../widgets/paper_status_style.dart';
import '../widgets/question_preview_tile.dart';
import '../widgets/send_back_dialog.dart';
import 'create_paper_screen.dart';
import 'paper_print_screen.dart';
import 'marks_entry_screen.dart';

/// One paper: its status, what the viewer can do with it (review and approve,
/// edit, shuffle, send for approval, enter marks), and its questions.
class PaperDetailScreen extends StatelessWidget {
  const PaperDetailScreen({super.key, required this.paperId});

  final String paperId;

  void _refreshApprovals(BuildContext context) =>
      context.read<ApprovalsBloc>().add(const ApprovalsRequested());

  Future<void> _sendBack(BuildContext context, ExamPaper paper) async {
    final exams = context.read<ExamsBloc>();
    final approvals = context.read<ApprovalsBloc>();
    final messenger = ScaffoldMessenger.of(context);
    final text = context.l10n.messagePaperSentBack;
    final note = await SendBackDialog.show(context);
    if (note == null) return;
    exams.add(PaperSentBack(paper.id, note));
    approvals.add(const ApprovalsRequested());
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _delete(BuildContext context, ExamPaper paper) async {
    final l = context.l10n;
    final exams = context.read<ExamsBloc>();
    final approvals = context.read<ApprovalsBloc>();
    final nav = Navigator.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.paperDeleteTitle),
        content: Text(l.paperDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.actionRemove),
          ),
        ],
      ),
    );
    if (yes ?? false) {
      exams.add(PaperDeleted(paper.id));
      approvals.add(const ApprovalsRequested());
      nav.pop();
    }
  }

  Future<void> _shuffle(BuildContext context, ExamPaper paper) async {
    final exams = context.read<ExamsBloc>();
    final messenger = ScaffoldMessenger.of(context);
    final text = context.l10n.messagePaperShuffled;
    final options = await ShuffleSheet.show(context);
    if (options == null) return;
    exams.add(PaperShuffled(paper.id, options: options));
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = context.select((AuthBloc b) => b.state.user);
    return BlocBuilder<ExamsBloc, ExamsState>(
      builder: (context, state) {
        final paper = state.paperById(paperId);
        if (paper == null || user == null) return const Scaffold();
        final isPrincipal = user.isPrincipal;
        final mine = paper.createdBy == user.id;
        final canEdit =
            !paper.isPast && (isPrincipal || (mine && paper.isInProgress));
        final setter = paperSetterName(context, paper);

        return Scaffold(
          appBar: AppBar(
            title: Text(paper.title),
            actions: [
              if (canEdit && paper.questions.length > 1)
                IconButton(
                  tooltip: l.paperShuffle,
                  icon: const Icon(Icons.shuffle),
                  onPressed: () => _shuffle(context, paper),
                ),
              if (canEdit)
                IconButton(
                  tooltip: l.actionDeletePaper,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(context, paper),
                ),
            ],
          ),
          body: ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.paperSubjectClass(
                              paper.subject,
                              paper.classSection,
                            ),
                            style: context.text.titleMedium,
                          ),
                        ),
                        StatusChip(
                          label: paper.status.label(l),
                          color: paper.status.color(context.brand),
                          background: paper.status.background(context.brand),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '${formatLongDate(context, paper.date)}\n'
                      '${l.paperMarksDuration(paper.totalMarks, paper.durationMinutes)}'
                      '${setter.isEmpty ? '' : '\n${l.paperSetBy(setter)}'}',
                      style: context.text.bodySmall,
                    ),
                    if (paper.instructions.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(paper.instructions, style: context.text.bodyMedium),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ..._actions(context, paper, isPrincipal: isPrincipal, mine: mine),
              if (paper.questions.isNotEmpty &&
                  (isPrincipal ||
                      mine ||
                      paper.status == PaperStatus.approved ||
                      paper.isPast)) ...[
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () => PaperPrintScreen.open(
                    context,
                    paper,
                    canPrint:
                        paper.status == PaperStatus.approved || paper.isPast,
                  ),
                  icon: const Icon(Icons.print_outlined),
                  label: Text(l.paperPreviewPrint),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SectionTitle(l.sectionQuestions),
              for (var i = 0; i < paper.questions.length; i++) ...[
                QuestionPreviewTile(
                  number: i + 1,
                  question: paper.questions[i],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        );
      },
    );
  }

  List<Widget> _actions(
    BuildContext context,
    ExamPaper paper, {
    required bool isPrincipal,
    required bool mine,
  }) {
    final l = context.l10n;
    final exams = context.read<ExamsBloc>();
    const gap = SizedBox(height: AppSpacing.md);
    final edit = OutlinedButton.icon(
      onPressed: () => CreatePaperScreen.open(context, initial: paper),
      icon: const Icon(Icons.edit_outlined),
      label: Text(l.actionEditPaper),
    );

    if (paper.isPast) {
      return [
        FilledButton.icon(
          onPressed: () => MarksEntryScreen.open(context, paper.id),
          icon: const Icon(Icons.edit_note),
          label: Text(l.actionEnterMarks),
        ),
      ];
    }

    switch (paper.status) {
      case PaperStatus.submitted:
        if (!isPrincipal) {
          return [_Notice(text: l.paperYourStatusSubmitted)];
        }
        return [
          _Notice(
            title: l.paperAwaitingTitle,
            text: l.paperAwaitingBody,
            warning: true,
          ),
          gap,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _sendBack(context, paper),
                  child: Text(l.actionSendBack),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    exams.add(PaperApproved(paper.id));
                    _refreshApprovals(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.messagePaperApproved)),
                    );
                  },
                  child: Text(l.actionApprove),
                ),
              ),
            ],
          ),
          gap,
          edit,
        ];
      case PaperStatus.changesRequested:
      case PaperStatus.draft:
        if (!isPrincipal && !mine) return const [];
        return [
          if (paper.reviewNote != null) ...[
            _Notice(
              title: l.paperSentBackTitle,
              text: paper.reviewNote!,
              warning: true,
            ),
            gap,
          ],
          edit,
          gap,
          FilledButton(
            onPressed: () {
              if (isPrincipal) {
                exams.add(PaperApproved(paper.id));
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l.messagePaperApproved)));
              } else {
                exams.add(PaperSubmittedForApproval(paper.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.messagePaperSubmitted)),
                );
              }
              _refreshApprovals(context);
            },
            child: Text(
              isPrincipal ? l.actionApprove : l.actionSendForApproval,
            ),
          ),
        ];
      case PaperStatus.approved:
        return [
          if (isPrincipal) ...[
            edit,
            gap,
            OutlinedButton.icon(
              onPressed: () => exams.add(PaperConducted(paper.id)),
              icon: const Icon(Icons.task_alt),
              label: Text(l.actionMarkConducted),
            ),
          ],
        ];
      case PaperStatus.conducted:
        return const [];
    }
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, this.title, this.warning = false});

  final String text;
  final String? title;
  final bool warning;

  @override
  Widget build(BuildContext context) => InfoBanner(
    message: text,
    title: title,
    kind: warning ? BannerKind.warning : BannerKind.info,
  );
}
