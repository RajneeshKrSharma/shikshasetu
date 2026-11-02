import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/member.dart';
import '../../domain/usecases/members_usecases.dart';

sealed class MemberDetailEvent extends Equatable {
  const MemberDetailEvent();

  @override
  List<Object?> get props => const [];
}

final class MemberDetailStarted extends MemberDetailEvent {
  const MemberDetailStarted();
}

final class MemberActiveToggled extends MemberDetailEvent {
  const MemberActiveToggled();
}

final class MemberPasswordReset extends MemberDetailEvent {
  const MemberPasswordReset(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class MemberDetailState extends Equatable {
  const MemberDetailState({
    this.status = ViewStatus.loading,
    this.failure,
    this.member,
    this.canManage = false,
    this.busy = false,
    this.changedCount = 0,
    this.passwordChanged = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final Member? member;
  final bool canManage;
  final bool busy;
  final int changedCount;

  /// Goes up each time a new password was set, so the screen can say so.
  final int passwordChanged;

  MemberDetailState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    Member? member,
    bool? canManage,
    bool? busy,
    int? changedCount,
    int? passwordChanged,
  }) => MemberDetailState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    member: member ?? this.member,
    canManage: canManage ?? this.canManage,
    busy: busy ?? this.busy,
    changedCount: changedCount ?? this.changedCount,
    passwordChanged: passwordChanged ?? this.passwordChanged,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    member,
    canManage,
    busy,
    changedCount,
    passwordChanged,
  ];
}

class MemberDetailBloc extends Bloc<MemberDetailEvent, MemberDetailState> {
  MemberDetailBloc({
    required MemberKind kind,
    required String memberId,
    required Account account,
    required GetMember getMember,
    required SetMemberActive setMemberActive,
    required SetMemberPassword setMemberPassword,
  }) : _kind = kind,
       _id = memberId,
       _account = account,
       _get = getMember,
       _setActive = setMemberActive,
       _setPassword = setMemberPassword,
       super(const MemberDetailState()) {
    on<MemberDetailStarted>(_onStarted);
    on<MemberActiveToggled>(_onToggled);
    on<MemberPasswordReset>(_onPassword);
  }

  final MemberKind _kind;
  final String _id;
  final Account _account;
  final GetMember _get;
  final SetMemberActive _setActive;
  final SetMemberPassword _setPassword;

  Future<void> _onStarted(
    MemberDetailStarted e,
    Emitter<MemberDetailState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          member: await _get(_id),
          canManage: _kind.canManage(_account),
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

  Future<void> _onToggled(
    MemberActiveToggled e,
    Emitter<MemberDetailState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      emit(
        state.copyWith(
          busy: false,
          member: await _setActive(
            SetMemberActiveParams(_id, active: !state.member!.isActive),
          ),
          changedCount: state.changedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  Future<void> _onPassword(
    MemberPasswordReset e,
    Emitter<MemberDetailState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _setPassword(SetMemberPasswordParams(_id, e.password));
      emit(
        state.copyWith(busy: false, passwordChanged: state.passwordChanged + 1),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
