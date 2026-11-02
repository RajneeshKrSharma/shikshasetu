import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../bloc/member_workspace_bloc.dart';
import '../widgets/member_kind_view.dart';
import '../widgets/member_search_field.dart';
import '../widgets/member_tile.dart';

/// Everyone of one group, to search, open, edit or add to. Opened from the
/// group's first screen, which owns the [MemberWorkspaceBloc].
class MemberListScreen extends StatelessWidget {
  const MemberListScreen({super.key, required this.view});

  final MemberKindView view;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<MemberWorkspaceBloc, MemberWorkspaceState>(
      listenWhen: (a, b) => a.changeId != b.changeId,
      listener: (context, state) {
        final m = state.lastChanged!;
        final bloc = context.read<MemberWorkspaceBloc>();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                m.active
                    ? l.memberMadeActive(m.name)
                    : l.memberMadeInactive(m.name),
              ),
              action: SnackBarAction(
                label: l.actionUndo,
                onPressed: () =>
                    bloc.add(MemberActiveChanged(m.id, active: !m.active)),
              ),
            ),
          );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(view.listLabel(l)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: FilledButton.icon(
                // The theme's buttons are full width; this one sits in the bar.
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, AppSizes.buttonCompact),
                ),
                onPressed: () async {
                  final bloc = context.read<MemberWorkspaceBloc>();
                  await view.openAdd(context);
                  bloc.add(const WorkspaceReloaded());
                },
                icon: const Icon(Icons.add, size: AppIconSize.md),
                label: Text(view.addLabel(l)),
              ),
            ),
          ],
        ),
        body: BlocBuilder<MemberWorkspaceBloc, MemberWorkspaceState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final visible = state.visible;
            return ListView(
              padding: AppSpacing.pageOf(context),
              children: [
                MemberSearchField(hint: view.searchHint(l)),
                const SizedBox(height: AppSpacing.lg),
                if (state.groups.length > 1) ...[
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ChoiceChip(
                          label: Text(view.groupAllLabel(l)),
                          selected: state.filter.group == null,
                          onSelected: (_) => context
                              .read<MemberWorkspaceBloc>()
                              .add(const WorkspaceGroupChosen(null)),
                        ),
                        for (final g in state.groups) ...[
                          const SizedBox(width: AppSpacing.sm),
                          ChoiceChip(
                            label: Text(g),
                            selected: state.filter.group == g,
                            onSelected: (_) => context
                                .read<MemberWorkspaceBloc>()
                                .add(WorkspaceGroupChosen(g)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (state.inactiveCount > 0)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(l.memberShowInactive(state.inactiveCount)),
                    value: state.filter.showInactive,
                    onChanged: (v) => context.read<MemberWorkspaceBloc>().add(
                      WorkspaceInactiveToggled(v),
                    ),
                  ),
                if (visible.isEmpty)
                  EmptyState(icon: view.icon, message: l.emptyPeople)
                else
                  for (final m in visible) ...[
                    MemberTile(member: m, view: view),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }
}
