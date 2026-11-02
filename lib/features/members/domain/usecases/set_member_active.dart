import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/member_kind.dart';
import '../repository/member_directory.dart';

class SetMemberActiveParams extends Equatable {
  const SetMemberActiveParams(this.kind, this.id, this.active);

  final MemberKind kind;
  final String id;
  final bool active;

  @override
  List<Object?> get props => [kind, id, active];
}

class SetMemberActive implements UseCase<void, SetMemberActiveParams> {
  const SetMemberActive(this._directory);

  final MemberDirectory _directory;

  @override
  Future<void> call(SetMemberActiveParams p) =>
      _directory.setActive(p.kind, p.id, p.active);
}
