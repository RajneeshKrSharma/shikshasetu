import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../session/domain/entities/account.dart';
import '../../domain/entities/notice.dart';
import '../../domain/usecases/notices_usecases.dart';

sealed class NoticesEvent extends Equatable {
  const NoticesEvent();

  @override
  List<Object?> get props => const [];
}

final class NoticesStarted extends NoticesEvent {
  const NoticesStarted();
}

final class NoticePosted extends NoticesEvent {
  const NoticePosted(this.params);

  final PostNoticeParams params;

  @override
  List<Object?> get props => [params];
}

final class NoticeWithdrawn extends NoticesEvent {
  const NoticeWithdrawn(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class NoticesState extends Equatable {
  const NoticesState({
    this.status = ViewStatus.loading,
    this.failure,
    this.notices = const [],
    this.canPost = false,
    this.busy = false,
    this.savedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Notice> notices;
  final bool canPost;
  final bool busy;
  final int savedCount;

  NoticesState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Notice>? notices,
    bool? canPost,
    bool? busy,
    int? savedCount,
  }) => NoticesState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    notices: notices ?? this.notices,
    canPost: canPost ?? this.canPost,
    busy: busy ?? this.busy,
    savedCount: savedCount ?? this.savedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    notices,
    canPost,
    busy,
    savedCount,
  ];
}

class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  NoticesBloc({
    required Account account,
    required GetNotices getNotices,
    required PostNotice postNotice,
    required WithdrawNotice withdrawNotice,
  }) : _account = account,
       _get = getNotices,
       _post = postNotice,
       _withdraw = withdrawNotice,
       super(const NoticesState()) {
    on<NoticesStarted>(_onStarted);
    on<NoticePosted>((e, emit) => _change(emit, () => _post(e.params)));
    on<NoticeWithdrawn>((e, emit) => _change(emit, () => _withdraw(e.id)));
  }

  final Account _account;
  final GetNotices _get;
  final PostNotice _post;
  final WithdrawNotice _withdraw;

  Future<void> _onStarted(NoticesStarted e, Emitter<NoticesState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          notices: await _get(const NoParams()),
          canPost: NoticesAccess.of(_account).canPost,
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
    Emitter<NoticesState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(
        state.copyWith(
          busy: false,
          notices: await _get(const NoParams()),
          savedCount: state.savedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
