import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/repository/classes_repository.dart';
import '../models/student_models.dart';

class ServerClassesRepository implements ClassesRepository {
  ServerClassesRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<SchoolClass>> getClasses() async => [
    for (final c in jsonObjects(await _client.send('GET', '/classes/')))
      SchoolClassModel.fromJson(c),
  ];

  @override
  Future<SchoolClass> add({
    required ClassLevel level,
    String section = '',
  }) async => SchoolClassModel.fromJson(
    jsonObject(
      await _client.send(
        'POST',
        '/classes/',
        body: {'level': level.code, 'section': section},
      ),
    ),
  );

  @override
  Future<SchoolClass> change(
    String id, {
    required ClassLevel level,
    required String section,
  }) async => SchoolClassModel.fromJson(
    jsonObject(
      await _client.send(
        'PATCH',
        '/classes/$id/',
        body: {'level': level.code, 'section': section},
      ),
    ),
  );

  @override
  Future<void> remove(String id) async {
    await _client.send('DELETE', '/classes/$id/');
  }
}
