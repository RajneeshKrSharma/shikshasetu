import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/entities/day_time.dart';

/// "8:00 AM", in the way the phone shows times.
String formatDayTime(BuildContext context, DayTime? t) => t == null
    ? context.l10n.timingNotSet
    : TimeOfDay(hour: t.hour, minute: t.minute).format(context);

/// The short name of a weekday (1 = Monday).
String weekdayName(BuildContext context, int weekday) =>
    formatWeekdayShort(context, DateTime(2024, 1, weekday));

/// Asks for a time; null if dismissed.
Future<DayTime?> pickDayTime(BuildContext context, DayTime? initial) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(
      hour: initial?.hour ?? 8,
      minute: initial?.minute ?? 0,
    ),
  );
  return picked == null ? null : DayTime.hm(picked.hour, picked.minute);
}

/// A tinted card with a small caption and a value, that can be tapped.
class ValueCard extends StatelessWidget {
  const ValueCard({
    super.key,
    required this.caption,
    required this.value,
    required this.onTap,
  });

  final String caption;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.brand.primaryLight,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.lgAll,
      side: BorderSide(color: context.brand.primary.withValues(alpha: 0.5)),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(caption, style: context.text.bodySmall),
            const SizedBox(height: 2),
            Text(value, style: context.text.titleMedium),
          ],
        ),
      ),
    ),
  );
}

/// Monday to Sunday as chips that can be switched on and off.
class WeekdayChips extends StatelessWidget {
  const WeekdayChips({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  final Set<int> selected;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var d = 1; d <= 7; d++)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: FilterChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  weekdayName(context, d),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              selected: selected.contains(d),
              onSelected: (_) => onToggle(d),
            ),
          ),
        ),
    ],
  );
}

/// A plain note in a box.
class NoteBox extends StatelessWidget {
  const NoteBox(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: AppSpacing.card,
    decoration: BoxDecoration(
      color: AppColors.lateLight,
      borderRadius: AppRadius.lgAll,
      border: Border.all(color: AppColors.late.withValues(alpha: 0.6)),
    ),
    child: Text(
      text,
      style: context.text.bodySmall!.copyWith(color: AppColors.textPrimary),
    ),
  );
}
