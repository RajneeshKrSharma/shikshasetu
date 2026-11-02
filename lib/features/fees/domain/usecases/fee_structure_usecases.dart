import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/fee_account.dart';
import '../entities/fee_structure_item.dart';
import '../repository/fees_repository.dart';

class GetFeeStructure implements UseCase<List<FeeStructureItem>, NoParams> {
  const GetFeeStructure(this._repository);

  final FeesRepository _repository;

  @override
  Future<List<FeeStructureItem>> call(NoParams params) =>
      _repository.getStructure();
}

class SaveFeeStructureItem implements UseCase<void, FeeStructureItem> {
  const SaveFeeStructureItem(this._repository);

  final FeesRepository _repository;

  @override
  Future<void> call(FeeStructureItem item) =>
      _repository.saveStructureItem(item);
}

class ApplyFeeStructureParams extends Equatable {
  const ApplyFeeStructureParams(this.className, this.head);

  final String className;
  final FeeHead head;

  @override
  List<Object?> get props => [className, head];
}

/// Gives a class's students the fee that was set up for them.
class ApplyFeeStructure implements UseCase<int, ApplyFeeStructureParams> {
  const ApplyFeeStructure(this._repository);

  final FeesRepository _repository;

  @override
  Future<int> call(ApplyFeeStructureParams p) =>
      _repository.applyStructure(p.className, p.head);
}
