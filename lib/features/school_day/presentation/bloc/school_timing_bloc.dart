import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/day_time.dart';
import '../../domain/entities/school_timing.dart';
import '../../domain/usecases/school_day_usecases.dart';

sealed class SchoolTimingEvent extends Equatable {
  const SchoolTimingEvent();

  @override
  List<Object?> get props => const [];
}

final class SchoolTimingStarted extends SchoolTimingEvent {
  const SchoolTimingStarted();
}

final class SchoolStartChanged extends SchoolTimingEvent {
  const SchoolStartChanged(this.time);

  final DayTime time;

  @override
  List<Object?> get props => [time];
}

final class SchoolEndChanged extends SchoolTimingEvent {
  const SchoolEndChanged(this.time);

  final DayTime time;

  @override
  List<Object?> get props => [time];
}

final class WorkingDayToggled extends SchoolTimingEvent {
  const WorkingDayToggled(this.weekday);

  final int weekday;

  @override
  List<Object?> get props => [weekday];
}

final class TimingRuleSaved extends SchoolTimingEvent {
  const TimingRuleSaved(this.rule);

  final TimingRule rule;

  @override
  List<Object?> get props => [rule];
}

final class TimingRuleRemoved extends SchoolTimingEvent {
  const TimingRuleRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class SchoolTimingState extends Equatable {
  const SchoolTimingState({
    this.loading = true,
    this.timing = const SchoolTiming(),
  });

  final bool loading;
  final SchoolTiming timing;

  @override
  List<Object?> get props => [loading, timing];
}

/// The school's timing: each change is saved as it is made.
class SchoolTimingBloc extends Bloc<SchoolTimingEvent, SchoolTimingState> {
  SchoolTimingBloc({
    required GetSchoolTiming getTiming,
    required SaveSchoolTiming saveTiming,
    required SaveTimingRule saveRule,
    required DeleteTimingRule deleteRule,
  }) : _get = getTiming,
       _saveTiming = saveTiming,
       _saveRule = saveRule,
       _deleteRule = deleteRule,
       super(const SchoolTimingState()) {
    on<SchoolTimingStarted>((e, emit) => _load(emit));
    on<SchoolStartChanged>(
      (e, emit) => _saveBase(
        emit,
        SchoolTiming(
          start: e.time,
          end: state.timing.end,
          workingDays: state.timing.workingDays,
        ),
      ),
    );
    on<SchoolEndChanged>(
      (e, emit) => _saveBase(
        emit,
        SchoolTiming(
          start: state.timing.start,
          end: e.time,
          workingDays: state.timing.workingDays,
        ),
      ),
    );
    on<WorkingDayToggled>((e, emit) {
      final days = {...state.timing.workingDays};
      if (!days.remove(e.weekday)) days.add(e.weekday);
      return _saveBase(
        emit,
        SchoolTiming(
          start: state.timing.start,
          end: state.timing.end,
          workingDays: days,
        ),
      );
    });
    on<TimingRuleSaved>((e, emit) async {
      await _saveRule(e.rule);
      await _load(emit);
    });
    on<TimingRuleRemoved>((e, emit) async {
      await _deleteRule(e.id);
      await _load(emit);
    });
  }

  final GetSchoolTiming _get;
  final SaveSchoolTiming _saveTiming;
  final SaveTimingRule _saveRule;
  final DeleteTimingRule _deleteRule;

  Future<void> _load(Emitter<SchoolTimingState> emit) async => emit(
    SchoolTimingState(loading: false, timing: await _get(const NoParams())),
  );

  Future<void> _saveBase(
    Emitter<SchoolTimingState> emit,
    SchoolTiming base,
  ) async {
    await _saveTiming(base);
    await _load(emit);
  }
}
