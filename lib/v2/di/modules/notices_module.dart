import 'package:get_it/get_it.dart';

import '../../features/notices/data/repository/server_notices_repository.dart';
import '../../features/notices/domain/repository/notices_repository.dart';
import '../../features/notices/domain/usecases/notices_usecases.dart';
import '../../features/notices/presentation/bloc/notices_bloc.dart';
import '../../features/session/domain/entities/account.dart';

void registerNotices(GetIt sl) {
  sl
    ..registerLazySingleton<NoticesRepository>(
      () => ServerNoticesRepository(sl()),
    )
    ..registerLazySingleton(() => GetNotices(sl()))
    ..registerLazySingleton(() => PostNotice(sl()))
    ..registerLazySingleton(() => WithdrawNotice(sl()))
    ..registerFactoryParam<NoticesBloc, Account, void>(
      (account, _) => NoticesBloc(
        account: account,
        getNotices: sl(),
        postNotice: sl(),
        withdrawNotice: sl(),
      ),
    );
}
