import '../features/cloud_sync/domain/entities/sync_feature.dart';
import 'generated/app_localizations.dart';

extension SyncFeatureL10n on SyncFeature {
  String label(AppLocalizations l) => switch (this) {
    SyncFeature.settings => l.syncFeatureSettings,
    SyncFeature.staff => l.syncFeatureStaff,
    SyncFeature.classes => l.syncFeatureClasses,
    SyncFeature.students => l.syncFeatureStudents,
    SyncFeature.calendar => l.syncFeatureCalendar,
    SyncFeature.attendance => l.syncFeatureAttendance,
    SyncFeature.exams => l.syncFeatureExams,
    SyncFeature.fees => l.syncFeatureFees,
    SyncFeature.notices => l.syncFeatureNotices,
    SyncFeature.questionBank => l.syncFeatureQuestionBank,
  };
}

/// "15 min" or "2 hr", for a number of [minutes].
String syncIntervalLabel(AppLocalizations l, int minutes) => minutes % 60 == 0
    ? l.cloudAutoSyncHours(minutes ~/ 60)
    : l.cloudAutoSyncMinutes(minutes);

/// What a synced table holds, in words, for the sync details.
String syncTableLabel(AppLocalizations l, String table) => switch (table) {
  'users' => l.syncTable_users,
  'other_staff' => l.syncTable_other_staff,
  'teacher_subjects' => l.syncTable_teacher_subjects,
  'classes' => l.syncTable_classes,
  'students' => l.syncTable_students,
  'accessory_items' => l.syncTable_accessory_items,
  'accessory_issues' => l.syncTable_accessory_issues,
  'school_days' => l.syncTable_school_days,
  'school_day_changes' => l.syncTable_school_day_changes,
  'school_timings' => l.syncTable_school_timings,
  'bell_slots' => l.syncTable_bell_slots,
  'assembly_duty' => l.syncTable_assembly_duty,
  'timetable_entries' => l.syncTable_timetable_entries,
  'teacher_attendance' => l.syncTable_teacher_attendance,
  'student_attendance' => l.syncTable_student_attendance,
  'staff_attendance' => l.syncTable_staff_attendance,
  'exam_papers' => l.syncTable_exam_papers,
  'exam_questions' => l.syncTable_exam_questions,
  'exam_marks' => l.syncTable_exam_marks,
  'fee_accounts' => l.syncTable_fee_accounts,
  'fee_payments' => l.syncTable_fee_payments,
  'fee_structure' => l.syncTable_fee_structure,
  'staff_bills' => l.syncTable_staff_bills,
  'staff_settlements' => l.syncTable_staff_settlements,
  'notices' => l.syncTable_notices,
  'master_questions' => l.syncTable_master_questions,
  'question_units' => l.syncTable_question_units,
  _ => l.syncTable_app_settings,
};
