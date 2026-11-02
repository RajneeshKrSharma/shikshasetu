import '../../../../core/money.dart';
import '../../../../core/server/json.dart';
import '../../domain/entities/accessory.dart';

class AccessoryItemModel extends AccessoryItem {
  const AccessoryItemModel({
    required super.id,
    required super.kind,
    required super.name,
    required super.price,
    required super.classId,
    required super.isActive,
  });

  factory AccessoryItemModel.fromJson(Json j) => AccessoryItemModel(
    id: j.string('id'),
    kind: AccessoryKind.fromCode(j.stringOrNull('kind')) ?? AccessoryKind.dress,
    name: j.string('name'),
    price: Money.fromServer(j['price']),
    classId: j.stringOrNull('class_id'),
    isActive: j.flag('is_active', otherwise: true),
  );
}
