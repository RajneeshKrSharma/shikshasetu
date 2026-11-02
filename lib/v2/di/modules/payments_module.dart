import 'package:get_it/get_it.dart';

import '../../features/payments/data/repository/server_payments_repository.dart';
import '../../features/payments/domain/entities/payments.dart';
import '../../features/payments/domain/repository/payments_repository.dart';
import '../../features/payments/domain/usecases/payments_usecases.dart';
import '../../features/payments/presentation/bloc/my_account_bloc.dart';
import '../../features/payments/presentation/bloc/payees_bloc.dart';
import '../../features/payments/presentation/bloc/person_account_bloc.dart';

void registerPayments(GetIt sl) {
  sl
    ..registerLazySingleton<PaymentsRepository>(
      () => ServerPaymentsRepository(sl()),
    )
    ..registerLazySingleton(() => GetPayees(sl()))
    ..registerLazySingleton(() => GetPersonAccount(sl()))
    ..registerLazySingleton(() => GetSalaryHistory(sl()))
    ..registerLazySingleton(() => SetSalary(sl()))
    ..registerLazySingleton(() => PayPerson(sl()))
    ..registerLazySingleton(() => GetMyAccount(sl()))
    ..registerFactoryParam<PayeesBloc, PayeeGroup, void>(
      (group, _) => PayeesBloc(group: group, getPayees: sl()),
    )
    ..registerFactoryParam<PersonAccountBloc, String, bool>(
      (id, canManage) => PersonAccountBloc(
        personId: id,
        canManage: canManage,
        getPersonAccount: sl(),
        getSalaryHistory: sl(),
        setSalary: sl(),
        payPerson: sl(),
      ),
    )
    ..registerFactory(() => MyAccountBloc(getMyAccount: sl()));
}
