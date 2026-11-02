import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/school_timing.dart';
import '../bloc/school_timing_bloc.dart';
import '../widgets/school_day_widgets.dart';
import '../widgets/timing_rule_sheet.dart';

/// When the school starts and ends, on which days, and any other timings.
class SchoolTimingScreen extends StatelessWidget {
  const SchoolTimingScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<SchoolTimingBloc>()..add(const SchoolTimingStarted()),
        child: const SchoolTimingScreen(),
      ),
    ),
  );

  Future<void> _editRule(
    BuildContext context, {
    TimingRule? existing,
    bool seasonal = false,
  }) async {
    final bloc = context.read<SchoolTimingBloc>();
    final choice = await TimingRuleSheet.show(
      context,
      existing: existing,
      seasonal: seasonal,
    );
    if (choice == null) return;
    bloc.add(
      choice.remove
          ? TimingRuleRemoved(choice.rule.id)
          : TimingRuleSaved(choice.rule),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.timingTitle)),
      body: BlocBuilder<SchoolTimingBloc, SchoolTimingState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final t = state.timing;
          final bloc = context.read<SchoolTimingBloc>();
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              Row(
                children: [
                  Expanded(
                    child: ValueCard(
                      caption: l.timingStarts,
                      value: formatDayTime(context, t.start),
                      onTap: () async {
                        final p = await pickDayTime(context, t.start);
                        if (p != null) bloc.add(SchoolStartChanged(p));
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ValueCard(
                      caption: l.timingEnds,
                      value: formatDayTime(context, t.end),
                      onTap: () async {
                        final p = await pickDayTime(context, t.end);
                        if (p != null) bloc.add(SchoolEndChanged(p));
                      },
                    ),
                  ),
                ],
              ),
              SectionLabel(l.timingWorkingDays),
              WeekdayChips(
                selected: t.workingDays,
                onToggle: (d) => bloc.add(WorkingDayToggled(d)),
              ),
              SectionLabel(l.timingClassRules),
              for (final r in t.classRules) ...[
                _RuleCard(
                  rule: r,
                  onTap: () => _editRule(context, existing: r),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              OutlinedButton(
                onPressed: () => _editRule(context),
                child: Text(l.timingAddAnother),
              ),
              SectionLabel(l.timingSeasonal),
              for (final r in t.seasonalRules) ...[
                _RuleCard(
                  rule: r,
                  onTap: () => _editRule(context, existing: r),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.timingSeasonalHint,
                        style: context.text.bodySmall,
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, AppSizes.buttonCompact),
                      ),
                      onPressed: () => _editRule(context, seasonal: true),
                      child: Text(l.timingAdd),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              NoteBox(l.timingNote),
            ],
          );
        },
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.rule, required this.onTap});

  final TimingRule rule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final range = l.periodTimeRange(
      formatDayTime(context, rule.start),
      formatDayTime(context, rule.end),
    );
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.classNames.isEmpty
                      ? l.filterAllClasses
                      : rule.classNames.join(', '),
                  style: context.text.titleSmall,
                ),
                Text(
                  rule.fromDate == null
                      ? range
                      : l.timingRuleFromDate(
                          range,
                          formatShortDate(context, rule.fromDate!),
                        ),
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, size: AppIconSize.md),
        ],
      ),
    );
  }
}
