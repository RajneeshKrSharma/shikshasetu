import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/accessory.dart';
import '../repository/accessories_repository.dart';

class GetItemsParams extends Equatable {
  const GetItemsParams({this.kind, this.classId});

  final AccessoryKind? kind;
  final String? classId;

  @override
  List<Object?> get props => [kind, classId];
}

class GetAccessoryItems
    implements UseCase<List<AccessoryItem>, GetItemsParams> {
  const GetAccessoryItems(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<List<AccessoryItem>> call(GetItemsParams p) =>
      _repository.items(kind: p.kind, classId: p.classId);
}

class SaveAccessoryItem implements UseCase<AccessoryItem, AccessoryItemDraft> {
  const SaveAccessoryItem(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<AccessoryItem> call(AccessoryItemDraft draft) =>
      _repository.save(draft);
}

class RemoveAccessoryItem implements UseCase<void, String> {
  const RemoveAccessoryItem(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<void> call(String id) => _repository.remove(id);
}

class SellAccessory implements UseCase<void, AccessorySale> {
  const SellAccessory(this._repository);

  final AccessoriesRepository _repository;

  @override
  Future<void> call(AccessorySale sale) => _repository.sell(sale);
}
