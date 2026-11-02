import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/staff_repository.dart';

class SetStaffActiveParams extends Equatable {
  const SetStaffActiveParams(this.staffId, this.active);

  final String staffId;
  final bool active;

  @override
  List<Object?> get props => [staffId, active];
}

class SetStaffActive implements UseCase<void, SetStaffActiveParams> {
  const SetStaffActive(this._repository);

  final StaffRepository _repository;

  @override
  Future<void> call(SetStaffActiveParams p) =>
      _repository.setActive(p.staffId, p.active);
}
