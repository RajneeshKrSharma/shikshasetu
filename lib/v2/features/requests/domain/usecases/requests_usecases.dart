import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/request.dart';
import '../repository/requests_repository.dart';

class GetRequestsParams extends Equatable {
  const GetRequestsParams({this.kind, this.status});

  final RequestKind? kind;
  final RequestStatus? status;

  @override
  List<Object?> get props => [kind, status];
}

class GetRequests implements UseCase<List<Request>, GetRequestsParams> {
  const GetRequests(this._repository);

  final RequestsRepository _repository;

  @override
  Future<List<Request>> call(GetRequestsParams p) =>
      _repository.requests(kind: p.kind, status: p.status);
}

class RaiseRequest implements UseCase<void, RequestDraft> {
  const RaiseRequest(this._repository);

  final RequestsRepository _repository;

  @override
  Future<void> call(RequestDraft draft) => _repository.raise(draft);
}

class WithdrawRequest implements UseCase<void, String> {
  const WithdrawRequest(this._repository);

  final RequestsRepository _repository;

  @override
  Future<void> call(String id) => _repository.withdraw(id);
}

class ApproveRequestParams extends Equatable {
  const ApproveRequestParams(this.id, {this.meetingOn, this.meetingAt});

  final String id;
  final DateTime? meetingOn;
  final int? meetingAt;

  @override
  List<Object?> get props => [id, meetingOn, meetingAt];
}

class ApproveRequest implements UseCase<void, ApproveRequestParams> {
  const ApproveRequest(this._repository);

  final RequestsRepository _repository;

  @override
  Future<void> call(ApproveRequestParams p) =>
      _repository.approve(p.id, meetingOn: p.meetingOn, meetingAt: p.meetingAt);
}

class RejectRequestParams extends Equatable {
  const RejectRequestParams(this.id, this.reason);

  final String id;
  final String reason;

  @override
  List<Object?> get props => [id, reason];
}

class RejectRequest implements UseCase<void, RejectRequestParams> {
  const RejectRequest(this._repository);

  final RequestsRepository _repository;

  @override
  Future<void> call(RejectRequestParams p) =>
      _repository.reject(p.id, p.reason.trim());
}
