import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/student.dart';
import '../../domain/usecases/students_usecases.dart';

sealed class StudentEditorEvent extends Equatable {
  const StudentEditorEvent();

  @override
  List<Object?> get props => const [];
}

final class StudentSubmitted extends StudentEditorEvent {
  const StudentSubmitted(this.draft);

  final StudentDraft draft;

  @override
  List<Object?> get props => [draft];
}

class StudentEditorState extends Equatable {
  const StudentEditorState({this.busy = false, this.failure, this.saved});

  final bool busy;
  final ViewFailure? failure;

  /// The student as saved; set once, so the screen can close.
  final Student? saved;

  @override
  List<Object?> get props => [busy, failure, saved];
}

class StudentEditorBloc extends Bloc<StudentEditorEvent, StudentEditorState> {
  StudentEditorBloc({required SaveStudent saveStudent})
    : _save = saveStudent,
      super(const StudentEditorState()) {
    on<StudentSubmitted>(_onSubmitted);
  }

  final SaveStudent _save;

  Future<void> _onSubmitted(
    StudentSubmitted e,
    Emitter<StudentEditorState> emit,
  ) async {
    emit(const StudentEditorState(busy: true));
    try {
      emit(StudentEditorState(saved: await _save(e.draft)));
    } on ServerException catch (error) {
      emit(StudentEditorState(failure: ViewFailure.from(error)));
    }
  }
}
