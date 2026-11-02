import '../entities/school.dart';

abstract interface class SchoolRepository {
  Future<School> getSchool();

  /// Changes the name and/or the season in use; what is null stays.
  Future<School> update({String? name, Season? activeSeason});

  Future<SchoolTimings> getTimings();

  /// Replaces one season's whole day.
  Future<SeasonTiming> setTiming(SeasonTiming timing);

  Future<List<Holiday>> getHolidays({DateTime? from, DateTime? to});

  Future<Holiday> addHoliday({
    required String name,
    required DateTime startsOn,
    required DateTime endsOn,
  });

  Future<Holiday> updateHoliday(Holiday holiday);

  Future<void> removeHoliday(String id);
}
