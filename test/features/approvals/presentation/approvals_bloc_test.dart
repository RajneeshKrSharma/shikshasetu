import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/approvals/domain/entities/approval_request.dart';
import 'package:shiksha_setu/features/approvals/domain/repository/approvals_repository.dart';
import 'package:shiksha_setu/features/approvals/domain/usecases/decide_approval.dart';
import 'package:shiksha_setu/features/approvals/domain/usecases/get_approvals.dart';
import 'package:shiksha_setu/features/approvals/presentation/bloc/approvals_bloc.dart';

class InMemoryApprovals implements ApprovalsRepository {
  InMemoryApprovals(this.requests);

  List<ApprovalRequest> requests;
  String? decidedBy;

  @override
  Future<List<ApprovalRequest>> getRequests(DateTime today) async => requests;

  @override
  Future<void> decide(
    ApprovalRequest request,
    ApprovalStatus status,
    String by,
  ) async {
    decidedBy = by;
    requests = [
      for (final r in requests)
        if (r == request)
          ApprovalRequest(category: r.category, date: r.date, status: status)
        else
          r,
    ];
  }
}

void main() {
  final day = DateTime(2026, 10, 1);
  final pending = ApprovalRequest(
    category: ApprovalCategory.schoolDay,
    date: day,
    status: ApprovalStatus.pending,
  );
  final approved = ApprovalRequest(
    category: ApprovalCategory.schoolDay,
    date: DateTime(2026, 9, 30),
    status: ApprovalStatus.approved,
  );

  ApprovalsBloc build(InMemoryApprovals repo) => ApprovalsBloc(
    getApprovals: GetApprovals(repo),
    decideApproval: DecideApproval(repo),
    now: () => day,
  );

  test('GetApprovals: pending requests come before decided ones', () async {
    final repo = InMemoryApprovals([approved, pending]);

    final result = await GetApprovals(repo)(day);

    expect(result, [pending, approved]);
  });

  blocTest<ApprovalsBloc, ApprovalsState>(
    'ApprovalsRequested: loads requests and counts the pending ones',
    build: () => build(InMemoryApprovals([pending, approved])),
    act: (b) => b.add(const ApprovalsRequested()),
    verify: (b) {
      expect(b.state.loading, isFalse);
      expect(b.state.pendingCount, 1);
      expect(b.state.pending, [pending]);
      expect(b.state.decided, [approved]);
    },
  );

  blocTest<ApprovalsBloc, ApprovalsState>(
    'ApprovalsRequested: nothing waiting → pendingCount is zero',
    build: () => build(InMemoryApprovals([approved])),
    act: (b) => b.add(const ApprovalsRequested()),
    verify: (b) => expect(b.state.pendingCount, 0),
  );

  blocTest<ApprovalsBloc, ApprovalsState>(
    'ApprovalCategoryChanged: filters the lists, and "all" shows everything',
    build: () => build(InMemoryApprovals([pending])),
    act: (b) => b
      ..add(const ApprovalsRequested())
      ..add(const ApprovalCategoryChanged(ApprovalCategory.schoolDay)),
    verify: (b) {
      expect(b.state.category, ApprovalCategory.schoolDay);
      expect(b.state.pending, [pending]);
      expect(b.state.categories, [ApprovalCategory.schoolDay]);
    },
  );

  blocTest<ApprovalsBloc, ApprovalsState>(
    'ApprovalCategoryChanged(null): clears the filter',
    build: () => build(InMemoryApprovals([pending])),
    seed: () => const ApprovalsState(category: ApprovalCategory.schoolDay),
    act: (b) => b.add(const ApprovalCategoryChanged(null)),
    verify: (b) => expect(b.state.category, isNull),
  );

  blocTest<ApprovalsBloc, ApprovalsState>(
    'ApprovalDecided: records who decided, moves it out of pending, and '
    'bumps decidedCount so other screens refresh',
    build: () => build(InMemoryApprovals([pending])),
    act: (b) => b
      ..add(const ApprovalsRequested())
      ..add(
        ApprovalDecided(
          request: pending,
          status: ApprovalStatus.approved,
          decidedBy: 'u1',
        ),
      ),
    verify: (b) {
      expect(b.state.pendingCount, 0);
      expect(b.state.decided.single.status, ApprovalStatus.approved);
      expect(b.state.decidedCount, 1);
    },
  );
}
