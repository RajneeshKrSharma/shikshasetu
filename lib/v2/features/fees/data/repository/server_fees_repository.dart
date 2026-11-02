import '../../../../core/money.dart';
import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/fees.dart';
import '../../domain/repository/fees_repository.dart';
import '../models/fee_models.dart';

class ServerFeesRepository implements FeesRepository {
  ServerFeesRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<FeeStructureLine>> structure(String classId) async => [
    for (final l in jsonObjects(
      await _client.send(
        'GET',
        '/fees/structure/',
        query: {'class_id': classId},
      ),
    ))
      FeeModels.structureLine(l),
  ];

  @override
  Future<void> setAmount(String classId, FeeHead head, Money amount) =>
      _client.send(
        'PUT',
        '/fees/structure/$classId/${head.code}/',
        body: {'amount': amount.wire},
      );

  @override
  Future<List<FeeStatement>> accounts({
    String? classId,
    String query = '',
    bool onlyDue = false,
  }) async => [
    for (final s in jsonObjects(
      await _client.send(
        'GET',
        '/fees/accounts/',
        query: {
          'class_id': classId,
          'query': query,
          'only_due': onlyDue ? 'true' : null,
        },
      ),
    ))
      FeeModels.statement(s),
  ];

  @override
  Future<FeeStatement> studentFees(String studentId) async =>
      FeeModels.statement(
        jsonObject(await _client.send('GET', '/students/$studentId/fees/')),
      );

  @override
  Future<void> receive({
    required String studentId,
    required FeeHead head,
    required Money amount,
    DateTime? paidOn,
    String note = '',
  }) => _client.send(
    'POST',
    '/fees/payments/',
    body: {
      'student_id': studentId,
      'head': head.code,
      'amount': amount.wire,
      'paid_on': ?(paidOn == null ? null : WireFormat.day(paidOn)),
      if (note.trim().isNotEmpty) 'note': note.trim(),
    },
  );
}
