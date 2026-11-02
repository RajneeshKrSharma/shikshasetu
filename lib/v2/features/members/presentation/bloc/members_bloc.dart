import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/member.dart';
import '../../domain/usecases/members_usecases.dart';

sealed class MembersEvent extends Equatable {
  const MembersEvent();

  @override
  List<Object?> get props => const [];
}

final class MembersStarted extends MembersEvent {
  const MembersStarted();
}

final class MembersFiltered extends MembersEvent {
  const MembersFiltered({required this.query, required this.onlyActive});

  final String query;
  final bool onlyActive;

  @override
  List<Object?> get props => [query, onlyActive];
}

class MembersState extends Equatable {
  const MembersState({
    this.status = ViewStatus.loading,
    this.failure,
    this.members = const [],
    this.query = '',
    this.onlyActive = true,
    this.canManage = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Member> members;
  final String query;
  final bool onlyActive;
  final bool canManage;

  MembersState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Member>? members,
    String? query,
    bool? onlyActive,
    bool? canManage,
  }) => MembersState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    members: members ?? this.members,
    query: query ?? this.query,
    onlyActive: onlyActive ?? this.onlyActive,
    canManage: canManage ?? this.canManage,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    members,
    query,
    onlyActive,
    canManage,
  ];
}

class MembersBloc extends Bloc<MembersEvent, MembersState> {
  MembersBloc({
    required MemberKind kind,
    required Account account,
    required GetMembers getMembers,
  }) : _kind = kind,
       _account = account,
       _get = getMembers,
       super(const MembersState()) {
    on<MembersStarted>(
      (e, emit) =>
          _load(emit, state.copyWith(canManage: _kind.canManage(_account))),
    );
    on<MembersFiltered>(
      (e, emit) =>
          _load(emit, state.copyWith(query: e.query, onlyActive: e.onlyActive)),
    );
  }

  final MemberKind _kind;
  final Account _account;
  final GetMembers _get;

  Future<void> _load(Emitter<MembersState> emit, MembersState next) async {
    emit(next.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        next.copyWith(
          status: ViewStatus.ready,
          members: await _get(
            GetMembersParams(query: next.query, onlyActive: next.onlyActive),
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
}
