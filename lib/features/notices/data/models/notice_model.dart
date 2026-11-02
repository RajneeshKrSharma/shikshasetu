import '../../domain/entities/notice.dart';
import '../dto/notice_dto.dart';

class NoticeModel extends Notice {
  const NoticeModel({
    required super.id,
    required super.title,
    required super.body,
    required super.postedBy,
    required super.postedAt,
  });

  factory NoticeModel.fromDto(NoticeDto d) => NoticeModel(
    id: d.id,
    title: d.title,
    body: d.body,
    postedBy: d.postedBy,
    postedAt: DateTime.fromMillisecondsSinceEpoch(d.postedAt),
  );

  factory NoticeModel.fromEntity(Notice n) => NoticeModel(
    id: n.id,
    title: n.title,
    body: n.body,
    postedBy: n.postedBy,
    postedAt: n.postedAt,
  );

  NoticeDto toDto() => NoticeDto(
    id: id,
    title: title,
    body: body,
    postedBy: postedBy,
    postedAt: postedAt.millisecondsSinceEpoch,
  );
}
