import '../entities/timetable.dart';

abstract interface class TimetableRepository {
  Future<TimetableSettings> settings();

  Future<TimetableSettings> saveSettings(TimetableSettings settings);

  /// Saves every scheduled line at once, or none; returns the server's
  /// warnings (such as two papers on one day).
  Future<List<String>> save(TimetableDraft draft);
}
