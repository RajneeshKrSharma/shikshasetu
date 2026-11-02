import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/member.dart';
import '../repository/members_repository.dart';

class GetMembersParams extends Equatable {
  const GetMembersParams({this.query = '', this.onlyActive = true});

  final String query;
  final bool onlyActive;

  @override
  List<Object?> get props => [query, onlyActive];
}

class GetMembers implements UseCase<List<Member>, GetMembersParams> {
  const GetMembers(this._repository);

  final MembersRepository _repository;

  @override
  Future<List<Member>> call(GetMembersParams p) =>
      _repository.members(query: p.query, onlyActive: p.onlyActive);
}

class GetMember implements UseCase<Member, String> {
  const GetMember(this._repository);

  final MembersRepository _repository;

  @override
  Future<Member> call(String id) => _repository.member(id);
}

class SaveMember implements UseCase<Member, MemberDraft> {
  const SaveMember(this._repository);

  final MembersRepository _repository;

  @override
  Future<Member> call(MemberDraft draft) => _repository.save(draft);
}

class SetMemberActiveParams extends Equatable {
  const SetMemberActiveParams(this.id, {required this.active});

  final String id;
  final bool active;

  @override
  List<Object?> get props => [id, active];
}

class SetMemberActive implements UseCase<Member, SetMemberActiveParams> {
  const SetMemberActive(this._repository);

  final MembersRepository _repository;

  @override
  Future<Member> call(SetMemberActiveParams p) =>
      _repository.setActive(p.id, active: p.active);
}

class SetMemberPasswordParams extends Equatable {
  const SetMemberPasswordParams(this.id, this.password);

  final String id;
  final String password;

  @override
  List<Object?> get props => [id, password];
}

class SetMemberPassword implements UseCase<void, SetMemberPasswordParams> {
  const SetMemberPassword(this._repository);

  final MembersRepository _repository;

  @override
  Future<void> call(SetMemberPasswordParams p) =>
      _repository.setPassword(p.id, p.password);
}
