import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/notice.dart';
import '../repository/notices_repository.dart';

class GetNotices implements UseCase<List<Notice>, NoParams> {
  const GetNotices(this._repository);

  final NoticesRepository _repository;

  @override
  Future<List<Notice>> call(NoParams params) => _repository.getNotices();
}

class PostNoticeParams extends Equatable {
  const PostNoticeParams({
    required this.kind,
    required this.title,
    required this.body,
  });

  final NoticeKind kind;
  final String title;
  final String body;

  @override
  List<Object?> get props => [kind, title, body];
}

class PostNotice implements UseCase<Notice, PostNoticeParams> {
  const PostNotice(this._repository);

  final NoticesRepository _repository;

  @override
  Future<Notice> call(PostNoticeParams p) => _repository.post(
    kind: p.kind,
    title: p.title.trim(),
    body: p.body.trim(),
  );
}

class WithdrawNotice implements UseCase<void, String> {
  const WithdrawNotice(this._repository);

  final NoticesRepository _repository;

  @override
  Future<void> call(String id) => _repository.withdraw(id);
}
