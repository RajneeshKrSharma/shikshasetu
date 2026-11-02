import '../entities/accessory.dart';

abstract interface class AccessoriesRepository {
  Future<List<AccessoryItem>> items({AccessoryKind? kind, String? classId});

  Future<AccessoryItem> save(AccessoryItemDraft draft);

  Future<void> remove(String id);

  Future<void> sell(AccessorySale sale);
}
