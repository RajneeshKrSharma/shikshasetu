import '../../features/accessories/presentation/bloc/accessory_set_cubit.dart';
import '../../features/accessories/presentation/bloc/accessory_records_cubit.dart';
import '../../features/data_monitor/presentation/bloc/data_monitor_cubit.dart';
import '../../features/backup/presentation/bloc/data_mirror_cubit.dart';
import '../../features/bills/presentation/bloc/add_bill_bloc.dart';
import '../../features/bills/presentation/bloc/bills_bloc.dart';
import '../../features/bills/presentation/bloc/settle_bloc.dart';
import '../../features/bills/presentation/bloc/settlements_cubit.dart';
import '../../features/bills/presentation/bloc/staff_payment_bloc.dart';
import '../../features/other_staff/presentation/bloc/staff_profile_cubit.dart';
import '../../features/question_bank/domain/entities/bank_scope.dart';
import '../../features/question_bank/presentation/bloc/add_question_cubit.dart';
import '../../features/question_bank/presentation/bloc/paper_maker_cubit.dart';
import '../../features/question_bank/presentation/bloc/photo_questions_cubit.dart';
import '../../features/question_bank/presentation/bloc/question_bank_cubit.dart';
import '../../features/question_bank/presentation/bloc/unit_questions_cubit.dart';
import '../../features/school_day/presentation/bloc/assembly_bloc.dart';
import '../../features/school_day/presentation/bloc/bell_schedule_bloc.dart';
import '../../features/school_day/presentation/bloc/school_timing_bloc.dart';
import '../../features/school_day/presentation/bloc/teacher_day_cubit.dart';
import '../../features/school_day/presentation/bloc/timetable_bloc.dart';
import '../../features/accessories/presentation/bloc/accessories_bloc.dart';
import '../../features/accessories/presentation/bloc/dress_sizes_bloc.dart';
import '../../features/accessories/presentation/bloc/issue_bloc.dart';
import '../../features/accessories/presentation/bloc/student_issues_cubit.dart';
import '../../features/proofs/presentation/bloc/proof_cubit.dart';
import '../../features/attendance/domain/entities/attendance_record.dart';
import '../../features/attendance/presentation/bloc/staff_marking_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/analytics/presentation/bloc/analytics_bloc.dart';
import '../../features/approvals/presentation/bloc/approvals_bloc.dart';
import '../../features/attendance/presentation/bloc/attendance_bloc.dart';
import '../../features/attendance/presentation/bloc/marking_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/teaching/presentation/bloc/teaching_bloc.dart';
import '../../features/backup/presentation/bloc/backup_bloc.dart';
import '../../features/classes/presentation/bloc/classes_bloc.dart';

import '../../features/attendance/presentation/bloc/attendance_report_bloc.dart';
import '../../features/cloud_sync/presentation/bloc/cloud_sync_cubit.dart';
import '../../features/cloud_sync/presentation/bloc/school_refresh_cubit.dart';
import '../../features/registration/presentation/bloc/aadhaar_capture_cubit.dart';
import '../../features/face_id/presentation/bloc/face_id_cubit.dart';
import '../../features/profiles/presentation/bloc/profile_cubits.dart';
import '../../features/school_calendar/presentation/bloc/add_holidays_bloc.dart';
import '../../features/school_calendar/presentation/bloc/day_detail_cubit.dart';
import '../../features/school_calendar/presentation/bloc/holidays_cubit.dart';
import '../../features/school_calendar/presentation/bloc/school_calendar_cubit.dart';
import '../../features/school_calendar/presentation/bloc/suggested_holidays_cubit.dart';
import '../../features/exams/domain/entities/exam_paper.dart';
import '../../features/exams/domain/entities/paper_document.dart';
import '../../features/exams/presentation/bloc/exams_bloc.dart';
import '../../features/exams/presentation/bloc/paper_print_cubit.dart';
import '../../features/master_questions/presentation/bloc/master_questions_bloc.dart';
import '../../features/exams/presentation/bloc/marks_entry_bloc.dart';
import '../../features/exams/presentation/bloc/paper_form_bloc.dart';
import '../../features/fees/presentation/bloc/add_fee_bloc.dart';
import '../../features/fees/presentation/bloc/fees_bloc.dart';
import '../../features/fees/presentation/bloc/fee_dates_cubit.dart';
import '../../features/fees/presentation/bloc/fee_ledger_bloc.dart';
import '../../features/fees/presentation/bloc/fee_setup_bloc.dart';
import '../../features/fees/presentation/bloc/record_payment_bloc.dart';
import '../../features/fees/presentation/bloc/payment_history_cubit.dart';
import '../../features/notices/presentation/bloc/notices_bloc.dart';
import '../../features/demo_data/presentation/bloc/demo_data_cubit.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/members/domain/entities/member_kind.dart';
import '../../features/members/presentation/bloc/member_workspace_bloc.dart';
import '../../features/registration/presentation/bloc/register_form_bloc.dart';
import '../../features/registration/presentation/bloc/registration_bloc.dart';
import '../../features/settings/domain/entities/school_settings.dart';
import '../../features/settings/presentation/bloc/locale_cubit.dart';
import '../../features/settings/presentation/bloc/school_settings_form_bloc.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/staff/presentation/bloc/staff_bloc.dart';
import '../../features/home/presentation/bloc/dashboard_bloc.dart';
import '../../features/home/presentation/bloc/home_nav_cubit.dart';

/// Blocs are factories: each `BlocProvider` creates its own and closes it.
void registerBlocs(GetIt sl) {
  sl
    ..registerFactory(
      () => AuthBloc(
        restoreSession: sl(),
        nameSchool: sl(),
        needsSchoolSetup: sl(),
        signIn: sl(),
        signOut: sl(),
        syncVerifiedEmail: sl(),
      ),
    )
    ..registerFactory(
      () => TeachingBloc(
        getAssignments: sl(),
        requestSubject: sl(),
        allotSubject: sl(),
        removeAssignment: sl(),
      ),
    )
    ..registerFactory(
      () => DataMirrorCubit(
        getPending: sl(),
        markMirrored: sl(),
        writeMirror: sl(),
        publishCopy: sl(),
      ),
    )
    ..registerFactory(
      () => DataMonitorCubit(
        getSummary: sl(),
        compareTable: sl(),
        compareBackup: sl(),
        diffBackupTable: sl(),
      ),
    )
    ..registerFactory(LocaleCubit.new)
    ..registerFactory(HomeNavCubit.new)
    ..registerFactory(() => DashboardBloc(getDashboardSummary: sl()))
    ..registerFactoryParam<AttendanceReportBloc, AttendanceGroup?, void>(
      (group, _) => AttendanceReportBloc(getReport: sl(), lockedGroup: group),
    )
    ..registerFactoryParam<StaffMarkingBloc, DateTime, void>(
      (day, _) => StaffMarkingBloc(day: day, getStaff: sl(), saveStaff: sl()),
    )
    ..registerFactory(
      () => SettingsBloc(
        getSchoolSettings: sl(),
        saveSchoolLogo: sl(),
        saveAnnouncement: sl(),
        pickPhoto: sl(),
      ),
    )
    ..registerFactoryParam<SchoolSettingsFormBloc, SchoolSettings, void>(
      (initial, _) => SchoolSettingsFormBloc(
        initial: initial,
        getCurrentLocation: sl(),
        getAddress: sl(),
        saveSchoolSettings: sl(),
      ),
    )
    ..registerFactory(
      () => ClassesBloc(
        getClasses: sl(),
        addClass: sl(),
        renameClass: sl(),
        deleteClass: sl(),
      ),
    )
    ..registerFactory(
      () => StaffBloc(
        getStaff: sl(),
        setStaffActive: sl(),
        assignClassTeacher: sl(),
      ),
    )
    ..registerFactory(
      () => AttendanceBloc(
        getOverview: sl(),
        setDayStatus: sl(),
        checkIn: sl(),
        checkOut: sl(),
      ),
    )
    ..registerFactory(
      () => ApprovalsBloc(getApprovals: sl(), decideApproval: sl()),
    )
    ..registerFactoryParam<MarkingBloc, MarkingArgs, void>(
      (args, _) => MarkingBloc(
        classSection: args.classSection,
        students: args.students,
        saved: args.saved,
        saveClassAttendance: sl(),
      ),
    )
    ..registerFactory(() => RegistrationBloc(getPeople: sl()))
    ..registerFactory(
      () => AadhaarCaptureCubit(pickPhoto: sl(), readAadhaarCard: sl()),
    )
    ..registerFactoryParam<RegisterFormBloc, RegisterFormArgs, void>(
      (args, _) => RegisterFormBloc(
        args: args,
        getStudent: sl(),
        getVehicles: sl(),
        addStudent: sl(),
        updateStudent: sl(),
        registerTeacher: sl(),
        registerOther: sl(),
      ),
    )
    ..registerFactoryParam<MemberWorkspaceBloc, MemberKind, void>(
      (kind, _) => MemberWorkspaceBloc(
        kind: kind,
        getWorkspace: sl(),
        getMembers: sl(),
        setActive: sl(),
      ),
    )
    ..registerFactory(
      () => ExamsBloc(
        getPapers: sl(),
        markPaperConducted: sl(),
        changePaperStatus: sl(),
        deletePaper: sl(),
        shufflePaper: sl(),
      ),
    )
    ..registerFactoryParam<PaperFormBloc, ExamPaper?, void>(
      (initial, _) => PaperFormBloc(
        savePaper: sl(),
        pickPhoto: sl(),
        scanQuestions: sl(),
        parseQuestionText: sl(),
        initial: initial,
      ),
    )
    ..registerFactoryParam<FaceIdCubit, FaceIdArgs, void>(
      (args, _) => FaceIdCubit(
        args: args,
        getFaceEnrollment: sl(),
        setUpFace: sl(),
        removeFace: sl(),
      ),
    )
    ..registerFactory(
      () => SchoolCalendarCubit(getCalendarMonth: sl(), editSchoolDay: sl()),
    )
    ..registerFactory(
      () => HolidaysCubit(getHolidays: sl(), removeHoliday: sl()),
    )
    ..registerFactory(() => AddHolidaysBloc(addHolidays: sl()))
    ..registerFactoryParam<SuggestedHolidaysCubit, int, void>(
      (year, _) =>
          SuggestedHolidaysCubit(getSuggestedHolidays: sl(), year: year),
    )
    ..registerFactoryParam<DayDetailCubit, DateTime, void>(
      (day, _) => DayDetailCubit(
        day: day,
        getSchoolDayHistory: sl(),
        getHolidays: sl(),
      ),
    )
    ..registerFactoryParam<StudentProfileCubit, String, void>(
      (id, _) => StudentProfileCubit(studentId: id, getStudentProfile: sl()),
    )
    ..registerFactoryParam<TeacherProfileCubit, String, void>(
      (id, _) => TeacherProfileCubit(teacherId: id, getTeacherProfile: sl()),
    )
    ..registerFactory(
      () => SchoolRefreshCubit(
        pullSchoolUpdates: sl(),
        pushTeacherWork: sl(),
        sendPaperRequests: sl(),
        applyPaperDecisions: sl(),
        importPaperRequests: sl(),
        importTeacherWork: sl(),
        sendSubjectRequests: sl(),
        importSubjectRequests: sl(),
        notifier: sl(),
        activityLog: sl(),
      ),
    )
    ..registerFactory(
      () => CloudSyncCubit(
        getCloudConnection: sl(),
        syncToCloud: sl(),
        getLastChangeRun: sl(),
        getSyncInterval: sl(),
        setSyncInterval: sl(),
        syncNotifier: sl(),
        getLastSyncRun: sl(),
        getCloudSchoolId: sl(),
        getPendingChanges: sl(),
        markChangesSent: sl(),
      ),
    )
    ..registerFactory(
      () => MasterQuestionsBloc(
        getMasterQuestions: sl(),
        saveMasterQuestion: sl(),
        deleteMasterQuestion: sl(),
      ),
    )
    ..registerFactoryParam<MarksEntryBloc, String, void>(
      (paperId, _) => MarksEntryBloc(
        paperId: paperId,
        getPaperMarks: sl(),
        savePaperMarks: sl(),
      ),
    )
    ..registerFactory(() => FeesBloc(getFeeAccounts: sl()))
    ..registerFactoryParam<PaymentHistoryCubit, String?, void>(
      (personId, _) =>
          PaymentHistoryCubit(getPaymentHistory: sl(), personId: personId),
    )
    ..registerFactoryParam<
      PaperPrintCubit,
      PaperDocumentRequest Function(PaperLayout, bool),
      String
    >(
      (requestFor, title) => PaperPrintCubit(
        requestFor: requestFor,
        paperTitle: title,
        buildPaperDocument: sl(),
        checkThermalAccess: sl(),
        getPairedPrinters: sl(),
        printOnThermal: sl(),
        printWithSystemDialog: sl(),
        sharePdf: sl(),
      ),
    )
    ..registerFactoryParam<FeeLedgerBloc, String, void>(
      (personId, _) => FeeLedgerBloc(
        personId: personId,
        getPayments: sl(),
        createReceipt: sl(),
        shareFiles: sl(),
      ),
    )
    ..registerFactoryParam<RecordPaymentBloc, String, void>(
      (accountId, _) =>
          RecordPaymentBloc(accountId: accountId, recordPayment: sl()),
    )
    ..registerFactoryParam<FeeSetupBloc, String?, void>(
      (firstClass, _) => FeeSetupBloc(
        getStructure: sl(),
        saveItem: sl(),
        apply: sl(),
        firstClass: firstClass,
      ),
    )
    ..registerFactoryParam<FeeDatesCubit, String, void>(
      (accountId, _) => FeeDatesCubit(accountId: accountId, changeDates: sl()),
    )
    ..registerFactory(
      () => AddFeeBloc(getFeePeople: sl(), createFeeAccount: sl()),
    )
    ..registerFactory(() => NoticesBloc(getNotices: sl(), postNotice: sl()))
    ..registerFactory(
      () => AnalyticsBloc(getClassAnalytics: sl(), getTeacherReports: sl()),
    )
    ..registerFactory(
      () => BackupBloc(
        createBackupZip: sl(),
        shareFiles: sl(),
        downloadBackup: sl(),
        pickBackupFile: sl(),
        previewBackup: sl(),
        restoreBackup: sl(),
        getRestoreHistory: sl(),
      ),
    )
    ..registerFactory(
      () => DemoDataCubit(loadDemoData: sl(), removeDemoData: sl()),
    )
    ..registerFactoryParam<AccessoriesBloc, String?, void>(
      (firstClass, _) => AccessoriesBloc(
        getClass: sl(),
        saveItems: sl(),
        firstClass: firstClass,
      ),
    )
    ..registerFactoryParam<AccessorySetCubit, String?, void>(
      (firstClass, _) => AccessorySetCubit(
        firstClass: firstClass,
        getClass: sl(),
        saveItems: sl(),
      ),
    )
    ..registerFactory(() => AccessoryRecordsCubit(getRecords: sl()))
    ..registerFactoryParam<DressSizesBloc, String, void>(
      (className, _) =>
          DressSizesBloc(className: className, getClass: sl(), saveSizes: sl()),
    )
    ..registerFactoryParam<IssueBloc, IssueArgs, void>(
      (args, _) => IssueBloc(args: args, issue: sl()),
    )
    ..registerFactoryParam<StudentIssuesCubit, String, void>(
      (studentId, _) =>
          StudentIssuesCubit(studentId: studentId, getIssues: sl()),
    )
    ..registerFactory(
      () => SchoolTimingBloc(
        getTiming: sl(),
        saveTiming: sl(),
        saveRule: sl(),
        deleteRule: sl(),
      ),
    )
    ..registerFactory(
      () => AssemblyBloc(getAssembly: sl(), saveAssembly: sl(), saveDuty: sl()),
    )
    ..registerFactory(
      () => BellScheduleBloc(getSlots: sl(), saveSlot: sl(), deleteSlot: sl()),
    )
    ..registerFactoryParam<QuestionBankCubit, String, BankScope?>(
      (teacherId, scope) => QuestionBankCubit(
        teacherId: teacherId,
        getScopes: sl(),
        getOverview: sl(),
        addUnit: sl(),
        initial: scope,
      ),
    )
    ..registerFactoryParam<AddQuestionCubit, BankScope, String?>(
      (scope, unitId) => AddQuestionCubit(
        scope: scope,
        getOverview: sl(),
        addUnit: sl(),
        save: sl(),
        initialUnitId: unitId,
      ),
    )
    ..registerFactoryParam<PhotoQuestionsCubit, BankScope, String?>(
      (scope, unitId) => PhotoQuestionsCubit(
        scope: scope,
        getOverview: sl(),
        addUnit: sl(),
        save: sl(),
        pickPhoto: sl(),
        scan: sl(),
        review: sl(),
        check: sl(),
        unitId: unitId,
      ),
    )
    ..registerFactoryParam<UnitQuestionsCubit, BankScope, String>(
      (scope, unitId) => UnitQuestionsCubit(
        scope: scope,
        unitId: unitId,
        getQuestions: sl(),
        delete: sl(),
      ),
    )
    ..registerFactoryParam<PaperMakerCubit, String, BankScope?>(
      (teacherId, scope) => PaperMakerCubit(
        teacherId: teacherId,
        getScopes: sl(),
        getOverview: sl(),
        getAvailability: sl(),
        makeSet: sl(),
        getReplacements: sl(),
        savePaper: sl(),
        initial: scope,
      ),
    )
    ..registerFactoryParam<TeacherDayCubit, String, void>(
      (teacherId, _) => TeacherDayCubit(teacherId: teacherId, getDay: sl()),
    )
    ..registerFactoryParam<TimetableBloc, String?, void>(
      (firstClass, _) => TimetableBloc(
        getTimetable: sl(),
        getOptions: sl(),
        saveEntry: sl(),
        clearEntry: sl(),
        copyDay: sl(),
        firstClass: firstClass,
      ),
    )
    ..registerFactoryParam<BillsBloc, String?, void>(
      (staffId, _) => BillsBloc(staffId: staffId, getBills: sl()),
    )
    ..registerFactoryParam<AddBillBloc, String, void>(
      (staffId, _) => AddBillBloc(staffId: staffId, addBill: sl()),
    )
    ..registerFactory(() => StaffPayablesCubit(getPayables: sl()))
    ..registerFactoryParam<StaffPaymentBloc, String, void>(
      (staffId, _) => StaffPaymentBloc(staffId: staffId, getBills: sl()),
    )
    ..registerFactoryParam<SettleBloc, SettleArgs, void>(
      (args, _) => SettleBloc(args: args, settleBills: sl()),
    )
    ..registerFactoryParam<SettlementsCubit, String?, void>(
      (staffId, _) => SettlementsCubit(staffId: staffId, getAll: sl()),
    )
    ..registerFactoryParam<StaffProfileCubit, String, void>(
      (staffId, _) => StaffProfileCubit(
        staffId: staffId,
        getStaff: sl(),
        getPayables: sl(),
      ),
    )
    ..registerFactoryParam<ProofCubit, String, void>(
      (folder, _) =>
          ProofCubit(folder: folder, capturePhoto: sl(), saveSignature: sl()),
    )
    ..registerFactory(
      () => ProfileBloc(
        updateProfile: sl(),
        changePassword: sl(),
        requestEmailChange: sl(),
      ),
    );
}
