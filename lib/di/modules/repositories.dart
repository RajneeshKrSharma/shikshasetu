import 'package:flutter/foundation.dart';
import '../../features/backup/data/repository/file_restore_log.dart';
import '../../features/backup/domain/repository/restore_log_repository.dart';
import '../../features/data_monitor/data/repository/restore_comparison_repository_impl.dart';
import '../../features/data_monitor/domain/repository/restore_comparison_repository.dart';
import '../../features/backup/data/repository/downloads_external_copy.dart';
import '../../features/backup/domain/repository/external_copy_repository.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/data_monitor/data/repository/cloud_data_source.dart';
import '../../features/data_monitor/data/repository/data_source_registry_impl.dart';
import '../../features/data_monitor/data/repository/file_data_source.dart';
import '../../features/data_monitor/data/repository/local_db_data_source.dart';
import '../../features/data_monitor/domain/repository/data_source.dart';
import '../../features/cloud_sync/data/repository/sqlite_change_tracker.dart';
import '../../features/other_staff/data/repository/other_staff_repository_impl.dart';
import '../../features/other_staff/domain/entities/other_staff.dart';
import '../../features/other_staff/domain/repository/other_staff_repository.dart';
import 'package:uuid/uuid.dart';
import '../../features/question_bank/data/repository/question_bank_repository_impl.dart';
import '../../features/question_bank/domain/repository/question_bank_repository.dart';
import '../../features/bills/data/repository/bills_repository_impl.dart';
import '../../features/bills/domain/repository/bills_repository.dart';
import '../../features/school_day/data/repository/assembly_repository_impl.dart';
import '../../features/school_day/data/repository/school_timing_repository_impl.dart';
import '../../features/school_day/data/repository/timetable_repository_impl.dart';
import '../../features/school_day/domain/repository/school_day_repositories.dart';
import '../../features/accessories/data/repository/accessories_repository_impl.dart';
import '../../features/accessories/domain/repository/accessories_repository.dart';
import '../../features/proofs/data/repository/file_proof_store.dart';
import '../../features/proofs/domain/repository/proof_store.dart';
import '../../features/attendance/data/repository/other_staff_attendance_repository_impl.dart';
import '../../features/attendance/domain/repository/other_staff_attendance_repository.dart';
import '../../features/members/data/repository/other_staff_member_source.dart';
import '../../features/members/data/repository/sql_member_directory.dart';
import '../../features/members/data/repository/student_member_source.dart';
import '../../features/members/data/repository/teacher_member_source.dart';
import '../../features/members/domain/entities/member_workspace.dart';
import '../../features/members/domain/entities/workspace_catalog.dart';
import '../../features/members/domain/repository/member_directory.dart';
import '../../features/members/domain/repository/member_repository.dart';
import '../../features/students/domain/entities/student.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../../features/analytics/data/repository/analytics_repository_impl.dart';
import '../../features/analytics/domain/repository/analytics_repository.dart';
import '../../features/approvals/data/repository/approvals_repository_impl.dart';
import '../../features/approvals/domain/repository/approvals_repository.dart';
import '../../features/attendance/data/repository/attendance_repository_impl.dart';
import '../../features/attendance/data/repository/selfie_repository_impl.dart';
import '../../features/attendance/data/repository/attendance_report_repository_impl.dart';
import '../../features/attendance/domain/repository/attendance_report_repository.dart';
import '../../features/attendance/domain/repository/attendance_repository.dart';
import '../../features/attendance/domain/repository/selfie_repository.dart';
import '../../core/network/http_inspector.dart';
import '../../features/auth/data/api/api_account_service.dart';
import '../../features/auth/data/api/api_client.dart';
import '../../features/auth/data/api/api_config.dart';
import '../../features/auth/data/api/api_school_profile_service.dart';
import '../../features/auth/data/api/api_school_restorer.dart';
import '../../features/auth/domain/repository/school_profile_service.dart';
import '../../features/auth/data/api/token_store.dart';
import '../../features/teaching/data/repository/teaching_repository_impl.dart';
import '../../features/teaching/domain/repository/teaching_repository.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/account_service.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/repository/school_restorer.dart';
import '../../features/backup/data/repository/backup_repository_impl.dart';
import '../../features/backup/data/repository/file_picker_backup_storage.dart';
import '../../features/backup/domain/repository/backup_repository.dart';
import '../../features/backup/domain/repository/backup_storage_repository.dart';
import '../../features/classes/data/repository/classes_repository_impl.dart';
import '../../features/classes/domain/repository/classes_repository.dart';
import '../../features/exams/data/repository/exams_repository_impl.dart';
import '../../features/exams/data/repository/image_picker_photo_repository.dart';
import '../../features/exams/data/repository/mlkit_question_scanner_repository.dart';
import '../../features/exams/domain/repository/exams_repository.dart';
import '../../features/exams/domain/repository/photo_picker_repository.dart';
import '../../features/exams/domain/repository/question_scanner_repository.dart';
import '../../features/exams/data/repository/pdf_paper_document_repository.dart';
import '../../features/exams/domain/repository/paper_document_repository.dart';
import '../../features/cloud_sync/data/notification/local_sync_notifier.dart';
import '../../features/cloud_sync/data/unconnected/unconnected_cloud.dart';
import '../../features/cloud_sync/data/repository/sqlite_sync_repositories.dart';
import '../../features/cloud_sync/domain/entities/sync_activity.dart';
import '../../features/cloud_sync/domain/repository/cloud_sync_repositories.dart';
import '../../features/face_id/data/repository/sqlite_face_template_repository.dart';
import '../../features/face_id/data/repository/tflite_face_embedder.dart';
import '../../features/face_id/domain/repository/face_repositories.dart';
import '../../features/face_id/presentation/widgets/face_capture_launcher.dart';
import '../../features/fees/data/repository/fees_repository_impl.dart';
import '../../features/school_calendar/data/repository/school_calendar_repository_impl.dart';
import '../../features/school_calendar/domain/repository/school_calendar_repository.dart';
import '../../features/profiles/data/repository/profiles_repository_impl.dart';
import '../../features/profiles/domain/repository/profiles_repository.dart';
import '../../features/printing/data/repository/bluetooth_thermal_printer_repository.dart';
import '../../features/printing/data/repository/system_document_printer_repository.dart';
import '../../features/printing/domain/repository/document_printer_repository.dart';
import '../../features/printing/domain/repository/thermal_printer_repository.dart';
import '../../features/master_questions/data/repository/master_questions_repository_impl.dart';
import '../../features/master_questions/domain/repository/master_questions_repository.dart';
import '../../features/fees/data/repository/pdf_receipt_repository.dart';
import '../../features/fees/domain/repository/fees_repository.dart';
import '../../features/fees/domain/repository/receipt_repository.dart';
import '../../features/location/data/repository/geocoding_address_repository.dart';
import '../../features/location/data/repository/geolocator_location_repository.dart';
import '../../features/location/domain/repository/address_repository.dart';
import '../../features/location/domain/repository/location_repository.dart';
import '../../features/notices/data/repository/notices_repository_impl.dart';
import '../../features/notices/domain/repository/notices_repository.dart';
import '../../features/registration/data/repository/registration_repository_impl.dart';
import '../../features/registration/domain/repository/registration_repository.dart';
import '../../features/demo_data/data/repository/demo_data_repository_impl.dart';
import '../../features/demo_data/domain/repository/demo_data_repository.dart';
import '../../features/settings/data/repository/settings_repository_impl.dart';
import '../../features/settings/domain/repository/settings_repository.dart';
import '../../features/sharing/data/repository/share_plus_file_sharer.dart';
import '../../features/sharing/domain/repository/file_sharer.dart';
import '../../features/staff/data/repository/staff_repository_impl.dart';
import '../../features/staff/domain/repository/staff_repository.dart';
import '../../features/students/data/repository/students_repository_impl.dart';
import '../../features/students/domain/repository/students_repository.dart';

/// Binds each repository contract to its implementation.
void registerRepositories(GetIt sl) {
  sl
    ..registerLazySingleton<SyncSourceRepository>(
      () => SqliteSyncSourceRepository(sl()),
    )
    ..registerLazySingleton<SyncSettingsRepository>(
      () => SqliteSyncSettingsRepository(sl()),
    )
    ..registerLazySingleton<ExternalCopyRepository>(DownloadsExternalCopy.new)
    ..registerLazySingleton<RestoreLogRepository>(FileRestoreLog.new)
    ..registerLazySingleton<RestoreComparisonRepository>(
      () => RestoreComparisonRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<DataSourceRegistry>(
      () => DataSourceRegistryImpl([
        LocalDbDataSource(sl()),
        FileDataSource(
          getApplicationDocumentsDirectory,
          tables: sl<SyncSourceRepository>().tables,
        ),
        const CloudDataSource(),
      ], sl<SyncSourceRepository>().tables),
    )
    ..registerLazySingleton<SyncNotifier>(() => LocalSyncNotifier())
    ..registerLazySingleton(SyncActivityLog.new)
    ..registerLazySingleton<ChangeTrackerRepository>(
      () => SqliteChangeTracker(sl()),
    )
    ..registerLazySingleton<SyncStateRepository>(
      () => SqliteSyncStateRepository(sl()),
    )
    ..registerLazySingleton<SchoolPullRepository>(
      () => const UnconnectedSchoolPull(),
    )
    ..registerLazySingleton<PaperRequestsRepository>(
      () => const UnconnectedPaperRequests(),
    )
    ..registerLazySingleton<SubjectRequestsRepository>(
      () => const UnconnectedSubjectRequests(),
    )
    ..registerLazySingleton<TeacherWorkRepository>(
      () => const UnconnectedTeacherWork(),
    )
    ..registerLazySingleton<CloudStoreRepository>(
      () => const UnconnectedCloudStore(),
    )
    ..registerLazySingleton<TeachingRepository>(
      () => TeachingRepositoryImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl(), sl(), sl()),
    )
    ..registerLazySingleton<HttpInspector>(
      () => kDebugMode ? ConsoleInspector() : const NoInspector(),
    )
    ..registerLazySingleton<TokenStore>(() => const SecureTokenStore())
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(const ApiConfig(), sl(), sl()),
    )
    ..registerLazySingleton<SchoolProfileService>(
      () => ApiSchoolProfileService(sl()),
    )
    ..registerLazySingleton<SchoolRestorer>(() => ApiSchoolRestorer(sl(), sl()))
    ..registerLazySingleton<AccountService>(
      () => ApiAccountService(sl(), sl(), sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl()),
    )
    ..registerLazySingleton<ClassesRepository>(
      () => ClassesRepositoryImpl(sl()),
    )
    ..registerLazySingleton<StudentsRepository>(
      () => StudentsRepositoryImpl(sl()),
    )
    ..registerLazySingleton<MemberRepository<Student>>(
      () => sl<StudentsRepository>(),
    )
    ..registerLazySingleton<MemberDirectory>(
      () => SqlMemberDirectory([
        StudentMemberSource(sl()),
        TeacherMemberSource(sl()),
        OtherStaffMemberSource(sl()),
      ]),
    )
    ..registerLazySingleton(
      () => WorkspaceCatalog(const [
        StudentWorkspace(),
        TeacherWorkspace(),
        OtherStaffWorkspace(),
      ]),
    )
    ..registerLazySingleton<StaffRepository>(() => StaffRepositoryImpl(sl()))
    ..registerLazySingleton<AttendanceRepository>(
      () => AttendanceRepositoryImpl(sl()),
    )
    ..registerLazySingleton<OtherStaffAttendanceRepository>(
      () => OtherStaffAttendanceRepositoryImpl(sl()),
    )
    ..registerLazySingleton<AttendanceReportRepository>(
      () => AttendanceReportRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<ApprovalsRepository>(
      () => ApprovalsRepositoryImpl(sl(), sl(), sl(), sl()),
    )
    ..registerLazySingleton<SelfieRepository>(() => SelfieRepositoryImpl())
    ..registerLazySingleton<FaceTemplateRepository>(
      () => SqliteFaceTemplateRepository(sl()),
    )
    ..registerLazySingleton<FaceEmbedder>(() => TfliteFaceEmbedder())
    ..registerLazySingleton<FaceCapturePort>(
      () => FaceCaptureLauncher(sl<GlobalKey<NavigatorState>>()),
    )
    ..registerLazySingleton<AddressRepository>(
      () => GeocodingAddressRepository(),
    )
    ..registerLazySingleton<LocationRepository>(
      () => GeolocatorLocationRepository(),
    )
    ..registerLazySingleton<RegistrationRepository>(
      () => RegistrationRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<ExamsRepository>(() => ExamsRepositoryImpl(sl()))
    ..registerLazySingleton<SchoolCalendarRepository>(
      () => SchoolCalendarRepositoryImpl(sl()),
    )
    ..registerLazySingleton<ProfilesRepository>(
      () => ProfilesRepositoryImpl(sl()),
    )
    ..registerLazySingleton<PaperDocumentRepository>(
      () => PdfPaperDocumentRepository(),
    )
    ..registerLazySingleton<ThermalPrinterRepository>(
      () => BluetoothThermalPrinterRepository(),
    )
    ..registerLazySingleton<DocumentPrinterRepository>(
      () => SystemDocumentPrinterRepository(),
    )
    ..registerLazySingleton<MasterQuestionsRepository>(
      () => MasterQuestionsRepositoryImpl(sl()),
    )
    ..registerLazySingleton<QuestionBankRepository>(
      () => QuestionBankRepositoryImpl(
        sl(),
        () => const Uuid().v4(),
        DateTime.now,
      ),
    )
    ..registerLazySingleton<QuestionScannerRepository>(
      () => MlKitQuestionScannerRepository(),
    )
    ..registerLazySingleton<PhotoPickerRepository>(
      () => ImagePickerPhotoRepository(),
    )
    ..registerLazySingleton<FeesRepository>(() => FeesRepositoryImpl(sl()))
    ..registerLazySingleton<ReceiptRepository>(() => PdfReceiptRepository())
    ..registerLazySingleton<NoticesRepository>(
      () => NoticesRepositoryImpl(sl()),
    )
    ..registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(sl()),
    )
    ..registerLazySingleton<BackupRepository>(() => BackupRepositoryImpl(sl()))
    ..registerLazySingleton<BackupStorageRepository>(
      () => FilePickerBackupStorage(),
    )
    ..registerLazySingleton<DemoDataRepository>(
      () => DemoDataRepositoryImpl(sl()),
    )
    ..registerLazySingleton<AccessoriesRepository>(
      () => AccessoriesRepositoryImpl(sl()),
    )
    ..registerLazySingleton<SchoolTimingRepository>(
      () => SchoolTimingRepositoryImpl(sl()),
    )
    ..registerLazySingleton<AssemblyRepository>(
      () => AssemblyRepositoryImpl(sl()),
    )
    ..registerLazySingleton<TimetableRepository>(
      () => TimetableRepositoryImpl(sl()),
    )
    ..registerLazySingleton<OtherStaffRepository>(
      () => OtherStaffRepositoryImpl(sl()),
    )
    ..registerLazySingleton<MemberRepository<OtherStaff>>(
      () => sl<OtherStaffRepository>(),
    )
    ..registerLazySingleton<BillsRepository>(() => BillsRepositoryImpl(sl()))
    ..registerLazySingleton<ProofStore>(() => FileProofStore())
    ..registerLazySingleton<FileSharer>(() => SharePlusFileSharer());
}
