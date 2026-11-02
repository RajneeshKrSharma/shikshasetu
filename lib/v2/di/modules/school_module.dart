import 'package:get_it/get_it.dart';

import '../../features/school/data/repository/server_school_repository.dart';
import '../../features/school/domain/repository/school_repository.dart';
import '../../features/school/domain/usecases/school_usecases.dart';
import '../../features/school/domain/entities/school.dart';
import '../../features/school/presentation/bloc/holidays_bloc.dart';
import '../../features/school/presentation/bloc/school_bloc.dart';
import '../../features/school/presentation/bloc/timing_editor_bloc.dart';
import '../../features/session/domain/entities/account.dart';

void registerSchool(GetIt sl) {
  sl
    ..registerLazySingleton<SchoolRepository>(
      () => ServerSchoolRepository(sl()),
    )
    ..registerLazySingleton(() => GetSchool(sl()))
    ..registerLazySingleton(() => UpdateSchool(sl()))
    ..registerLazySingleton(() => GetTimings(sl()))
    ..registerLazySingleton(() => SetSeasonTiming(sl()))
    ..registerLazySingleton(() => GetHolidays(sl()))
    ..registerLazySingleton(() => SaveHoliday(sl()))
    ..registerLazySingleton(() => RemoveHoliday(sl()))
    ..registerFactoryParam<SchoolBloc, Account, void>(
      (account, _) => SchoolBloc(
        account: account,
        getSchool: sl(),
        getTimings: sl(),
        updateSchool: sl(),
      ),
    )
    ..registerFactoryParam<TimingEditorBloc, SeasonTiming, void>(
      (timing, _) => TimingEditorBloc(initial: timing, setSeasonTiming: sl()),
    )
    ..registerFactoryParam<HolidaysBloc, Account, void>(
      (account, _) => HolidaysBloc(
        account: account,
        getHolidays: sl(),
        saveHoliday: sl(),
        removeHoliday: sl(),
      ),
    );
}
