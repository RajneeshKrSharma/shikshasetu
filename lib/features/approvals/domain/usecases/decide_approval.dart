import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/approval_request.dart';
import '../repository/approvals_repository.dart';

class DecideApprovalParams extends Equatable {
  const DecideApprovalParams({
    required this.request,
    required this.status,
    required this.decidedBy,
  });

  final ApprovalRequest request;
  final ApprovalStatus status;
  final String decidedBy;

  @override
  List<Object?> get props => [request, status, decidedBy];
}

class DecideApproval implements UseCase<void, DecideApprovalParams> {
  const DecideApproval(this._repository);

  final ApprovalsRepository _repository;

  @override
  Future<void> call(DecideApprovalParams p) =>
      _repository.decide(p.request, p.status, p.decidedBy);
}
