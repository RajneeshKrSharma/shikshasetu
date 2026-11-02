import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/calendar_entities.dart';
import '../../domain/usecases/holiday_usecases.dart';

/// One holiday being written: its dates and its reason.
class HolidayDraft extends Equatable {
  const HolidayDraft({required this.id, this.reason = '', this.range});

  final int id;
  final String reason;

  /// The dates; a single day when start and end are the same.
  final DateTimeRange? range;

  int get days => range == null ? 0 : range!.duration.inDays + 1;

  HolidayDraft copyWith({String? reason, DateTimeRange? range}) => HolidayDraft(
    id: id,
    reason: reason ?? this.reason,
    range: range ?? this.range,
  );

  @override
  List<Object?> get props => [id, reason, range];
}

sealed class AddHolidaysEvent extends Equatable {
  const AddHolidaysEvent();

  @override
  List<Object?> get props => const [];
}

final class HolidayDraftAdded extends AddHolidaysEvent {
  const HolidayDraftAdded();
}

final class HolidayDraftRemoved extends AddHolidaysEvent {
  const HolidayDraftRemoved(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

final class HolidayReasonEdited extends AddHolidaysEvent {
  const HolidayReasonEdited(this.id, this.reason);

  final int id;
  final String reason;

  @override
  List<Object?> get props => [id, reason];
}

final class HolidayRangeChosen extends AddHolidaysEvent {
  const HolidayRangeChosen(this.id, this.range);

  final int id;
  final DateTimeRange range;

  @override
  List<Object?> get props => [id, range];
}

/// A holiday picked from the suggestions: its name and its day.
class HolidaySeed extends Equatable {
  const HolidaySeed({required this.reason, required this.date});

  final String reason;
  final DateTime date;

  @override
  List<Object?> get props => [reason, date];
}

final class HolidaysSuggested extends AddHolidaysEvent {
  const HolidaysSuggested(this.seeds);

  final List<HolidaySeed> seeds;

  @override
  List<Object?> get props => [seeds];
}

final class HolidaysSubmitted extends AddHolidaysEvent {
  const HolidaysSubmitted({required this.changedBy, required this.isPrincipal});

  final String changedBy;
  final bool isPrincipal;

  @override
  List<Object?> get props => [changedBy, isPrincipal];
}

enum AddHolidaysError { notAllowed, reasonRequired, invalidDates, failed }

class AddHolidaysState extends Equatable {
  const AddHolidaysState({
    required this.drafts,
    this.saving = false,
    this.result,
    this.error,
    this.errorId = 0,
  });

  final List<HolidayDraft> drafts;
  final bool saving;

  /// Set when everything was saved.
  final AddHolidaysResult? result;
  final AddHolidaysError? error;
  final int errorId;

  /// Days across all the holidays written so far.
  int get totalDays => drafts.fold(0, (s, d) => s + d.days);

  AddHolidaysState copyWith({
    List<HolidayDraft>? drafts,
    bool? saving,
    AddHolidaysResult? result,
    AddHolidaysError? error,
    int? errorId,
  }) => AddHolidaysState(
    drafts: drafts ?? this.drafts,
    saving: saving ?? this.saving,
    result: result ?? this.result,
    error: error ?? this.error,
    errorId: errorId ?? this.errorId,
  );

  @override
  List<Object?> get props => [drafts, saving, result, error, errorId];
}

/// The "Add holidays" form: any number of holidays, each with dates and a
/// reason, saved together.
class AddHolidaysBloc extends Bloc<AddHolidaysEvent, AddHolidaysState> {
  AddHolidaysBloc({required AddHolidays addHolidays, DateTime Function()? now})
    : _add = addHolidays,
      _now = now ?? DateTime.now,
      super(const AddHolidaysState(drafts: [HolidayDraft(id: 0)])) {
    on<HolidayDraftAdded>(
      (e, emit) => emit(
        state.copyWith(
          drafts: [
            ...state.drafts,
            HolidayDraft(id: _nextId++),
          ],
        ),
      ),
    );
    on<HolidayDraftRemoved>(
      (e, emit) => emit(
        state.copyWith(
          drafts: [
            for (final d in state.drafts)
              if (d.id != e.id) d,
          ],
        ),
      ),
    );
    on<HolidayReasonEdited>(
      (e, emit) => emit(
        state.copyWith(
          drafts: [
            for (final d in state.drafts)
              if (d.id == e.id) d.copyWith(reason: e.reason) else d,
          ],
        ),
      ),
    );
    on<HolidayRangeChosen>(
      (e, emit) => emit(
        state.copyWith(
          drafts: [
            for (final d in state.drafts)
              if (d.id == e.id) d.copyWith(range: e.range) else d,
          ],
        ),
      ),
    );
    on<HolidaysSuggested>((e, emit) {
      // A form still untouched gives way to the picked holidays.
      final kept = [
        for (final d in state.drafts)
          if (d.reason.trim().isNotEmpty || d.range != null) d,
      ];
      emit(
        state.copyWith(
          drafts: [
            ...kept,
            for (final seed in e.seeds)
              HolidayDraft(
                id: _nextId++,
                reason: seed.reason,
                range: DateTimeRange(start: seed.date, end: seed.date),
              ),
          ],
        ),
      );
    });
    on<HolidaysSubmitted>(_onSubmitted);
  }

  final AddHolidays _add;
  final DateTime Function() _now;

  int _nextId = 1;
  int _errorCounter = 0;

  void _fail(Emitter<AddHolidaysState> emit, AddHolidaysError e) =>
      emit(state.copyWith(saving: false, error: e, errorId: ++_errorCounter));

  Future<void> _onSubmitted(
    HolidaysSubmitted e,
    Emitter<AddHolidaysState> emit,
  ) async {
    if (state.saving) return;
    // Every holiday needs its dates before it can be saved.
    if (state.drafts.any((d) => d.range == null)) {
      _fail(emit, AddHolidaysError.invalidDates);
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      final result = await _add(
        AddHolidaysParams(
          holidays: [
            for (final d in state.drafts)
              HolidayEntry(
                start: d.range!.start,
                end: d.range!.end,
                reason: d.reason,
              ),
          ],
          changedBy: e.changedBy,
          isPrincipal: e.isPrincipal,
          at: _now(),
        ),
      );
      emit(state.copyWith(saving: false, result: result));
    } on CalendarException catch (ex) {
      _fail(emit, switch (ex.failure) {
        CalendarFailure.notAllowed => AddHolidaysError.notAllowed,
        CalendarFailure.reasonRequired => AddHolidaysError.reasonRequired,
        CalendarFailure.invalidDates => AddHolidaysError.invalidDates,
      });
    } catch (_) {
      _fail(emit, AddHolidaysError.failed);
    }
  }
}
