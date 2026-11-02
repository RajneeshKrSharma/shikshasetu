import 'package:get_it/get_it.dart';

import '../../features/accessories/data/repository/server_accessories_repository.dart';
import '../../features/accessories/domain/repository/accessories_repository.dart';
import '../../features/accessories/domain/usecases/accessories_usecases.dart';
import '../../features/accessories/presentation/bloc/accessory_items_bloc.dart';
import '../../features/accessories/presentation/bloc/sell_item_bloc.dart';
import '../../features/fees/data/repository/server_fees_repository.dart';
import '../../features/fees/domain/repository/fees_repository.dart';
import '../../features/fees/domain/usecases/fees_usecases.dart';
import '../../features/fees/presentation/bloc/fee_accounts_bloc.dart';
import '../../features/fees/presentation/bloc/fee_structure_bloc.dart';
import '../../features/fees/presentation/bloc/student_fees_bloc.dart';

void registerFees(GetIt sl) {
  sl
    ..registerLazySingleton<FeesRepository>(() => ServerFeesRepository(sl()))
    ..registerLazySingleton<AccessoriesRepository>(
      () => ServerAccessoriesRepository(sl()),
    )
    ..registerLazySingleton(() => GetFeeStructure(sl()))
    ..registerLazySingleton(() => SetFeeAmount(sl()))
    ..registerLazySingleton(() => GetFeeAccounts(sl()))
    ..registerLazySingleton(() => GetStudentFees(sl()))
    ..registerLazySingleton(() => ReceiveFee(sl()))
    ..registerLazySingleton(() => GetAccessoryItems(sl()))
    ..registerLazySingleton(() => SaveAccessoryItem(sl()))
    ..registerLazySingleton(() => RemoveAccessoryItem(sl()))
    ..registerLazySingleton(() => SellAccessory(sl()))
    ..registerFactory(
      () => FeeAccountsBloc(getFeeAccounts: sl(), getClasses: sl()),
    )
    ..registerFactory(
      () => FeeStructureBloc(
        getClasses: sl(),
        getFeeStructure: sl(),
        setFeeAmount: sl(),
      ),
    )
    ..registerFactoryParam<StudentFeesBloc, String, void>(
      (id, _) => StudentFeesBloc(
        studentId: id,
        getStudentFees: sl(),
        receiveFee: sl(),
      ),
    )
    ..registerFactory(
      () => AccessoryItemsBloc(
        getItems: sl(),
        saveItem: sl(),
        removeItem: sl(),
        getClasses: sl(),
      ),
    )
    ..registerFactoryParam<SellItemBloc, String, String>(
      (studentId, classId) => SellItemBloc(
        studentId: studentId,
        classId: classId,
        getItems: sl(),
        sellAccessory: sl(),
      ),
    );
}
