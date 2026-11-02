import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/presentation/bloc/exams_bloc.dart';
import '../../../exams/presentation/widgets/exam_kind_style.dart';
import '../../domain/entities/bank_scope.dart';
import '../bloc/paper_maker_cubit.dart';
import '../widgets/paper_maker_review.dart';
import '../widgets/paper_maker_types.dart';

/// Makes an exam paper from the teacher's own bank, in five steps.
class PaperMakerScreen extends StatelessWidget {
  const PaperMakerScreen({super.key});

  static Future<void> open(BuildContext context, [BankScope? scope]) {
    final user = context.read<AuthBloc>().state.user!;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) =>
              sl<PaperMakerCubit>(param1: user.id, param2: scope)..load(),
          child: const PaperMakerScreen(),
        ),
      ),
    );
  }

  String _problem(MakerProblem p, BuildContext context, PaperMakerState s) {
    final l = context.l10n;
    return switch (p) {
      MakerProblem.needTotals => l.makeNeedTotal,
      MakerProblem.needUnits => l.makeNeedUnits,
      MakerProblem.needTypes => l.makeNeedTypes,
      MakerProblem.mismatch => l.makeMismatch(s.set.marks, s.totalMarksValue),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperMakerCubit>();
    return BlocConsumer<PaperMakerCubit, PaperMakerState>(
      listenWhen: (a, b) => a.result != b.result && b.result != null,
      listener: (context, s) {
        final messenger = ScaffoldMessenger.of(context);
        context.read<ExamsBloc>().add(const ExamsLoaded());
        Navigator.of(context).popUntil((r) => r.isFirst);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              s.result == MakerResult.sent ? l.makeSent : l.makeDraftSaved,
            ),
          ),
        );
      },
      builder: (context, s) => PopScope(
        canPop: s.step == 1,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) cubit.back();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.makeTitle),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Center(
                  child: Text(
                    l.makeStep(s.step),
                    style: context.text.labelMedium,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              if (s.problem != null)
                Container(
                  width: double.infinity,
                  color: AppColors.lateLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Text(_problem(s.problem!, context, s)),
                ),
              Expanded(
                child: switch (s.step) {
                  1 => const _KindStep(),
                  2 => const _UnitsStep(),
                  3 => const PaperMakerTypes(),
                  4 => const PaperMakerReview(),
                  _ => const _SendStep(),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: AppSpacing.pageOf(context),
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            Expanded(child: children[i]),
          ],
        ],
      ),
    ),
  );
}

class _KindStep extends StatelessWidget {
  const _KindStep();

  Future<void> _pickDate(BuildContext context, PaperMakerState s) async {
    final cubit = context.read<PaperMakerCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: s.date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) cubit.dateChosen(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperMakerCubit>();
    return BlocBuilder<PaperMakerCubit, PaperMakerState>(
      builder: (context, s) => Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                Text(l.makeExamType, style: context.text.titleSmall),
                RadioGroup<ExamKind>(
                  groupValue: s.kind,
                  onChanged: (k) {
                    if (k != null) cubit.kindChosen(k);
                  },
                  child: Column(
                    children: [
                      for (final k in ExamKind.values)
                        RadioListTile<ExamKind>(
                          contentPadding: EdgeInsets.zero,
                          value: k,
                          title: Text(k.label(l)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (s.scopes.length > 1) ...[
                  Wrap(
                    spacing: AppSpacing.md,
                    children: [
                      for (final sc in s.scopes)
                        ChoiceChip(
                          label: Text(
                            '${l.classLabel(sc.classSection)} · ${sc.subject}',
                          ),
                          selected: sc == s.scope,
                          onSelected: (_) => cubit.scopeChosen(sc),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ] else if (s.scope != null) ...[
                  Text(
                    '${l.classLabel(s.scope!.classSection)} · '
                    '${s.scope!.subject}',
                    style: context.text.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ] else
                  Text(l.bankNoScopes),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: s.totalMarks,
                        keyboardType: TextInputType.number,
                        onChanged: cubit.totalMarksChanged,
                        decoration: InputDecoration(
                          labelText: l.makeTotalMarks,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        initialValue: s.minutes,
                        keyboardType: TextInputType.number,
                        onChanged: cubit.minutesChanged,
                        decoration: InputDecoration(labelText: l.makeTime),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.makeDate),
                  subtitle: Text(formatLongDate(context, s.date)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () => _pickDate(context, s),
                ),
              ],
            ),
          ),
          _BottomBar(
            children: [
              FilledButton(
                onPressed: s.scope == null ? null : cubit.toUnits,
                child: Text(l.makeNextUnits),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnitsStep extends StatelessWidget {
  const _UnitsStep();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperMakerCubit>();
    return BlocBuilder<PaperMakerCubit, PaperMakerState>(
      builder: (context, s) {
        final chosen = [
          for (final u in s.units)
            if (s.unitIds.contains(u.unit.id)) u,
        ];
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  Text(l.makePickUnits, style: context.text.titleSmall),
                  for (final u in s.units)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: s.unitIds.contains(u.unit.id),
                      onChanged: u.total == 0
                          ? null
                          : (_) => cubit.unitToggled(u.unit.id),
                      title: Text(u.unit.name),
                      subtitle: Text(
                        u.total == 0
                            ? l.makeNoQuestions
                            : l.makeUnitCount(u.total),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                l.makeUnitsSummary(
                  chosen.length,
                  chosen.fold(0, (a, u) => a + u.total),
                ),
                style: context.text.bodySmall,
              ),
            ),
            _BottomBar(
              children: [
                FilledButton(
                  onPressed: cubit.toTypes,
                  child: Text(l.makeNextTypes),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SendStep extends StatelessWidget {
  const _SendStep();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PaperMakerCubit>();
    return BlocBuilder<PaperMakerCubit, PaperMakerState>(
      builder: (context, s) {
        final scope = s.scope!;
        final title =
            '${s.kind.label(l)} · ${l.classLabel(scope.classSection)}';
        final names = [
          for (final u in s.units)
            if (s.unitIds.contains(u.unit.id)) u.unit.name,
        ];
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.text.titleMedium),
                        Text(
                          l.makeSummaryLine(
                            scope.subject,
                            s.totalMarksValue,
                            s.minutesValue,
                          ),
                          style: context.text.bodySmall,
                        ),
                        Text(
                          formatLongDate(context, s.date),
                          style: context.text.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(names.join(', '), style: context.text.bodySmall),
                        Text(
                          l.makeUnitCount(s.set.questions.length),
                          style: context.text.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l.makeMadeFrom(s.replaced),
                          style: context.text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _BottomBar(
              children: [
                OutlinedButton(
                  onPressed: s.saving
                      ? null
                      : () => cubit.finish(title: title, send: false),
                  child: Text(l.makeSaveDraft),
                ),
                FilledButton(
                  onPressed: s.saving
                      ? null
                      : () => cubit.finish(title: title, send: true),
                  child: Text(l.makeSend),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
