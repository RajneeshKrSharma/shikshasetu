import 'package:equatable/equatable.dart';

import '../../../../core/money.dart';

/// The two kinds of things the school sells.
enum AccessoryKind {
  dress('dress'),
  books('books');

  const AccessoryKind(this.code);

  final String code;

  static AccessoryKind? fromCode(String? code) {
    for (final k in values) {
      if (k.code == code) return k;
    }
    return null;
  }
}

/// Something for sale: a dress piece or a book set. With no class it is for
/// every class.
class AccessoryItem extends Equatable {
  const AccessoryItem({
    required this.id,
    required this.kind,
    required this.name,
    required this.price,
    required this.classId,
    required this.isActive,
  });

  final String id;
  final AccessoryKind kind;
  final String name;
  final Money price;
  final String? classId;
  final bool isActive;

  @override
  List<Object?> get props => [id, kind, name, price, classId, isActive];
}

class AccessoryItemDraft extends Equatable {
  const AccessoryItemDraft({
    this.id,
    required this.kind,
    required this.name,
    required this.price,
    this.classId,
  });

  final String? id;
  final AccessoryKind kind;
  final String name;
  final Money price;
  final String? classId;

  @override
  List<Object?> get props => [id, kind, name, price, classId];
}

class AccessorySale extends Equatable {
  const AccessorySale({
    required this.studentId,
    required this.itemId,
    this.quantity = 1,
  });

  final String studentId;
  final String itemId;
  final int quantity;

  @override
  List<Object?> get props => [studentId, itemId, quantity];
}
