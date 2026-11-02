import 'package:get_it/get_it.dart';

import '../../features/fleet/data/repository/server_fleet_repository.dart';
import '../../features/fleet/domain/repository/fleet_repository.dart';
import '../../features/fleet/domain/usecases/fleet_usecases.dart';
import '../../features/fleet/presentation/bloc/fuel_bills_bloc.dart';
import '../../features/fleet/presentation/bloc/vans_bloc.dart';
import '../../features/members/data/repository/server_members_repository.dart';
import '../../features/members/domain/entities/member.dart';
import '../../features/members/domain/usecases/members_usecases.dart';
import '../../features/session/domain/entities/account.dart';

void registerFleet(GetIt sl) {
  sl
    ..registerLazySingleton<FleetRepository>(() => ServerFleetRepository(sl()))
    ..registerLazySingleton(() => GetVans(sl()))
    ..registerLazySingleton(() => SaveVan(sl()))
    ..registerLazySingleton(() => RemoveVan(sl()))
    ..registerLazySingleton(() => GetFuelBills(sl()))
    ..registerLazySingleton(() => SubmitFuelBill(sl()))
    ..registerLazySingleton(() => WithdrawFuelBill(sl()))
    ..registerLazySingleton(() => ApproveFuelBill(sl()))
    ..registerLazySingleton(() => RejectFuelBill(sl()))
    ..registerFactoryParam<VansBloc, Account, void>(
      (account, _) => VansBloc(
        account: account,
        getVans: sl(),
        saveVan: sl(),
        removeVan: sl(),
        getStaff: GetMembers(ServerMembersRepository(sl(), const StaffKind())),
      ),
    )
    ..registerFactoryParam<FuelBillsBloc, Account, void>(
      (account, _) => FuelBillsBloc(
        account: account,
        getFuelBills: sl(),
        submitFuelBill: sl(),
        withdrawFuelBill: sl(),
        approveFuelBill: sl(),
        rejectFuelBill: sl(),
      ),
    );
}
