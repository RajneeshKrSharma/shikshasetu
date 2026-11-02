import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_filter.dart';
import '../../domain/entities/member_kind.dart';
import '../../domain/entities/member_summary.dart';
import '../../domain/entities/member_workspace.dart';
import '../../domain/usecases/get_member_summaries.dart';
import '../../domain/usecases/get_workspace.dart';
import '../../domain/usecases/set_member_active.dart';

sealed class MemberWorkspaceEvent extends Equatable {
  const MemberWorkspaceEvent();

  @override
  List<Object?> get props => const [];
}

final class WorkspaceStarted extends MemberWorkspaceEvent {
  const WorkspaceStarted();
}

/// The list changed elsewhere (someone was added or edited): read it again.
final class WorkspaceReloaded extends MemberWorkspaceEvent {
  const WorkspaceReloaded();
}

final class WorkspaceQueryChanged extends MemberWorkspaceEvent {
  const WorkspaceQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class WorkspaceGroupChosen extends MemberWorkspaceEvent {
  const WorkspaceGroupChosen(this.group);

  /// Null shows everyone.
  final String? group;

  @override
  List<Object?> get props => [group];
}

final class WorkspaceInactiveToggled extends MemberWorkspaceEvent {
  const WorkspaceInactiveToggled(this.show);

  final bool show;

  @override
  List<Object?> get props => [show];
}

final class MemberActiveChanged extends MemberWorkspaceEvent {
  const MemberActiveChanged(this.id, {required this.active});

  final String id;
  final bool active;

  @override
  List<Object?> get props => [id, active];
}

class MemberWorkspaceState extends Equatable {
  const MemberWorkspaceState({
    this.loading = true,
    this.workspace,
    this.members = const [],
    this.filter = const MemberFilter(),
    this.changeId = 0,
    this.lastChanged,
  });

  final bool loading;
  final MemberWorkspace? workspace;
  final List<MemberSummary> members;
  final MemberFilter filter;

  /// Goes up each time someone is made active or inactive, so the screen can
  /// say so once.
  final int changeId;
  final MemberSummary? lastChanged;

  List<MemberSummary> get visible => filter.apply(members);

  List<String> get groups => MemberFilter.groupsOf(members);

  int get inactiveCount => members.where((m) => !m.active).length;

  MemberWorkspaceState copyWith({
    bool? loading,
    MemberWorkspace? workspace,
    List<MemberSummary>? members,
    MemberFilter? filter,
    int? changeId,
    MemberSummary? lastChanged,
  }) => MemberWorkspaceState(
    loading: loading ?? this.loading,
    workspace: workspace ?? this.workspace,
    members: members ?? this.members,
    filter: filter ?? this.filter,
    changeId: changeId ?? this.changeId,
    lastChanged: lastChanged ?? this.lastChanged,
  );

  @override
  List<Object?> get props => [
    loading,
    workspace,
    members,
    filter,
    changeId,
    lastChanged,
  ];
}

/// One group of people (students, teachers or other staff): the features it
/// offers and its list, narrowed by what the Principal types or picks.
class MemberWorkspaceBloc
    extends Bloc<MemberWorkspaceEvent, MemberWorkspaceState> {
  MemberWorkspaceBloc({
    required this.kind,
    required GetWorkspace getWorkspace,
    required GetMemberSummaries getMembers,
    required SetMemberActive setActive,
  }) : _getWorkspace = getWorkspace,
       _getMembers = getMembers,
       _setActive = setActive,
       super(const MemberWorkspaceState()) {
    on<WorkspaceStarted>(_load);
    on<WorkspaceReloaded>(_load);
    on<WorkspaceQueryChanged>(
      (e, emit) =>
          emit(state.copyWith(filter: state.filter.withQuery(e.query))),
    );
    on<WorkspaceGroupChosen>(
      (e, emit) =>
          emit(state.copyWith(filter: state.filter.withGroup(e.group))),
    );
    on<WorkspaceInactiveToggled>(
      (e, emit) =>
          emit(state.copyWith(filter: state.filter.withInactive(e.show))),
    );
    on<MemberActiveChanged>(_onActiveChanged);
  }

  final MemberKind kind;
  final GetWorkspace _getWorkspace;
  final GetMemberSummaries _getMembers;
  final SetMemberActive _setActive;

  Future<void> _load(
    MemberWorkspaceEvent e,
    Emitter<MemberWorkspaceState> emit,
  ) async {
    final workspace = await _getWorkspace(kind);
    final members = await _getMembers(kind);
    emit(
      state.copyWith(loading: false, workspace: workspace, members: members),
    );
  }

  Future<void> _onActiveChanged(
    MemberActiveChanged e,
    Emitter<MemberWorkspaceState> emit,
  ) async {
    await _setActive(SetMemberActiveParams(kind, e.id, e.active));
    final members = await _getMembers(kind);
    emit(
      state.copyWith(
        members: members,
        changeId: state.changeId + 1,
        lastChanged: members.firstWhere((m) => m.id == e.id),
      ),
    );
  }
}
