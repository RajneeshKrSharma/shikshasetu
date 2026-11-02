import '../../../../core/server/json.dart';
import '../../domain/entities/notice.dart';

class NoticeModel extends Notice {
  const NoticeModel({
    required super.id,
    required super.kind,
    required super.title,
    required super.body,
    required super.postedByName,
    required super.postedAt,
  });

  factory NoticeModel.fromJson(Json json) => NoticeModel(
    id: json.string('id'),
    kind: NoticeKind.fromCode(json.stringOrNull('kind')),
    title: json.string('title'),
    body: json.string('body'),
    postedByName: json.string('posted_by_name'),
    postedAt: json.momentOrNull('posted_at'),
  );
}
