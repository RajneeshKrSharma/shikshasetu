import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../accessories/presentation/screen/accessories_screen.dart';
import '../../../analytics/presentation/screen/analytics_screen.dart';
import '../../../attendance/domain/entities/attendance_record.dart';
import '../../../attendance/presentation/screen/attendance_report_screen.dart';
import '../../../bills/presentation/screen/bills_screen.dart';
import '../../../bills/presentation/screen/staff_payables_screen.dart';
import '../../../classes/presentation/screen/classes_screen.dart';
import '../../../exams/presentation/screen/exams_screen.dart';
import '../../../fees/domain/entities/fee_account.dart';
import '../../../fees/presentation/screen/fees_screen.dart';
import '../../../master_questions/presentation/screen/master_questions_screen.dart';
import '../../../teaching/presentation/screen/teacher_subjects_list_screen.dart';
import '../../domain/entities/member_feature.dart';

/// How one feature looks on a workspace and what it opens. The screen reads
/// these; it never decides what a feature is.
abstract class MemberFeatureView {
  const MemberFeatureView();

  MemberFeature get feature;
  IconData get icon;
  String label(AppLocalizations l);

  /// What the feature is for, in a line.
  String description(AppLocalizations l);

  /// A small line under the name, when the feature has one.
  String? caption(AppLocalizations l) => null;
  void open(BuildContext context);
}

class _PushView extends MemberFeatureView {
  const _PushView(
    this.feature,
    this.icon,
    this._label,
    this._open,
    this._description, {
    String Function(AppLocalizations)? caption,
  }) : _caption = caption;

  @override
  final MemberFeature feature;
  @override
  final IconData icon;
  final String Function(AppLocalizations) _label;
  final void Function(BuildContext) _open;
  final String Function(AppLocalizations) _description;
  final String Function(AppLocalizations)? _caption;

  @override
  String description(AppLocalizations l) => _description(l);

  @override
  String label(AppLocalizations l) => _label(l);

  @override
  String? caption(AppLocalizations l) => _caption?.call(l);

  @override
  void open(BuildContext context) => _open(context);
}

void _push(BuildContext context, Widget screen) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));

/// Every feature that has a screen, by its id.
class MemberFeatureViews {
  const MemberFeatureViews._();

  static final Map<MemberFeature, MemberFeatureView> _all = {
    for (final v in <MemberFeatureView>[
      _PushView(
        MemberFeature.fees,
        Icons.payments_outlined,
        (l) => l.featureFees,
        (c) => FeesScreen.open(c, FeeGroup.student),
        (l) => l.wsFeesHint,
      ),
      _PushView(
        MemberFeature.accessories,
        Icons.checkroom_outlined,
        (l) => l.featureAccessories,
        AccessoriesScreen.open,
        (l) => l.wsAccessoriesHint,
        caption: (l) => '${l.accKindDress} · ${l.accKindBooks}',
      ),
      _PushView(
        MemberFeature.performance,
        Icons.insights_outlined,
        (l) => l.featurePerformance,
        AnalyticsScreen.open,
        (l) => l.wsPerformanceHint,
      ),
      _PushView(
        MemberFeature.studentAttendance,
        Icons.fact_check_outlined,
        (l) => l.featureAttendance,
        (c) => AttendanceReportScreen.open(c, group: AttendanceGroup.student),
        (l) => l.wsStudentAttendanceHint,
      ),
      _PushView(
        MemberFeature.classes,
        Icons.class_outlined,
        (l) => l.featureClasses,
        (c) => _push(c, const ClassesScreen()),
        (l) => l.wsClassesHint,
      ),
      _PushView(
        MemberFeature.teacherPayment,
        Icons.payments_outlined,
        (l) => l.featureTeacherPayment,
        (c) => FeesScreen.open(c, FeeGroup.teacher),
        (l) => l.wsTeacherPaymentHint,
      ),
      _PushView(
        MemberFeature.questionBank,
        Icons.library_books_outlined,
        (l) => l.featureQuestionBank,
        MasterQuestionsScreen.open,
        (l) => l.wsQuestionBankHint,
      ),
      _PushView(
        MemberFeature.examPapers,
        Icons.quiz_outlined,
        (l) => l.featureExamPapers,
        (c) => _push(c, const ExamsScreen()),
        (l) => l.wsExamPapersHint,
      ),
      _PushView(
        MemberFeature.teacherAttendance,
        Icons.fact_check_outlined,
        (l) => l.featureAttendance,
        (c) => AttendanceReportScreen.open(c, group: AttendanceGroup.teacher),
        (l) => l.wsTeacherAttendanceHint,
      ),
      _PushView(
        MemberFeature.subjects,
        Icons.menu_book_outlined,
        (l) => l.featureSubjects,
        TeacherSubjectsListScreen.open,
        (l) => l.wsSubjectsHint,
      ),
      _PushView(
        MemberFeature.otherAttendance,
        Icons.fact_check_outlined,
        (l) => l.featureAttendance,
        (c) => AttendanceReportScreen.open(c, group: AttendanceGroup.other),
        (l) => l.wsStaffAttendanceHint,
      ),
      _PushView(
        MemberFeature.staffPayment,
        Icons.payments_outlined,
        (l) => l.featureStaffPayment,
        StaffPayablesScreen.open,
        (l) => l.wsStaffPaymentHint,
      ),
      _PushView(
        MemberFeature.bills,
        Icons.receipt_long_outlined,
        (l) => l.featureBills,
        (c) => BillsScreen.open(c),
        (l) => l.wsBillsHint,
        caption: (l) => '${l.fuelPetrol} / ${l.fuelDiesel}',
      ),
    ])
      v.feature: v,
  };

  /// Null for a feature that has no screen yet.
  static MemberFeatureView? of(MemberFeature feature) => _all[feature];
}
