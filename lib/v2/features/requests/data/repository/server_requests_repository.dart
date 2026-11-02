import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/request.dart';
import '../../domain/repository/requests_repository.dart';
import '../models/request_model.dart';

class ServerRequestsRepository implements RequestsRepository {
  ServerRequestsRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<Request>> requests({
    RequestKind? kind,
    RequestStatus? status,
  }) async => [
    for (final r in jsonObjects(
      await _client.send(
        'GET',
        '/requests/',
        query: {'kind': kind?.code, 'status': status?.code},
      ),
    ))
      RequestModel.fromJson(r),
  ];

  @override
  Future<void> raise(RequestDraft draft) => switch (draft) {
    LeaveDraft d => _client.send(
      'POST',
      '/requests/leaves/',
      body: {
        'starts_on': WireFormat.day(d.startsOn),
        'ends_on': WireFormat.day(d.endsOn),
        'reason': d.reason.trim(),
      },
    ),
    MeetingDraft d => _client.send(
      'POST',
      '/requests/meetings/',
      body: {
        'subject': d.subject.trim(),
        'details': d.details.trim(),
        'preferred_on': d.preferredOn == null
            ? null
            : WireFormat.day(d.preferredOn!),
      },
    ),
  };

  @override
  Future<void> withdraw(String id) => _client.send('DELETE', '/requests/$id/');

  @override
  Future<void> approve(String id, {DateTime? meetingOn, int? meetingAt}) =>
      _client.send(
        'POST',
        '/requests/$id/approve/',
        body: {
          if (meetingOn != null) 'meeting_on': WireFormat.day(meetingOn),
          if (meetingAt != null) 'meeting_at': WireFormat.minutes(meetingAt),
        },
      );

  @override
  Future<void> reject(String id, String reason) =>
      _client.send('POST', '/requests/$id/reject/', body: {'reason': reason});
}
