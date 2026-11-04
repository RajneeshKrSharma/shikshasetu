import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/repository/timetable_repository.dart';
import '../models/timetable_models.dart';

class ServerTimetableRepository implements TimetableRepository {
  ServerTimetableRepository(this._client);

  final ServerClient _client;

  @override
  Future<TimetableSettings> settings() async => TimetableModels.settings(
    jsonObject(await _client.send('GET', '/exams/settings/')),
  );

  @override
  Future<TimetableSettings> saveSettings(TimetableSettings s) async =>
      TimetableModels.settings(
        jsonObject(
          await _client.send(
            'PUT',
            '/exams/settings/',
            body: TimetableModels.settingsBody(s),
          ),
        ),
      );

  @override
  Future<List<String>> save(TimetableDraft draft) async => jsonObject(
    await _client.send(
      'POST',
      '/exams/timetable/',
      body: TimetableModels.timetableBody(draft),
    ),
  ).strings('warnings');
}
