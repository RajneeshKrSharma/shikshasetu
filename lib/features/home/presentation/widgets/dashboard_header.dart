import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../auth/domain/entities/app_user.dart';

/// The greeting for the time of day ("Good morning, Asha", with a sun, a
/// sunset or a moon in a small badge beside it), and the school and today's date under it.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.user,
    required this.schoolName,
  });

  final AppUser user;
  final String schoolName;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    final name = user.name.split(' ').first;
    final h = now.hour;
    final (greeting, icon) = h >= 5 && h < 12
        ? (l.greetingMorning(name), Icons.wb_twilight)
        : h >= 12 && h < 17
        ? (l.greetingAfternoon(name), Icons.wb_sunny_outlined)
        : h >= 17 && h < 21
        ? (l.greetingEvening(name), Icons.wb_twilight)
        : (l.greetingNight(name), Icons.nights_stay_outlined);
    final date =
        '${formatWeekdayShort(context, now)}, ${formatShortDate(context, now)}';
    // The Principal's title is the school's name; here only the day and the
    // greeting, on one line.
    if (user.isPrincipal) {
      return Text(
        l.homeGreetingLine(date, greeting),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.bodyMedium,
      );
    }
    return Row(
      children: [
        IconBadge(icon),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.headlineSmall,
              ),
              const SizedBox(height: 2),
              // The school and the date on one line, shrunk a little if it
              // is long, never cut off.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  schoolName.isEmpty
                      ? date
                      : l.dashSchoolAndDate(schoolName, date),
                  maxLines: 1,
                  softWrap: false,
                  style: context.text.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
