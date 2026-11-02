import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/date_range_chips.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../exams/presentation/screen/paper_detail_screen.dart';
import '../../../exams/presentation/widgets/paper_status_style.dart';
import '../../../face_id/presentation/screen/face_id_screen.dart';
import '../../../fees/presentation/screen/payment_history_screen.dart';
import '../../../registration/presentation/widgets/gender_l10n.dart';
import '../../domain/entities/profile_entities.dart';
import '../bloc/profile_cubits.dart';
import '../widgets/profile_widgets.dart';
import 'student_profile_screen.dart' show FeeCard;

/// Everything on record about one teacher: details, attendance history (with
/// a date filter), the papers they set, and their payments.
class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key, required this.teacherId});

  final String teacherId;

  static Future<void> open(BuildContext context, String teacherId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => TeacherProfileScreen(teacherId: teacherId),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => sl<TeacherProfileCubit>(param1: teacherId)..load(),
      child: BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
        builder: (context, s) {
          final p = s.profile;
          if (s.loading || p == null) {
            return Scaffold(
              appBar: AppBar(),
              body: s.loading
                  ? const Center(child: CircularProgressIndicator())
                  : EmptyState(
                      icon: Icons.person_off_outlined,
                      message: l.profileNotFound,
                    ),
            );
          }
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: Text(p.details.name),
                bottom: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    Tab(text: l.profileOverview),
                    Tab(text: l.profileAttendance),
                    Tab(text: l.profilePapers),
                    Tab(text: l.sectionPayments),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _Overview(profile: p, state: s),
                  const _AttendanceTab(),
                  _PapersTab(papers: p.papers),
                  _PaymentsTab(profile: p),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.profile, required this.state});

  final TeacherProfile profile;
  final TeacherProfileState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = profile.details;
    final daysIn = profile.attendance.where((x) => x.checkIn != null).length;
    return ListView(
      padding: AppSpacing.pageOf(context),
      children: [
        ProfileHeader(
          name: d.name,
          lines: [
            if (profile.subject != null) profile.subject!,
            if (profile.classSection != null)
              l.profileClassTeacherOfClass(profile.classSection!),
            l.profileJoinedOn(formatShortDate(context, d.registeredOn)),
          ],
          trailing: StatusChip(
            label: profile.active ? l.staffActive : l.staffInactive,
            color: profile.active ? AppColors.present : AppColors.textMuted,
            background: profile.active
                ? AppColors.presentLight
                : AppColors.pendingLight,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: l.profileAttendance,
                value: l.profileDaysPresent(daysIn),
                icon: Icons.fact_check_outlined,
                color: AppColors.present,
                background: AppColors.presentLight,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                label: l.profilePapers,
                value: '${profile.papers.length}',
                icon: Icons.description_outlined,
                color: context.brand.primary,
                background: context.brand.primaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionTitle(l.profileDetails),
        DetailsCard(
          rows: [
            InfoRow(
              icon: Icons.badge_outlined,
              label: l.profileEmployeeId,
              value: profile.employeeId,
            ),
            InfoRow(
              icon: Icons.email_outlined,
              label: l.fieldEmail,
              value: profile.email,
            ),
            InfoRow(
              icon: Icons.call_outlined,
              label: l.fieldPhone,
              value: d.phone,
            ),
            InfoRow(
              icon: Icons.cake_outlined,
              label: l.fieldDob,
              value: d.dateOfBirth == null
                  ? null
                  : formatShortDate(context, d.dateOfBirth!),
            ),
            InfoRow(
              icon: Icons.wc_outlined,
              label: l.fieldGender,
              value: d.gender?.label(l),
            ),
            InfoRow(
              icon: Icons.fingerprint,
              label: l.fieldAadhaar,
              value: d.aadhaarMasked,
            ),
            InfoRow(
              icon: Icons.home_outlined,
              label: l.fieldAddress,
              value: d.address,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          onTap: () => FaceIdScreen.open(
            context,
            teacherId: d.id,
            teacherName: d.name,
            canManage: true,
          ),
          child: Row(
            children: [
              Icon(Icons.face, color: context.brand.primary),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(l.faceTitle, style: context.text.titleSmall),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttendanceTab extends StatelessWidget {
  const _AttendanceTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<TeacherProfileCubit>();
    return BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
      builder: (context, s) {
        final rows = s.attendance;
        return ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.profileDates, style: context.text.labelMedium),
                  const SizedBox(height: AppSpacing.md),
                  DateRangeChips(value: s.range, onChanged: cubit.setRange),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l.profileDaysPresent(s.daysPresent),
              style: context.text.titleSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            ListHeader(title: l.profileAttendance, count: rows.length),
            const SizedBox(height: AppSpacing.lg),
            if (rows.isEmpty)
              EmptyState(
                icon: Icons.event_busy_outlined,
                message: l.profileNoAttendance,
              )
            else
              for (final d in rows) ...[
                _DayCard(record: d),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        );
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.record});

  final TeacherDayRecord record;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${formatWeekdayShort(context, record.day)}, '
            '${formatShortDate(context, record.day)}',
            style: context.text.titleSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _Time(
                  label: l.labelCheckIn,
                  value: formatTime(context, record.checkIn),
                ),
              ),
              Expanded(
                child: _Time(
                  label: l.labelCheckOut,
                  value: record.checkOut == null
                      ? (record.checkIn == null ? kNoTime : l.profileStillIn)
                      : formatTime(context, record.checkOut),
                ),
              ),
            ],
          ),
          if (record.distanceMeters != null || record.faceScore != null) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.xs,
              children: [
                if (record.distanceMeters != null)
                  Text(
                    l.distanceFromSchool(record.distanceMeters!.round()),
                    style: context.text.labelSmall,
                  ),
                if (record.faceScore != null)
                  Text(
                    l.faceScore((record.faceScore! * 100).round()),
                    style: context.text.labelSmall,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: context.text.labelSmall),
      const SizedBox(height: AppSpacing.xs),
      Text(value, style: context.text.bodyLarge),
    ],
  );
}

class _PapersTab extends StatelessWidget {
  const _PapersTab({required this.papers});

  final List<TeacherPaper> papers;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (papers.isEmpty) {
      return EmptyState(
        icon: Icons.description_outlined,
        message: l.profileNoPapers,
      );
    }
    return ListView(
      padding: AppSpacing.pageOf(context),
      children: [
        ListHeader(title: l.profilePapers, count: papers.length),
        const SizedBox(height: AppSpacing.lg),
        for (final p in papers) ...[
          AppCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PaperDetailScreen(paperId: p.id),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.title, style: context.text.titleSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${l.paperSubjectClass(p.subject, p.classSection)}'
                        '  ·  ${formatShortDate(context, p.date)}',
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                ),
                StatusChip(
                  label: p.status.label(l),
                  color: p.status.color(context.brand),
                  background: p.status.background(context.brand),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _PaymentsTab extends StatelessWidget {
  const _PaymentsTab({required this.profile});

  final TeacherProfile profile;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fees = profile.fees;
    if (fees.isEmpty) {
      return EmptyState(
        icon: Icons.payments_outlined,
        message: l.profileNoFees,
      );
    }
    final paid = fees.fold(0, (s, f) => s + f.paid);
    return ListView(
      padding: AppSpacing.pageOf(context),
      children: [
        Text(
          l.profileTotalPaid(formatRupees(context, paid)),
          style: context.text.titleMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final f in fees) ...[
          FeeCard(fee: f),
          const SizedBox(height: AppSpacing.lg),
        ],
        OutlinedButton.icon(
          onPressed: () => PaymentHistoryScreen.open(
            context,
            personId: profile.details.id,
            personName: profile.details.name,
          ),
          icon: const Icon(Icons.receipt_long_outlined),
          label: Text(l.profilePaymentHistory),
        ),
      ],
    );
  }
}
