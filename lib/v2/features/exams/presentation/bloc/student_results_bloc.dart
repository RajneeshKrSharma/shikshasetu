import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/exams.dart';
import '../../domain/usecases/exams_usecases.dart';

sealed class StudentResultsEvent extends Equatable {
  const StudentResultsEvent();

  @override
  List<Object?> get props => const [];
}

final class StudentResultsStarted extends StudentResultsEvent {
  const StudentResultsStarted();
}

class StudentResultsState extends Equatable {
  const StudentResultsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.results,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final StudentResults? results;

  @override
  List<Object?> get props => [status, failure, results];
}

class StudentResultsBloc
    extends Bloc<StudentResultsEvent, StudentResultsState> {
  StudentResultsBloc({
    required String studentId,
    required GetStudentResults getStudentResults,
  }) : _id = studentId,
       _get = getStudentResults,
       super(const StudentResultsState()) {
    on<StudentResultsStarted>((e, emit) async {
      try {
        emit(
          StudentResultsState(
            status: ViewStatus.ready,
            results: await _get(_id),
          ),
        );
      } on ServerException catch (error) {
        emit(
          StudentResultsState(
            status: ViewStatus.failed,
            failure: ViewFailure.from(error),
          ),
        );
      }
    });
  }

  final String _id;
  final GetStudentResults _get;
}
