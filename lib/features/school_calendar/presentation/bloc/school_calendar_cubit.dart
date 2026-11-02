import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../attendance/domain/entities/attendance_status.dart';
import '../../domain/entities/calendar_entities.dart';
import '../../domain/usecases/calendar_usecases.dart';

enum CalendarNotice { saved, notAllowed, reasonRequired, failed }

class SchoolCalendarState extends Equatable {
  const SchoolCalendarState({
    required this.month,
    this.data,
    this.loading = true,
    this.saving = false,
    this.notice,
    this.noticeId = 0,
  });

  /// The first day of the month shown.
  final DateTime month;
  final CalendarMonth? data;
  final bool loading;
  final bool saving;
  final CalendarNotice? notice;
  final int noticeId;

  SchoolCalendarState copyWith({
    DateTime? month,
    CalendarMonth? data,
    bool? loading,
    bool? saving,
    CalendarNotice? notice,
    int? noticeId,
  }) => SchoolCalendarState(
    month: month ?? this.month,
    data: data ?? this.data,
    loading: loading ?? this.loading,
    saving: saving ?? this.saving,
    notice: notice ?? this.notice,
    noticeId: noticeId ?? this.noticeId,
  );

  @override
  List<Object?> get props => [month, data, loading, saving, notice, noticeId];
}

/// The calendar of school days: the month on show, its days and totals, and
/// the Principal's edits.
class SchoolCalendarCubit extends Cubit<SchoolCalendarState> {
  SchoolCalendarCubit({
    required GetCalendarMonth getCalendarMonth,
    required EditSchoolDay editSchoolDay,
    DateTime Function()? now,
  }) : _get = getCalendarMonth,
       _edit = editSchoolDay,
       _now = now ?? DateTime.now,
       super(
         SchoolCalendarState(
           month: DateTime(
             (now ?? DateTime.now)().year,
             (now ?? DateTime.now)().month,
           ),
         ),
       );

  final GetCalendarMonth _get;
  final EditSchoolDay _edit;
  final DateTime Function() _now;

  int _noticeCounter = 0;

  Future<void> load() async {
    emit(state.copyWith(loading: state.data == null));
    final data = await _get(GetCalendarMonthParams(state.month, _now()));
    emit(state.copyWith(loading: false, data: data));
  }

  Future<void> _show(DateTime month) async {
    emit(state.copyWith(month: DateTime(month.year, month.month)));
    await load();
  }

  Future<void> previousMonth() =>
      _show(DateTime(state.month.year, state.month.month - 1));

  Future<void> nextMonth() =>
      _show(DateTime(state.month.year, state.month.month + 1));

  Future<void> goToToday() => _show(_now());

  void _tell(CalendarNotice n) => emit(
    state.copyWith(notice: n, noticeId: ++_noticeCounter, saving: false),
  );

  /// The Principal's edit of [day].
  Future<void> edit({
    required DateTime day,
    required SchoolDayStatus status,
    required String reason,
    required String changedBy,
    required bool isPrincipal,
  }) async {
    emit(state.copyWith(saving: true));
    try {
      await _edit(
        EditSchoolDayParams(
          day: day,
          status: status,
          reason: reason,
          changedBy: changedBy,
          isPrincipal: isPrincipal,
          at: _now(),
        ),
      );
    } on CalendarException catch (e) {
      _tell(
        e.failure == CalendarFailure.notAllowed
            ? CalendarNotice.notAllowed
            : CalendarNotice.reasonRequired,
      );
      return;
    } catch (_) {
      _tell(CalendarNotice.failed);
      return;
    }
    await load();
    _tell(CalendarNotice.saved);
  }
}
