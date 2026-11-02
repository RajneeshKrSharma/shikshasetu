import 'package:get_it/get_it.dart';

import '../../features/attendance/data/repository/server_attendance_repository.dart';
import '../../features/attendance/domain/repository/attendance_repository.dart';
import '../../features/attendance/domain/usecases/attendance_usecases.dart';
import '../../features/attendance/presentation/bloc/my_attendance_bloc.dart';
import '../../features/attendance/presentation/bloc/people_board_bloc.dart';
import '../../features/attendance/presentation/bloc/roster_bloc.dart';
import '../../features/attendance/presentation/bloc/student_report_bloc.dart';
import '../../features/session/domain/entities/account.dart';

void registerAttendance(GetIt sl) {
  sl
    ..registerLazySingleton<AttendanceRepository>(
      () => ServerAttendanceRepository(sl()),
    )
    ..registerLazySingleton(() => GetRoster(sl()))
    ..registerLazySingleton(() => MarkRoster(sl()))
    ..registerLazySingleton(() => GetStudentReport(sl()))
    ..registerLazySingleton(() => CheckIn(sl()))
    ..registerLazySingleton(() => CheckOut(sl()))
    ..registerLazySingleton(() => GetMyAttendance(sl()))
    ..registerLazySingleton(() => GetDayBoard(sl()))
    ..registerLazySingleton(() => CorrectAttendance(sl()))
    ..registerFactoryParam<RosterBloc, Account, void>(
      (account, _) => RosterBloc(
        account: account,
        getClasses: sl(),
        getRoster: sl(),
        markRoster: sl(),
      ),
    )
    ..registerFactory(
      () => StudentReportBloc(getClasses: sl(), getStudentReport: sl()),
    )
    ..registerFactory(
      () => MyAttendanceBloc(
        getMyAttendance: sl(),
        checkIn: sl(),
        checkOut: sl(),
      ),
    )
    ..registerFactoryParam<PeopleBoardBloc, Account, void>(
      (account, _) => PeopleBoardBloc(
        account: account,
        getDayBoard: sl(),
        correctAttendance: sl(),
      ),
    );
}
