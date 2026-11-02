import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../exams/presentation/widgets/question_type_style.dart';
import '../bloc/paper_maker_cubit.dart';

/// The other questions of the same type that could take the place of one
/// in the set.
class ReplaceQuestionScreen extends StatelessWidget {
  const ReplaceQuestionScreen({super.key});

  static Future<void> open(BuildContext context) {
    final cubit = context.read<PaperMakerCubit>();
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const ReplaceQuestionScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperMakerCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(l.makeReplaceTitle)),
      body: BlocBuilder<PaperMakerCubit, PaperMakerState>(
        builder: (context, s) {
          final index = s.replaceIndex;
          if (index == null) return const SizedBox.shrink();
          final old = s.set.questions[index];
          final names = {for (final u in s.units) u.unit.id: u.unit.name};
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.makeReplacing, style: context.text.labelSmall),
                    Text(old.bank.question.text),
                    Text(
                      '${old.type.label(l)} · '
                      '${names[old.bank.unitId] ?? ''} · ${old.marks}',
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l.makeOtherOfType, style: context.text.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              if (s.candidates.isEmpty)
                Text(l.makeNoOthers, style: context.text.bodySmall),
              for (final q in s.candidates)
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
                            Text(q.question.text),
                            Text(
                              names[q.unitId] ?? '',
                              style: context.text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          cubit.replaced(q);
                          Navigator.of(context).pop();
                        },
                        child: Text(l.makeUse),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              Text(l.makeReplaceHint, style: context.text.bodySmall),
            ],
          );
        },
      ),
    );
  }
}
