import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../domain/entities/day_time.dart';
import '../../domain/entities/school_timing.dart';
import 'school_day_widgets.dart';

/// What was chosen in the sheet: a rule to save, or to remove.
class TimingRuleChoice {
  const TimingRuleChoice(this.rule, {this.remove = false});

  final TimingRule rule;
  final bool remove;
}

/// Sets a timing for some classes, or from a date. Closes with the rule to
/// save, or with nothing if dismissed.
class TimingRuleSheet extends StatefulWidget {
  const TimingRuleSheet({super.key, this.existing, this.seasonal = false});

  final TimingRule? existing;

  /// Starts with a "from" date, for summer and winter timings.
  final bool seasonal;

  static Future<TimingRuleChoice?> show(
    BuildContext context, {
    TimingRule? existing,
    bool seasonal = false,
  }) => showModalBottomSheet<TimingRuleChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => TimingRuleSheet(existing: existing, seasonal: seasonal),
  );

  @override
  State<TimingRuleSheet> createState() => _TimingRuleSheetState();
}

class _TimingRuleSheetState extends State<TimingRuleSheet> {
  late final ValueNotifier<DayTime> _start;
  late final ValueNotifier<DayTime> _end;
  late final ValueNotifier<DateTime?> _from;
  late final ValueNotifier<Set<String>> _classes;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _start = ValueNotifier(e?.start ?? const DayTime.hm(8, 0));
    _end = ValueNotifier(e?.end ?? const DayTime.hm(13, 0));
    _from = ValueNotifier(
      e?.fromDate ?? (widget.seasonal ? DateTime.now() : null),
    );
    _classes = ValueNotifier({...?e?.classNames});
  }

  @override
  void dispose() {
    _start.dispose();
    _end.dispose();
    _from.dispose();
    _classes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final classes = context.read<ClassesBloc>().state.classes;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.timingRuleTitle, style: context.text.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<DayTime>(
                    valueListenable: _start,
                    builder: (context, t, _) => PickerField(
                      label: l.timingStarts,
                      suffixIcon: Icons.schedule,
                      value: formatDayTime(context, t),
                      onTap: () async {
                        final p = await pickDayTime(context, t);
                        if (p != null) _start.value = p;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ValueListenableBuilder<DayTime>(
                    valueListenable: _end,
                    builder: (context, t, _) => PickerField(
                      label: l.timingEnds,
                      suffixIcon: Icons.schedule,
                      value: formatDayTime(context, t),
                      onTap: () async {
                        final p = await pickDayTime(context, t);
                        if (p != null) _end.value = p;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ValueListenableBuilder<DateTime?>(
              valueListenable: _from,
              builder: (context, d, _) => PickerField(
                label: l.timingRuleFrom,
                value: d == null
                    ? l.timingRuleFromNone
                    : formatShortDate(context, d),
                onTap: () async {
                  final p = await showDatePicker(
                    context: context,
                    initialDate: d ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (p != null) _from.value = p;
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.timingRuleClasses, style: context.text.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            ValueListenableBuilder<Set<String>>(
              valueListenable: _classes,
              builder: (context, picked, _) => Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final c in classes)
                    FilterChip(
                      label: Text(c.name),
                      selected: picked.contains(c.name),
                      onSelected: (on) => _classes.value = {
                        ...picked.where((x) => x != c.name),
                        if (on) c.name,
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(
                TimingRuleChoice(
                  TimingRule(
                    id: widget.existing?.id ?? '',
                    start: _start.value,
                    end: _end.value,
                    classNames: _classes.value.toList(),
                    fromDate: _from.value,
                  ),
                ),
              ),
              child: Text(l.actionSave),
            ),
            if (widget.existing != null)
              TextButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(TimingRuleChoice(widget.existing!, remove: true)),
                child: Text(l.timingRuleRemove),
              ),
          ],
        ),
      ),
    );
  }
}
