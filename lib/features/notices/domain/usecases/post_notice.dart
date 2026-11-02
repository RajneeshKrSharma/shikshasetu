import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/notice.dart';
import '../repository/notices_repository.dart';

class PostNoticeParams extends Equatable {
  const PostNoticeParams({
    required this.title,
    required this.body,
    required this.postedBy,
  });

  final String title;
  final String body;
  final String postedBy;

  @override
  List<Object?> get props => [title, body, postedBy];
}

class PostNotice implements UseCase<void, PostNoticeParams> {
  const PostNotice(this._repository);

  final NoticesRepository _repository;

  @override
  Future<void> call(PostNoticeParams p) => _repository.post(
    Notice(
      id: const Uuid().v4(),
      title: p.title.trim(),
      body: p.body.trim(),
      postedBy: p.postedBy,
      postedAt: DateTime.now(),
    ),
  );
}
