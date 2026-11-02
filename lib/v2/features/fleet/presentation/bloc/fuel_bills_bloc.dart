import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/fleet.dart';
import '../../domain/usecases/fleet_usecases.dart';

sealed class FuelBillsEvent extends Equatable {
  const FuelBillsEvent();

  @override
  List<Object?> get props => const [];
}

final class FuelBillsStarted extends FuelBillsEvent {
  const FuelBillsStarted();
}

final class FuelBillsFiltered extends FuelBillsEvent {
  const FuelBillsFiltered(this.status);

  /// Null shows all.
  final BillStatus? status;

  @override
  List<Object?> get props => [status];
}

final class FuelBillSubmitted extends FuelBillsEvent {
  const FuelBillSubmitted(this.draft);

  final FuelBillDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class FuelBillWithdrawn extends FuelBillsEvent {
  const FuelBillWithdrawn(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class FuelBillApproved extends FuelBillsEvent {
  const FuelBillApproved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class FuelBillRejected extends FuelBillsEvent {
  const FuelBillRejected(this.id, this.reason);

  final String id;
  final String reason;

  @override
  List<Object?> get props => [id, reason];
}

class FuelBillsState extends Equatable {
  const FuelBillsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.bills = const [],
    this.filter,
    this.access,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<FuelBill> bills;
  final BillStatus? filter;
  final FleetAccess? access;
  final bool busy;

  bool get canSubmit => access?.canSubmit ?? false;
  bool get canApprove => access?.canApprove ?? false;

  FuelBillsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<FuelBill>? bills,
    BillStatus? filter,
    bool clearFilter = false,
    FleetAccess? access,
    bool? busy,
  }) => FuelBillsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    bills: bills ?? this.bills,
    filter: clearFilter ? null : (filter ?? this.filter),
    access: access ?? this.access,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [status, failure, bills, filter, busy];
}

class FuelBillsBloc extends Bloc<FuelBillsEvent, FuelBillsState> {
  FuelBillsBloc({
    required Account account,
    required GetFuelBills getFuelBills,
    required SubmitFuelBill submitFuelBill,
    required WithdrawFuelBill withdrawFuelBill,
    required ApproveFuelBill approveFuelBill,
    required RejectFuelBill rejectFuelBill,
  }) : _account = account,
       _get = getFuelBills,
       _submit = submitFuelBill,
       _withdraw = withdrawFuelBill,
       _approve = approveFuelBill,
       _reject = rejectFuelBill,
       super(const FuelBillsState()) {
    on<FuelBillsStarted>(_onStarted);
    on<FuelBillsFiltered>(_onFiltered);
    on<FuelBillSubmitted>((e, emit) => _change(emit, () => _submit(e.draft)));
    on<FuelBillWithdrawn>((e, emit) => _change(emit, () => _withdraw(e.id)));
    on<FuelBillApproved>((e, emit) => _change(emit, () => _approve(e.id)));
    on<FuelBillRejected>(
      (e, emit) =>
          _change(emit, () => _reject(RejectFuelBillParams(e.id, e.reason))),
    );
  }

  final Account _account;
  final GetFuelBills _get;
  final SubmitFuelBill _submit;
  final WithdrawFuelBill _withdraw;
  final ApproveFuelBill _approve;
  final RejectFuelBill _reject;

  Future<void> _onStarted(FuelBillsStarted e, Emitter<FuelBillsState> emit) =>
      _load(emit, state.copyWith(access: FleetAccess.of(_account)));

  Future<void> _onFiltered(FuelBillsFiltered e, Emitter<FuelBillsState> emit) =>
      _load(
        emit,
        state.copyWith(filter: e.status, clearFilter: e.status == null),
      );

  Future<void> _load(Emitter<FuelBillsState> emit, FuelBillsState next) async {
    emit(next.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        next.copyWith(status: ViewStatus.ready, bills: await _get(next.filter)),
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
    Emitter<FuelBillsState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(state.copyWith(busy: false, bills: await _get(state.filter)));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
