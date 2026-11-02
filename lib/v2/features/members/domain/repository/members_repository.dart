import '../entities/member.dart';

abstract interface class MembersRepository {
  Future<List<Member>> members({String query = '', bool onlyActive = true});

  Future<Member> member(String id);

  Future<Member> save(MemberDraft draft);

  Future<Member> setActive(String id, {required bool active});

  Future<void> setPassword(String id, String password);
}
