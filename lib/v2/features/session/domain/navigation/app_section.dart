import '../entities/account.dart';
import '../entities/permission.dart';

/// One area of the app. Which areas a person gets depends on what they may do.
enum AppSection {
  home(null),
  students({
    Permission.viewStudents,
    Permission.manageStudents,
    Permission.manageClasses,
    Permission.manageFees,
    Permission.manageAccessories,
    Permission.viewResults,
  }),
  teachers({Permission.manageTeachers, Permission.allotClasses}),
  staff({Permission.manageStaff, Permission.allotVans}),
  attendance({
    Permission.viewAttendance,
    Permission.markStudentAttendance,
    Permission.recordOwnAttendance,
  }),
  requests({
    Permission.decideRequests,
    Permission.approveLeaves,
    Permission.raiseMeetingQuery,
    Permission.recordOwnAttendance,
  }),
  exams({
    Permission.scheduleExams,
    Permission.conductExams,
    Permission.prepareQuestions,
    Permission.manageQuestionBank,
    Permission.viewResults,
  }),
  examTimetable({Permission.scheduleExams}),
  payments({
    Permission.manageTeacherPayments,
    Permission.manageStaffPayments,
    Permission.viewOwnPayments,
  }),
  analytics({Permission.viewAnalytics}),
  lessons({Permission.recordDailyLesson}),
  school({Permission.manageSchool}),
  notices(null),
  fuelBills({
    Permission.submitFuelBill,
    Permission.approveFuelBills,
    Permission.allotVans,
  }),
  vicePrincipal({Permission.appointVicePrincipal}),
  profile(null);

  const AppSection(this._anyOf);

  /// Any one of these opens the area; null means everyone has it.
  final Set<Permission>? _anyOf;

  bool isAvailableTo(Account account) =>
      _anyOf == null || account.canAny(_anyOf);
}
