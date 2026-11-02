import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/exam_paper.dart';
import '../bloc/exams_bloc.dart';
import '../widgets/paper_card.dart';
import '../../../question_bank/presentation/screen/question_bank_screen.dart';
import '../widgets/new_paper_sheet.dart';
import 'create_paper_screen.dart';
import 'paper_detail_screen.dart';

/// Question papers by stage: awaiting approval, ready, drafts and past. A
/// teacher sees the papers they set; the Principal sees all.
class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = context.select((AuthBloc b) => b.state.user);
    if (user == null) return const SizedBox.shrink();
    return DefaultTabController(
      length: 4,
      child: BlocBuilder<ExamsBloc, ExamsState>(
        builder: (context, all) {
          final state = all.visibleTo(user.id, isPrincipal: user.isPrincipal);
          return Scaffold(
            appBar: AppBar(
              title: Text(l.examsTitle),
              actions: [
                if (user.ownsQuestionBank)
                  IconButton(
                    tooltip: l.examsMyBank,
                    icon: const Icon(Icons.library_books_outlined),
                    onPressed: () => QuestionBankScreen.open(context),
                  ),
                TextButton(
                  onPressed: () => user.ownsQuestionBank
                      ? NewPaperSheet.show(context)
                      : CreatePaperScreen.open(context),
                  child: Text(l.examsNewPaper),
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(text: l.tabDrafts),
                  Tab(text: l.tabSent),
                  Tab(text: l.tabApproved),
                  Tab(text: l.tabDone),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _PaperList(papers: state.inProgress),
                _PaperList(papers: state.awaitingApproval),
                _PaperList(papers: state.ready),
                _PaperList(papers: state.past),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PaperList extends StatelessWidget {
  const _PaperList({required this.papers});

  final List<ExamPaper> papers;

  @override
  Widget build(BuildContext context) {
    if (papers.isEmpty) {
      return EmptyState(
        icon: Icons.description_outlined,
        message: context.l10n.emptyPapersHere,
      );
    }
    return ListView.separated(
      padding: AppSpacing.pageOf(context),
      itemCount: papers.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (_, i) => PaperCard(
        paper: papers[i],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PaperDetailScreen(paperId: papers[i].id),
          ),
        ),
      ),
    );
  }
}
