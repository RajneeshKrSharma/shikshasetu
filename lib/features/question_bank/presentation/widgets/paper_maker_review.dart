import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/presentation/widgets/question_type_style.dart';
import '../bloc/paper_maker_cubit.dart';
import '../screen/replace_question_screen.dart';

/// Step 4: the set that was made, grouped by type, each question with its
/// unit and a Replace button.
class PaperMakerReview extends StatelessWidget {
  const PaperMakerReview({super.key});

  String _letter(int i) => String.fromCharCode(0x41 + i);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperMakerCubit>();
    return BlocBuilder<PaperMakerCubit, PaperMakerState>(
      builder: (context, s) {
        final names = {for (final u in s.units) u.unit.id: u.unit.name};
        final questions = s.set.questions;
        final types = <QuestionType>[
          for (final q in questions)
            if (!questions
                .sublist(0, questions.indexOf(q))
                .any((p) => p.type == q.type))
              q.type,
        ];
        var number = 0;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  Row(
                    children: [
                      Text(
                        l.makeMarksOf(s.set.marks, s.totalMarksValue),
                        style: context.text.titleMedium!.copyWith(
                          color: s.set.marks == s.totalMarksValue
                              ? AppColors.present
                              : AppColors.late,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l.makeUnitCount(questions.length),
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                  for (final (ti, t) in types.indexed) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.lg,
                        bottom: AppSpacing.sm,
                      ),
                      child: Text(
                        '${_letter(ti)} · ${t.label(l)}',
                        style: context.text.titleSmall,
                      ),
                    ),
                    for (var i = 0; i < questions.length; i++)
                      if (questions[i].type == t)
                        _Row(
                          number: ++number,
                          text: questions[i].bank.question.text,
                          unit: names[questions[i].bank.unitId] ?? '',
                          marks: questions[i].marks,
                          onReplace: () async {
                            await cubit.openReplace(i);
                            if (context.mounted) {
                              await ReplaceQuestionScreen.open(context);
                            }
                          },
                        ),
                  ],
                  for (final e in s.set.shortBy.entries)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Text(
                        '${e.key.label(l)}: ${l.makeShort(e.value, 0)}',
                        style: context.text.bodySmall!.copyWith(
                          color: AppColors.late,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.pageOf(context),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: cubit.makeSet,
                        child: Text(l.makeNewSet),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: cubit.toSend,
                        child: Text(l.makeNext),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.number,
    required this.text,
    required this.unit,
    required this.marks,
    required this.onReplace,
  });

  final int number;
  final String text;
  final String unit;
  final int marks;
  final VoidCallback onReplace;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text('$number', style: context.text.bodySmall),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyMedium,
                ),
                Text('$unit · $marks', style: context.text.bodySmall),
              ],
            ),
          ),
          TextButton(onPressed: onReplace, child: Text(l.makeReplace)),
        ],
      ),
    );
  }
}
