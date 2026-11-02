import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../master_questions/presentation/bloc/master_questions_bloc.dart';
import '../../../teaching/presentation/bloc/teaching_access_x.dart';
import '../../../teaching/presentation/screen/subjects_screen.dart';
import '../../../master_questions/presentation/screen/master_question_picker_screen.dart';
import '../../domain/entities/exam_paper.dart';
import '../../domain/entities/scanned_question.dart';
import '../bloc/exams_bloc.dart';
import '../bloc/paper_form_bloc.dart';
import '../widgets/paper_builder_dialogs.dart';
import '../widgets/question_edit_handler.dart';
import '../widgets/question_editor_card.dart';
import '../widgets/question_type_sheet.dart';
import '../widgets/scan_source_sheet.dart';

const _durations = [30, 45, 60, 90, 120, 180];

/// Subject that defaults the scanner to Devanagari text.
const _hindi = 'Hindi';

/// Sends the editor's edits to the paper builder as events.
class _BlocHandler implements QuestionEditHandler {
  const _BlocHandler(this.bloc, this.id);

  final PaperFormBloc bloc;
  final int id;

  @override
  void text(String value) => bloc.add(QuestionEdited(id, text: value));
  @override
  void marks(String value) => bloc.add(QuestionEdited(id, marks: value));
  @override
  void answer(String value) => bloc.add(QuestionEdited(id, answer: value));
  @override
  void type(QuestionType type) => bloc.add(QuestionTypeChanged(id, type));
  @override
  void optionEdited(int index, String value) =>
      bloc.add(OptionEdited(id, index, value));
  @override
  void optionAdded() => bloc.add(OptionAdded(id));
  @override
  void optionRemoved(int index) => bloc.add(OptionRemoved(id, index));
  @override
  void correct(int? index) => bloc.add(CorrectChosen(id, index));
  @override
  void pairEdited(int index, {String? left, String? right}) =>
      bloc.add(PairEdited(id, index, left: left, right: right));
  @override
  void pairAdded() => bloc.add(PairAdded(id));
  @override
  void pairRemoved(int index) => bloc.add(PairRemoved(id, index));
}

enum _CardAction { duplicate, saveToMaster, delete }

/// Builds (or edits) a question paper: details, questions of every type, and
/// quick ways to fill it. Expects a [PaperFormBloc] above it.
class CreatePaperScreen extends StatefulWidget {
  const CreatePaperScreen({super.key});

  /// Opens the builder, empty or with [initial] to edit.
  static Future<void> open(BuildContext context, {ExamPaper? initial}) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => sl<PaperFormBloc>(param1: initial),
            child: const CreatePaperScreen(),
          ),
        ),
      );

  @override
  State<CreatePaperScreen> createState() => _CreatePaperScreenState();
}

class _CreatePaperScreenState extends State<CreatePaperScreen> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  void _submit(PaperStatus status) {
    if (!_formKey.currentState!.validate()) return;
    final me = context.read<AuthBloc>().state.user!.id;
    context.read<PaperFormBloc>().add(PaperSubmitted(status, me));
  }

  Future<void> _pickDate(DateTime current) async {
    final bloc = context.read<PaperFormBloc>();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) bloc.add(PaperDateChosen(picked));
  }

  Future<void> _addQuestion() async {
    final bloc = context.read<PaperFormBloc>();
    final type = await QuestionTypeSheet.show(context);
    if (type != null) bloc.add(QuestionAdded(type));
  }

  Future<void> _scan() async {
    final bloc = context.read<PaperFormBloc>();
    final choice = await showModalBottomSheet<ScanChoice>(
      context: context,
      showDragHandle: true,
      builder: (_) => ScanSourceSheet(
        initialScript: bloc.state.subject == _hindi
            ? ScanScript.devanagari
            : ScanScript.latin,
      ),
    );
    if (choice != null) bloc.add(ScanRequested(choice.source, choice.script));
  }

  Future<void> _paste() async {
    final bloc = context.read<PaperFormBloc>();
    final text = await PasteQuestionsSheet.show(context);
    if (text != null && text.trim().isNotEmpty) bloc.add(TextImported(text));
  }

  Future<void> _fromMaster() async {
    final bloc = context.read<PaperFormBloc>();
    final picked = await MasterQuestionPickerScreen.pick(
      context,
      subject: bloc.state.subject,
    );
    if (picked != null && picked.isNotEmpty) {
      bloc.add(MasterQuestionsAdded(picked));
    }
  }

  Future<void> _marksForAll() async {
    final bloc = context.read<PaperFormBloc>();
    final marks = await MarksForAllDialog.show(context);
    if (marks != null) bloc.add(MarksAppliedToAll(marks));
  }

  Future<void> _shuffle() async {
    final bloc = context.read<PaperFormBloc>();
    final messenger = ScaffoldMessenger.of(context);
    final text = context.l10n.messagePaperShuffled;
    final options = await ShuffleSheet.show(context);
    if (options == null) return;
    bloc.add(QuestionsShuffled(options: options));
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  void _onCardAction(_CardAction action, QuestionDraft draft) {
    final l = context.l10n;
    final bloc = context.read<PaperFormBloc>();
    switch (action) {
      case _CardAction.duplicate:
        bloc.add(QuestionDuplicated(draft.id));
      case _CardAction.delete:
        bloc.add(QuestionRemoved(draft.id));
      case _CardAction.saveToMaster:
        final q = draft.toQuestion();
        final messenger = ScaffoldMessenger.of(context);
        if (q.text.isEmpty) {
          messenger.showSnackBar(SnackBar(content: Text(l.errorRequired)));
          return;
        }
        context.read<MasterQuestionsBloc>().add(
          MasterQuestionSaved(
            q,
            subject: bloc.state.subject,
            createdBy: context.read<AuthBloc>().state.user?.id,
          ),
        );
        messenger.showSnackBar(SnackBar(content: Text(l.paperSavedToMaster)));
    }
  }

  Future<void> _onScanFeedback(ScanFeedback feedback) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (feedback.kind) {
          ScanFeedbackKind.noText => l.scanNoText,
          ScanFeedbackKind.failed => l.scanFailed,
          ScanFeedbackKind.found => l.paperFoundN(feedback.questions.length),
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<PaperFormBloc>();
    final isPrincipal = context.select(
      (AuthBloc b) => b.state.user?.isPrincipal ?? false,
    );
    final access = watchTeachingAccess(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<PaperFormBloc, PaperFormState>(
          listenWhen: (a, b) => !a.saved && b.saved,
          listener: (context, state) {
            context.read<ExamsBloc>().add(const ExamsLoaded());
            // A paper sent for approval shows up in the Principal's list.
            context.read<ApprovalsBloc>().add(const ApprovalsRequested());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(switch (state.savedAs) {
                  PaperStatus.submitted => l.messagePaperSubmitted,
                  PaperStatus.approved => l.messagePaperApproved,
                  _ => l.messagePaperSaved,
                }),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        BlocListener<PaperFormBloc, PaperFormState>(
          listenWhen: (a, b) =>
              b.scanFeedback != null && a.scanFeedback != b.scanFeedback,
          listener: (context, state) => _onScanFeedback(state.scanFeedback!),
        ),
        BlocListener<PaperFormBloc, PaperFormState>(
          listenWhen: (a, b) => !a.scanning && b.scanning,
          listener: (context, state) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l.scanProcessing))),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            bloc.state.isEditing ? l.actionEditPaper : l.createPaperTitle,
          ),
          actions: [
            // The two things used rarely live here, out of the way.
            PopupMenuButton<String>(
              tooltip: l.paperTools,
              onSelected: (v) => v == 'marks' ? _marksForAll() : _shuffle(),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'marks', child: Text(l.paperSetMarksAll)),
                PopupMenuItem(
                  value: 'shuffle',
                  child: Text(l.paperShuffleQuestions),
                ),
              ],
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              if (bloc.state.reviewNote != null) ...[
                _ReviewNoteBanner(note: bloc.state.reviewNote!),
                const SizedBox(height: AppSpacing.lg),
              ],
              SectionTitle(l.paperDetailsTitle),
              if (access.hasNone)
                _NoSubjectCard(
                  onAsk: () => SubjectsScreen.open(
                    context,
                    teacherId: access.user.id,
                    teacherName: access.user.name,
                    registeredSubject: access.user.subject,
                  ),
                )
              else
                BlocBuilder<PaperFormBloc, PaperFormState>(
                  buildWhen: (a, b) =>
                      a.classSection != b.classSection ||
                      a.subject != b.subject,
                  builder: (context, state) {
                    final classes = {
                      ...access.classes(),
                      ?state.classSection,
                    }.toList();
                    final subjects = state.classSection == null
                        ? <String>[]
                        : {
                            ...access.subjects(className: state.classSection),
                            ?state.subject,
                          }.toList();
                    return Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: state.classSection,
                          decoration: InputDecoration(labelText: l.fieldClass),
                          items: [
                            for (final c in classes)
                              DropdownMenuItem(value: c, child: Text(c)),
                          ],
                          onChanged: (v) {
                            bloc.add(PaperClassChosen(v));
                            // The subject must be one allowed in this class.
                            final allowed = access.subjects(className: v);
                            if (state.subject != null &&
                                !allowed.contains(state.subject)) {
                              bloc.add(const PaperSubjectChosen(null));
                            }
                          },
                          validator: (v) => v == null ? l.errorRequired : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          key: ValueKey('subject-${state.classSection}'),
                          initialValue: subjects.contains(state.subject)
                              ? state.subject
                              : null,
                          decoration: InputDecoration(
                            labelText: l.fieldSubject,
                            helperText: state.classSection == null
                                ? l.subjectChooseClassFirst
                                : subjects.isEmpty
                                ? l.subjectNoneInClass
                                : null,
                          ),
                          items: [
                            for (final s in subjects)
                              DropdownMenuItem(value: s, child: Text(s)),
                          ],
                          onChanged: subjects.isEmpty
                              ? null
                              : (v) => bloc.add(PaperSubjectChosen(v)),
                          validator: (v) => v == null ? l.errorRequired : null,
                        ),
                      ],
                    );
                  },
                ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                initialValue: bloc.state.title,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => bloc.add(PaperTitleChanged(v)),
                decoration: InputDecoration(labelText: l.fieldPaperTitle),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<PaperFormBloc, PaperFormState>(
                      buildWhen: (a, b) => a.date != b.date,
                      builder: (context, state) => PickerField(
                        label: l.fieldDate,
                        value: formatShortDate(context, state.date),
                        onTap: () => _pickDate(state.date),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: bloc.state.durationMinutes,
                      decoration: InputDecoration(labelText: l.fieldDuration),
                      items: [
                        for (final d in {
                          ..._durations,
                          bloc.state.durationMinutes,
                        })
                          DropdownMenuItem(
                            value: d,
                            child: Text(l.durationMinutes(d)),
                          ),
                      ],
                      onChanged: (v) => bloc.add(PaperDurationChosen(v ?? 60)),
                    ),
                  ),
                ],
              ),
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    l.paperMoreOptions,
                    style: context.text.bodyMedium,
                  ),
                  initiallyExpanded: bloc.state.instructions.isNotEmpty,
                  children: [
                    TextFormField(
                      initialValue: bloc.state.instructions,
                      minLines: 2,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (v) => bloc.add(PaperInstructionsChanged(v)),
                      decoration: InputDecoration(
                        labelText: l.paperMoreOptionsHint,
                        hintText: l.paperInstructionsHint,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<PaperFormBloc, PaperFormState>(
                buildWhen: (a, b) =>
                    a.questions != b.questions || a.scanning != b.scanning,
                builder: (context, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(l.sectionQuestions),
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: state.questions.length,
                      onReorder: (from, to) =>
                          bloc.add(QuestionMoved(from, to)),
                      itemBuilder: (context, i) {
                        final draft = state.questions[i];
                        return Padding(
                          key: ValueKey(draft.id),
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: QuestionEditorCard(
                            index: i,
                            draft: draft,
                            handler: _BlocHandler(bloc, draft.id),
                            dragHandle: ReorderableDragStartListener(
                              index: i,
                              child: Padding(
                                padding: EdgeInsets.only(right: AppSpacing.md),
                                child: Icon(
                                  Icons.drag_indicator,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                            menu: PopupMenuButton<_CardAction>(
                              onSelected: (a) => _onCardAction(a, draft),
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  value: _CardAction.duplicate,
                                  child: Text(l.paperDuplicate),
                                ),
                                PopupMenuItem(
                                  value: _CardAction.saveToMaster,
                                  child: Text(l.paperSaveToMaster),
                                ),
                                if (state.questions.length > 1)
                                  PopupMenuItem(
                                    value: _CardAction.delete,
                                    child: Text(l.actionRemove),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _addQuestion,
                      icon: const Icon(Icons.add),
                      label: Text(l.paperAddQuestion),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                          AppSizes.buttonHeight,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(l.paperQuickAdd, style: context.text.bodySmall),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.document_scanner_outlined),
                          label: Text(l.paperScan),
                          onPressed: state.scanning ? null : _scan,
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.content_paste),
                          label: Text(l.paperPaste),
                          onPressed: _paste,
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.library_books_outlined),
                          label: Text(l.paperFromMaster),
                          onPressed: _fromMaster,
                        ),
                      ],
                    ),
                    if (state.scanning) ...[
                      const SizedBox(height: AppSpacing.lg),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        // The buttons stay in view, with the total, so nothing is to be found
        // by scrolling.
        bottomNavigationBar: SafeArea(
          child: Material(
            elevation: 8,
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: BlocBuilder<PaperFormBloc, PaperFormState>(
                buildWhen: (a, b) =>
                    a.saving != b.saving || a.questions != b.questions,
                builder: (context, state) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.paperQuestionsCount(
                        state.questions.length,
                        state.totalMarks,
                      ),
                      style: context.text.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: state.saving
                                ? null
                                : () => _submit(PaperStatus.draft),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(
                                AppSizes.buttonHeight,
                              ),
                            ),
                            child: Text(l.actionSaveDraft),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: state.saving
                                ? null
                                : () => _submit(
                                    isPrincipal
                                        ? PaperStatus.approved
                                        : PaperStatus.submitted,
                                  ),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(
                                AppSizes.buttonHeight,
                              ),
                            ),
                            child: Text(
                              isPrincipal
                                  ? l.actionApproveSave
                                  : l.actionSendForApproval,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A teacher with no subject yet cannot set a paper: this says why and takes
/// them to ask for one.
class _NoSubjectCard extends StatelessWidget {
  const _NoSubjectCard({required this.onAsk});

  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return InfoBanner(
      kind: BannerKind.warning,
      message: l.subjectNoneForPaper,
      action: FilledButton.icon(
        onPressed: onAsk,
        icon: const Icon(Icons.menu_book_outlined, size: AppIconSize.sm),
        label: Text(l.subjectAskButton),
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppSizes.buttonCompact),
        ),
      ),
    );
  }
}

class _ReviewNoteBanner extends StatelessWidget {
  const _ReviewNoteBanner({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) => InfoBanner(
    kind: BannerKind.warning,
    title: context.l10n.paperSentBackTitle,
    message: note,
  );
}
