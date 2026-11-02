import 'package:get_it/get_it.dart';

import '../../features/session/data/repository/server_session_repository.dart';
import '../../features/session/domain/navigation/navigation_policy.dart';
import '../../features/session/domain/repository/session_repository.dart';
import '../../features/session/domain/usecases/build_navigation.dart';
import '../../features/session/domain/usecases/session_usecases.dart';
import '../../features/session/presentation/bloc/session_bloc.dart';

void registerSession(GetIt sl) {
  sl
    ..registerLazySingleton<SessionRepository>(
      () => ServerSessionRepository(sl(), sl()),
    )
    ..registerLazySingleton(() => const NavigationPolicies())
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => RestoreSession(sl()))
    ..registerLazySingleton(() => SignOut(sl()))
    ..registerLazySingleton(() => RenameMe(sl()))
    ..registerLazySingleton(() => ChangePassword(sl()))
    ..registerLazySingleton(() => WatchSessionEnd(sl()))
    ..registerLazySingleton(() => BuildNavigation(sl()))
    ..registerFactory(
      () => SessionBloc(
        signIn: sl(),
        restoreSession: sl(),
        signOut: sl(),
        renameMe: sl(),
        changePassword: sl(),
        watchSessionEnd: sl(),
        buildNavigation: sl(),
      ),
    );
}
