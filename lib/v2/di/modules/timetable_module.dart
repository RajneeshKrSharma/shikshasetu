import 'package:get_it/get_it.dart';

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
    ..registerLazySingleton(() => SaveTimetable(sl()))
    ..registerFactory(
      () => TimetableBloc(
        getSettings: sl(),
        getClasses: sl(),
        getSubjects: sl(),
        getExams: sl(),
        saveTimetable: sl(),
        removeExam: sl(),
      ),
    )
    ..registerFactoryParam<TimetableSettingsCubit, TimetableSettings, void>(
      (initial, _) =>
          TimetableSettingsCubit(initial: initial, saveSettings: sl()),
    );
}
