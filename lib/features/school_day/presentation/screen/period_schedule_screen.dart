import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/bell_slot.dart';
import '../../domain/entities/day_time.dart';
import '../bloc/bell_schedule_bloc.dart';
import '../widgets/school_day_widgets.dart';
import 'timetable_screen.dart';

/// The school's bell: every period and break of the day, once for the whole
/// school. Classes fill in their subjects on the timetable.
class PeriodScheduleScreen extends StatelessWidget {
  const PeriodScheduleScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<BellScheduleBloc>()..add(const BellScheduleStarted()),
        child: const PeriodScheduleScreen(),
      ),
    ),
  );

  Future<void> _edit(BuildContext context, {BellSlot? slot}) async {
    final bloc = context.read<BellScheduleBloc>();
    final choice = await showModalBottomSheet<_SlotChoice>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _SlotSheet(existing: slot, after: bloc.state.slots),
    );
    if (choice == null) return;
    bloc.add(
      choice.remove ? BellSlotRemoved(slot!.id) : BellSlotSaved(choice.slot),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.periodsTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, AppSizes.buttonCompact),
              ),
              onPressed: () => _edit(context),
              child: Text(l.periodsAdd),
            ),
          ),
        ],
      ),
      body: BlocBuilder<BellScheduleBloc, BellScheduleState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              InfoBanner(message: l.periodsHint),
              const SizedBox(height: AppSpacing.md),
              for (final s in state.slots) ...[
                _SlotRow(
                  slot: s,
                  number: state.numberOf(s),
                  onEdit: () => _edit(context, slot: s),
                ),
                const Divider(height: 1),
              ],
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: () => TimetableScreen.open(context),
                child: Text(l.periodsTimetableButton),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SlotRow extends StatelessWidget {
  const _SlotRow({
    required this.slot,
    required this.number,
    required this.onEdit,
  });

  final BellSlot slot;
  final int number;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final title = slot.label.isNotEmpty
        ? slot.label
        : (slot.isPeriod ? l.periodN(number) : l.periodKindBreak);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: slot.isPeriod
                ? context.brand.primaryLight
                : AppColors.lateLight,
            child: Icon(
              slot.isPeriod ? Icons.menu_book_outlined : Icons.free_breakfast,
              size: AppIconSize.sm,
              color: slot.isPeriod ? context.brand.primary : AppColors.late,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall),
                Text(
                  '${l.periodTimeRange(formatDayTime(context, slot.start), formatDayTime(context, slot.end))}'
                  ' · ${l.periodMinutes(slot.minutes)}',
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          if (slot.isPeriod)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, AppSizes.buttonCompact),
              ),
              onPressed: onEdit,
              child: Text(l.periodEdit),
            )
          else
            InkWell(
              onTap: onEdit,
              child: StatusChip(
                label: l.periodBreakTag,
                color: AppColors.late,
                background: AppColors.lateLight,
              ),
            ),
        ],
      ),
    );
  }
}

class _SlotChoice {
  const _SlotChoice(this.slot, {this.remove = false});

  final BellSlot slot;
  final bool remove;
}

/// Sets one period or break: what it is, its name and its times.
class _SlotSheet extends StatefulWidget {
  const _SlotSheet({required this.after, this.existing});

  final BellSlot? existing;

  /// The day so far, so a new one can start where the last one ended.
  final List<BellSlot> after;

  @override
  State<_SlotSheet> createState() => _SlotSheetState();
}

class _SlotSheetState extends State<_SlotSheet> {
  late final TextEditingController _label;
  late final ValueNotifier<SlotKind> _kind;
  late final ValueNotifier<DayTime> _start;
  late final ValueNotifier<DayTime> _end;
  late final ValueNotifier<bool> _backwards;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final last = widget.after.isEmpty ? null : widget.after.last;
    _label = TextEditingController(text: e?.label ?? '');
    _kind = ValueNotifier(e?.kind ?? SlotKind.period);
    _start = ValueNotifier(e?.start ?? last?.end ?? const DayTime.hm(8, 0));
    _end = ValueNotifier(e?.end ?? DayTime((last?.end.minutes ?? 480) + 40));
    _backwards = ValueNotifier(false);
  }

  @override
  void dispose() {
    _label.dispose();
    _kind.dispose();
    _start.dispose();
    _end.dispose();
    _backwards.dispose();
    super.dispose();
  }

  void _save() {
    if (!_start.value.isBefore(_end.value)) {
      _backwards.value = true;
      return;
    }
    final e = widget.existing;
    Navigator.of(context).pop(
      _SlotChoice(
        BellSlot(
          id: e?.id ?? '',
          position: e?.position ?? widget.after.length,
          kind: _kind.value,
          label: _label.text.trim(),
          start: _start.value,
          end: _end.value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<SlotKind>(
              valueListenable: _kind,
              builder: (context, k, _) => SegmentedButton<SlotKind>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: SlotKind.period,
                    label: Text(l.periodKindPeriod),
                  ),
                  ButtonSegment(
                    value: SlotKind.breakTime,
                    label: Text(l.periodKindBreak),
                  ),
                ],
                selected: {k},
                onSelectionChanged: (v) => _kind.value = v.first,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _label,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.periodLabel),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<DayTime>(
                    valueListenable: _start,
                    builder: (context, t, _) => ValueCard(
                      caption: l.timingStarts,
                      value: formatDayTime(context, t),
                      onTap: () async {
                        final p = await pickDayTime(context, t);
                        if (p != null) _start.value = p;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ValueListenableBuilder<DayTime>(
                    valueListenable: _end,
                    builder: (context, t, _) => ValueCard(
                      caption: l.timingEnds,
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
            ValueListenableBuilder<bool>(
              valueListenable: _backwards,
              builder: (context, bad, _) => bad
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        l.periodEndBeforeStart,
                        style: context.text.bodySmall!.copyWith(
                          color: AppColors.absent,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: _save, child: Text(l.actionSave)),
            if (widget.existing != null)
              TextButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(_SlotChoice(widget.existing!, remove: true)),
                child: Text(l.periodRemove),
              ),
          ],
        ),
      ),
    );
  }
}
