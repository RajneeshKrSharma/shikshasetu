import '../../../../core/usecase/usecase.dart';
import '../entities/fee_account.dart';
import '../entities/fee_person.dart';
import '../repository/fees_repository.dart';

/// People in a group who do not have a fee account yet.
class GetFeePeople implements UseCase<List<FeePerson>, FeeGroup> {
  const GetFeePeople(this._repository);

  final FeesRepository _repository;

  @override
  Future<List<FeePerson>> call(FeeGroup group) async {
    final people = await _repository.getPeople(group);
    final accounts = await _repository.getAccounts();
    return [
      for (final p in people)
        if (!accounts.any((a) => a.group == group && a.personId == p.id)) p,
    ];
  }
}
