import '../../../../core/usecase/usecase.dart';
import '../entities/suggested_holiday.dart';

/// The suggested (Indian public) holidays of a year, in date order. Days that
/// have already passed are left out: a holiday cannot be planned for them.
class GetSuggestedHolidays implements UseCase<List<SuggestedHoliday>, int> {
  const GetSuggestedHolidays({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Future<List<SuggestedHoliday>> call(int year) async {
    final n = _now();
    final today = DateTime(n.year, n.month, n.day);
    return [
      for (final h in IndianHolidays.forYear(year))
        if (!h.date.isBefore(today)) h,
    ];
  }
}
