import 'package:equatable/equatable.dart';

import 'accessory_kind.dart';

/// One piece of a class's dress (shirt, tie...) or one of its books.
class AccessoryItem extends Equatable {
  const AccessoryItem({
    required this.id,
    required this.className,
    required this.kind,
    required this.name,
  });

  final String id;
  final String className;
  final AccessoryKind kind;
  final String name;

  @override
  List<Object?> get props => [id, className, kind, name];
}
