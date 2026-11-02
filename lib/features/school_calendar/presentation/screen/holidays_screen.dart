import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/calendar_entities.dart';
import '../bloc/holidays_cubit.dart';
import '../widgets/reason_dialog.dart';
import 'add_holidays_screen.dart';

/// The school's holiday list, which everyone can read. The Principal can add
/// a whole list of holidays at once, or remove one with a reason.
class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const HolidaysScreen()));

  Future<void> _openHoliday(BuildContext context, Holiday h) async {
    final cubit = context.read<HolidaysCubit>();
    final user = context.read<AuthBloc>().state.user;
    final canEdit = user?.isPrincipal ?? false;
    final remove = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (_) => _HolidaySheet(holiday: h, canEdit: canEdit),
    );
    if (remove != true || !context.mounted || user == null) return;
    final reason = await ReasonDialog.show(context);
    if (reason == null) return;
    await cubit.remove(
      holiday: h,
      reason: reason,
      changedBy: user.id,
      isPrincipal: canEdit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isPrincipal = context.select(
      (AuthBloc b) => b.state.user?.isPrincipal ?? false,
    );
    return BlocProvider(
      create: (_) => sl<HolidaysCubit>()..load(),
      child: BlocConsumer<HolidaysCubit, HolidaysState>(
        listenWhen: (a, b) => a.noticeId != b.noticeId && b.notice != null,
        listener: (context, s) {
          if (s.notice == HolidayNotice.removed) {
            context.read<AttendanceBloc>().add(const AttendanceRefreshed());
            context.read<ApprovalsBloc>().add(const ApprovalsRequested());
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(switch (s.notice!) {
                HolidayNotice.removed => l.holidayRemoved,
                HolidayNotice.notAllowed => l.calendarNotAllowed,
                HolidayNotice.reasonRequired => l.calendarReasonRequired,
                HolidayNotice.failed => l.calendarFailed,
              }),
            ),
          );
        },
        builder: (context, s) {
          final cubit = context.read<HolidaysCubit>();
          final today = DateTime.now();
          final shown = s.visible(today);
          return Scaffold(
            appBar: AppBar(title: Text(l.holidaysTitle)),
            floatingActionButton: isPrincipal
                ? FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () async {
                      final saved = await AddHolidaysScreen.open(context);
                      if (saved == true) await cubit.load();
                    },
                    icon: const Icon(Icons.add),
                    label: Text(l.holidayAdd),
                  )
                : null,
            body: s.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: AppSpacing.pageOf(context, fab: true),
                    children: [
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          for (final (f, label) in [
                            (HolidayFilter.upcoming, l.holidayFilterUpcoming),
                            (HolidayFilter.past, l.holidayFilterPast),
                            (HolidayFilter.all, l.holidayFilterAll),
                          ])
                            ChoiceChip(
                              label: Text(label),
                              selected: s.filter == f,
                              onSelected: (_) => cubit.setFilter(f),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ListHeader(
                        title: switch (s.filter) {
                          HolidayFilter.upcoming => l.holidayListUpcoming,
                          HolidayFilter.past => l.holidayListPast,
                          HolidayFilter.all => l.holidayListAll,
                        },
                        count: shown.length,
                      ),
                      if (shown.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l.holidaySummary(shown.length, s.daysIn(shown)),
                          style: context.text.labelSmall,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      if (shown.isEmpty)
                        EmptyState(
                          icon: Icons.beach_access_outlined,
                          message: s.holidays.isEmpty
                              ? (isPrincipal
                                    ? l.holidayEmptyPrincipal
                                    : l.holidayEmpty)
                              : l.holidayEmptyFilter,
                        )
                      else
                        ..._grouped(context, shown, today),
                    ],
                  ),
          );
        },
      ),
    );
  }

  /// The holidays under a heading for each month they start in.
  List<Widget> _grouped(
    BuildContext context,
    List<Holiday> list,
    DateTime now,
  ) {
    final locale = Localizations.localeOf(context).toString();
    final widgets = <Widget>[];
    String? month;
    for (final h in list) {
      final m = DateFormat.yMMMM(locale).format(h.start);
      if (m != month) {
        month = m;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.md,
            ),
            child: Text(
              m,
              style: context.text.labelLarge!.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
        );
      }
      widgets
        ..add(
          _HolidayTile(
            holiday: h,
            today: now,
            onTap: () => _openHoliday(context, h),
          ),
        )
        ..add(const SizedBox(height: AppSpacing.md));
    }
    return widgets;
  }
}

class _HolidayTile extends StatelessWidget {
  const _HolidayTile({
    required this.holiday,
    required this.today,
    required this.onTap,
  });

  final Holiday holiday;
  final DateTime today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final day = DateTime(today.year, today.month, today.day);
    final (label, color, bg) = holiday.covers(day)
        ? (l.holidayOnNow, AppColors.present, AppColors.presentLight)
        : holiday.end.isBefore(day)
        ? (l.holidayPast, AppColors.textMuted, AppColors.pendingLight)
        : (
            l.holidayInDays(holiday.start.difference(day).inDays),
            brand.primary,
            brand.primaryLight,
          );
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: brand.primaryLight,
              borderRadius: AppRadius.mdAll,
            ),
            child: Column(
              children: [
                Text(
                  formatWeekdayShort(context, holiday.start).toUpperCase(),
                  style: context.text.labelSmall!.copyWith(
                    color: brand.primary,
                  ),
                ),
                Text(
                  formatDayOfMonth(holiday.start),
                  style: context.text.headlineSmall!.copyWith(
                    color: brand.primary,
                  ),
                ),
                Text(
                  formatMonthShort(context, holiday.start).toUpperCase(),
                  style: context.text.labelSmall!.copyWith(
                    color: brand.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(holiday.reason, style: context.text.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  holiday.isSingleDay
                      ? formatLongDate(context, holiday.start)
                      : '${formatDateRange(context, DateTimeRange(start: holiday.start, end: holiday.end))}'
                            '  ·  ${l.holidayDays(holiday.days)}',
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          StatusChip(label: label, color: color, background: bg),
        ],
      ),
    );
  }
}

class _HolidaySheet extends StatelessWidget {
  const _HolidaySheet({required this.holiday, required this.canEdit});

  final Holiday holiday;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Padding(
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
            Text(holiday.reason, style: context.text.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              holiday.isSingleDay
                  ? formatLongDate(context, holiday.start)
                  : formatDateRange(
                      context,
                      DateTimeRange(start: holiday.start, end: holiday.end),
                    ),
              style: context.text.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(l.holidayDays(holiday.days), style: context.text.bodySmall),
            if (canEdit) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.delete_outline),
                label: Text(l.holidayRemove),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
