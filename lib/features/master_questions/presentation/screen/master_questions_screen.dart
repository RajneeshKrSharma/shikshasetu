import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../exams/presentation/widgets/question_type_sheet.dart';
import '../bloc/master_browse_cubit.dart';
import '../bloc/master_questions_bloc.dart';
import '../widgets/master_filters.dart';
import '../widgets/master_question_tile.dart';
import 'master_question_form_screen.dart';

/// The bank of reusable questions: browse, add, edit and remove.
class MasterQuestionsScreen extends StatelessWidget {
  const MasterQuestionsScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const MasterQuestionsScreen()),
  );

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final l = context.l10n;
    final bloc = context.read<MasterQuestionsBloc>();
    final messenger = ScaffoldMessenger.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.masterRemoveTitle),
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
      bloc.add(MasterQuestionDeleted(id));
      messenger.showSnackBar(SnackBar(content: Text(l.masterRemoved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => MasterBrowseCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(l.masterTitle)),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () async {
            final type = await QuestionTypeSheet.show(context);
            if (type != null && context.mounted) {
              MasterQuestionFormScreen.open(context, type: type);
            }
          },
          icon: const Icon(Icons.add),
          label: Text(l.masterAdd),
        ),
        body: Column(
          children: [
            const MasterFilters(),
            Expanded(
              child: BlocBuilder<MasterQuestionsBloc, MasterQuestionsState>(
                builder: (context, bank) =>
                    BlocBuilder<MasterBrowseCubit, MasterBrowseState>(
                      builder: (context, browse) {
                        if (bank.questions.isEmpty) {
                          return EmptyState(
                            icon: Icons.library_books_outlined,
                            message: l.masterEmpty,
                          );
                        }
                        final items = bank.filtered(
                          query: browse.query,
                          types: browse.types,
                        );
                        if (items.isEmpty) {
                          return EmptyState(
                            icon: Icons.search_off,
                            message: l.masterNoMatch,
                          );
                        }
                        return ListView.separated(
                          padding: AppSpacing.pageOf(context, fab: true),
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (_, i) => MasterQuestionTile(
                            item: items[i],
                            onTap: () => MasterQuestionFormScreen.open(
                              context,
                              initial: items[i],
                            ),
                            trailing: IconButton(
                              tooltip: l.actionRemove,
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  _confirmDelete(context, items[i].id),
                            ),
                          ),
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
