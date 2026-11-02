import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/calendar_entities.dart';
import '../../domain/usecases/holiday_usecases.dart';

enum HolidayFilter { upcoming, past, all }

enum HolidayNotice { removed, notAllowed, reasonRequired, failed }

class HolidaysState extends Equatable {
  const HolidaysState({
    this.loading = true,
    this.holidays = const [],
    this.filter = HolidayFilter.upcoming,
    this.notice,
    this.noticeId = 0,
  });

  final bool loading;

  /// Every holiday, oldest first.
  final List<Holiday> holidays;
  final HolidayFilter filter;
  final HolidayNotice? notice;
  final int noticeId;

  /// The holidays the filter lets through: one that is on now counts as
  /// upcoming; [today] is the start of today.
  List<Holiday> visible(DateTime today) {
    final d = DateTime(today.year, today.month, today.day);
    return switch (filter) {
      HolidayFilter.all => holidays,
      HolidayFilter.upcoming => [
        for (final h in holidays)
          if (!h.end.isBefore(d)) h,
      ],
      // Latest first: what just ended is what is looked for.
      HolidayFilter.past => [
        for (final h in holidays.reversed)
          if (h.end.isBefore(d)) h,
      ],
    };
  }

  /// Days across the given holidays.
  int daysIn(List<Holiday> list) => list.fold(0, (s, h) => s + h.days);

  HolidaysState copyWith({
    bool? loading,
    List<Holiday>? holidays,
    HolidayFilter? filter,
    HolidayNotice? notice,
    int? noticeId,
  }) => HolidaysState(
    loading: loading ?? this.loading,
    holidays: holidays ?? this.holidays,
    filter: filter ?? this.filter,
    notice: notice ?? this.notice,
    noticeId: noticeId ?? this.noticeId,
  );

  @override
  List<Object?> get props => [loading, holidays, filter, notice, noticeId];
}

/// The holiday list everyone can read; the Principal can remove a holiday
/// (with a reason).
class HolidaysCubit extends Cubit<HolidaysState> {
  HolidaysCubit({
    required GetHolidays getHolidays,
    required RemoveHoliday removeHoliday,
    DateTime Function()? now,
  }) : _get = getHolidays,
       _remove = removeHoliday,
       _now = now ?? DateTime.now,
       super(const HolidaysState());

  final GetHolidays _get;
  final RemoveHoliday _remove;
  final DateTime Function() _now;

  int _noticeCounter = 0;

  Future<void> load() async => emit(
    state.copyWith(loading: false, holidays: await _get(const NoParams())),
  );

  void setFilter(HolidayFilter f) => emit(state.copyWith(filter: f));

  void _tell(HolidayNotice n) =>
      emit(state.copyWith(notice: n, noticeId: ++_noticeCounter));

  Future<void> remove({
    required Holiday holiday,
    required String reason,
    required String changedBy,
    required bool isPrincipal,
  }) async {
    try {
      await _remove(
        RemoveHolidayParams(
          holiday: holiday,
          reason: reason,
          changedBy: changedBy,
          isPrincipal: isPrincipal,
          at: _now(),
        ),
      );
    } on CalendarException catch (e) {
      _tell(
        e.failure == CalendarFailure.notAllowed
            ? HolidayNotice.notAllowed
            : HolidayNotice.reasonRequired,
      );
      return;
    } catch (_) {
      _tell(HolidayNotice.failed);
      return;
    }
    await load();
    _tell(HolidayNotice.removed);
  }
}
