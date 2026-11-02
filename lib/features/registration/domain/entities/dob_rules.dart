import 'person.dart';

/// Why a date of birth is not acceptable.
enum DobProblem {
  /// After today.
  future,

  /// Younger than the minimum age for this kind of person.
  tooYoung,

  /// Older than the maximum age for this kind of person.
  tooOld,
}

/// What dates of birth are acceptable for each kind of person.
///
/// The age limits are a starting point, not a rule from the school: a student
/// is between [studentMinAge] and [studentMaxAge], teachers and other staff
/// between [staffMinAge] and [staffMaxAge]. Change them here to suit.
class DobRules {
  DobRules._();

  static const studentMinAge = 2;
  static const studentMaxAge = 25;
  static const staffMinAge = 18;
  static const staffMaxAge = 70;

  static int minAge(PersonType t) =>
      t == PersonType.student ? studentMinAge : staffMinAge;

  static int maxAge(PersonType t) =>
      t == PersonType.student ? studentMaxAge : staffMaxAge;

  /// Whole years between [dob] and [now].
  static int ageOn(DateTime dob, DateTime now) {
    var age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  /// The latest acceptable date of birth: someone born then is exactly the
  /// minimum age today. Never after today.
  static DateTime latest(PersonType t, DateTime now) {
    final today = _day(now);
    final d = DateTime(today.year - minAge(t), today.month, today.day);
    return d.isAfter(today) ? today : d;
  }

  /// The earliest acceptable date of birth: the day after someone would turn
  /// one year past the maximum age.
  static DateTime earliest(PersonType t, DateTime now) {
    final today = _day(now);
    return DateTime(today.year - maxAge(t) - 1, today.month, today.day + 1);
  }

  /// The problem with [dob] for a [t], or null if it is fine.
  static DobProblem? check(DateTime dob, PersonType t, DateTime now) {
    final d = _day(dob);
    if (d.isAfter(_day(now))) return DobProblem.future;
    if (d.isAfter(latest(t, now))) return DobProblem.tooYoung;
    if (d.isBefore(earliest(t, now))) return DobProblem.tooOld;
    return null;
  }
}
