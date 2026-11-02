import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/school.dart';
import '../../domain/usecases/school_usecases.dart';

sealed class TimingEditorEvent extends Equatable {
  const TimingEditorEvent();

  @override
  List<Object?> get props => const [];
}

final class OpensChanged extends TimingEditorEvent {
  const OpensChanged(this.minute);

  final int minute;

  @override
  List<Object?> get props => [minute];
}

final class ClosesChanged extends TimingEditorEvent {
  const ClosesChanged(this.minute);

  final int minute;

  @override
  List<Object?> get props => [minute];
}

final class PeriodAdded extends TimingEditorEvent {
  const PeriodAdded();
}

final class PeriodRemoved extends TimingEditorEvent {
  const PeriodRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

final class PeriodEdited extends TimingEditorEvent {
  const PeriodEdited(this.index, {this.name, this.startsAt, this.endsAt});

  final int index;
  final String? name;
  final int? startsAt;
  final int? endsAt;

  @override
  List<Object?> get props => [index, name, startsAt, endsAt];
}

final class TimingSaved extends TimingEditorEvent {
  const TimingSaved();
}

class TimingEditorState extends Equatable {
  const TimingEditorState({
    required this.timing,
    this.busy = false,
    this.failure,
    this.doneCount = 0,
  });

  final SeasonTiming timing;
  final bool busy;
  final ViewFailure? failure;

  /// Goes up when the day was saved, so the screen can close.
  final int doneCount;

  TimingEditorState copyWith({
    SeasonTiming? timing,
    bool? busy,
    ViewFailure? failure,
    bool clearFailure = false,
    int? doneCount,
  }) => TimingEditorState(
    timing: timing ?? this.timing,
    busy: busy ?? this.busy,
    failure: clearFailure ? null : (failure ?? this.failure),
    doneCount: doneCount ?? this.doneCount,
  );

  @override
  List<Object?> get props => [timing, busy, failure, doneCount];
}

/// Edits one season's school day before it is saved as a whole.
class TimingEditorBloc extends Bloc<TimingEditorEvent, TimingEditorState> {
  TimingEditorBloc({
    required SeasonTiming initial,
    required SetSeasonTiming setSeasonTiming,
  }) : _set = setSeasonTiming,
       super(TimingEditorState(timing: initial)) {
    on<OpensChanged>(
      (e, emit) => emit(
        state.copyWith(timing: _with(opensAt: e.minute), clearFailure: true),
      ),
    );
    on<ClosesChanged>(
      (e, emit) => emit(
        state.copyWith(timing: _with(closesAt: e.minute), clearFailure: true),
      ),
    );
    on<PeriodAdded>(_onAdded);
    on<PeriodRemoved>(
      (e, emit) => emit(
        state.copyWith(
          timing: _with(periods: [...state.timing.periods]..removeAt(e.index)),
        ),
      ),
    );
    on<PeriodEdited>(_onEdited);
    on<TimingSaved>(_onSaved);
  }

  final SetSeasonTiming _set;

  SeasonTiming _with({int? opensAt, int? closesAt, List<Period>? periods}) =>
      SeasonTiming(
        season: state.timing.season,
        opensAt: opensAt ?? state.timing.opensAt,
        closesAt: closesAt ?? state.timing.closesAt,
        periods: periods ?? state.timing.periods,
      );

  /// A new period starts where the last one ended and runs for 40 minutes.
  void _onAdded(PeriodAdded e, Emitter<TimingEditorState> emit) {
    final periods = state.timing.periods;
    final start = periods.isEmpty
        ? (state.timing.opensAt ?? 8 * 60)
        : periods.last.endsAt;
    emit(
      state.copyWith(
        timing: _with(
          periods: [
            ...periods,
            Period(name: '', startsAt: start, endsAt: start + 40),
          ],
        ),
      ),
    );
  }

  void _onEdited(PeriodEdited e, Emitter<TimingEditorState> emit) {
    final periods = [...state.timing.periods];
    final p = periods[e.index];
    periods[e.index] = Period(
      name: e.name ?? p.name,
      startsAt: e.startsAt ?? p.startsAt,
      endsAt: e.endsAt ?? p.endsAt,
    );
    emit(state.copyWith(timing: _with(periods: periods), clearFailure: true));
  }

  Future<void> _onSaved(TimingSaved e, Emitter<TimingEditorState> emit) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      emit(
        state.copyWith(
          busy: false,
          timing: await _set(state.timing),
          doneCount: state.doneCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
