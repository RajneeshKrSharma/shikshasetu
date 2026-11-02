import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../exams/presentation/widgets/question_type_style.dart';
import '../../domain/entities/paper_plan.dart';
import '../bloc/paper_maker_cubit.dart';

/// Step 3: for each type of question found in the chosen units, which units
/// to take from, how many questions and how many marks each.
class PaperMakerTypes extends StatelessWidget {
  const PaperMakerTypes({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperMakerCubit>();
    return BlocBuilder<PaperMakerCubit, PaperMakerState>(
      builder: (context, s) {
        final names = {for (final u in s.units) u.unit.id: u.unit.name};
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  Text(
                    l.makePlanned(s.plannedMarks, s.totalMarksValue),
                    style: context.text.titleMedium!.copyWith(
                      color: s.plannedMarks == s.totalMarksValue
                          ? AppColors.present
                          : AppColors.late,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(l.makeTypesHave, style: context.text.titleSmall),
                  const SizedBox(height: AppSpacing.md),
                  for (final a in s.availability) ...[
                    _TypeCard(
                      availability: a,
                      plan: s.plans[a.type]!,
                      names: names,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.pageOf(context),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: cubit.makeSet,
                    child: Text(l.makeMakeSet),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.availability,
    required this.plan,
    required this.names,
  });

  final TypeAvailability availability;
  final TypePlan plan;
  final Map<String, String> names;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperMakerCubit>();
    final type = availability.type;
    final have = [
      for (final e in availability.perUnit.entries)
        if (plan.unitIds.contains(e.key)) e.value,
    ].fold(0, (a, b) => a + b);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(type.label(l), style: context.text.titleSmall),
              ),
              Text(
                plan.count == 0
                    ? l.makeNotUsed
                    : l.makeAvailable(availability.total),
                style: context.text.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l.makeTakeFrom, style: context.text.labelSmall),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final e in availability.perUnit.entries)
                if (e.value > 0)
                  FilterChip(
                    label: Text('${names[e.key] ?? ''} · ${e.value}'),
                    selected: plan.unitIds.contains(e.key),
                    onSelected: (_) => cubit.planUnitToggled(type, e.key),
                  ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _Stepper(
                  label: l.makeQuestions,
                  value: plan.count,
                  onChanged: (v) => cubit.planCountChanged(type, v),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _Stepper(
                  label: l.makeMarksEach,
                  value: plan.marksEach,
                  onChanged: (v) => cubit.planMarksChanged(type, v),
                ),
              ),
            ],
          ),
          if (plan.count > have)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                l.makeShort(plan.count, have),
                style: context.text.bodySmall!.copyWith(color: AppColors.late),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.labelSmall),
        Row(
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => onChanged(value - 1),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$value', style: context.text.titleMedium),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => onChanged(value + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}
