import 'package:get_it/get_it.dart';

import '../../features/analytics/data/repository/server_analytics_repository.dart';
import '../../features/analytics/domain/repository/analytics_repository.dart';
import '../../features/analytics/domain/usecases/analytics_usecases.dart';
import '../../features/analytics/presentation/bloc/analytics_bloc.dart';

void registerAnalytics(GetIt sl) {
  sl
    ..registerLazySingleton<AnalyticsRepository>(
      () => ServerAnalyticsRepository(sl()),
    )
    ..registerLazySingleton(() => GetGraph(sl()))
    ..registerFactory(() => AnalyticsBloc(getGraph: sl(), getClasses: sl()));
}
