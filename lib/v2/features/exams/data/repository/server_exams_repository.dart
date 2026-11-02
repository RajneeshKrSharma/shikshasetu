import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../../../core/server/server_exception.dart';
import '../../domain/entities/exams.dart';
import '../../domain/repository/exams_repository.dart';
import '../models/exam_models.dart';

class ServerExamsRepository implements ExamsRepository {
  ServerExamsRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<Exam>> exams({String? classId}) async => [
    for (final e in jsonObjects(
      await _client.send('GET', '/exams/', query: {'class_id': classId}),
    ))
      ExamModels.exam(e),
  ];

  @override
  Future<void> save(ExamDraft d) => d.id == null
      ? _client.send(
          'POST',
          '/exams/',
          body: {
            'exam_type': d.type.code,
            'class_id': d.classId,
            'subject': d.subject.trim(),
            'held_on': WireFormat.day(d.heldOn),
            'max_marks': d.maxMarks,
          },
        )
      : _client.send(
          'PATCH',
          '/exams/${d.id}/',
          body: {
            'exam_type': d.type.code,
            'held_on': WireFormat.day(d.heldOn),
            'max_marks': d.maxMarks,
          },
        );

  @override
  Future<void> remove(String id) => _client.send('DELETE', '/exams/$id/');

  @override
  Future<ExamResults> results(String examId) async => ExamModels.results(
    jsonObject(await _client.send('GET', '/exams/$examId/marks/')),
  );

  @override
  Future<void> enterMarks(String examId, List<MarkEntry> entries) =>
      _client.send(
        'PUT',
        '/exams/$examId/marks/',
        body: {
          'marks': [
            for (final e in entries)
              {
                'student_id': e.studentId,
                'marks': e.absent ? null : e.marks,
                'absent': e.absent,
              },
          ],
        },
      );

  @override
  Future<StudentResults> studentResults(String studentId) async =>
      ExamModels.studentResults(
        jsonObject(await _client.send('GET', '/students/$studentId/results/')),
      );
}

class ServerQuestionBankRepository implements QuestionBankRepository {
  ServerQuestionBankRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<QuestionUnit>> units() async => [
    for (final u in jsonObjects(
      await _client.send('GET', '/question-bank/units/'),
    ))
      ExamModels.unit(u),
  ];

  @override
  Future<void> saveUnit(UnitDraft d) => d.id == null
      ? _client.send(
          'POST',
          '/question-bank/units/',
          body: {
            'class_id': d.classId,
            'subject': d.subject.trim(),
            'name': d.name.trim(),
          },
        )
      : _client.send(
          'PATCH',
          '/question-bank/units/${d.id}/',
          body: {'name': d.name.trim()},
        );

  @override
  Future<void> removeUnit(String id) =>
      _client.send('DELETE', '/question-bank/units/$id/');

  @override
  Future<List<Question>> questions(String unitId) async => [
    for (final q in jsonObjects(
      await _client.send('GET', '/question-bank/units/$unitId/questions/'),
    ))
      ExamModels.question(q),
  ];

  @override
  Future<void> saveQuestion(QuestionDraft d) {
    final body = {
      'text': d.text.trim(),
      'marks': d.marks,
      'question_type': d.type.code,
    };
    return d.id == null
        ? _client.send(
            'POST',
            '/question-bank/units/${d.unitId}/questions/',
            body: body,
          )
        : _client.send(
            'PATCH',
            '/question-bank/questions/${d.id}/',
            body: body,
          );
  }

  @override
  Future<void> removeQuestion(String id) =>
      _client.send('DELETE', '/question-bank/questions/$id/');
}

class ServerPaperRepository implements PaperRepository {
  ServerPaperRepository(this._client);

  final ServerClient _client;

  Paper _one(Object? body) => ExamModels.paper(jsonObject(body));

  @override
  Future<Paper?> paper(String examId) async {
    try {
      return _one(await _client.send('GET', '/exams/$examId/paper/'));
    } on ServerException catch (error) {
      if (error.failure == ServerFailure.notFound) return null;
      rethrow;
    }
  }

  @override
  Future<Paper> compose(String examId, List<String> questionIds) async => _one(
    await _client.send(
      'PUT',
      '/exams/$examId/paper/',
      body: {'question_ids': questionIds},
    ),
  );

  @override
  Future<Paper> send(String examId) async =>
      _one(await _client.send('POST', '/exams/$examId/paper/send/'));

  @override
  Future<Paper> approve(String examId) async =>
      _one(await _client.send('POST', '/exams/$examId/paper/approve/'));

  @override
  Future<Paper> reject(String examId, String reason) async => _one(
    await _client.send(
      'POST',
      '/exams/$examId/paper/reject/',
      body: {'reason': reason},
    ),
  );
}
