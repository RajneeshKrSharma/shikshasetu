import 'package:get_it/get_it.dart';

import '../../features/session/domain/entities/account.dart';
import '../../features/students/data/repository/server_classes_repository.dart';
import '../../features/students/data/repository/server_students_repository.dart';
import '../../features/students/domain/repository/classes_repository.dart';
import '../../features/students/domain/repository/students_repository.dart';
import '../../features/students/domain/usecases/classes_usecases.dart';
import '../../features/students/domain/usecases/students_usecases.dart';
import '../../features/students/presentation/bloc/classes_bloc.dart';
import '../../features/students/presentation/bloc/student_detail_bloc.dart';
import '../../features/students/presentation/bloc/student_editor_bloc.dart';
import '../../features/students/presentation/bloc/students_bloc.dart';

void registerStudents(GetIt sl) {
  sl
    ..registerLazySingleton<ClassesRepository>(
      () => ServerClassesRepository(sl()),
    )
    ..registerLazySingleton<StudentsRepository>(
      () => ServerStudentsRepository(sl()),
    )
    ..registerLazySingleton(() => GetClasses(sl()))
    ..registerLazySingleton(() => SaveClass(sl()))
    ..registerLazySingleton(() => RemoveClass(sl()))
    ..registerLazySingleton(() => GetStudents(sl()))
    ..registerLazySingleton(() => GetStudent(sl()))
    ..registerLazySingleton(() => SaveStudent(sl()))
    ..registerLazySingleton(() => SetStudentActive(sl()))
    ..registerFactoryParam<ClassesBloc, Account, void>(
      (account, _) => ClassesBloc(
        account: account,
        getClasses: sl(),
        saveClass: sl(),
        removeClass: sl(),
      ),
    )
    ..registerFactoryParam<StudentsBloc, Account, void>(
      (account, _) =>
          StudentsBloc(account: account, getStudents: sl(), getClasses: sl()),
    )
    ..registerFactoryParam<StudentDetailBloc, String, Account>(
      (id, account) => StudentDetailBloc(
        studentId: id,
        account: account,
        getStudent: sl(),
        setStudentActive: sl(),
      ),
    )
    ..registerFactory(() => StudentEditorBloc(saveStudent: sl()));
}
