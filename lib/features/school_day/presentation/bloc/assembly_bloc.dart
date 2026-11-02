import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/assembly.dart';
import '../../domain/entities/day_time.dart';
import '../../domain/usecases/school_day_usecases.dart';

sealed class AssemblyEvent extends Equatable {
  const AssemblyEvent();

  @override
  List<Object?> get props => const [];
}

final class AssemblyStarted extends AssemblyEvent {
  const AssemblyStarted();
}

final class AssemblyTimesChanged extends AssemblyEvent {
  const AssemblyTimesChanged({this.start, this.end});

  final DayTime? start;
  final DayTime? end;

  @override
  List<Object?> get props => [start, end];
}

final class AssemblyPlaceChanged extends AssemblyEvent {
  const AssemblyPlaceChanged(this.place);

  final String place;

  @override
  List<Object?> get props => [place];
}

final class AssemblyDayToggled extends AssemblyEvent {
  const AssemblyDayToggled(this.weekday);

  final int weekday;

  @override
  List<Object?> get props => [weekday];
}

final class AssemblyOrderChanged extends AssemblyEvent {
  const AssemblyOrderChanged(this.order);

  final List<String> order;

  @override
  List<Object?> get props => [order];
}

final class AssemblyDutySaved extends AssemblyEvent {
  const AssemblyDutySaved(this.duty);

  final AssemblyDuty duty;

  @override
  List<Object?> get props => [duty];
}

class AssemblyState extends Equatable {
  const AssemblyState({
    this.loading = true,
    this.overview = const AssemblyOverview(AssemblySettings(), []),
  });

  final bool loading;
  final AssemblyOverview overview;

  AssemblySettings get settings => overview.settings;

  @override
  List<Object?> get props => [loading, overview];
}

/// The morning assembly: its time, place and order, and who is on duty.
class AssemblyBloc extends Bloc<AssemblyEvent, AssemblyState> {
  AssemblyBloc({
    required GetAssembly getAssembly,
    required SaveAssembly saveAssembly,
    required SaveAssemblyDuty saveDuty,
  }) : _get = getAssembly,
       _save = saveAssembly,
       _saveDuty = saveDuty,
       super(const AssemblyState()) {
    on<AssemblyStarted>((e, emit) => _load(emit));
    on<AssemblyTimesChanged>(
      (e, emit) => _update(
        emit,
        AssemblySettings(
          start: e.start ?? state.settings.start,
          end: e.end ?? state.settings.end,
          place: state.settings.place,
          days: state.settings.days,
          order: state.settings.order,
        ),
      ),
    );
    on<AssemblyPlaceChanged>(
      (e, emit) => _update(
        emit,
        AssemblySettings(
          start: state.settings.start,
          end: state.settings.end,
          place: e.place,
          days: state.settings.days,
          order: state.settings.order,
        ),
      ),
    );
    on<AssemblyDayToggled>((e, emit) {
      final days = {...state.settings.days};
      if (!days.remove(e.weekday)) days.add(e.weekday);
      return _update(
        emit,
        AssemblySettings(
          start: state.settings.start,
          end: state.settings.end,
          place: state.settings.place,
          days: days,
          order: state.settings.order,
        ),
      );
    });
    on<AssemblyOrderChanged>(
      (e, emit) => _update(
        emit,
        AssemblySettings(
          start: state.settings.start,
          end: state.settings.end,
          place: state.settings.place,
          days: state.settings.days,
          order: e.order,
        ),
      ),
    );
    on<AssemblyDutySaved>((e, emit) async {
      await _saveDuty(e.duty);
      await _load(emit);
    });
  }

  final GetAssembly _get;
  final SaveAssembly _save;
  final SaveAssemblyDuty _saveDuty;

  Future<void> _load(Emitter<AssemblyState> emit) async => emit(
    AssemblyState(loading: false, overview: await _get(const NoParams())),
  );

  Future<void> _update(
    Emitter<AssemblyState> emit,
    AssemblySettings next,
  ) async {
    await _save(next);
    await _load(emit);
  }
}
