import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../utils/context_ext.dart';
import '../utils/date_format.dart';
import '../utils/date_range.dart';

/// Picks a span of days for a filter: quick choices (any, today, this week,
/// this month) and a calendar for anything else. One day is a valid range.
class DateRangeChips extends StatelessWidget {
  const DateRangeChips({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5, 12, 31),
      initialDateRange: value,
      saveText: context.l10n.feesShowResults,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    final presets = <(String, DateTimeRange)>[
      (l.dateToday, DateRanges.today(now)),
      (l.dateThisWeek, DateRanges.thisWeek(now)),
      (l.dateThisMonth, DateRanges.thisMonth(now)),
    ];
    final isPreset = value != null && presets.any((p) => p.$2 == value);
    final isCustom = value != null && !isPreset;
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        ChoiceChip(
          label: Text(l.dateAnyTime),
          selected: value == null,
          onSelected: (_) => onChanged(null),
        ),
        for (final (label, range) in presets)
          ChoiceChip(
            label: Text(label),
            selected: value == range,
            onSelected: (_) => onChanged(range),
          ),
        ChoiceChip(
          avatar: const Icon(
            Icons.calendar_month_outlined,
            size: AppIconSize.sm,
          ),
          label: Text(
            isCustom ? formatDateRange(context, value!) : l.datePickRange,
          ),
          selected: isCustom,
          onSelected: (_) => _pick(context),
        ),
      ],
    );
  }
}
