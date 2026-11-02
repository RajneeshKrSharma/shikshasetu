import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/member_summary.dart';
import '../bloc/member_workspace_bloc.dart';
import 'member_kind_view.dart';
import 'summary_part_l10n.dart';

enum _MemberAction { open, edit, setInactive, setActive }

/// One person on a list: name, a line about them, and a menu. It shows no
/// status (attendance, dues): that lives on the screens about those things.
class MemberTile extends StatelessWidget {
  const MemberTile({super.key, required this.member, required this.view});

  final MemberSummary member;
  final MemberKindView view;

  Future<void> _onAction(BuildContext context, _MemberAction a) async {
    final bloc = context.read<MemberWorkspaceBloc>();
    switch (a) {
      case _MemberAction.open:
        view.openProfile?.call(context, member);
      case _MemberAction.edit:
        await view.openEdit?.call(context, member);
        bloc.add(const WorkspaceReloaded());
      case _MemberAction.setInactive:
        bloc.add(MemberActiveChanged(member.id, active: false));
      case _MemberAction.setActive:
        bloc.add(MemberActiveChanged(member.id, active: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final open = view.openProfile;
    final dim = member.active ? 1.0 : 0.55;
    return Opacity(
      opacity: dim,
      child: InkWell(
        onTap: open == null ? null : () => open(context, member),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                InitialsAvatar(member.name, radius: 18),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: context.text.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (member.parts.isNotEmpty)
                        Text(
                          member.subtitle(l),
                          style: context.text.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (!member.active)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: StatusChip(
                      label: l.memberInactiveTag,
                      color: AppColors.textMuted,
                      background: AppColors.border,
                    ),
                  ),
                PopupMenuButton<Object>(
                  onSelected: (a) async {
                    if (a is MemberActionView) {
                      final bloc = context.read<MemberWorkspaceBloc>();
                      await a.run(context, member);
                      bloc.add(const WorkspaceReloaded());
                    } else {
                      await _onAction(context, a as _MemberAction);
                    }
                  },
                  itemBuilder: (_) => [
                    if (open != null)
                      PopupMenuItem(
                        value: _MemberAction.open,
                        child: Text(l.memberOpen),
                      ),
                    if (view.openEdit != null)
                      PopupMenuItem(
                        value: _MemberAction.edit,
                        child: Text(l.memberEdit),
                      ),
                    for (final a in view.actions)
                      PopupMenuItem<Object>(value: a, child: Text(a.label(l))),
                    PopupMenuItem(
                      value: member.active
                          ? _MemberAction.setInactive
                          : _MemberAction.setActive,
                      child: Text(
                        member.active
                            ? l.memberMakeInactive
                            : l.memberMakeActive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
