import '../entities/request.dart';

abstract interface class RequestsRepository {
  Future<List<Request>> requests({RequestKind? kind, RequestStatus? status});

  Future<void> raise(RequestDraft draft);

  Future<void> withdraw(String id);

  Future<void> approve(String id, {DateTime? meetingOn, int? meetingAt});

  Future<void> reject(String id, String reason);
}
