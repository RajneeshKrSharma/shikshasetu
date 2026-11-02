import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/suggested_holiday.dart';
import '../../domain/usecases/get_suggested_holidays.dart';

class SuggestedHolidaysState extends Equatable {
  const SuggestedHolidaysState({
    required this.year,
    this.items = const [],
    this.selected = const {},
  });

  final int year;
  final List<SuggestedHoliday> items;

  /// Indexes into [items] that are ticked.
  final Set<int> selected;

  List<SuggestedHoliday> get chosen => [
    for (final i in selected.toList()..sort()) items[i],
  ];

  @override
  List<Object?> get props => [year, items, selected];
}

/// Choosing from the suggested holidays of a year.
class SuggestedHolidaysCubit extends Cubit<SuggestedHolidaysState> {
  SuggestedHolidaysCubit({
    required GetSuggestedHolidays getSuggestedHolidays,
    required int year,
  }) : _get = getSuggestedHolidays,
       super(SuggestedHolidaysState(year: year));

  final GetSuggestedHolidays _get;

  Future<void> setYear(int year) async =>
      emit(SuggestedHolidaysState(year: year, items: await _get(year)));

  void toggle(int index) {
    final next = {...state.selected};
    if (!next.remove(index)) next.add(index);
    emit(
      SuggestedHolidaysState(
        year: state.year,
        items: state.items,
        selected: next,
      ),
    );
  }
}
