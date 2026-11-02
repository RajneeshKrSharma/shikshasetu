import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';

/// Placeholder shown where a time has not been recorded yet.
const String kNoTime = '--:--';

String formatTime(BuildContext context, DateTime? t) => t == null
    ? kNoTime
    : DateFormat.jm(Localizations.localeOf(context).toString()).format(t);

String formatLongDate(BuildContext context, DateTime d) => DateFormat(
  'EEEE, d MMMM y',
  Localizations.localeOf(context).toString(),
).format(d);

String formatShortDate(BuildContext context, DateTime d) =>
    DateFormat('d MMM y', Localizations.localeOf(context).toString()).format(d);

String formatDuration(AppLocalizations l, Duration d) =>
    l.durationHoursMinutes(d.inHours, d.inMinutes.remainder(60));

/// Short weekday, e.g. "Thu".
String formatWeekdayShort(BuildContext context, DateTime d) =>
    DateFormat.E(Localizations.localeOf(context).toString()).format(d);

/// Day of the month, e.g. "1".
String formatDayOfMonth(DateTime d) => '${d.day}';

/// Short month, e.g. "Oct".
String formatMonthShort(BuildContext context, DateTime d) =>
    DateFormat.MMM(Localizations.localeOf(context).toString()).format(d);

/// "5 Oct 2026" for a single day, "1 Oct – 5 Oct 2026" for a span.
String formatDateRange(BuildContext context, DateTimeRange r) {
  final sameDay =
      r.start.year == r.end.year &&
      r.start.month == r.end.month &&
      r.start.day == r.end.day;
  return sameDay
      ? formatShortDate(context, r.start)
      : '${formatShortDate(context, r.start)} – '
            '${formatShortDate(context, r.end)}';
}
