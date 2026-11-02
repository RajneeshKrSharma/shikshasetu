import 'package:get_it/get_it.dart';

import '../../features/exams/data/repository/server_exams_repository.dart';
import '../../features/exams/domain/entities/exams.dart';
import '../../features/exams/domain/repository/exams_repository.dart';
import '../../features/exams/domain/usecases/exams_usecases.dart';
import '../../features/exams/presentation/bloc/exam_detail_bloc.dart';
import '../../features/exams/presentation/bloc/exams_bloc.dart';
import '../../features/exams/presentation/bloc/question_bank_bloc.dart';
import '../../features/exams/presentation/bloc/student_results_bloc.dart';
import '../../features/exams/presentation/bloc/unit_questions_bloc.dart';
import '../../features/session/domain/entities/account.dart';

void registerExams(GetIt sl) {
  sl
    ..registerLazySingleton<ExamsRepository>(() => ServerExamsRepository(sl()))
    ..registerLazySingleton<QuestionBankRepository>(
      () => ServerQuestionBankRepository(sl()),
    )
    ..registerLazySingleton<PaperRepository>(() => ServerPaperRepository(sl()))
    ..registerLazySingleton(() => GetExams(sl()))
    ..registerLazySingleton(() => SaveExam(sl()))
    ..registerLazySingleton(() => RemoveExam(sl()))
    ..registerLazySingleton(() => GetExamResults(sl()))
    ..registerLazySingleton(() => EnterMarks(sl()))
    ..registerLazySingleton(() => GetStudentResults(sl()))
    ..registerLazySingleton(() => GetUnits(sl()))
    ..registerLazySingleton(() => SaveUnit(sl()))
    ..registerLazySingleton(() => RemoveUnit(sl()))
    ..registerLazySingleton(() => GetQuestions(sl()))
    ..registerLazySingleton(() => SaveQuestion(sl()))
    ..registerLazySingleton(() => RemoveQuestion(sl()))
    ..registerLazySingleton(() => GetPaper(sl()))
    ..registerLazySingleton(() => ComposePaper(sl()))
    ..registerLazySingleton(() => SendPaper(sl()))
    ..registerLazySingleton(() => ApprovePaper(sl()))
    ..registerLazySingleton(() => RejectPaper(sl()))
    ..registerFactoryParam<ExamsBloc, Account, void>(
      (account, _) => ExamsBloc(
        account: account,
        getExams: sl(),
        saveExam: sl(),
        removeExam: sl(),
        getClasses: sl(),
      ),
    )
    ..registerFactoryParam<ExamDetailBloc, Exam, Account>(
      (exam, account) => ExamDetailBloc(
        exam: exam,
        account: account,
        getExamResults: sl(),
        enterMarks: sl(),
        getPaper: sl(),
        composePaper: sl(),
        sendPaper: sl(),
        approvePaper: sl(),
        rejectPaper: sl(),
        getUnits: sl(),
        getQuestions: sl(),
      ),
    )
    ..registerFactoryParam<StudentResultsBloc, String, void>(
      (id, _) => StudentResultsBloc(studentId: id, getStudentResults: sl()),
    )
    ..registerFactoryParam<QuestionBankBloc, Account, void>(
      (account, _) => QuestionBankBloc(
        account: account,
        getUnits: sl(),
        saveUnit: sl(),
        removeUnit: sl(),
        getClasses: sl(),
      ),
    )
    ..registerFactoryParam<UnitQuestionsBloc, String, Account>(
      (unitId, account) => UnitQuestionsBloc(
        unitId: unitId,
        account: account,
        getQuestions: sl(),
        saveQuestion: sl(),
        removeQuestion: sl(),
      ),
    );
}
