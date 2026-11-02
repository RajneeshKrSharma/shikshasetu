import 'package:get_it/get_it.dart';

import 'modules/analytics_module.dart';
import 'modules/attendance_module.dart';
import 'modules/exams_module.dart';
import 'modules/fees_module.dart';
import 'modules/fleet_module.dart';
import 'modules/members_module.dart';
import 'modules/notices_module.dart';
import 'modules/paper_scan_module.dart';
import 'modules/payments_module.dart';
import 'modules/permissions_module.dart';
import 'modules/requests_module.dart';
import 'modules/school_module.dart';
import 'modules/server_module.dart';
import 'modules/session_module.dart';
import 'modules/teaching_module.dart';
import 'modules/students_module.dart';

/// The service locator of the server-backed app. Everything is registered
/// against its contract, so tests can swap in fakes.
final GetIt sl = GetIt.instance;

Future<void> configureV2Dependencies() async {
  await sl.reset();
  sl.allowReassignment = true;
  registerServer(sl);
  registerSession(sl);
  registerSchool(sl);
  registerNotices(sl);
  registerStudents(sl);
  registerFees(sl);
  registerMembers(sl);
  registerTeaching(sl);
  registerFleet(sl);
  registerAttendance(sl);
  registerRequests(sl);
  registerExams(sl);
  registerPayments(sl);
  registerAnalytics(sl);
  registerPermissions(sl);
  registerPaperScan(sl);
}
