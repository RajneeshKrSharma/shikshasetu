import '../../../../../core/usecase/usecase.dart';
import '../repository/ai_key_repository.dart';

/// Whether an AI key is saved on this phone.
class HasAiKey implements UseCase<bool, NoParams> {
  const HasAiKey(this._repository);

  final AiKeyRepository _repository;

  @override
  Future<bool> call(NoParams params) async {
    final key = await _repository.load();
    return key != null && key.isNotEmpty;
  }
}

class SaveAiKey implements UseCase<void, String> {
  const SaveAiKey(this._repository);

  final AiKeyRepository _repository;

  @override
  Future<void> call(String key) => _repository.save(key.trim());
}

class ClearAiKey implements UseCase<void, NoParams> {
  const ClearAiKey(this._repository);

  final AiKeyRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.clear();
}
