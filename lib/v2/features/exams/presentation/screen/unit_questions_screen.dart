import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/exams.dart';
import '../bloc/unit_questions_bloc.dart';
import '../widgets/exam_labels.dart';
import '../widgets/question_dialog.dart';

/// The questions of one unit.
class UnitQuestionsScreen extends StatelessWidget {
  const UnitQuestionsScreen({super.key, required this.unit});

  final QuestionUnit unit;

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<UnitQuestionsBloc>(param1: unit.id, param2: account)
            ..add(const UnitQuestionsStarted()),
      child: _View(unit: unit),
    );
  }
}

class _View extends StatelessWidget {
  const _View({required this.unit});

  final QuestionUnit unit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<UnitQuestionsBloc, UnitQuestionsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<UnitQuestionsBloc, UnitQuestionsState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(unit.name)),
          floatingActionButton: state.canEdit
              ? FloatingActionButton.extended(
                  onPressed: state.busy
                      ? null
                      : () => showQuestionDialog(context, unitId: unit.id),
                  icon: const Icon(Icons.add),
                  label: Text(l.qbQuestionAdd),
                )
              : null,
          body: AsyncBody(
            status: state.status,
            failure: state.failure,
            onRetry: () => context.read<UnitQuestionsBloc>().add(
              const UnitQuestionsStarted(),
            ),
            isEmpty: state.questions.isEmpty,
            emptyText: l.qbQuestionsEmpty,
            emptyIcon: Icons.quiz_outlined,
            builder: (context) => ListView(
              padding: AppSpacing.pageOf(context, fab: state.canEdit),
              children: [
                for (final q in state.questions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      onTap: state.canEdit
                          ? () => showQuestionDialog(
                              context,
                              unitId: unit.id,
                              existing: q,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.text, style: context.text.bodyMedium),
                          Text(
                            '${q.type.label(l)} · ${q.marks}',
                            style: context.text.bodySmall,
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
