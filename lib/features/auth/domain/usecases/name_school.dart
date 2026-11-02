import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class NameSchool implements UseCase<void, String> {
  const NameSchool(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(String name) => _repository.nameSchool(name.trim());
}
