import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/timetable.dart';
import '../../domain/usecases/school_day_usecases.dart';

sealed class TimetableEvent extends Equatable {
  const TimetableEvent();

  @override
  List<Object?> get props => const [];
}

final class TimetableStarted extends TimetableEvent {
  const TimetableStarted();
}

final class TimetableClassChosen extends TimetableEvent {
  const TimetableClassChosen(this.className);

  final String className;

  @override
  List<Object?> get props => [className];
}

final class TimetableDayChosen extends TimetableEvent {
  const TimetableDayChosen(this.weekday);

  final int weekday;

  @override
  List<Object?> get props => [weekday];
}

final class TimetableEntryPicked extends TimetableEvent {
  const TimetableEntryPicked(this.slotId, this.option);

  final String slotId;
  final TeachingOption option;

  @override
  List<Object?> get props => [slotId, option];
}

final class TimetableEntryCleared extends TimetableEvent {
  const TimetableEntryCleared(this.slotId);

  final String slotId;

  @override
  List<Object?> get props => [slotId];
}

final class TimetableCopyRequested extends TimetableEvent {
  const TimetableCopyRequested(this.toWeekdays);

  final List<int> toWeekdays;

  @override
  List<Object?> get props => [toWeekdays];
}

class TimetableState extends Equatable {
  const TimetableState({
    this.loading = true,
    this.className,
    this.weekday = 1,
    this.timetable,
    this.options = const [],
    this.conflict,
    this.copyId = 0,
    this.copyResult,
  });

  final bool loading;
  final String? className;
  final int weekday;
  final ClassTimetable? timetable;

  /// Who can teach what in the chosen class, to choose from.
  final List<TeachingOption> options;

  /// Why the last change was refused.
  final TimetableConflict? conflict;

  /// Goes up each time a day is copied, so the screen can say how it went.
  final int copyId;
  final CopyResult? copyResult;

  TimetableState copyWith({
    bool? loading,
    String? className,
    int? weekday,
    ClassTimetable? timetable,
    List<TeachingOption>? options,
    TimetableConflict? conflict,
    bool clearConflict = false,
    int? copyId,
    CopyResult? copyResult,
  }) => TimetableState(
    loading: loading ?? this.loading,
    className: className ?? this.className,
    weekday: weekday ?? this.weekday,
    timetable: timetable ?? this.timetable,
    options: options ?? this.options,
    conflict: clearConflict ? null : (conflict ?? this.conflict),
    copyId: copyId ?? this.copyId,
    copyResult: copyResult ?? this.copyResult,
  );

  @override
  List<Object?> get props => [
    loading,
    className,
    weekday,
    timetable,
    options,
    conflict,
    copyId,
    copyResult,
  ];
}

/// A class's timetable: choose a class and a day, then fill each period.
class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  TimetableBloc({
    required GetClassTimetable getTimetable,
    required GetTeachingOptions getOptions,
    required SaveTimetableEntry saveEntry,
    required ClearTimetableEntry clearEntry,
    required CopyTimetableDay copyDay,
    String? firstClass,
  }) : _get = getTimetable,
       _getOptions = getOptions,
       _save = saveEntry,
       _clear = clearEntry,
       _copy = copyDay,
       super(TimetableState(className: firstClass)) {
    on<TimetableStarted>((e, emit) => _load(emit));
    on<TimetableClassChosen>((e, emit) async {
      emit(state.copyWith(className: e.className, clearConflict: true));
      await _load(emit);
    });
    on<TimetableDayChosen>(
      (e, emit) =>
          emit(state.copyWith(weekday: e.weekday, clearConflict: true)),
    );
    on<TimetableEntryPicked>((e, emit) async {
      try {
        await _save(
          TimetableEntry(
            className: state.className!,
            weekday: state.weekday,
            slotId: e.slotId,
            subject: e.option.subject,
            teacherId: e.option.teacherId,
            teacherName: e.option.teacherName,
          ),
        );
        emit(state.copyWith(clearConflict: true));
      } on TimetableConflict catch (c) {
        emit(state.copyWith(conflict: c));
        return;
      }
      await _load(emit);
    });
    on<TimetableEntryCleared>((e, emit) async {
      await _clear(
        ClearTimetableEntryParams(state.className!, state.weekday, e.slotId),
      );
      emit(state.copyWith(clearConflict: true));
      await _load(emit);
    });
    on<TimetableCopyRequested>((e, emit) async {
      final result = await _copy(
        CopyTimetableDayParams(
          className: state.className!,
          fromWeekday: state.weekday,
          toWeekdays: e.toWeekdays,
        ),
      );
      emit(state.copyWith(copyId: state.copyId + 1, copyResult: result));
      await _load(emit);
    });
  }

  final GetClassTimetable _get;

  final GetTeachingOptions _getOptions;
  final SaveTimetableEntry _save;
  final ClearTimetableEntry _clear;
  final CopyTimetableDay _copy;

  Future<void> _load(Emitter<TimetableState> emit) async {
    final className = state.className;
    if (className == null) {
      emit(state.copyWith(loading: false));
      return;
    }
    emit(
      state.copyWith(
        loading: false,
        timetable: await _get(className),
        options: await _getOptions(className),
      ),
    );
  }
}
