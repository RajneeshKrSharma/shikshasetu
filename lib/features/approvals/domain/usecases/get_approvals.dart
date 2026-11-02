import '../../../../core/usecase/usecase.dart';
import '../entities/approval_request.dart';
import '../repository/approvals_repository.dart';

/// Pending requests first, then decided ones.
class GetApprovals implements UseCase<List<ApprovalRequest>, DateTime> {
  const GetApprovals(this._repository);

  final ApprovalsRepository _repository;

  @override
  Future<List<ApprovalRequest>> call(DateTime today) async {
    final all = await _repository.getRequests(today);
    return [
      ...all.where((r) => r.isPending),
      ...all.where((r) => !r.isPending),
    ];
  }
}
