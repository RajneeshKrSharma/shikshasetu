import 'package:get_it/get_it.dart';

import '../../features/members/data/repository/server_members_repository.dart';
import '../../features/members/domain/entities/member.dart';
import '../../features/members/domain/repository/members_repository.dart';
import '../../features/members/domain/usecases/members_usecases.dart';
import '../../features/members/presentation/bloc/member_detail_bloc.dart';
import '../../features/members/presentation/bloc/member_editor_bloc.dart';
import '../../features/members/presentation/bloc/members_bloc.dart';
import '../../features/session/domain/entities/account.dart';

/// Teachers, staff and Vice Principals share everything but their server path,
/// so each kind just gets its own repository.
void registerMembers(GetIt sl) {
  MembersRepository repo(MemberKind kind) =>
      ServerMembersRepository(sl(), kind);
  sl
    ..registerFactoryParam<
      MembersBloc,
      ({MemberKind kind, Account account}),
      void
    >(
      (p, _) => MembersBloc(
        kind: p.kind,
        account: p.account,
        getMembers: GetMembers(repo(p.kind)),
      ),
    )
    ..registerFactoryParam<MemberEditorBloc, MemberKind, void>(
      (kind, _) => MemberEditorBloc(saveMember: SaveMember(repo(kind))),
    )
    ..registerFactoryParam<
      MemberDetailBloc,
      ({MemberKind kind, String id}),
      Account
    >(
      (p, account) => MemberDetailBloc(
        kind: p.kind,
        memberId: p.id,
        account: account,
        getMember: GetMember(repo(p.kind)),
        setMemberActive: SetMemberActive(repo(p.kind)),
        setMemberPassword: SetMemberPassword(repo(p.kind)),
      ),
    );
}
