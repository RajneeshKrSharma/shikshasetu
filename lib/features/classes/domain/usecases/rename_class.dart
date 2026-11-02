import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/classes_repository.dart';

class RenameClassParams extends Equatable {
  const RenameClassParams(this.oldName, this.newName);

  final String oldName;
  final String newName;

  @override
  List<Object?> get props => [oldName, newName];
}

class RenameClass implements UseCase<void, RenameClassParams> {
  const RenameClass(this._repository);

  final ClassesRepository _repository;

  @override
  Future<void> call(RenameClassParams p) =>
      _repository.rename(p.oldName, p.newName.trim());
}
