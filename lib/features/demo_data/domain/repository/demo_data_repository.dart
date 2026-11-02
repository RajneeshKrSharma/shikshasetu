/// A made-up school (classes, people, attendance, exams, fees...) that lets a
/// Principal try every part of the app. Nothing here is real.
abstract interface class DemoDataRepository {
  /// Adds the demo school next to what is already there. Safe to run again:
  /// the earlier demo data is replaced.
  Future<void> load();

  /// Takes out everything [load] added and leaves the real data alone.
  Future<void> remove();
}
