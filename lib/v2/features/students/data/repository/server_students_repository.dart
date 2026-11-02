import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/student.dart';
import '../../domain/repository/students_repository.dart';
import '../models/student_models.dart';

class ServerStudentsRepository implements StudentsRepository {
  ServerStudentsRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<Student>> getStudents({
    String? classId,
    String query = '',
    bool onlyActive = true,
  }) async => [
    for (final s in jsonObjects(
      await _client.send(
        'GET',
        '/students/',
        query: {
          'class_id': classId,
          'query': query,
          'active': onlyActive ? 'true' : 'all',
        },
      ),
    ))
      StudentModel.fromJson(s),
  ];

  @override
  Future<Student> getStudent(String id) async => StudentModel.fromJson(
    jsonObject(await _client.send('GET', '/students/$id/')),
  );

  @override
  Future<Student> save(StudentDraft d) async {
    final body = {
      'name': d.name,
      if (d.rollNumber.isNotEmpty) 'roll_number': d.rollNumber,
      'class_id': d.classId,
      'guardian_name': d.guardianName,
      'uses_van': d.usesVan,
    };
    final saved = d.id == null
        ? await _client.send('POST', '/students/', body: body)
        : await _client.send('PATCH', '/students/${d.id}/', body: body);
    return StudentModel.fromJson(jsonObject(saved));
  }

  @override
  Future<Student> setActive(String id, {required bool active}) async {
    if (!active) {
      await _client.send('DELETE', '/students/$id/');
      return getStudent(id);
    }
    return StudentModel.fromJson(
      jsonObject(
        await _client.send(
          'PATCH',
          '/students/$id/',
          body: {'is_active': true},
        ),
      ),
    );
  }
}
