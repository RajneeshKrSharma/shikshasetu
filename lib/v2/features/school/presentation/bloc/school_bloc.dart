import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/school.dart';
import '../../domain/entities/school_access.dart';
import '../../domain/usecases/school_usecases.dart';

sealed class SchoolEvent extends Equatable {
  const SchoolEvent();

  @override
  List<Object?> get props => const [];
}

final class SchoolStarted extends SchoolEvent {
  const SchoolStarted();
}

final class SchoolRenamed extends SchoolEvent {
  const SchoolRenamed(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class SeasonChosen extends SchoolEvent {
  const SeasonChosen(this.season);

  final Season season;

  @override
  List<Object?> get props => [season];
}

class SchoolState extends Equatable {
  const SchoolState({
    this.status = ViewStatus.loading,
    this.failure,
    this.school,
    this.timings,
    this.canEdit = false,
    this.busy = false,
    this.savedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final School? school;
  final SchoolTimings? timings;
  final bool canEdit;
  final bool busy;
  final int savedCount;

  SchoolState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    School? school,
    SchoolTimings? timings,
    bool? canEdit,
    bool? busy,
    int? savedCount,
  }) => SchoolState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    school: school ?? this.school,
    timings: timings ?? this.timings,
    canEdit: canEdit ?? this.canEdit,
    busy: busy ?? this.busy,
    savedCount: savedCount ?? this.savedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    school,
    timings,
    canEdit,
    busy,
    savedCount,
  ];
}

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  SchoolBloc({
    required Account account,
    required GetSchool getSchool,
    required GetTimings getTimings,
    required UpdateSchool updateSchool,
  }) : _account = account,
       _getSchool = getSchool,
       _getTimings = getTimings,
       _update = updateSchool,
       super(const SchoolState()) {
    on<SchoolStarted>(_onStarted);
    on<SchoolRenamed>(
      (e, emit) => _save(emit, UpdateSchoolParams(name: e.name)),
    );
    on<SeasonChosen>(
      (e, emit) => _save(emit, UpdateSchoolParams(activeSeason: e.season)),
    );
  }

  final Account _account;
  final GetSchool _getSchool;
  final GetTimings _getTimings;
  final UpdateSchool _update;

  Future<void> _onStarted(SchoolStarted e, Emitter<SchoolState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          school: await _getSchool(const NoParams()),
          timings: await _getTimings(const NoParams()),
          canEdit: SchoolAccess.of(_account).canEdit,
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

  Future<void> _save(Emitter<SchoolState> emit, UpdateSchoolParams p) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      final school = await _update(p);
      emit(
        state.copyWith(
          busy: false,
          school: school,
          timings: await _getTimings(const NoParams()),
          savedCount: state.savedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
