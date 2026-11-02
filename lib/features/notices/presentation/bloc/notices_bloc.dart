import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/notice.dart';
import '../../domain/usecases/get_notices.dart';
import '../../domain/usecases/post_notice.dart';

sealed class NoticesEvent extends Equatable {
  const NoticesEvent();

  @override
  List<Object?> get props => const [];
}

final class NoticesLoaded extends NoticesEvent {
  const NoticesLoaded();
}

final class NoticePosted extends NoticesEvent {
  const NoticePosted(this.params);

  final PostNoticeParams params;

  @override
  List<Object?> get props => [params];
}

class NoticesState extends Equatable {
  const NoticesState({
    this.loading = true,
    this.notices = const [],
    this.postedCount = 0,
  });

  final bool loading;

  /// Newest first.
  final List<Notice> notices;

  /// Increases each time a notice is posted, so the UI can confirm it.
  final int postedCount;

  @override
  List<Object?> get props => [loading, notices, postedCount];
}

class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  NoticesBloc({required GetNotices getNotices, required PostNotice postNotice})
    : _get = getNotices,
      _post = postNotice,
      super(const NoticesState()) {
    on<NoticesLoaded>(
      (e, emit) async => emit(
        NoticesState(
          loading: false,
          notices: await _get(const NoParams()),
          postedCount: state.postedCount,
        ),
      ),
    );
    on<NoticePosted>((e, emit) async {
      await _post(e.params);
      emit(
        NoticesState(
          loading: false,
          notices: await _get(const NoParams()),
          postedCount: state.postedCount + 1,
        ),
      );
    });
  }

  final GetNotices _get;
  final PostNotice _post;
}
