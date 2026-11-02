import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../attendance/domain/usecases/get_attendance_overview.dart';
import '../../../attendance/domain/usecases/other_staff_attendance_usecases.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/domain/usecases/get_papers.dart';
import '../../../fees/domain/entities/fee_account.dart';
import '../../../fees/domain/usecases/get_fee_accounts.dart';
import '../../../notices/domain/usecases/get_notices.dart';
import '../../../settings/domain/usecases/get_school_settings.dart';
import '../entities/dashboard_summary.dart';

class DashboardQuery extends Equatable {
  const DashboardQuery({required this.now, required this.includeFees});

  final DateTime now;

  /// Only the Principal sees fees.
  final bool includeFees;

  @override
  List<Object?> get props => [now, includeFees];
}

/// Gathers today's numbers and works out what needs the Principal.
class GetDashboardSummary implements UseCase<DashboardSummary, DashboardQuery> {
  const GetDashboardSummary({
    required GetAttendanceOverview getOverview,
    required GetOtherStaffAttendance getOtherStaff,
    required GetFeeAccounts getFeeAccounts,
    required GetPapers getPapers,
    required GetNotices getNotices,
    required GetSchoolSettings getSettings,
  }) : _getOverview = getOverview,
       _getOtherStaff = getOtherStaff,
       _getFees = getFeeAccounts,
       _getPapers = getPapers,
       _getNotices = getNotices,
       _getSettings = getSettings;

  final GetAttendanceOverview _getOverview;
  final GetOtherStaffAttendance _getOtherStaff;
  final GetFeeAccounts _getFees;
  final GetPapers _getPapers;
  final GetNotices _getNotices;
  final GetSchoolSettings _getSettings;

  /// How many upcoming exams the Dashboard lists.
  static const upcomingExamLimit = 3;

  @override
  Future<DashboardSummary> call(DashboardQuery q) async {
    final overview = await _getOverview(q.now);
    final settings = await _getSettings(const NoParams());
    final others = await _getOtherStaff(q.now);

    final classes = [
      for (final c in overview.classes)
        ClassProgress(
          className: c.className,
          studentCount: c.students.length,
          presentCount: c.presentCount,
          isMarked: c.isMarked,
        ),
    ];

    FeeSnapshot? fees;
    if (q.includeFees) {
      final accounts = await _getFees(const NoParams());
      final overdue = accounts
          .where((a) => a.statusAt(q.now) == FeeStatus.overdue)
          .toList();
      fees = FeeSnapshot(
        total: accounts.fold(0, (s, a) => s + a.total),
        collected: accounts.fold(0, (s, a) => s + a.paid),
        overdueCount: overdue.length,
        overdueAmount: overdue.fold(0, (s, a) => s + a.pending),
      );
    }

    final today = DateTime(q.now.year, q.now.month, q.now.day);
    final upcoming =
        (await _getPapers(const NoParams()))
            .where(
              (p) =>
                  p.status == PaperStatus.approved && !p.date.isBefore(today),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    final notices = await _getNotices(const NoParams());

    final teachersPresent = overview.teachers.where((t) => t.isPresent).length;
    final teachersNotIn = overview.teachers.length - teachersPresent;
    // Only classes that have students can be marked.
    final unmarked = classes
        .where((c) => !c.isMarked && c.studentCount > 0)
        .length;
    final open = overview.dayStatus == SchoolDayStatus.approved;

    return DashboardSummary(
      dayStatus: overview.dayStatus,
      teachersPresent: teachersPresent,
      teachersTotal: overview.teachers.length,
      othersPresent: others
          .where((o) => o.status != null && o.status != AttendanceStatus.absent)
          .length,
      othersTotal: others.length,
      classes: classes,
      fees: fees,
      upcomingExams: upcoming.take(upcomingExamLimit).toList(),
      latestNotice: notices.isEmpty ? null : notices.first,
      attention: [
        if (open && teachersNotIn > 0)
          AttentionItem(AttentionKind.teachersNotIn, count: teachersNotIn),
        if (open && unmarked > 0)
          AttentionItem(AttentionKind.classesNotMarked, count: unmarked),
        if (fees != null && fees.overdueCount > 0)
          AttentionItem(
            AttentionKind.overdueFees,
            count: fees.overdueCount,
            amount: fees.overdueAmount,
          ),
        if (!settings.hasLocation)
          const AttentionItem(AttentionKind.schoolLocationMissing),
        if (settings.lastBackupAt == null)
          const AttentionItem(AttentionKind.neverBackedUp),
      ],
    );
  }
}
