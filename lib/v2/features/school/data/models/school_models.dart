import '../../../../core/server/json.dart';
import '../../domain/entities/school.dart';

class SchoolModel extends School {
  const SchoolModel({required super.name, super.activeSeason});

  factory SchoolModel.fromJson(Json json) => SchoolModel(
    name: json.string('school_name'),
    activeSeason: Season.fromCode(json.stringOrNull('active_season')),
  );
}

class PeriodModel extends Period {
  const PeriodModel({
    required super.name,
    required super.startsAt,
    required super.endsAt,
    required super.number,
  });

  factory PeriodModel.fromJson(Json json) => PeriodModel(
    number: json.integer('number'),
    name: json.string('name'),
    startsAt: json.minuteOrNull('starts_at') ?? 0,
    endsAt: json.minuteOrNull('ends_at') ?? 0,
  );

  /// What goes to the server when the whole day is saved.
  static Json toJson(Period p) => {
    'name': p.name,
    'starts_at': WireFormat.minutes(p.startsAt),
    'ends_at': WireFormat.minutes(p.endsAt),
  };
}

class SeasonTimingModel extends SeasonTiming {
  const SeasonTimingModel({
    required super.season,
    super.opensAt,
    super.closesAt,
    super.periods,
  });

  factory SeasonTimingModel.fromJson(Json json) => SeasonTimingModel(
    season: Season.fromCode(json.stringOrNull('season')) ?? Season.summer,
    opensAt: json.minuteOrNull('opens_at'),
    closesAt: json.minuteOrNull('closes_at'),
    periods: [for (final p in json.list('periods')) PeriodModel.fromJson(p)],
  );
}

class SchoolTimingsModel extends SchoolTimings {
  const SchoolTimingsModel({
    required super.activeSeason,
    required super.seasons,
  });

  factory SchoolTimingsModel.fromJson(Json json) => SchoolTimingsModel(
    activeSeason: Season.fromCode(json.stringOrNull('active_season')),
    seasons: [
      for (final s in json.list('seasons')) SeasonTimingModel.fromJson(s),
    ],
  );
}

class HolidayModel extends Holiday {
  const HolidayModel({
    required super.id,
    required super.name,
    required super.startsOn,
    required super.endsOn,
  });

  factory HolidayModel.fromJson(Json json) => HolidayModel(
    id: json.string('id'),
    name: json.string('name'),
    startsOn: json.day('starts_on'),
    endsOn: json.day('ends_on'),
  );
}
