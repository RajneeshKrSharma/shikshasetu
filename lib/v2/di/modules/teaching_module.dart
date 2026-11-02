import 'package:get_it/get_it.dart';

import '../../features/members/domain/entities/member.dart';
import '../../features/members/data/repository/server_members_repository.dart';
import '../../features/members/domain/usecases/members_usecases.dart';
import '../../features/session/domain/entities/account.dart';
import '../../features/teaching/data/repository/server_teaching_repository.dart';
import '../../features/teaching/domain/repository/teaching_repository.dart';
import '../../features/teaching/domain/usecases/teaching_usecases.dart';
import '../../features/teaching/presentation/bloc/allotments_bloc.dart';
import '../../features/teaching/presentation/bloc/lesson_board_bloc.dart';
import '../../features/teaching/presentation/bloc/my_lessons_bloc.dart';

void registerTeaching(GetIt sl) {
  sl
    ..registerLazySingleton<TeachingRepository>(
      () => ServerTeachingRepository(sl()),
    )
    ..registerLazySingleton(() => GetAllotments(sl()))
    ..registerLazySingleton(() => AllotClass(sl()))
    ..registerLazySingleton(() => RemoveAllotment(sl()))
    ..registerLazySingleton(() => GetRecentLessons(sl()))
    ..registerLazySingleton(() => RecordLesson(sl()))
    ..registerLazySingleton(() => GetLessonBoard(sl()))
    ..registerFactoryParam<AllotmentsBloc, Account, void>(
      (account, _) => AllotmentsBloc(
        account: account,
        getAllotments: sl(),
        allotClass: sl(),
        removeAllotment: sl(),
        getTeachers: GetMembers(
          ServerMembersRepository(sl(), const TeacherKind()),
        ),
        getClasses: sl(),
      ),
    )
    ..registerFactory(() => LessonBoardBloc(getLessonBoard: sl()))
    ..registerFactoryParam<MyLessonsBloc, Account, void>(
      (account, _) => MyLessonsBloc(
        account: account,
        getAllotments: sl(),
        getRecentLessons: sl(),
        recordLesson: sl(),
      ),
    );
}
