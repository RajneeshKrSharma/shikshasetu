import 'package:equatable/equatable.dart';

import 'member_summary.dart';

/// How a list of people is narrowed: by what was typed, and by group.
class MemberFilter extends Equatable {
  const MemberFilter({this.query = '', this.group, this.showInactive = false});

  final String query;
  final String? group;
  final bool showInactive;

  MemberFilter withQuery(String value) =>
      MemberFilter(query: value, group: group, showInactive: showInactive);

  MemberFilter withGroup(String? value) =>
      MemberFilter(query: query, group: value, showInactive: showInactive);

  MemberFilter withInactive(bool value) =>
      MemberFilter(query: query, group: group, showInactive: value);

  /// The groups present in [all], in the order they first appear.
  static List<String> groupsOf(List<MemberSummary> all) => [
    ...{
      for (final m in all)
        if (m.group != null) m.group!,
    },
  ];

  List<MemberSummary> apply(List<MemberSummary> all) {
    final q = query.trim().toLowerCase();
    return [
      for (final m in all)
        if ((showInactive || m.active) &&
            (group == null || m.group == group) &&
            (q.isEmpty ||
                m.name.toLowerCase().contains(q) ||
                m.parts.any((p) => p.value.toLowerCase().contains(q))))
          m,
    ];
  }

  @override
  List<Object?> get props => [query, group, showInactive];
}
