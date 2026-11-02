import '../../features/backup/domain/usecases/download_backup.dart';
import '../../features/backup/domain/usecases/create_backup_zip.dart';
import '../../features/backup/domain/usecases/publish_mirror_copy.dart';
import '../../features/data_monitor/domain/usecases/monitor_usecases.dart';
import 'dart:math';

import '../../features/backup/domain/usecases/write_data_mirror.dart';

import 'package:uuid/uuid.dart';

import '../../features/question_bank/domain/services/question_checker.dart';
import '../../features/question_bank/domain/usecases/bank_usecases.dart';
import '../../features/question_bank/domain/usecases/paper_maker_usecases.dart';
import '../../features/other_staff/domain/entities/other_staff.dart';
import '../../features/bills/domain/usecases/bills_usecases.dart';
import '../../features/school_day/domain/usecases/school_day_usecases.dart';
import '../../features/accessories/domain/usecases/accessories_usecases.dart';
import '../../features/students/domain/usecases/get_vehicle_numbers.dart';
import '../../features/fees/domain/usecases/change_fee_dates.dart';
import '../../features/fees/domain/usecases/fee_structure_usecases.dart';
import '../../features/fees/domain/usecases/get_person_payments.dart';
import '../../features/proofs/domain/usecases/capture_proof_photo.dart';
import '../../features/proofs/domain/usecases/save_signature.dart';
import '../../features/attendance/domain/usecases/other_staff_attendance_usecases.dart';
import '../../features/demo_data/domain/usecases/load_demo_data.dart';
import '../../features/demo_data/domain/usecases/remove_demo_data.dart';
import 'package:get_it/get_it.dart';

import '../../features/analytics/domain/usecases/get_class_analytics.dart';
import '../../features/analytics/domain/usecases/get_teacher_reports.dart';
import '../../features/approvals/domain/usecases/decide_approval.dart';
import '../../features/approvals/domain/usecases/get_approvals.dart';
import '../../features/attendance/domain/usecases/get_attendance_overview.dart';
import '../../features/attendance/domain/usecases/get_attendance_report.dart';
import '../../features/attendance/domain/usecases/record_teacher_check.dart';
import '../../features/attendance/domain/usecases/save_class_attendance.dart';
import '../../features/attendance/domain/usecases/set_school_day_status.dart';
import '../../features/attendance/domain/usecases/verify_teacher_presence.dart';
import '../../features/auth/domain/usecases/change_password.dart';
import '../../features/auth/domain/usecases/request_email_change.dart';
import '../../features/teaching/domain/usecases/teaching_usecases.dart';
import '../../features/auth/domain/usecases/restore_session.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/name_school.dart';
import '../../features/auth/domain/usecases/needs_school_setup.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sync_verified_email.dart';
import '../../features/auth/domain/usecases/update_profile.dart';
import '../../features/backup/domain/usecases/pick_backup_file.dart';
import '../../features/backup/domain/usecases/preview_backup.dart';
import '../../features/backup/domain/usecases/restore_backup.dart';
import '../../features/classes/domain/usecases/add_class.dart';
import '../../features/classes/domain/usecases/delete_class.dart';
import '../../features/classes/domain/usecases/get_classes.dart';
import '../../features/classes/domain/usecases/rename_class.dart';
import '../../features/exams/domain/usecases/get_paper_marks.dart';
import '../../features/cloud_sync/domain/usecases/cloud_usecases.dart';
import '../../features/face_id/domain/usecases/face_usecases.dart';
import '../../features/profiles/domain/usecases/get_profiles.dart';
import '../../features/school_calendar/domain/usecases/calendar_usecases.dart';
import '../../features/school_calendar/domain/usecases/get_suggested_holidays.dart';
import '../../features/school_calendar/domain/usecases/holiday_usecases.dart';
import '../../features/registration/domain/usecases/read_aadhaar_card.dart';
import '../../features/cloud_sync/domain/usecases/pull_school_updates.dart';
import '../../features/cloud_sync/domain/usecases/school_exchange_usecases.dart';
import '../../features/cloud_sync/domain/usecases/sync_to_cloud.dart';
import '../../features/exams/domain/usecases/build_paper_document.dart';
import '../../features/exams/domain/usecases/change_paper_status.dart';
import '../../features/printing/domain/usecases/printer_usecases.dart';
import '../../features/exams/domain/usecases/delete_paper.dart';
import '../../features/exams/domain/usecases/get_papers.dart';
import '../../features/exams/domain/usecases/parse_question_text.dart';
import '../../features/exams/domain/usecases/shuffle_paper.dart';
import '../../features/exams/domain/usecases/mark_paper_conducted.dart';
import '../../features/exams/domain/usecases/pick_photo.dart';
import '../../features/exams/domain/usecases/question_parser.dart';
import '../../features/exams/domain/usecases/save_paper.dart';
import '../../features/exams/domain/usecases/save_paper_marks.dart';
import '../../features/exams/domain/usecases/scan_questions.dart';
import '../../features/fees/domain/usecases/create_fee_account.dart';
import '../../features/master_questions/domain/usecases/delete_master_question.dart';
import '../../features/master_questions/domain/usecases/get_master_questions.dart';
import '../../features/master_questions/domain/usecases/save_master_question.dart';
import '../../features/fees/domain/usecases/create_receipt.dart';
import '../../features/fees/domain/usecases/get_fee_accounts.dart';
import '../../features/fees/domain/usecases/get_fee_people.dart';
import '../../features/fees/domain/usecases/get_payment_history.dart';
import '../../features/fees/domain/usecases/get_payments.dart';
import '../../features/fees/domain/usecases/record_payment.dart';
import '../../core/usecase/usecase.dart';
import '../../features/home/domain/entities/dashboard_summary.dart';
import '../../features/home/domain/usecases/get_dashboard_summary.dart';
import '../../features/location/domain/usecases/get_address.dart';
import '../../features/location/domain/usecases/get_current_location.dart';
import '../../features/notices/domain/usecases/get_notices.dart';
import '../../features/notices/domain/usecases/post_notice.dart';
import '../../features/registration/domain/usecases/get_people.dart';
import '../../features/registration/domain/usecases/register_other.dart';
import '../../features/registration/domain/usecases/register_teacher.dart';
import '../../features/settings/domain/usecases/get_school_settings.dart';
import '../../features/settings/domain/usecases/record_backup_time.dart';
import '../../features/settings/domain/usecases/save_school_settings.dart';
import '../../features/settings/domain/usecases/save_announcement.dart';
import '../../features/settings/domain/usecases/save_school_logo.dart';
import '../../features/sharing/domain/usecases/share_files.dart';
import '../../features/staff/domain/usecases/assign_class_teacher.dart';
import '../../features/staff/domain/usecases/get_staff.dart';
import '../../features/staff/domain/usecases/set_staff_active.dart';
import '../../features/members/domain/usecases/get_member_summaries.dart';
import '../../features/members/domain/usecases/get_workspace.dart';
import '../../features/members/domain/usecases/member_crud.dart';
import '../../features/members/domain/usecases/set_member_active.dart';
import '../../features/students/domain/entities/student.dart';
import '../../features/students/domain/usecases/get_students_by_class.dart';

/// One use case per business action; each depends only on contracts.
void registerUseCases(GetIt sl) {
  sl
    // auth
    ..registerLazySingleton(() => RestoreSession(sl()))
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => NameSchool(sl()))
    ..registerLazySingleton(() => NeedsSchoolSetup(sl()))
    ..registerLazySingleton(() => GetTeachingAssignments(sl()))
    ..registerLazySingleton(() => RequestSubject(sl()))
    ..registerLazySingleton(() => AllotSubject(sl()))
    ..registerLazySingleton(() => RemoveTeachingAssignment(sl()))
    ..registerLazySingleton(() => RequestEmailChange(sl()))
    ..registerLazySingleton(() => SyncVerifiedEmail(sl()))
    ..registerLazySingleton(() => SignOut(sl()))
    ..registerLazySingleton(() => ChangePassword(sl()))
    ..registerLazySingleton(() => UpdateProfile(sl()))
    // settings
    ..registerLazySingleton(() => GetSchoolSettings(sl()))
    ..registerLazySingleton(() => SaveSchoolSettings(sl()))
    ..registerLazySingleton(() => RecordBackupTime(sl()))
    ..registerLazySingleton(() => SaveAnnouncement(sl()))
    ..registerLazySingleton(() => SaveSchoolLogo(sl()))
    // location
    ..registerLazySingleton(() => GetCurrentLocation(sl()))
    ..registerLazySingleton(() => GetAddress(sl()))
    // classes
    ..registerLazySingleton(() => GetClasses(sl()))
    ..registerLazySingleton(() => AddClass(sl()))
    ..registerLazySingleton(() => RenameClass(sl()))
    ..registerLazySingleton(() => DeleteClass(sl()))
    // students
    ..registerLazySingleton(() => GetStudentsByClass(sl()))
    ..registerLazySingleton(() => AddMember<Student>(sl()))
    ..registerLazySingleton(() => UpdateMember<Student>(sl()))
    ..registerLazySingleton(() => GetMember<Student>(sl()))
    ..registerLazySingleton(() => GetVehicleNumbers(sl()))
    // members
    ..registerLazySingleton(() => GetWorkspace(sl()))
    ..registerLazySingleton(() => GetMemberSummaries(sl()))
    ..registerLazySingleton(() => SetMemberActive(sl()))
    // staff
    ..registerLazySingleton(() => GetStaff(sl()))
    ..registerLazySingleton(() => SetStaffActive(sl()))
    ..registerLazySingleton(() => AssignClassTeacher(sl()))
    // attendance
    ..registerLazySingleton(() => GetAttendanceOverview(sl(), sl(), sl()))
    ..registerLazySingleton(() => SetSchoolDayStatus(sl()))
    ..registerLazySingleton(() => GetAttendanceReport(sl()))
    ..registerLazySingleton(() => GetOtherStaffAttendance(sl()))
    ..registerLazySingleton(() => SaveOtherStaffAttendance(sl()))
    ..registerLazySingleton(() => SaveClassAttendance(sl()))
    ..registerLazySingleton(
      () => VerifyTeacherPresence(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
    )
    ..registerLazySingleton(() => CheckInTeacher(sl(), sl()))
    ..registerLazySingleton(() => CheckOutTeacher(sl(), sl()))
    // approvals
    ..registerLazySingleton(() => GetApprovals(sl()))
    ..registerLazySingleton(() => DecideApproval(sl()))
    // registration
    ..registerLazySingleton(() => GetPeople(sl()))
    ..registerLazySingleton(() => RegisterTeacher(sl()))
    ..registerLazySingleton(() => RegisterOther(sl()))
    // exams
    ..registerLazySingleton(() => GetPapers(sl()))
    ..registerLazySingleton(() => SavePaper(sl()))
    ..registerLazySingleton(() => MarkPaperConducted(sl()))
    ..registerLazySingleton(() => GetPaperMarks(sl()))
    ..registerLazySingleton(() => SavePaperMarks(sl()))
    ..registerLazySingleton(() => PickPhoto(sl()))
    ..registerLazySingleton(() => const QuestionParser())
    ..registerLazySingleton(() => ScanQuestions(sl(), sl()))
    ..registerLazySingleton(() => ParseQuestionText(sl()))
    ..registerLazySingleton(() => ChangePaperStatus(sl()))
    ..registerLazySingleton(() => DeletePaper(sl()))
    ..registerLazySingleton(() => ShufflePaper(sl()))
    ..registerLazySingleton(() => BuildPaperDocument(sl()))
    // printing
    ..registerLazySingleton(() => CheckThermalAccess(sl()))
    ..registerLazySingleton(() => GetPairedPrinters(sl()))
    ..registerLazySingleton(() => PrintOnThermal(sl()))
    ..registerLazySingleton(() => PrintWithSystemDialog(sl()))
    ..registerLazySingleton(() => SharePdf(sl()))
    ..registerLazySingleton(() => ReadAadhaarCard(sl()))
    // face id
    ..registerLazySingleton(() => HasFaceEnrolled(sl()))
    ..registerLazySingleton(() => GetEnrolledFaceIds(sl()))
    ..registerLazySingleton(() => EnrollFace(sl(), sl()))
    ..registerLazySingleton(() => VerifyFace(sl(), sl()))
    ..registerLazySingleton(() => RemoveFace(sl()))
    ..registerLazySingleton(() => GetFaceEnrollment(sl()))
    ..registerLazySingleton(() => SetUpFace(sl(), sl()))
    // school calendar
    ..registerLazySingleton(() => GetCalendarMonth(sl()))
    ..registerLazySingleton(() => EditSchoolDay(sl()))
    ..registerLazySingleton(() => GetSchoolDayHistory(sl()))
    ..registerLazySingleton(() => GetHolidays(sl()))
    ..registerLazySingleton(() => AddHolidays(sl()))
    ..registerLazySingleton(() => const GetSuggestedHolidays())
    ..registerLazySingleton(() => RemoveHoliday(sl()))
    // profiles
    ..registerLazySingleton(() => GetStudentProfile(sl()))
    ..registerLazySingleton(() => GetTeacherProfile(sl()))
    // cloud sync
    ..registerLazySingleton(() => PullSchoolUpdates(sl()))
    ..registerLazySingleton(
      () => PushTeacherWork(source: sl(), state: sl(), cloud: sl(), log: sl()),
    )
    ..registerLazySingleton(() => SendPaperRequests(sl()))
    ..registerLazySingleton(() => ApplyPaperDecisions(sl()))
    ..registerLazySingleton(() => ImportPaperRequests(sl()))
    ..registerLazySingleton(() => ImportTeacherWork(sl()))
    ..registerLazySingleton(() => SendSubjectRequests(sl()))
    ..registerLazySingleton(() => ImportSubjectRequests(sl()))
    ..registerLazySingleton(() => GetCloudConnection(sl()))
    ..registerLazySingleton(() => GetLastChangeRun(sl()))
    ..registerLazySingleton(() => GetSyncInterval(sl()))
    ..registerLazySingleton(() => SetSyncInterval(sl()))
    ..registerLazySingleton(() => GetLastSyncRun(sl()))
    ..registerLazySingleton(() => GetCloudSchoolId(sl()))
    ..registerLazySingleton(() => GetPendingChanges(sl()))
    ..registerLazySingleton(() => GetSourceSummary(sl()))
    ..registerLazySingleton(() => CompareTable(sl()))
    ..registerLazySingleton(() => CompareBackupWithApp(sl()))
    ..registerLazySingleton(() => DiffBackupTable(sl()))
    ..registerLazySingleton(() => GetMirrorPending(sl()))
    ..registerLazySingleton(() => MarkMirrored(sl()))
    ..registerLazySingleton(() => WriteDataMirror(sl()))
    ..registerLazySingleton(() => CreateBackupZip(sl()))
    ..registerLazySingleton(() => DownloadBackup(sl(), sl()))
    ..registerLazySingleton(() => PublishMirrorCopy(sl()))
    ..registerLazySingleton(() => MarkChangesSent(sl()))
    ..registerLazySingleton(
      () => SyncToCloud(source: sl(), state: sl(), cloud: sl()),
    )
    // teacher question bank
    ..registerLazySingleton(() => GetBankScopes(sl(), sl()))
    ..registerLazySingleton(() => GetBankOverview(sl()))
    ..registerLazySingleton(() => AddBankUnit(sl()))
    ..registerLazySingleton(() => GetUnitQuestions(sl()))
    ..registerLazySingleton(() => SaveBankQuestions(sl()))
    ..registerLazySingleton(() => DeleteBankQuestion(sl()))
    ..registerLazySingleton(() => const QuestionChecker())
    ..registerLazySingleton(() => ReviewScanned(sl()))
    ..registerLazySingleton(() => CheckQuestion(sl()))
    ..registerLazySingleton(() => GetTypeAvailability(sl()))
    ..registerLazySingleton(() => MakePaperSet(sl(), Random()))
    ..registerLazySingleton(() => GetReplacements(sl()))
    ..registerLazySingleton(
      () => SavePlannedPaper(sl(), () => const Uuid().v4(), DateTime.now),
    )
    // master questions
    ..registerLazySingleton(() => GetMasterQuestions(sl()))
    ..registerLazySingleton(() => SaveMasterQuestion(sl()))
    ..registerLazySingleton(() => DeleteMasterQuestion(sl()))
    // fees
    ..registerLazySingleton(() => GetFeeAccounts(sl()))
    ..registerLazySingleton(() => GetFeePeople(sl()))
    ..registerLazySingleton(() => CreateFeeAccount(sl()))
    ..registerLazySingleton(() => RecordPayment(sl()))
    ..registerLazySingleton(() => GetPersonPayments(sl()))
    ..registerLazySingleton(() => GetFeeStructure(sl()))
    ..registerLazySingleton(() => SaveFeeStructureItem(sl()))
    ..registerLazySingleton(() => ApplyFeeStructure(sl()))
    ..registerLazySingleton(() => ChangeFeeDates(sl()))
    ..registerLazySingleton(() => GetPayments(sl()))
    ..registerLazySingleton(() => GetPaymentHistory(sl()))
    ..registerLazySingleton(() => CreateReceipt(sl()))
    // notices
    ..registerLazySingleton(() => GetNotices(sl()))
    ..registerLazySingleton(() => PostNotice(sl()))
    // analytics
    ..registerLazySingleton(() => GetClassAnalytics(sl()))
    ..registerLazySingleton(() => GetTeacherReports(sl()))
    // backup
    ..registerLazySingleton(() => PickBackupFile(sl()))
    ..registerLazySingleton(() => PreviewBackup(sl()))
    ..registerLazySingleton(() => RestoreBackup(sl(), sl(), sl(), sl()))
    ..registerLazySingleton(() => GetRestoreHistory(sl()))
    // demo data
    ..registerLazySingleton(() => LoadDemoData(sl()))
    ..registerLazySingleton(() => RemoveDemoData(sl()))
    // dashboard
    ..registerLazySingleton<UseCase<DashboardSummary, DashboardQuery>>(
      () => GetDashboardSummary(
        getOverview: sl(),
        getOtherStaff: sl(),
        getFeeAccounts: sl(),
        getPapers: sl(),
        getNotices: sl(),
        getSettings: sl(),
      ),
    )
    // accessories
    ..registerLazySingleton(() => GetClassAccessories(sl()))
    ..registerLazySingleton(() => SaveAccessoryItems(sl()))
    ..registerLazySingleton(() => SaveDressSizes(sl()))
    ..registerLazySingleton(() => IssueAccessories(sl()))
    ..registerLazySingleton(() => GetStudentIssues(sl()))
    ..registerLazySingleton(() => GetAccessoryRecords(sl()))
    // school day
    ..registerLazySingleton(() => GetSchoolTiming(sl()))
    ..registerLazySingleton(() => SaveSchoolTiming(sl()))
    ..registerLazySingleton(() => SaveTimingRule(sl()))
    ..registerLazySingleton(() => DeleteTimingRule(sl()))
    ..registerLazySingleton(() => GetAssembly(sl()))
    ..registerLazySingleton(() => SaveAssembly(sl()))
    ..registerLazySingleton(() => SaveAssemblyDuty(sl()))
    ..registerLazySingleton(() => GetBellSlots(sl()))
    ..registerLazySingleton(() => SaveBellSlot(sl()))
    ..registerLazySingleton(() => DeleteBellSlot(sl()))
    ..registerLazySingleton(() => GetClassTimetable(sl()))
    ..registerLazySingleton(() => GetTeachingOptions(sl()))
    ..registerLazySingleton(() => SaveTimetableEntry(sl()))
    ..registerLazySingleton(() => ClearTimetableEntry(sl()))
    ..registerLazySingleton(() => CopyTimetableDay(sl()))
    ..registerLazySingleton(() => GetTeacherDay(sl(), sl()))
    ..registerLazySingleton(() => GetMember<OtherStaff>(sl()))
    // bills
    ..registerLazySingleton(() => GetBills(sl()))
    ..registerLazySingleton(() => AddBill(sl()))
    ..registerLazySingleton(() => GetStaffPayables(sl()))
    ..registerLazySingleton(() => SettleBills(sl()))
    ..registerLazySingleton(() => GetSettlements(sl()))
    // proofs
    ..registerLazySingleton(() => CaptureProofPhoto(sl()))
    ..registerLazySingleton(() => SaveSignature(sl()))
    // sharing
    ..registerLazySingleton(() => ShareFiles(sl()));
}
