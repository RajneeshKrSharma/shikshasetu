/// The kinds of school data, as the Principal knows them. Several tables can
/// belong to one feature (e.g. an exam has papers, questions and marks).
enum SyncFeature {
  settings,
  staff,
  classes,
  students,
  calendar,
  attendance,
  exams,
  fees,
  notices,
  questionBank;

  /// The feature a synced [table] belongs to.
  static SyncFeature ofTable(String table) => switch (table) {
    'users' || 'other_staff' || 'teacher_subjects' => staff,
    'classes' => classes,
    'students' || 'accessory_items' || 'accessory_issues' => students,
    'school_days' ||
    'school_day_changes' ||
    'school_timings' ||
    'bell_slots' ||
    'assembly_duty' ||
    'timetable_entries' => calendar,
    'teacher_attendance' ||
    'student_attendance' ||
    'staff_attendance' => attendance,
    'exam_papers' || 'exam_questions' || 'exam_marks' => exams,
    'fee_accounts' ||
    'fee_payments' ||
    'fee_structure' ||
    'staff_bills' ||
    'staff_settlements' => fees,
    'notices' => notices,
    'master_questions' || 'question_units' => questionBank,
    _ => settings,
  };
}
