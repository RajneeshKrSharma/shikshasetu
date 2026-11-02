import 'member_kind.dart';
import 'member_workspace.dart';

/// Finds the workspace of a group of people.
class WorkspaceCatalog {
  WorkspaceCatalog(Iterable<MemberWorkspace> workspaces)
    : _byKind = {for (final w in workspaces) w.kind: w};

  final Map<MemberKind, MemberWorkspace> _byKind;

  MemberWorkspace of(MemberKind kind) => _byKind[kind]!;
}
