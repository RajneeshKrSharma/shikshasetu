import '../../../../l10n/class_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/date_range_chips.dart';
import '../../../../core/widgets/feature_tile.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../accessories/presentation/bloc/student_issues_cubit.dart';
import '../../../accessories/presentation/widgets/issue_log_card.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../attendance/presentation/widgets/attendance_status_style.dart';
import '../../../fees/presentation/screen/fee_ledger_screen.dart';
import '../../../registration/domain/entities/person.dart';
import '../../../registration/presentation/screen/register_form_screen.dart';
import '../../../registration/presentation/widgets/gender_l10n.dart';
import '../../domain/entities/profile_entities.dart';
import '../bloc/profile_cubits.dart';

/// Everything on record about one student: details, attendance history (with
/// date and status filters), fees and payments, and exam results.
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key, required this.studentId});

  final String studentId;

  static Future<void> open(BuildContext context, String studentId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => StudentProfileScreen(studentId: studentId),
        ),
      );

  /// Opens one of the profile's sub-screens with the same loaded profile.
  void _push(BuildContext context, String title, Widget body) {
    final cubit = context.read<StudentProfileCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: Scaffold(
            appBar: AppBar(title: Text(title)),
            body: body,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => sl<StudentProfileCubit>(param1: studentId)..load(),
      child: BlocBuilder<StudentProfileCubit, StudentProfileState>(
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
          final d = p.details;
          final pending = p.fees.fold(0, (sum, f) => sum + f.pending);
          final marks = p.attendance;
          final attended = marks
              .where((e) => e.status != AttendanceStatus.absent)
              .length;
          final avg = p.results.isEmpty
              ? null
              : (p.results.fold(0.0, (sum, r) => sum + r.percent) /
                        p.results.length)
                    .round();
          return Scaffold(
            appBar: AppBar(
              title: Text(d.name),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, AppSizes.buttonCompact),
                    ),
                    onPressed: () async {
                      final cubit = context.read<StudentProfileCubit>();
                      await RegisterFormScreen.open(
                        context,
                        PersonType.student,
                        studentId: studentId,
                      );
                      await cubit.load();
                    },
                    child: Text(l.memberEdit),
                  ),
                ),
              ],
            ),
            body: ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                Container(
                  width: double.infinity,
                  padding: AppSpacing.card,
                  decoration: BoxDecoration(
                    color: context.brand.primaryLight,
                    borderRadius: AppRadius.lgAll,
                    border: Border.all(
                      color: context.brand.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l.classLabel(p.classSection)} · '
                        '${l.feeRollNo(p.rollNo)}',
                        style: context.text.titleSmall,
                      ),
                      Text(
                        l.profileGuardianLine(p.guardian ?? '–', d.phone),
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FeatureGrid(
                  columns: 2,
                  tiles: [
                    FeatureTile(
                      icon: Icons.payments_outlined,
                      label: l.featureFees,
                      caption: pending > 0
                          ? l.profileTileFeesDue(formatRupees(context, pending))
                          : l.profileTileFeesClear,
                      onTap: () => FeeLedgerScreen.open(context, studentId),
                    ),
                    FeatureTile(
                      icon: Icons.checkroom_outlined,
                      label: l.featureAccessories,
                      caption: '${l.accKindDress} · ${l.accKindBooks}',
                      onTap: () => _push(
                        context,
                        l.featureAccessories,
                        _AccessoriesTab(studentId: studentId),
                      ),
                    ),
                    FeatureTile(
                      icon: Icons.insights_outlined,
                      label: l.featurePerformance,
                      caption: avg == null
                          ? l.profileTileNone
                          : l.profileTileAvg(avg),
                      onTap: () => _push(
                        context,
                        l.featurePerformance,
                        _ResultsTab(results: p.results),
                      ),
                    ),
                    FeatureTile(
                      icon: Icons.fact_check_outlined,
                      label: l.featureAttendance,
                      caption: marks.isEmpty
                          ? l.profileTileNone
                          : l.profileTileAttendance(
                              (attended * 100 / marks.length).round(),
                            ),
                      onTap: () => _push(
                        context,
                        l.featureAttendance,
                        const _AttendanceTab(),
                      ),
                    ),
                  ],
                ),
                SectionLabel(l.profileDetails),
                _DetailBox(
                  label: l.fieldDob,
                  value: d.dateOfBirth == null
                      ? '–'
                      : formatShortDate(context, d.dateOfBirth!),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _DetailBox(
                        label: l.fieldGender,
                        value: d.gender?.label(l) ?? '–',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _DetailBox(
                        label: l.fieldAadhaar,
                        value: d.aadhaarMasked.isEmpty ? '–' : d.aadhaarMasked,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _DetailBox(label: l.fieldAddress, value: d.address ?? '–'),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// One fact in an outlined box, with a small caption.
class _DetailBox extends StatelessWidget {
  const _DetailBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    decoration: BoxDecoration(
      borderRadius: AppRadius.mdAll,
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.labelSmall),
        Text(value, style: context.text.bodyMedium),
      ],
    ),
  );
}

class _AttendanceTab extends StatelessWidget {
  const _AttendanceTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<StudentProfileCubit>();
    return BlocBuilder<StudentProfileCubit, StudentProfileState>(
      builder: (context, s) {
        final c = s.counts;
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
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      for (final st in AttendanceStatus.values)
                        FilterChip(
                          label: Text(st.label(l)),
                          selected: s.statuses.contains(st),
                          onSelected: (_) => cubit.toggleStatus(st),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                for (final (label, n, st) in [
                  (l.statusPresent, c.present, AttendanceStatus.present),
                  (l.statusAbsent, c.absent, AttendanceStatus.absent),
                  (l.statusLate, c.late, AttendanceStatus.late),
                ]) ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: st.background,
                        borderRadius: AppRadius.lgAll,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$n',
                            style: context.text.headlineSmall!.copyWith(
                              color: st.color,
                            ),
                          ),
                          Text(label, style: context.text.labelSmall),
                        ],
                      ),
                    ),
                  ),
                  if (st != AttendanceStatus.late)
                    const SizedBox(width: AppSpacing.md),
                ],
              ],
            ),
            if (c.total > 0) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                '${l.profileAttended(c.attendedPercent)}  ·  '
                '${l.profileDaysRecorded(c.total)}',
                style: context.text.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ListHeader(title: l.profileAttendance, count: rows.length),
            const SizedBox(height: AppSpacing.lg),
            if (rows.isEmpty)
              EmptyState(
                icon: Icons.event_busy_outlined,
                message: l.profileNoAttendance,
              )
            else
              for (final e in rows) ...[
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${formatWeekdayShort(context, e.day)}, '
                          '${formatShortDate(context, e.day)}',
                          style: context.text.bodyLarge,
                        ),
                      ),
                      StatusChip(
                        label: e.status.label(l),
                        color: e.status.color,
                        background: e.status.background,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        );
      },
    );
  }
}

/// One fee with the payments made against it. Shared by the student and
/// teacher profiles.
class FeeCard extends StatelessWidget {
  const FeeCard({super.key, required this.fee});

  final ProfileFee fee;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.feePaidOfTotal(
              formatRupees(context, fee.paid),
              formatRupees(context, fee.total),
            ),
            style: context.text.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.feeDueOn(formatShortDate(context, fee.dueDate)),
            style: context.text.bodySmall,
          ),
          if (fee.payments.isEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(l.profileNoPayments, style: context.text.bodySmall),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            const DottedLine(),
            for (final p in fee.payments)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${p.receiptNo}  ·  '
                        '${formatShortDate(context, p.paidAt)}',
                        style: context.text.bodyMedium,
                      ),
                    ),
                    Text(
                      formatRupees(context, p.amount),
                      style: context.text.titleSmall!.copyWith(
                        color: AppColors.present,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _ResultsTab extends StatelessWidget {
  const _ResultsTab({required this.results});

  final List<ExamResult> results;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (results.isEmpty) {
      return EmptyState(
        icon: Icons.assignment_outlined,
        message: l.profileNoResults,
      );
    }
    return ListView(
      padding: AppSpacing.pageOf(context),
      children: [
        ListHeader(title: l.profileResults, count: results.length),
        const SizedBox(height: AppSpacing.lg),
        for (final r in results) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(r.title, style: context.text.titleSmall),
                    ),
                    Text(
                      l.profileMarksOf(r.obtained, r.total),
                      style: context.text.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${r.subject}  ·  ${formatShortDate(context, r.date)}',
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: AppRadius.smAll,
                  child: LinearProgressIndicator(
                    value: (r.percent / 100).clamp(0, 1),
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    color: r.percent >= 40
                        ? AppColors.present
                        : AppColors.absent,
                  ),
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

/// What has been given to the student (dress and books), with the proof.
class _AccessoriesTab extends StatelessWidget {
  const _AccessoriesTab({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => sl<StudentIssuesCubit>(param1: studentId)..load(),
      child: BlocBuilder<StudentIssuesCubit, StudentIssuesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.issues.isEmpty) {
            return EmptyState(
              icon: Icons.checkroom_outlined,
              message: l.accLogEmpty,
            );
          }
          return ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              for (final i in state.issues) ...[
                IssueLogCard(issue: i),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }
}
