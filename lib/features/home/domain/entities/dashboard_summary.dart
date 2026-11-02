import 'package:equatable/equatable.dart';

import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../../notices/domain/entities/notice.dart';

/// Why something needs the Principal's attention.
enum AttentionKind {
  teachersNotIn,
  classesNotMarked,
  overdueFees,
  schoolLocationMissing,
  neverBackedUp,
}

class AttentionItem extends Equatable {
  const AttentionItem(this.kind, {this.count = 0, this.amount = 0});

  final AttentionKind kind;

  /// How many teachers / classes / accounts are involved.
  final int count;

  /// Money involved (overdue fees), in rupees.
  final int amount;

  @override
  List<Object?> get props => [kind, count, amount];
}

/// One class's attendance today.
class ClassProgress extends Equatable {
  const ClassProgress({
    required this.className,
    required this.studentCount,
    required this.presentCount,
    required this.isMarked,
  });

  final String className;
  final int studentCount;
  final int presentCount;
  final bool isMarked;

  /// 0..1, or 0 when the class has not been marked.
  double get ratio =>
      (!isMarked || studentCount == 0) ? 0 : presentCount / studentCount;

  @override
  List<Object?> get props => [className, studentCount, presentCount, isMarked];
}

class FeeSnapshot extends Equatable {
  const FeeSnapshot({
    required this.total,
    required this.collected,
    required this.overdueCount,
    required this.overdueAmount,
  });

  final int total;
  final int collected;
  final int overdueCount;
  final int overdueAmount;

  int get pending => total - collected;
  double get collectedRatio => total == 0 ? 0 : collected / total;

  @override
  List<Object?> get props => [total, collected, overdueCount, overdueAmount];
}

/// Everything the Dashboard shows, already worked out.
class DashboardSummary extends Equatable {
  const DashboardSummary({
    required this.dayStatus,
    required this.teachersPresent,
    required this.teachersTotal,
    required this.othersPresent,
    required this.othersTotal,
    required this.classes,
    required this.upcomingExams,
    required this.attention,
    this.fees,
    this.latestNotice,
  });

  final SchoolDayStatus dayStatus;
  final int teachersPresent;
  final int teachersTotal;

  /// Other staff marked present (or late) today, and how many there are.
  final int othersPresent;
  final int othersTotal;
  final List<ClassProgress> classes;

  /// Null when the user may not see fees.
  final FeeSnapshot? fees;
  final List<ExamPaper> upcomingExams;
  final Notice? latestNotice;

  /// Things that need the Principal, most important first.
  final List<AttentionItem> attention;

  /// Every student of every class (marked or not).
  int get studentsTotal => classes.fold(0, (s, c) => s + c.studentCount);

  bool get isSchoolOpen => dayStatus == SchoolDayStatus.approved;
  int get classesMarked => classes.where((c) => c.isMarked).length;

  ({int present, int total}) get studentTotals {
    var present = 0;
    var total = 0;
    for (final c in classes.where((c) => c.isMarked)) {
      present += c.presentCount;
      total += c.studentCount;
    }
    return (present: present, total: total);
  }

  @override
  List<Object?> get props => [
    dayStatus,
    teachersPresent,
    teachersTotal,
    othersPresent,
    othersTotal,
    classes,
    fees,
    upcomingExams,
    latestNotice,
    attention,
  ];
}
