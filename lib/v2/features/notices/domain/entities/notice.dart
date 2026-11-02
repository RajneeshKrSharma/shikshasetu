import 'package:equatable/equatable.dart';

import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

enum NoticeKind {
  notice('notice'),
  announcement('announcement');

  const NoticeKind(this.code);

  final String code;

  static NoticeKind fromCode(String? code) =>
      values.firstWhere((k) => k.code == code, orElse: () => notice);
}

class Notice extends Equatable {
  const Notice({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.postedByName,
    required this.postedAt,
  });

  final String id;
  final NoticeKind kind;
  final String title;
  final String body;
  final String postedByName;
  final DateTime? postedAt;

  @override
  List<Object?> get props => [id, kind, title, body, postedByName, postedAt];
}

/// What a person may do with notices: everyone reads, some post.
class NoticesAccess {
  const NoticesAccess._(this.canPost);

  factory NoticesAccess.of(Account account) =>
      NoticesAccess._(account.can(Permission.postNotices));

  final bool canPost;
}
