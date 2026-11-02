import 'package:get_it/get_it.dart';

import '../../features/permissions/data/repository/server_grants_repository.dart';
import '../../features/permissions/domain/repository/grants_repository.dart';
import '../../features/permissions/domain/usecases/grants_usecases.dart';
import '../../features/permissions/presentation/bloc/grants_bloc.dart';

void registerPermissions(GetIt sl) {
  sl
    ..registerLazySingleton<GrantsRepository>(
      () => ServerGrantsRepository(sl()),
    )
    ..registerLazySingleton(() => GetCapabilities(sl()))
    ..registerLazySingleton(() => GetGrants(sl()))
    ..registerLazySingleton(() => GrantPermission(sl()))
    ..registerLazySingleton(() => RevokePermission(sl()))
    ..registerFactoryParam<GrantsBloc, String, void>(
      (userId, _) => GrantsBloc(
        userId: userId,
        getCapabilities: sl(),
        getGrants: sl(),
        grantPermission: sl(),
        revokePermission: sl(),
      ),
    );
}
