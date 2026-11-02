import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../domain/entities/bell_slot.dart';
import '../../domain/entities/timetable.dart';
import '../bloc/timetable_bloc.dart';
import '../widgets/school_day_widgets.dart';

/// A class's timetable: pick a class and a day, then fill each period with a
/// subject and its teacher. A teacher busy elsewhere then is refused.
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  static Future<void> open(BuildContext context) {
    final classes = context.read<ClassesBloc>().state.classes;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<TimetableBloc>(
            param1: classes.isEmpty ? null : classes.first.name,
          )..add(const TimetableStarted()),
          child: const TimetableScreen(),
        ),
      ),
    );
  }

  String _slotName(BuildContext context, BellSlot slot, int number) =>
      slot.label.isNotEmpty ? slot.label : context.l10n.periodN(number);

  Future<void> _copy(BuildContext context, int from) async {
    final bloc = context.read<TimetableBloc>();
    final days = await showModalBottomSheet<Set<int>>(
      context: context,
      showDragHandle: true,
      builder: (_) => _CopySheet(from: from),
    );
    if (days != null && days.isNotEmpty) {
      bloc.add(TimetableCopyRequested(days.toList()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final classes = context.select((ClassesBloc b) => b.state.classes);
    return BlocListener<TimetableBloc, TimetableState>(
      listenWhen: (a, b) => a.copyId != b.copyId,
      listener: (context, state) {
        final r = state.copyResult!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.timetableCopied(r.copied, r.skipped))),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.timetableTitle),
          actions: [
            BlocBuilder<TimetableBloc, TimetableState>(
              buildWhen: (a, b) => a.weekday != b.weekday,
              builder: (context, state) => TextButton(
                onPressed: () => _copy(context, state.weekday),
                child: Text(l.timetableCopy),
              ),
            ),
          ],
        ),
        body: BlocBuilder<TimetableBloc, TimetableState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final table = state.timetable;
            if (classes.isEmpty || table == null) {
              return EmptyState(
                icon: Icons.class_outlined,
                message: l.accNoClasses,
              );
            }
            final bloc = context.read<TimetableBloc>();
            var number = 0;
            return ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final c in classes) ...[
                        ChoiceChip(
                          label: Text(c.name),
                          selected: state.className == c.name,
                          onSelected: (_) =>
                              bloc.add(TimetableClassChosen(c.name)),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    showSelectedIcon: false,
                    segments: [
                      for (var d = 1; d <= 6; d++)
                        ButtonSegment(
                          value: d,
                          label: Text(weekdayName(context, d)),
                        ),
                    ],
                    selected: {state.weekday},
                    onSelectionChanged: (v) =>
                        bloc.add(TimetableDayChosen(v.first)),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (state.conflict != null) ...[
                  NoteBox(
                    l.timetableConflict(
                      state.conflict!.teacherName,
                      l.classLabel(state.conflict!.className),
                      _slotName(
                        context,
                        state.conflict!.slot,
                        table.slots
                            .where(
                              (s) =>
                                  s.isPeriod &&
                                  s.position <= state.conflict!.slot.position,
                            )
                            .length,
                      ),
                      weekdayName(context, state.conflict!.weekday),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (table.slots.isEmpty)
                  EmptyState(
                    icon: Icons.schedule_outlined,
                    message: l.timetableNoSlots,
                  ),
                for (final slot in table.slots) ...[
                  if (slot.isPeriod)
                    _PeriodRow(
                      slot: slot,
                      name: _slotName(context, slot, ++number),
                      entry: table.entryOf(state.weekday, slot.id),
                      onTap: () => _pick(context, state, slot, number),
                    )
                  else
                    Opacity(opacity: 0.55, child: _BreakRow(slot: slot)),
                  const Divider(height: 1),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pick(
    BuildContext context,
    TimetableState state,
    BellSlot slot,
    int number,
  ) async {
    final bloc = context.read<TimetableBloc>();
    final l = context.l10n;
    final result = await showModalBottomSheet<_Pick>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PickSheet(
        title: l.timetablePickTitle(
          _slotName(context, slot, number),
          weekdayName(context, state.weekday),
        ),
        options: state.options,
        current: state.timetable!.entryOf(state.weekday, slot.id),
      ),
    );
    if (result == null) return;
    bloc.add(
      result.option == null
          ? TimetableEntryCleared(slot.id)
          : TimetableEntryPicked(slot.id, result.option!),
    );
  }
}

class _PeriodRow extends StatelessWidget {
  const _PeriodRow({
    required this.slot,
    required this.name,
    required this.entry,
    required this.onTap,
  });

  final BellSlot slot;
  final String name;
  final TimetableEntry? entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: context.brand.primaryLight,
              child: Text(
                name.replaceAll(RegExp(r'[^0-9]'), '').isEmpty
                    ? name.characters.first
                    : 'P${name.replaceAll(RegExp(r'[^0-9]'), '')}',
                style: context.text.labelSmall!.copyWith(
                  color: context.brand.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry?.subject ?? l.timetableNotSet,
                    style: context.text.titleSmall!.copyWith(
                      color: entry == null ? AppColors.textMuted : null,
                    ),
                  ),
                  Text(
                    [
                      formatDayTime(context, slot.start),
                      if (entry?.teacherName != null) entry!.teacherName!,
                    ].join(' · '),
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            StatusChip(
              label: l.timetableChange,
              color: AppColors.textMuted,
              background: AppColors.pendingLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakRow extends StatelessWidget {
  const _BreakRow({required this.slot});

  final BellSlot slot;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 16,
          child: Icon(Icons.free_breakfast, size: AppIconSize.sm),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slot.label.isEmpty ? context.l10n.periodKindBreak : slot.label,
                style: context.text.titleSmall,
              ),
              Text(
                context.l10n.periodTimeRange(
                  formatDayTime(context, slot.start),
                  formatDayTime(context, slot.end),
                ),
                style: context.text.bodySmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Pick {
  const _Pick(this.option);

  /// Null clears the period.
  final TeachingOption? option;
}

/// Chooses what is taught in a period, from what is allotted to the class.
class _PickSheet extends StatelessWidget {
  const _PickSheet({
    required this.title,
    required this.options,
    required this.current,
  });

  final String title;
  final List<TeachingOption> options;
  final TimetableEntry? current;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(title, style: context.text.titleMedium),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (options.isEmpty)
            Padding(padding: AppSpacing.page, child: Text(l.timetableNoOptions))
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final o in options)
                    ListTile(
                      title: Text(o.subject),
                      subtitle: Text(o.teacherName),
                      selected:
                          current?.subject == o.subject &&
                          current?.teacherId == o.teacherId,
                      onTap: () => Navigator.of(context).pop(_Pick(o)),
                    ),
                ],
              ),
            ),
          if (current != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(const _Pick(null)),
              child: Text(l.timetableClear),
            ),
        ],
      ),
    );
  }
}

/// Chooses the days to copy a day to.
class _CopySheet extends StatefulWidget {
  const _CopySheet({required this.from});

  final int from;

  @override
  State<_CopySheet> createState() => _CopySheetState();
}

class _CopySheetState extends State<_CopySheet> {
  late final ValueNotifier<Set<int>> _days;

  @override
  void initState() {
    super.initState();
    _days = ValueNotifier({});
  }

  @override
  void dispose() {
    _days.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Padding(
        padding: AppSpacing.page,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.timetableCopyTo(weekdayName(context, widget.from)),
              style: context.text.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            ValueListenableBuilder<Set<int>>(
              valueListenable: _days,
              builder: (context, picked, _) => Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (var d = 1; d <= 6; d++)
                    if (d != widget.from)
                      FilterChip(
                        label: Text(weekdayName(context, d)),
                        selected: picked.contains(d),
                        onSelected: (on) => _days.value = {
                          ...picked.where((x) => x != d),
                          if (on) d,
                        },
                      ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_days.value),
              child: Text(l.actionDone),
            ),
          ],
        ),
      ),
    );
  }
}
