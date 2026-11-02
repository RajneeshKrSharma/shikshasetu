import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/school_class.dart';
import '../repository/classes_repository.dart';

class GetClasses implements UseCase<List<SchoolClass>, NoParams> {
  const GetClasses(this._repository);

  final ClassesRepository _repository;

  @override
  Future<List<SchoolClass>> call(NoParams params) => _repository.getClasses();
}

class SaveClassParams extends Equatable {
  const SaveClassParams({this.id, required this.level, this.section = ''});

  /// Null for a class not yet saved.
  final String? id;
  final ClassLevel level;
  final String section;

  @override
  List<Object?> get props => [id, level, section];
}

class SaveClass implements UseCase<SchoolClass, SaveClassParams> {
  const SaveClass(this._repository);

  final ClassesRepository _repository;

  @override
  Future<SchoolClass> call(SaveClassParams p) => p.id == null
      ? _repository.add(level: p.level, section: p.section.trim())
      : _repository.change(p.id!, level: p.level, section: p.section.trim());
}

class RemoveClass implements UseCase<void, String> {
  const RemoveClass(this._repository);

  final ClassesRepository _repository;

  @override
  Future<void> call(String id) => _repository.remove(id);
}
