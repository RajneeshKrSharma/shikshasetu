import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/school.dart';
import '../../domain/entities/school_access.dart';
import '../../domain/usecases/school_usecases.dart';

sealed class HolidaysEvent extends Equatable {
  const HolidaysEvent();

  @override
  List<Object?> get props => const [];
}

final class HolidaysStarted extends HolidaysEvent {
  const HolidaysStarted();
}

final class HolidaySaved extends HolidaysEvent {
  const HolidaySaved(this.draft);

  final HolidayDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class HolidayRemoved extends HolidaysEvent {
  const HolidayRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class HolidaysState extends Equatable {
  const HolidaysState({
    this.status = ViewStatus.loading,
    this.failure,
    this.holidays = const [],
    this.canEdit = false,
    this.busy = false,
    this.savedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Holiday> holidays;
  final bool canEdit;
  final bool busy;
  final int savedCount;

  HolidaysState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Holiday>? holidays,
    bool? canEdit,
    bool? busy,
    int? savedCount,
  }) => HolidaysState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    holidays: holidays ?? this.holidays,
    canEdit: canEdit ?? this.canEdit,
    busy: busy ?? this.busy,
    savedCount: savedCount ?? this.savedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    holidays,
    canEdit,
    busy,
    savedCount,
  ];
}

class HolidaysBloc extends Bloc<HolidaysEvent, HolidaysState> {
  HolidaysBloc({
    required Account account,
    required GetHolidays getHolidays,
    required SaveHoliday saveHoliday,
    required RemoveHoliday removeHoliday,
  }) : _account = account,
       _get = getHolidays,
       _save = saveHoliday,
       _remove = removeHoliday,
       super(const HolidaysState()) {
    on<HolidaysStarted>(_onStarted);
    on<HolidaySaved>((e, emit) => _change(emit, () => _save(e.draft)));
    on<HolidayRemoved>((e, emit) => _change(emit, () => _remove(e.id)));
  }

  final Account _account;
  final GetHolidays _get;
  final SaveHoliday _save;
  final RemoveHoliday _remove;

  Future<void> _onStarted(
    HolidaysStarted e,
    Emitter<HolidaysState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          holidays: await _get(const NoParams()),
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

  Future<void> _change(
    Emitter<HolidaysState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(
        state.copyWith(
          busy: false,
          holidays: await _get(const NoParams()),
          savedCount: state.savedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
