import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/exams.dart';
import '../../domain/usecases/exams_usecases.dart';

sealed class ExamDetailEvent extends Equatable {
  const ExamDetailEvent();

  @override
  List<Object?> get props => const [];
}

final class ExamDetailStarted extends ExamDetailEvent {
  const ExamDetailStarted();
}

final class MarksSubmitted extends ExamDetailEvent {
  const MarksSubmitted(this.entries);

  final List<MarkEntry> entries;

  @override
  List<Object?> get props => [entries];
}

final class PaperComposed extends ExamDetailEvent {
  const PaperComposed(this.questionIds);

  final List<String> questionIds;

  @override
  List<Object?> get props => [questionIds];
}

final class PaperSentForApproval extends ExamDetailEvent {
  const PaperSentForApproval();
}

final class PaperApprovedEvent extends ExamDetailEvent {
  const PaperApprovedEvent();
}

final class PaperRejectedEvent extends ExamDetailEvent {
  const PaperRejectedEvent(this.reason);

  final String reason;

  @override
  List<Object?> get props => [reason];
}

class ExamDetailState extends Equatable {
  const ExamDetailState({
    this.status = ViewStatus.loading,
    this.failure,
    this.access,
    this.results,
    this.paper,
    this.available = const [],
    this.busy = false,
    this.changedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final ExamsAccess? access;
  final ExamResults? results;
  final Paper? paper;

  /// Questions of the bank that could go on the paper (the teacher's units
  /// for this class and subject).
  final List<Question> available;
  final bool busy;
  final int changedCount;

  ExamDetailState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    ExamsAccess? access,
    ExamResults? results,
    Paper? paper,
    List<Question>? available,
    bool? busy,
    int? changedCount,
  }) => ExamDetailState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    access: access ?? this.access,
    results: results ?? this.results,
    paper: paper ?? this.paper,
    available: available ?? this.available,
    busy: busy ?? this.busy,
    changedCount: changedCount ?? this.changedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    access,
    results,
    paper,
    available,
    busy,
    changedCount,
  ];
}

class ExamDetailBloc extends Bloc<ExamDetailEvent, ExamDetailState> {
  ExamDetailBloc({
    required Exam exam,
    required Account account,
    required GetExamResults getExamResults,
    required EnterMarks enterMarks,
    required GetPaper getPaper,
    required ComposePaper composePaper,
    required SendPaper sendPaper,
    required ApprovePaper approvePaper,
    required RejectPaper rejectPaper,
    required GetUnits getUnits,
    required GetQuestions getQuestions,
  }) : _exam = exam,
       _account = account,
       _results = getExamResults,
       _enter = enterMarks,
       _getPaper = getPaper,
       _compose = composePaper,
       _send = sendPaper,
       _approve = approvePaper,
       _reject = rejectPaper,
       _units = getUnits,
       _questions = getQuestions,
       super(const ExamDetailState()) {
    on<ExamDetailStarted>(_onStarted);
    on<MarksSubmitted>(
      (e, emit) => _change(emit, () async {
        await _enter(EnterMarksParams(_exam.id, e.entries));
        emit(state.copyWith(results: await _results(_exam.id)));
      }),
    );
    on<PaperComposed>(
      (e, emit) => _change(emit, () async {
        emit(
          state.copyWith(
            paper: await _compose(ComposePaperParams(_exam.id, e.questionIds)),
          ),
        );
      }),
    );
    on<PaperSentForApproval>(
      (e, emit) => _change(emit, () async {
        emit(state.copyWith(paper: await _send(_exam.id)));
      }),
    );
    on<PaperApprovedEvent>(
      (e, emit) => _change(emit, () async {
        emit(state.copyWith(paper: await _approve(_exam.id)));
      }),
    );
    on<PaperRejectedEvent>(
      (e, emit) => _change(emit, () async {
        emit(
          state.copyWith(
            paper: await _reject(RejectPaperParams(_exam.id, e.reason)),
          ),
        );
      }),
    );
  }

  final Exam _exam;
  final Account _account;
  final GetExamResults _results;
  final EnterMarks _enter;
  final GetPaper _getPaper;
  final ComposePaper _compose;
  final SendPaper _send;
  final ApprovePaper _approve;
  final RejectPaper _reject;
  final GetUnits _units;
  final GetQuestions _questions;

  Future<void> _onStarted(
    ExamDetailStarted e,
    Emitter<ExamDetailState> emit,
  ) async {
    final access = ExamsAccess.of(_account);
    try {
      final results = access.canSeeResults ? await _results(_exam.id) : null;
      final wantsPaper = access.canPrepare || access.canSchedule;
      final paper = wantsPaper ? await _getPaper(_exam.id) : null;
      final available = access.canPrepare ? await _bank() : const <Question>[];
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          access: access,
          results: results,
          paper: paper,
          available: available,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<List<Question>> _bank() async {
    final units = await _units(const NoUnitsParams());
    final matching = [
      for (final u in units)
        if (u.classId == _exam.classId &&
            u.subject.toLowerCase() == _exam.subject.toLowerCase())
          u,
    ];
    return [for (final u in matching) ...await _questions(u.id)];
  }

  Future<void> _change(
    Emitter<ExamDetailState> emit,
    Future<void> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(state.copyWith(busy: false, changedCount: state.changedCount + 1));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
