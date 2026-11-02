import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/school.dart';
import '../repository/school_repository.dart';

class GetSchool implements UseCase<School, NoParams> {
  const GetSchool(this._repository);

  final SchoolRepository _repository;

  @override
  Future<School> call(NoParams params) => _repository.getSchool();
}

class UpdateSchoolParams extends Equatable {
  const UpdateSchoolParams({this.name, this.activeSeason});

  final String? name;
  final Season? activeSeason;

  @override
  List<Object?> get props => [name, activeSeason];
}

class UpdateSchool implements UseCase<School, UpdateSchoolParams> {
  const UpdateSchool(this._repository);

  final SchoolRepository _repository;

  @override
  Future<School> call(UpdateSchoolParams p) =>
      _repository.update(name: p.name?.trim(), activeSeason: p.activeSeason);
}

class GetTimings implements UseCase<SchoolTimings, NoParams> {
  const GetTimings(this._repository);

  final SchoolRepository _repository;

  @override
  Future<SchoolTimings> call(NoParams params) => _repository.getTimings();
}

class SetSeasonTiming implements UseCase<SeasonTiming, SeasonTiming> {
  const SetSeasonTiming(this._repository);

  final SchoolRepository _repository;

  @override
  Future<SeasonTiming> call(SeasonTiming timing) =>
      _repository.setTiming(timing);
}

class GetHolidays implements UseCase<List<Holiday>, NoParams> {
  const GetHolidays(this._repository);

  final SchoolRepository _repository;

  /// From the first day of the current month onwards: the ones that matter.
  @override
  Future<List<Holiday>> call(NoParams params) {
    final now = DateTime.now();
    return _repository.getHolidays(from: DateTime(now.year, now.month));
  }
}

class HolidayDraft extends Equatable {
  const HolidayDraft({
    this.id,
    required this.name,
    required this.startsOn,
    required this.endsOn,
  });

  /// Null for a holiday not yet saved.
  final String? id;
  final String name;
  final DateTime startsOn;
  final DateTime endsOn;

  @override
  List<Object?> get props => [id, name, startsOn, endsOn];
}

class SaveHoliday implements UseCase<Holiday, HolidayDraft> {
  const SaveHoliday(this._repository);

  final SchoolRepository _repository;

  @override
  Future<Holiday> call(HolidayDraft h) => h.id == null
      ? _repository.addHoliday(
          name: h.name.trim(),
          startsOn: h.startsOn,
          endsOn: h.endsOn,
        )
      : _repository.updateHoliday(
          Holiday(
            id: h.id!,
            name: h.name.trim(),
            startsOn: h.startsOn,
            endsOn: h.endsOn,
          ),
        );
}

class RemoveHoliday implements UseCase<void, String> {
  const RemoveHoliday(this._repository);

  final SchoolRepository _repository;

  @override
  Future<void> call(String id) => _repository.removeHoliday(id);
}
