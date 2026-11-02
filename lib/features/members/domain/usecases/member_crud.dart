import '../../../../core/usecase/usecase.dart';
import '../entities/member.dart';
import '../repository/member_repository.dart';

/// Adds a person of type [T]. One class for every group of people.
class AddMember<T extends Member> implements UseCase<T, T> {
  const AddMember(this._repository);

  final MemberRepository<T> _repository;

  @override
  Future<T> call(T draft) => _repository.add(draft);
}

class UpdateMember<T extends Member> implements UseCase<void, T> {
  const UpdateMember(this._repository);

  final MemberRepository<T> _repository;

  @override
  Future<void> call(T member) => _repository.update(member);
}

class GetMember<T extends Member> implements UseCase<T?, String> {
  const GetMember(this._repository);

  final MemberRepository<T> _repository;

  @override
  Future<T?> call(String id) => _repository.get(id);
}
