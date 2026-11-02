import 'package:get_it/get_it.dart';

import '../../features/requests/data/repository/server_requests_repository.dart';
import '../../features/requests/domain/repository/requests_repository.dart';
import '../../features/requests/domain/usecases/requests_usecases.dart';
import '../../features/requests/presentation/bloc/requests_bloc.dart';
import '../../features/session/domain/entities/account.dart';

void registerRequests(GetIt sl) {
  sl
    ..registerLazySingleton<RequestsRepository>(
      () => ServerRequestsRepository(sl()),
    )
    ..registerLazySingleton(() => GetRequests(sl()))
    ..registerLazySingleton(() => RaiseRequest(sl()))
    ..registerLazySingleton(() => WithdrawRequest(sl()))
    ..registerLazySingleton(() => ApproveRequest(sl()))
    ..registerLazySingleton(() => RejectRequest(sl()))
    ..registerFactoryParam<RequestsBloc, Account, void>(
      (account, _) => RequestsBloc(
        account: account,
        getRequests: sl(),
        raiseRequest: sl(),
        withdrawRequest: sl(),
        approveRequest: sl(),
        rejectRequest: sl(),
      ),
    );
}
