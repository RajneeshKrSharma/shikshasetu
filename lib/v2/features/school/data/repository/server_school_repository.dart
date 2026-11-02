import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/school.dart';
import '../../domain/repository/school_repository.dart';
import '../models/school_models.dart';

class ServerSchoolRepository implements SchoolRepository {
  ServerSchoolRepository(this._client);

  final ServerClient _client;

  @override
  Future<School> getSchool() async =>
      SchoolModel.fromJson(jsonObject(await _client.send('GET', '/school/')));

  @override
  Future<School> update({String? name, Season? activeSeason}) async =>
      SchoolModel.fromJson(
        jsonObject(
          await _client.send(
            'PATCH',
            '/school/',
            body: {'school_name': ?name, 'active_season': ?activeSeason?.code},
          ),
        ),
      );

  @override
  Future<SchoolTimings> getTimings() async => SchoolTimingsModel.fromJson(
    jsonObject(await _client.send('GET', '/school/timings/')),
  );

  @override
  Future<SeasonTiming> setTiming(SeasonTiming timing) async =>
      SeasonTimingModel.fromJson(
        jsonObject(
          await _client.send(
            'PUT',
            '/school/timings/${timing.season.code}/',
            body: {
              'opens_at': WireFormat.minutes(timing.opensAt!),
              'closes_at': WireFormat.minutes(timing.closesAt!),
              'periods': [
                for (final p in timing.periods) PeriodModel.toJson(p),
              ],
            },
          ),
        ),
      );

  @override
  Future<List<Holiday>> getHolidays({DateTime? from, DateTime? to}) async => [
    for (final h in jsonObjects(
      await _client.send(
        'GET',
        '/school/holidays/',
        query: {
          'from': from == null ? null : WireFormat.day(from),
          'to': to == null ? null : WireFormat.day(to),
        },
      ),
    ))
      HolidayModel.fromJson(h),
  ];

  @override
  Future<Holiday> addHoliday({
    required String name,
    required DateTime startsOn,
    required DateTime endsOn,
  }) async => HolidayModel.fromJson(
    jsonObject(
      await _client.send(
        'POST',
        '/school/holidays/',
        body: {
          'name': name,
          'starts_on': WireFormat.day(startsOn),
          'ends_on': WireFormat.day(endsOn),
        },
      ),
    ),
  );

  @override
  Future<Holiday> updateHoliday(Holiday holiday) async => HolidayModel.fromJson(
    jsonObject(
      await _client.send(
        'PATCH',
        '/school/holidays/${holiday.id}/',
        body: {
          'name': holiday.name,
          'starts_on': WireFormat.day(holiday.startsOn),
          'ends_on': WireFormat.day(holiday.endsOn),
        },
      ),
    ),
  );

  @override
  Future<void> removeHoliday(String id) async {
    await _client.send('DELETE', '/school/holidays/$id/');
  }
}
