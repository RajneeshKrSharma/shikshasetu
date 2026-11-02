import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../exams/presentation/widgets/question_type_style.dart';
import '../../domain/entities/bank_unit.dart';
import '../bloc/unit_questions_cubit.dart';
import '../widgets/add_questions_sheet.dart';

/// The questions in one unit of the bank.
class UnitQuestionsScreen extends StatelessWidget {
  const UnitQuestionsScreen({super.key, required this.unit});

  final BankUnit unit;

  static Future<void> open(BuildContext context, BankUnit unit) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<UnitQuestionsCubit>(param1: unit.scope, param2: unit.id)
                  ..load(),
            child: UnitQuestionsScreen(unit: unit),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<UnitQuestionsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(unit.name),
        actions: [
          TextButton(
            onPressed: () async {
              await AddQuestionsSheet.show(
                context,
                unit.scope,
                unitId: unit.id,
              );
              await cubit.load();
            },
            child: Text(l.bankAddQuestion),
          ),
        ],
      ),
      body: BlocBuilder<UnitQuestionsCubit, UnitQuestionsState>(
        builder: (context, s) {
          if (s.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.questions.isEmpty) {
            return EmptyState(
              icon: Icons.help_outline,
              message: l.bankUnitEmpty,
            );
          }
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              for (final q in s.questions)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.question.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              q.question.type.label(l),
                              style: context.text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l.actionDelete,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => cubit.remove(q.id),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
