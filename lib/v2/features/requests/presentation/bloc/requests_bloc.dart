import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/request.dart';
import '../../domain/usecases/requests_usecases.dart';

sealed class RequestsEvent extends Equatable {
  const RequestsEvent();

  @override
  List<Object?> get props => const [];
}

final class RequestsStarted extends RequestsEvent {
  const RequestsStarted();
}

final class RequestsFiltered extends RequestsEvent {
  const RequestsFiltered({this.kind, this.status});

  final RequestKind? kind;
  final RequestStatus? status;

  @override
  List<Object?> get props => [kind, status];
}

final class RequestRaised extends RequestsEvent {
  const RequestRaised(this.draft);

  final RequestDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class RequestWithdrawn extends RequestsEvent {
  const RequestWithdrawn(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class RequestApproved extends RequestsEvent {
  const RequestApproved(this.params);

  final ApproveRequestParams params;

  @override
  List<Object?> get props => [params];
}

final class RequestRejected extends RequestsEvent {
  const RequestRejected(this.id, this.reason);

  final String id;
  final String reason;

  @override
  List<Object?> get props => [id, reason];
}

class RequestsState extends Equatable {
  const RequestsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.requests = const [],
    this.kind,
    this.requestStatus,
    this.access,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Request> requests;
  final RequestKind? kind;
  final RequestStatus? requestStatus;
  final RequestsAccess? access;
  final bool busy;

  RequestsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Request>? requests,
    RequestKind? kind,
    RequestStatus? requestStatus,
    bool clearFilters = false,
    RequestsAccess? access,
    bool? busy,
  }) => RequestsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    requests: requests ?? this.requests,
    kind: clearFilters ? null : (kind ?? this.kind),
    requestStatus: clearFilters ? null : (requestStatus ?? this.requestStatus),
    access: access ?? this.access,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    requests,
    kind,
    requestStatus,
    busy,
  ];
}

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  RequestsBloc({
    required Account account,
    required GetRequests getRequests,
    required RaiseRequest raiseRequest,
    required WithdrawRequest withdrawRequest,
    required ApproveRequest approveRequest,
    required RejectRequest rejectRequest,
  }) : _account = account,
       _get = getRequests,
       _raise = raiseRequest,
       _withdraw = withdrawRequest,
       _approve = approveRequest,
       _reject = rejectRequest,
       super(const RequestsState()) {
    on<RequestsStarted>(
      (e, emit) =>
          _load(emit, state.copyWith(access: RequestsAccess.of(_account))),
    );
    on<RequestsFiltered>(
      (e, emit) => _load(
        emit,
        state.copyWith(
          kind: e.kind,
          requestStatus: e.status,
          clearFilters: e.kind == null && e.status == null,
        ),
      ),
    );
    on<RequestRaised>((e, emit) => _change(emit, () => _raise(e.draft)));
    on<RequestWithdrawn>((e, emit) => _change(emit, () => _withdraw(e.id)));
    on<RequestApproved>((e, emit) => _change(emit, () => _approve(e.params)));
    on<RequestRejected>(
      (e, emit) =>
          _change(emit, () => _reject(RejectRequestParams(e.id, e.reason))),
    );
  }

  final Account _account;
  final GetRequests _get;
  final RaiseRequest _raise;
  final WithdrawRequest _withdraw;
  final ApproveRequest _approve;
  final RejectRequest _reject;

  Future<void> _load(Emitter<RequestsState> emit, RequestsState next) async {
    emit(next.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        next.copyWith(
          status: ViewStatus.ready,
          requests: await _get(
            GetRequestsParams(kind: next.kind, status: next.requestStatus),
          ),
        ),
      );
    } on ServerException catch (error) {
      emit(
        next.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _change(
    Emitter<RequestsState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(
        state.copyWith(
          busy: false,
          requests: await _get(
            GetRequestsParams(kind: state.kind, status: state.requestStatus),
          ),
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
