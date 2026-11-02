import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../bloc/master_browse_cubit.dart';
import '../bloc/master_questions_bloc.dart';
import '../widgets/master_filters.dart';
import '../widgets/master_question_tile.dart';

/// Pick questions from the master bank to add to a paper. Pops with the
/// chosen questions (or null).
class MasterQuestionPickerScreen extends StatelessWidget {
  const MasterQuestionPickerScreen({super.key, this.subject});

  /// Only show questions for this subject (and those with no subject).
  final String? subject;

  static Future<List<Question>?> pick(
    BuildContext context, {
    String? subject,
  }) => Navigator.of(context).push<List<Question>>(
    MaterialPageRoute(
      builder: (_) => MasterQuestionPickerScreen(subject: subject),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => MasterBrowseCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(l.masterPickTitle)),
        body: Column(
          children: [
            const MasterFilters(),
            Expanded(
              child: BlocBuilder<MasterQuestionsBloc, MasterQuestionsState>(
                builder: (context, bank) =>
                    BlocBuilder<MasterBrowseCubit, MasterBrowseState>(
                      builder: (context, browse) {
                        final items = bank.filtered(
                          query: browse.query,
                          types: browse.types,
                          subject: subject,
                        );
                        if (items.isEmpty) {
                          return EmptyState(
                            icon: Icons.library_books_outlined,
                            message: bank.questions.isEmpty
                                ? l.masterEmpty
                                : l.masterNoMatch,
                          );
                        }
                        final cubit = context.read<MasterBrowseCubit>();
                        return ListView.separated(
                          padding: AppSpacing.pageOf(context),
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (_, i) => MasterQuestionTile(
                            item: items[i],
                            onTap: () => cubit.toggleSelected(items[i].id),
                            leading: Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.md,
                              ),
                              child: Icon(
                                browse.selected.contains(items[i].id)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: browse.selected.contains(items[i].id)
                                    ? context.brand.primary
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: AppSpacing.pageOf(context),
            child: BlocBuilder<MasterBrowseCubit, MasterBrowseState>(
              buildWhen: (a, b) => a.selected != b.selected,
              builder: (context, browse) => FilledButton(
                onPressed: browse.selected.isEmpty
                    ? null
                    : () => Navigator.of(context).pop([
                        for (final m
                            in context
                                .read<MasterQuestionsBloc>()
                                .state
                                .questions)
                          if (browse.selected.contains(m.id)) m.question,
                      ]),
                child: Text(l.masterAddSelected(browse.selected.length)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
