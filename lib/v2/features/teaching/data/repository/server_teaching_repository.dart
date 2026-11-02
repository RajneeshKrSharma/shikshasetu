import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/teaching.dart';
import '../../domain/repository/teaching_repository.dart';
import '../models/teaching_models.dart';

class ServerTeachingRepository implements TeachingRepository {
  ServerTeachingRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<Allotment>> allotments({
    String? teacherId,
    String? classId,
  }) async => [
    for (final a in jsonObjects(
      await _client.send(
        'GET',
        '/teaching/allotments/',
        query: {'teacher_id': teacherId, 'class_id': classId},
      ),
    ))
      TeachingModels.allotment(a),
  ];

  @override
  Future<void> allot(AllotmentDraft d) => _client.send(
    'POST',
    '/teaching/allotments/',
    body: {
      'teacher_id': d.teacherId,
      'class_id': d.classId,
      'subject': d.subject.trim(),
    },
  );

  @override
  Future<void> removeAllotment(String id) =>
      _client.send('DELETE', '/teaching/allotments/$id/');

  @override
  Future<List<Lesson>> lessons({DateTime? from, DateTime? to}) async => [
    for (final l in jsonObjects(
      await _client.send(
        'GET',
        '/teaching/lessons/',
        query: {
          'from': from == null ? null : WireFormat.day(from),
          'to': to == null ? null : WireFormat.day(to),
        },
      ),
    ))
      TeachingModels.lesson(l),
  ];

  @override
  Future<void> record({required String allotmentId, required String topic}) =>
      _client.send(
        'POST',
        '/teaching/lessons/',
        body: {'allotment_id': allotmentId, 'topic': topic},
      );

  @override
  Future<void> revise({required String lessonId, required String topic}) =>
      _client.send(
        'PATCH',
        '/teaching/lessons/$lessonId/',
        body: {'topic': topic},
      );

  @override
  Future<List<LessonStatus>> board(DateTime day) async => [
    for (final s in jsonObjects(
      await _client.send(
        'GET',
        '/teaching/lessons/board/',
        query: {'day': WireFormat.day(day)},
      ),
    ))
      TeachingModels.status(s),
  ];
}
