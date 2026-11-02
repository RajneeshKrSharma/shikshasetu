import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/grants.dart';
import '../../domain/usecases/grants_usecases.dart';

sealed class GrantsEvent extends Equatable {
  const GrantsEvent();

  @override
  List<Object?> get props => const [];
}

final class GrantsStarted extends GrantsEvent {
  const GrantsStarted();
}

final class PermissionGiven extends GrantsEvent {
  const PermissionGiven(this.capability, this.reason);

  final String capability;
  final String reason;

  @override
  List<Object?> get props => [capability, reason];
}

final class PermissionTakenBack extends GrantsEvent {
  const PermissionTakenBack(this.grantId);

  final String grantId;

  @override
  List<Object?> get props => [grantId];
}

class GrantsState extends Equatable {
  const GrantsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.capabilities = const [],
    this.grants = const [],
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Capability> capabilities;
  final List<Grant> grants;
  final bool busy;

  /// The permission's given grant, if it is given.
  Grant? grantOf(String capability) {
    for (final g in grants) {
      if (g.capability == capability && g.isActive) return g;
    }
    return null;
  }

  GrantsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Capability>? capabilities,
    List<Grant>? grants,
    bool? busy,
  }) => GrantsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    capabilities: capabilities ?? this.capabilities,
    grants: grants ?? this.grants,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [status, failure, capabilities, grants, busy];
}

/// What the Principal has given one Vice Principal.
class GrantsBloc extends Bloc<GrantsEvent, GrantsState> {
  GrantsBloc({
    required String userId,
    required GetCapabilities getCapabilities,
    required GetGrants getGrants,
    required GrantPermission grantPermission,
    required RevokePermission revokePermission,
  }) : _userId = userId,
       _capabilities = getCapabilities,
       _grants = getGrants,
       _grant = grantPermission,
       _revoke = revokePermission,
       super(const GrantsState()) {
    on<GrantsStarted>(_onStarted);
    on<PermissionGiven>(
      (e, emit) => _change(
        emit,
        () => _grant(
          GrantDraft(
            userId: _userId,
            capability: e.capability,
            reason: e.reason,
          ),
        ),
      ),
    );
    on<PermissionTakenBack>(
      (e, emit) => _change(emit, () => _revoke(e.grantId)),
    );
  }

  final String _userId;
  final GetCapabilities _capabilities;
  final GetGrants _grants;
  final GrantPermission _grant;
  final RevokePermission _revoke;

  Future<void> _onStarted(GrantsStarted e, Emitter<GrantsState> emit) async {
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          capabilities: await _capabilities(_userId),
          grants: await _grants(_userId),
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
    Emitter<GrantsState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(state.copyWith(busy: false, grants: await _grants(_userId)));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
