import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../bloc/question_bank_bloc.dart';
import '../widgets/unit_dialog.dart';
import 'unit_questions_screen.dart';

/// The teacher's units; each holds its questions.
class QuestionBankTab extends StatelessWidget {
  const QuestionBankTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<QuestionBankBloc, QuestionBankState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<QuestionBankBloc, QuestionBankState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: state.canManage
              ? FloatingActionButton.extended(
                  onPressed: state.busy ? null : () => showUnitDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(l.qbUnitAdd),
                )
              : null,
          body: AsyncBody(
            status: state.status,
            failure: state.failure,
            onRetry: () => context.read<QuestionBankBloc>().add(
              const QuestionBankStarted(),
            ),
            isEmpty: state.units.isEmpty,
            emptyText: l.qbUnitsEmpty,
            emptyIcon: Icons.quiz_outlined,
            builder: (context) => ListView(
              padding: AppSpacing.pageOf(context, fab: state.canManage),
              children: [
                for (final u in state.units)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => UnitQuestionsScreen(unit: u),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(u.name, style: context.text.titleSmall),
                                Text(
                                  l.qbUnitBy(
                                    u.teacherName,
                                    u.className,
                                    u.subject,
                                  ),
                                  style: context.text.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (state.canManage)
                            IconButton(
                              tooltip: l.qbUnitEdit,
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () =>
                                  showUnitDialog(context, existing: u),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
