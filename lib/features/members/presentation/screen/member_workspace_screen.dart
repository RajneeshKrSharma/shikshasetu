import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/context_ext.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/member_kind.dart';
import '../bloc/member_workspace_bloc.dart';
import '../widgets/member_feature_views.dart';
import '../widgets/member_kind_view.dart';
import '../../../../core/widgets/choice_tile.dart';
import 'member_list_screen.dart';

/// The first screen of a group (Students, Teachers or Others): it asks what
/// you need and shows one tile for each choice. The same screen serves all
/// three; [kind] picks the words and the choices.
class MemberWorkspaceScreen extends StatelessWidget {
  const MemberWorkspaceScreen({super.key, required this.kind});

  final MemberKind kind;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        sl<MemberWorkspaceBloc>(param1: kind)..add(const WorkspaceStarted()),
    child: _Choices(view: MemberKindViews.of(kind)),
  );
}

class _Choices extends StatelessWidget {
  const _Choices({required this.view});

  final MemberKindView view;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<MemberWorkspaceBloc>();
    return Scaffold(
      appBar: AppBar(title: Text(view.title(l))),
      body: BlocBuilder<MemberWorkspaceBloc, MemberWorkspaceState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final tiles = [
            ChoiceTile(
              highlight: true,
              icon: Icons.person_add_alt_1_outlined,
              title: view.addLabel(l),
              description: view.addHint(l),
              onTap: () async {
                await view.openAdd(context);
                bloc.add(const WorkspaceReloaded());
              },
            ),
            ChoiceTile(
              icon: view.icon,
              title: view.listLabel(l),
              description: l.wsListHint(state.members.length),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: MemberListScreen(view: view),
                    ),
                  ),
                );
                bloc.add(const WorkspaceReloaded());
              },
            ),
            if (state.workspace != null)
              for (final f in state.workspace!.features)
                if (MemberFeatureViews.of(f) case final v?)
                  ChoiceTile(
                    icon: v.icon,
                    title: v.label(l),
                    description: v.description(l),
                    onTap: () => v.open(context),
                  ),
          ];
          return ChoiceScreenBody(question: l.wsAsk, tiles: tiles);
        },
      ),
    );
  }
}
