import 'package:get_it/get_it.dart';

import '../../features/timetable/data/document/pdf_timetable_document_builder.dart';
import '../../features/timetable/domain/entities/timetable_sheet.dart';
import '../../features/timetable/domain/repository/timetable_document_builder.dart';
import '../../features/timetable/presentation/bloc/timetable_print_cubit.dart';
import '../../features/timetable/data/repository/server_timetable_repository.dart';
import '../../features/timetable/domain/entities/timetable.dart';
import '../../features/timetable/domain/repository/timetable_repository.dart';
import '../../features/timetable/domain/usecases/timetable_usecases.dart';
import '../../features/timetable/presentation/bloc/timetable_bloc.dart';
import '../../features/timetable/presentation/bloc/timetable_settings_cubit.dart';

void registerTimetable(GetIt sl) {
  sl
    ..registerLazySingleton<TimetableRepository>(
      () => ServerTimetableRepository(sl()),
    )
    ..registerLazySingleton(() => GetTimetableSettings(sl()))
    ..registerLazySingleton(() => SaveTimetableSettings(sl()))
    ..registerLazySingleton(() => GetClassSubjects(sl()))
    ..registerLazySingleton<TimetableDocumentBuilder>(
      () => PdfTimetableDocumentBuilder(
        const PrintLetterhead(
          logoAsset: 'assets/images/school_logo.jpg',
          schoolName: 'R.D. Higher Secondary School',
          address: 'Nikasi, Nagra-Ballia (U.P.)',
        ),
      ),
    )
    ..registerLazySingleton(() => BuildTimetablePdf(sl(), sl(), sl(), sl()))
    ..registerFactory(() => TimetablePrintCubit(sl()))
    ..registerLazySingleton(() => SaveTimetable(sl()))
    ..registerFactory(
      () => TimetableBloc(
        getSettings: sl(),
        getClasses: sl(),
        getSubjects: sl(),
        getExams: sl(),
        saveTimetable: sl(),
        removeExam: sl(),
        saveExam: sl(),
      ),
    )
    ..registerFactoryParam<TimetableSettingsCubit, TimetableSettings, void>(
      (initial, _) =>
          TimetableSettingsCubit(initial: initial, saveSettings: sl()),
    );
}
