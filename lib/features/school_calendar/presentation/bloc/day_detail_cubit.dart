import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/calendar_entities.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/calendar_usecases.dart';
import '../../domain/usecases/holiday_usecases.dart';

class DayDetailState extends Equatable {
  const DayDetailState({
    this.loading = true,
    this.history = const [],
    this.holiday,
  });

  final bool loading;

  /// Edits of the day, newest first.
  final List<SchoolDayChange> history;

  /// The whole holiday this day belongs to, if it is a holiday.
  final Holiday? holiday;

  @override
  List<Object?> get props => [loading, history, holiday];
}

/// The edit history of one day, shown in its details sheet.
class DayDetailCubit extends Cubit<DayDetailState> {
  DayDetailCubit({
    required this.day,
    required GetSchoolDayHistory getSchoolDayHistory,
    required GetHolidays getHolidays,
  }) : _get = getSchoolDayHistory,
       _getHolidays = getHolidays,
       super(const DayDetailState());

  final DateTime day;
  final GetSchoolDayHistory _get;
  final GetHolidays _getHolidays;

  Future<void> load() async {
    final history = await _get(day);
    final holidays = await _getHolidays(const NoParams());
    Holiday? holiday;
    for (final h in holidays) {
      if (h.covers(day)) holiday = h;
    }
    emit(DayDetailState(loading: false, history: history, holiday: holiday));
  }
}
