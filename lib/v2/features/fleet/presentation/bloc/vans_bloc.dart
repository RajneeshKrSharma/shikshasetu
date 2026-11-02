import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/usecases/members_usecases.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/fleet.dart';
import '../../domain/usecases/fleet_usecases.dart';

sealed class VansEvent extends Equatable {
  const VansEvent();

  @override
  List<Object?> get props => const [];
}

final class VansStarted extends VansEvent {
  const VansStarted();
}

final class VanSaved extends VansEvent {
  const VanSaved(this.draft);

  final VanDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class VanRemoved extends VansEvent {
  const VanRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class VansState extends Equatable {
  const VansState({
    this.status = ViewStatus.loading,
    this.failure,
    this.vans = const [],
    this.drivers = const [],
    this.canAllot = false,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Van> vans;
  final List<Member> drivers;
  final bool canAllot;
  final bool busy;

  VansState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Van>? vans,
    List<Member>? drivers,
    bool? canAllot,
    bool? busy,
  }) => VansState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    vans: vans ?? this.vans,
    drivers: drivers ?? this.drivers,
    canAllot: canAllot ?? this.canAllot,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [status, failure, vans, drivers, canAllot, busy];
}

class VansBloc extends Bloc<VansEvent, VansState> {
  VansBloc({
    required Account account,
    required GetVans getVans,
    required SaveVan saveVan,
    required RemoveVan removeVan,
    required GetMembers getStaff,
  }) : _account = account,
       _get = getVans,
       _save = saveVan,
       _remove = removeVan,
       _staff = getStaff,
       super(const VansState()) {
    on<VansStarted>(_onStarted);
    on<VanSaved>((e, emit) => _change(emit, () => _save(e.draft)));
    on<VanRemoved>((e, emit) => _change(emit, () => _remove(e.id)));
  }

  final Account _account;
  final GetVans _get;
  final SaveVan _save;
  final RemoveVan _remove;
  final GetMembers _staff;

  Future<void> _onStarted(VansStarted e, Emitter<VansState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      final canAllot = FleetAccess.of(_account).canAllotVans;
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          vans: await _get(const NoVanParams()),
          drivers: await _staff(const GetMembersParams()),
          canAllot: canAllot,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _change(
    Emitter<VansState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(state.copyWith(busy: false, vans: await _get(const NoVanParams())));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
