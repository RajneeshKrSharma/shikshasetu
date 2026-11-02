import '../../../../../core/usecase/usecase.dart';
import '../entities/grants.dart';
import '../repository/grants_repository.dart';

class GetCapabilities implements UseCase<List<Capability>, String> {
  const GetCapabilities(this._repository);

  final GrantsRepository _repository;

  /// The argument is unused: the list is the same for everyone.
  @override
  Future<List<Capability>> call(String _) => _repository.capabilities();
}

class GetGrants implements UseCase<List<Grant>, String> {
  const GetGrants(this._repository);

  final GrantsRepository _repository;

  @override
  Future<List<Grant>> call(String userId) => _repository.grants(userId);
}

class GrantPermission implements UseCase<void, GrantDraft> {
  const GrantPermission(this._repository);

  final GrantsRepository _repository;

  @override
  Future<void> call(GrantDraft draft) => _repository.grant(draft);
}

class RevokePermission implements UseCase<void, String> {
  const RevokePermission(this._repository);

  final GrantsRepository _repository;

  @override
  Future<void> call(String grantId) => _repository.revoke(grantId);
}
