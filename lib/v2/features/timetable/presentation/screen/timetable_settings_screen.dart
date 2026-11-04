import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/picker_field.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/server/json.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../../exams/domain/entities/exams.dart';
import '../../../exams/presentation/widgets/exam_labels.dart';
import '../../domain/entities/timetable.dart';
import '../bloc/timetable_settings_cubit.dart';

/// Where the Principal decides how exam timetables are made in the school.
/// Pops with the saved settings.
class TimetableSettingsScreen extends StatelessWidget {
  const TimetableSettingsScreen({super.key, required this.initial});

  final TimetableSettings initial;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<TimetableSettingsCubit>(param1: initial),
    child: _SettingsForm(initial: initial),
  );
}

class _SettingsForm extends StatefulWidget {
  const _SettingsForm({required this.initial});

  final TimetableSettings initial;

  @override
  State<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<_SettingsForm> {
  late final TextEditingController _marks;
  late final TextEditingController _duration;
  late final TextEditingController _gap;
  late final Map<ExamType, TextEditingController> _names;

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    _marks = TextEditingController(text: '${s.defaultMaxMarks}');
    _duration = TextEditingController(text: '${s.defaultDurationMinutes}');
    _gap = TextEditingController(text: '${s.minGapDays}');
    _names = {
      for (final t in ExamType.values)
        t: TextEditingController(text: s.labelOf(t)),
    };
  }

  @override
  void dispose() {
    _marks.dispose();
    _duration.dispose();
    _gap.dispose();
    for (final c in _names.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<TimetableSettingsCubit>();
    return FailureToast<TimetableSettingsCubit, TimetableSettingsState>(
      failureOf: (s) => s.failure,
      child: BlocListener<TimetableSettingsCubit, TimetableSettingsState>(
        listenWhen: (a, b) => b.saved != null && a.saved != b.saved,
        listener: (context, s) => Navigator.of(context).pop(s.saved),
        child: Scaffold(
          appBar: AppBar(title: Text(l.ttbSettings)),
          body: BlocBuilder<TimetableSettingsCubit, TimetableSettingsState>(
            builder: (context, state) {
              final s = state.settings;
              void edit(TimetableSettings next) => cubit.edit(next);
              return ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  SectionTitle(l.ttbSetNames),
                  for (final t in ExamType.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: TextField(
                        controller: _names[t],
                        maxLength: 40,
                        decoration: InputDecoration(labelText: t.label(l)),
                        onChanged: (v) => edit(
                          s.copyWith(typeLabels: {...s.typeLabels, t: v}),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _marks,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: l.ttbSetMarks),
                          onChanged: (v) {
                            final n = int.tryParse(v.trim());
                            if (n != null) edit(s.copyWith(defaultMaxMarks: n));
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _duration,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l.ttbSetDuration,
                          ),
                          onChanged: (v) {
                            final n = int.tryParse(v.trim());
                            if (n != null) {
                              edit(s.copyWith(defaultDurationMinutes: n));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.ttbSetShowTime),
                    value: s.showTime,
                    onChanged: (v) => edit(s.copyWith(showTime: v)),
                  ),
                  if (s.showTime)
                    Row(
                      children: [
                        Expanded(
                          child: PickerField(
                            label: l.ttbSetStart,
                            suffixIcon: Icons.schedule,
                            value: s.defaultStartMinutes == null
                                ? null
                                : WireFormat.minutes(s.defaultStartMinutes!),
                            onTap: () => _pickStart(context, s, edit),
                          ),
                        ),
                        if (s.defaultStartMinutes != null)
                          IconButton(
                            tooltip: l.actionRemove,
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                edit(s.copyWith(clearDefaultStart: true)),
                          ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionTitle(l.ttbSetSameDay),
                  SegmentedButton<SameDayRule>(
                    segments: [
                      ButtonSegment(
                        value: SameDayRule.allow,
                        label: Text(l.ttbRuleAllow),
                      ),
                      ButtonSegment(
                        value: SameDayRule.warn,
                        label: Text(l.ttbRuleWarn),
                      ),
                      ButtonSegment(
                        value: SameDayRule.block,
                        label: Text(l.ttbRuleBlock),
                      ),
                    ],
                    selected: {s.sameDayRule},
                    onSelectionChanged: (v) =>
                        edit(s.copyWith(sameDayRule: v.first)),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _gap,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l.ttbSetGap),
                    onChanged: (v) {
                      final n = int.tryParse(v.trim());
                      if (n != null) edit(s.copyWith(minGapDays: n));
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionTitle(l.ttbSetOffDays),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      for (var i = 0; i < 7; i++)
                        FilterChip(
                          // 1 January 2024 was a Monday.
                          label: Text(
                            formatWeekdayShort(
                              context,
                              DateTime(2024, 1, 1 + i),
                            ),
                          ),
                          selected: s.offWeekdays.contains(i),
                          onSelected: (on) => edit(
                            s.copyWith(
                              offWeekdays: on
                                  ? [...s.offWeekdays, i]
                                  : [
                                      for (final d in s.offWeekdays)
                                        if (d != i) d,
                                    ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionTitle(l.ttbSetOffDates),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final d in s.offDates)
                        InputChip(
                          label: Text(formatShortDate(context, d)),
                          onDeleted: () => edit(
                            s.copyWith(
                              offDates: [
                                for (final x in s.offDates)
                                  if (x != d) x,
                              ],
                            ),
                          ),
                        ),
                      ActionChip(
                        avatar: const Icon(Icons.add),
                        label: Text(l.ttbAddDate),
                        onPressed: () => _addDate(context, s, edit),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: state.busy ? null : cubit.save,
                    child: Text(l.actionSave),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickStart(
    BuildContext context,
    TimetableSettings s,
    ValueChanged<TimetableSettings> edit,
  ) async {
    final start = s.defaultStartMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: start == null
          ? const TimeOfDay(hour: 10, minute: 0)
          : TimeOfDay(hour: start ~/ 60, minute: start % 60),
    );
    if (picked != null) {
      edit(s.copyWith(defaultStartMinutes: picked.hour * 60 + picked.minute));
    }
  }

  Future<void> _addDate(
    BuildContext context,
    TimetableSettings s,
    ValueChanged<TimetableSettings> edit,
  ) async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(today.year - 1, 1, 1),
      lastDate: DateTime(today.year + 3, 12, 31),
    );
    if (picked != null && !s.offDates.contains(picked)) {
      edit(s.copyWith(offDates: [...s.offDates, picked]));
    }
  }
}
