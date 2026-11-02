import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/calendar_entities.dart';
import '../bloc/school_calendar_cubit.dart';
import '../widgets/day_sheet.dart';
import '../widgets/month_grid.dart';
import '../widgets/reason_dialog.dart';

/// How many days school ran, month by month, with a calendar everyone can
/// read. Only the Principal can change a day, and must give a reason.
class SchoolCalendarScreen extends StatelessWidget {
  const SchoolCalendarScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const SchoolCalendarScreen()));

  Future<void> _onDayTap(BuildContext context, DateTime date) async {
    final cubit = context.read<SchoolCalendarCubit>();
    final user = context.read<AuthBloc>().state.user;
    final isPrincipal = user?.isPrincipal ?? false;
    final record = cubit.state.data!.dayOf(date);

    final action = await DaySheet.show(
      context,
      record: record,
      canEdit: isPrincipal,
    );
    if (action == null || !context.mounted || user == null) return;
    final reason = await ReasonDialog.show(context);
    if (reason == null) return;
    await cubit.edit(
      day: date,
      status: switch (action) {
        DayAction.open => SchoolDayStatus.approved,
        DayAction.closed => SchoolDayStatus.rejected,
        DayAction.clear => SchoolDayStatus.pending,
      },
      reason: reason,
      changedBy: user.id,
      isPrincipal: isPrincipal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isPrincipal = context.select(
      (AuthBloc b) => b.state.user?.isPrincipal ?? false,
    );
    return BlocProvider(
      create: (_) => sl<SchoolCalendarCubit>()..load(),
      child: BlocConsumer<SchoolCalendarCubit, SchoolCalendarState>(
        listenWhen: (a, b) => a.noticeId != b.noticeId && b.notice != null,
        listener: (context, s) {
          if (s.notice == CalendarNotice.saved) {
            // Today's school day may have changed: attendance and approvals.
            context.read<AttendanceBloc>().add(const AttendanceRefreshed());
            context.read<ApprovalsBloc>().add(const ApprovalsRequested());
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(switch (s.notice!) {
                CalendarNotice.saved => l.calendarSaved,
                CalendarNotice.notAllowed => l.calendarNotAllowed,
                CalendarNotice.reasonRequired => l.calendarReasonRequired,
                CalendarNotice.failed => l.calendarFailed,
              }),
            ),
          );
        },
        builder: (context, s) {
          final data = s.data;
          final today = DateTime.now();
          return Scaffold(
            appBar: AppBar(title: Text(l.calendarTitle)),
            body: data == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: AppSpacing.pageOf(context),
                    children: [
                      _MonthHeader(
                        month: s.month,
                        canGoBack: data.hasPreviousMonth,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppCard(
                        child: MonthGrid(
                          data: data,
                          today: today,
                          onDayTap: (d) => _onDayTap(context, d),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _Legend(),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        isPrincipal
                            ? l.calendarTapHintPrincipal
                            : l.calendarTapHint,
                        style: context.text.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SectionTitle(l.calendarThisMonth),
                      _CountsCard(counts: data.monthCounts),
                      const SizedBox(height: AppSpacing.lg),
                      SectionTitle(
                        l.calendarYear(
                          formatShortDate(context, data.yearStart),
                        ),
                      ),
                      _CountsCard(counts: data.yearCounts),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l.calendarNoRecordNote,
                        style: context.text.labelSmall,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

/// "October 2026" with arrows to the neighbouring months and a Today button.
class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.month, required this.canGoBack});

  final DateTime month;

  /// The school was registered before this month.
  final bool canGoBack;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<SchoolCalendarCubit>();
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final isThisMonth = month.year == now.year && month.month == now.month;
    return Row(
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.chevron_left),
          onPressed: canGoBack ? cubit.previousMonth : null,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                DateFormat.yMMMM(locale).format(month),
                style: context.text.titleLarge,
              ),
              if (!isThisMonth)
                TextButton(
                  onPressed: cubit.goToToday,
                  child: Text(l.calendarToday),
                ),
            ],
          ),
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.chevron_right),
          onPressed: cubit.nextMonth,
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget item(Color bg, Color border, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: context.text.labelSmall),
      ],
    );
    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.md,
      children: [
        item(AppColors.presentLight, AppColors.present, l.calendarOpen),
        item(AppColors.absentLight, AppColors.absent, l.calendarClosed),
        item(
          context.brand.primaryLight,
          context.brand.primary,
          l.calendarHoliday,
        ),
        item(AppColors.pendingLight, AppColors.border, l.calendarWeeklyOff),
        item(AppColors.surface, AppColors.border, l.calendarNoRecord),
      ],
    );
  }
}

class _CountsCard extends StatelessWidget {
  const _CountsCard({required this.counts});

  final CalendarCounts counts;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget cell(String label, int n, Color color) => Expanded(
      child: Column(
        children: [
          Text(
            '$n',
            style: context.text.headlineMedium!.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.text.labelSmall,
          ),
        ],
      ),
    );
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cell(l.calendarDaysOpen, counts.open, AppColors.present),
          cell(l.calendarDaysClosed, counts.closed, AppColors.absent),
          cell(l.calendarDaysNoRecord, counts.noRecord, AppColors.late),
        ],
      ),
    );
  }
}
