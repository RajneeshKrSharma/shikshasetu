import 'package:equatable/equatable.dart';

class Notice extends Equatable {
  const Notice({
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
  final DateTime postedAt;

  @override
  List<Object?> get props => [id, title, body, postedBy, postedAt];
}
