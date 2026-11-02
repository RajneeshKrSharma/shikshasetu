import 'package:equatable/equatable.dart';

/// The two timings a school keeps, one chosen as the one in use.
enum Season {
  summer('summer'),
  winter('winter');

  const Season(this.code);

  final String code;

  static Season? fromCode(String? code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return null;
  }
}

class School extends Equatable {
  const School({required this.name, this.activeSeason});

  final String name;

  /// The season whose timing is in use; null until the Principal chooses.
  final Season? activeSeason;

  @override
  List<Object?> get props => [name, activeSeason];
}

/// One period of the school day, as minutes since midnight.
class Period extends Equatable {
  const Period({
    required this.name,
    required this.startsAt,
    required this.endsAt,
    this.number = 0,
  });

  final int number;
  final String name;
  final int startsAt;
  final int endsAt;

  @override
  List<Object?> get props => [number, name, startsAt, endsAt];
}

/// How one season's school day runs. The hours are null until it is set.
class SeasonTiming extends Equatable {
  const SeasonTiming({
    required this.season,
    this.opensAt,
    this.closesAt,
    this.periods = const [],
  });

  final Season season;
  final int? opensAt;
  final int? closesAt;
  final List<Period> periods;

  bool get isSet => opensAt != null && closesAt != null;

  @override
  List<Object?> get props => [season, opensAt, closesAt, periods];
}

class SchoolTimings extends Equatable {
  const SchoolTimings({required this.activeSeason, required this.seasons});

  final Season? activeSeason;
  final List<SeasonTiming> seasons;

  SeasonTiming of(Season season) => seasons.firstWhere(
    (t) => t.season == season,
    orElse: () => SeasonTiming(season: season),
  );

  @override
  List<Object?> get props => [activeSeason, seasons];
}

class Holiday extends Equatable {
  const Holiday({
    required this.id,
    required this.name,
    required this.startsOn,
    required this.endsOn,
  });

  final String id;
  final String name;
  final DateTime startsOn;
  final DateTime endsOn;

  bool get isOneDay => startsOn == endsOn;

  @override
  List<Object?> get props => [id, name, startsOn, endsOn];
}
