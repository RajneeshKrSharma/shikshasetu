import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/approval_request.dart';
import '../../domain/usecases/decide_approval.dart';
import '../../domain/usecases/get_approvals.dart';

sealed class ApprovalsEvent extends Equatable {
  const ApprovalsEvent();

  @override
  List<Object?> get props => const [];
}

final class ApprovalsRequested extends ApprovalsEvent {
  const ApprovalsRequested();
}

/// Narrows the list to one category; null shows every category.
final class ApprovalCategoryChanged extends ApprovalsEvent {
  const ApprovalCategoryChanged(this.category);

  final ApprovalCategory? category;

  @override
  List<Object?> get props => [category];
}

final class ApprovalQueryChanged extends ApprovalsEvent {
  const ApprovalQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Waiting, approved or rejected requests.
final class ApprovalTabChosen extends ApprovalsEvent {
  const ApprovalTabChosen(this.tab);

  final ApprovalStatus tab;

  @override
  List<Object?> get props => [tab];
}

final class ApprovalDecided extends ApprovalsEvent {
  const ApprovalDecided({
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

class ApprovalsState extends Equatable {
  const ApprovalsState({
    this.loading = true,
    this.requests = const [],
    this.category,
    this.decidedCount = 0,
    this.query = '',
    this.tab = ApprovalStatus.pending,
  });

  final bool loading;
  final List<ApprovalRequest> requests;

  /// The category filter; null means all.
  final ApprovalCategory? category;

  /// Increases on every decision, so other screens know to refresh.
  final int decidedCount;

  /// What was typed in the search box.
  final String query;

  /// Which requests the list shows: waiting, approved or rejected.
  final ApprovalStatus tab;

  bool _matches(ApprovalRequest r) {
    final q = query.trim().toLowerCase();
    return q.isEmpty ||
        (r.title?.toLowerCase().contains(q) ?? false) ||
        (r.detail?.toLowerCase().contains(q) ?? false);
  }

  List<ApprovalRequest> get _filtered => [
    for (final r in requests)
      if ((category == null || r.category == category) && _matches(r)) r,
  ];

  /// The requests the list shows: those of the chosen tab.
  List<ApprovalRequest> get visible => inTab(tab);

  List<ApprovalRequest> inTab(ApprovalStatus status) => [
    for (final r in _filtered)
      if (r.status == status) r,
  ];

  /// How many waiting requests a category has (null: all), for its chip.
  int waitingIn(ApprovalCategory? c) => requests
      .where((r) => r.isPending && (c == null || r.category == c))
      .length;

  List<ApprovalRequest> get pending =>
      _filtered.where((r) => r.isPending).toList();
  List<ApprovalRequest> get decided =>
      _filtered.where((r) => !r.isPending).toList();

  /// Pending requests across every category (what the Dashboard shows).
  int get pendingCount => requests.where((r) => r.isPending).length;

  /// Categories that currently have requests, for the filter chips.
  List<ApprovalCategory> get categories => [
    for (final c in ApprovalCategory.values)
      if (requests.any((r) => r.category == c)) c,
  ];

  ApprovalsState copyWith({
    bool? loading,
    List<ApprovalRequest>? requests,
    ApprovalCategory? category,
    bool clearCategory = false,
    int? decidedCount,
    String? query,
    ApprovalStatus? tab,
  }) => ApprovalsState(
    loading: loading ?? this.loading,
    requests: requests ?? this.requests,
    category: clearCategory ? null : (category ?? this.category),
    decidedCount: decidedCount ?? this.decidedCount,
    query: query ?? this.query,
    tab: tab ?? this.tab,
  );

  @override
  List<Object?> get props => [
    loading,
    requests,
    category,
    decidedCount,
    query,
    tab,
  ];
}

/// Everything waiting for the Principal's decision, with a category filter.
class ApprovalsBloc extends Bloc<ApprovalsEvent, ApprovalsState> {
  ApprovalsBloc({
    required GetApprovals getApprovals,
    required DecideApproval decideApproval,
    DateTime Function()? now,
  }) : _get = getApprovals,
       _decide = decideApproval,
       _now = now ?? DateTime.now,
       super(const ApprovalsState()) {
    on<ApprovalsRequested>(_onRequested);
    on<ApprovalCategoryChanged>(
      (e, emit) => emit(
        e.category == null
            ? state.copyWith(clearCategory: true)
            : state.copyWith(category: e.category),
      ),
    );
    on<ApprovalQueryChanged>((e, emit) => emit(state.copyWith(query: e.query)));
    on<ApprovalTabChosen>((e, emit) => emit(state.copyWith(tab: e.tab)));
    on<ApprovalDecided>(_onDecided);
  }

  final GetApprovals _get;
  final DecideApproval _decide;
  final DateTime Function() _now;

  Future<void> _onRequested(
    ApprovalsRequested e,
    Emitter<ApprovalsState> emit,
  ) async {
    emit(state.copyWith(loading: false, requests: await _get(_now())));
  }

  Future<void> _onDecided(
    ApprovalDecided e,
    Emitter<ApprovalsState> emit,
  ) async {
    await _decide(
      DecideApprovalParams(
        request: e.request,
        status: e.status,
        decidedBy: e.decidedBy,
      ),
    );
    emit(
      state.copyWith(
        loading: false,
        requests: await _get(_now()),
        decidedCount: state.decidedCount + 1,
      ),
    );
  }
}
