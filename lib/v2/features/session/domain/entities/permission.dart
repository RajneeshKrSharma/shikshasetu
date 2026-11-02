/// One thing a person may be allowed to do. The codes are the server's own.
enum Permission {
  grantPermissions('grant_permissions'),
  appointVicePrincipal('appoint_vice_principal'),
  manageSchool('manage_school'),
  postNotices('post_notices'),
  manageClasses('manage_classes'),
  manageStudents('manage_students'),
  viewStudents('view_students'),
  manageAccessories('manage_accessories'),
  manageFees('manage_fees'),
  viewResults('view_results'),
  viewAttendance('view_attendance'),
  correctAttendance('correct_attendance'),
  manageTeachers('manage_teachers'),
  manageTeacherPayments('manage_teacher_payments'),
  allotClasses('allot_classes'),
  scheduleExams('schedule_exams'),
  manageStaff('manage_staff'),
  manageStaffPayments('manage_staff_payments'),
  allotVans('allot_vans'),
  approveFuelBills('approve_fuel_bills'),
  decideRequests('decide_requests'),
  approveLeaves('approve_leaves'),
  viewAnalytics('view_analytics'),
  markStudentAttendance('mark_student_attendance'),
  conductExams('conduct_exams'),
  prepareQuestions('prepare_questions'),
  manageQuestionBank('manage_question_bank'),
  recordDailyLesson('record_daily_lesson'),
  recordOwnAttendance('record_own_attendance'),
  raiseMeetingQuery('raise_meeting_query'),
  viewOwnPayments('view_own_payments'),
  submitFuelBill('submit_fuel_bill');

  const Permission(this.code);

  final String code;

  /// The permission for a server code, or null for one this app does not know.
  static Permission? fromCode(String code) {
    for (final p in values) {
      if (p.code == code) return p;
    }
    return null;
  }
}
