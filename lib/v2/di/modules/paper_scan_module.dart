import 'package:get_it/get_it.dart';

import '../../../features/exams/data/repository/image_picker_photo_repository.dart';
import '../../../features/exams/data/repository/pdf_paper_document_repository.dart';
import '../../../features/exams/domain/repository/paper_document_repository.dart';
import '../../../features/exams/domain/repository/photo_picker_repository.dart';
import '../../../features/exams/domain/usecases/build_paper_document.dart';
import '../../../features/exams/domain/usecases/pick_photo.dart';
import '../../../features/printing/data/repository/system_document_printer_repository.dart';
import '../../../features/printing/domain/repository/document_printer_repository.dart';
import '../../../features/printing/domain/usecases/printer_usecases.dart';
import '../../features/paper_scan/data/repository/gemini_question_reader.dart';
import '../../features/paper_scan/data/repository/image_picker_logo_repository.dart';
import '../../features/paper_scan/data/repository/prefs_school_identity_repository.dart';
import '../../features/paper_scan/data/repository/secure_ai_key_repository.dart';
import '../../features/paper_scan/domain/repository/ai_key_repository.dart';
import '../../features/paper_scan/domain/repository/logo_picker_repository.dart';
import '../../features/paper_scan/domain/repository/question_reader_repository.dart';
import '../../features/paper_scan/domain/repository/school_identity_repository.dart';
import '../../features/paper_scan/domain/usecases/ai_key_usecases.dart';
import '../../features/paper_scan/domain/usecases/build_scanned_paper.dart';
import '../../features/paper_scan/domain/usecases/scan_paper_pages.dart';
import '../../features/paper_scan/domain/usecases/school_identity_usecases.dart';
import '../../features/paper_scan/presentation/bloc/paper_scan_bloc.dart';

/// Scan a handwritten paper to a PDF. Needs no sign-in. Handwriting is read
/// by Gemini (internet and an AI key); the PDF part is the exams feature's.
void registerPaperScan(GetIt sl) {
  sl
    ..registerLazySingleton<AiKeyRepository>(
      () => const SecureAiKeyRepository(),
    )
    ..registerLazySingleton<QuestionReaderRepository>(
      () => GeminiQuestionReader(sl()),
    )
    ..registerLazySingleton<PhotoPickerRepository>(
      () => ImagePickerPhotoRepository(),
    )
    ..registerLazySingleton<PaperDocumentRepository>(
      () => PdfPaperDocumentRepository(),
    )
    ..registerLazySingleton<DocumentPrinterRepository>(
      () => SystemDocumentPrinterRepository(),
    )
    ..registerLazySingleton<SchoolIdentityRepository>(
      () => PrefsSchoolIdentityRepository(),
    )
    ..registerLazySingleton<LogoPickerRepository>(
      () => ImagePickerLogoRepository(),
    )
    ..registerLazySingleton(() => PickPhoto(sl()))
    ..registerLazySingleton(() => BuildPaperDocument(sl()))
    ..registerLazySingleton(() => PrintWithSystemDialog(sl()))
    ..registerLazySingleton(() => SharePdf(sl()))
    ..registerLazySingleton(() => ScanPaperPages(sl()))
    ..registerLazySingleton(() => HasAiKey(sl()))
    ..registerLazySingleton(() => SaveAiKey(sl()))
    ..registerLazySingleton(() => ClearAiKey(sl()))
    ..registerLazySingleton(() => LoadSchoolIdentity(sl()))
    ..registerLazySingleton(() => SaveSchoolIdentity(sl()))
    ..registerLazySingleton(() => PickSchoolLogo(sl()))
    ..registerLazySingleton(() => BuildScannedPaper(sl()))
    ..registerFactory(
      () => PaperScanBloc(
        hasAiKey: sl(),
        saveAiKey: sl(),
        clearAiKey: sl(),
        pickPhoto: sl(),
        scanPages: sl(),
        loadIdentity: sl(),
        saveIdentity: sl(),
        pickLogo: sl(),
        buildPaper: sl(),
        printPdf: sl(),
        sharePdf: sl(),
      ),
    );
}
