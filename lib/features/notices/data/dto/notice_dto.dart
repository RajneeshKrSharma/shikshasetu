/// A row of the `notices` table.
class NoticeDto {
  const NoticeDto({
    required this.id,
    required this.title,
    required this.body,
    required this.postedBy,
    required this.postedAt,
  });

  final String id;
  final String title;
  final String body;
  final String postedBy;
  final int postedAt;

  factory NoticeDto.fromMap(Map<String, Object?> m) => NoticeDto(
    id: m['id']! as String,
    title: m['title']! as String,
    body: m['body']! as String,
    postedBy: m['posted_by']! as String,
    postedAt: m['posted_at']! as int,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'posted_by': postedBy,
    'posted_at': postedAt,
  };
}
