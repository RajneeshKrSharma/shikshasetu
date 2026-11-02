import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../domain/entities/member.dart';
import '../bloc/members_bloc.dart';
import '../widgets/member_kind_labels.dart';
import 'member_detail_screen.dart';
import 'member_form_screen.dart';

/// The people of one kind, searchable, with add when the viewer may.
class MembersTab extends StatelessWidget {
  const MembersTab({super.key, required this.kind, this.detailExtra});

  final MemberKind kind;

  /// More shown under a person's details.
  final Widget Function(BuildContext, Member)? detailExtra;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<MembersBloc, MembersState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<MembersBloc, MembersState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: state.canManage
              ? FloatingActionButton.extended(
                  onPressed: () => _add(context),
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                  label: Text(kind.addLabel(l)),
                )
              : null,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (v) => context.read<MembersBloc>().add(
                        MembersFiltered(query: v, onlyActive: state.onlyActive),
                      ),
                      decoration: InputDecoration(
                        hintText: l.stuSearch,
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.memShowRemoved),
                      value: !state.onlyActive,
                      onChanged: (v) => context.read<MembersBloc>().add(
                        MembersFiltered(query: state.query, onlyActive: !v),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AsyncBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: () =>
                      context.read<MembersBloc>().add(const MembersStarted()),
                  isEmpty: state.members.isEmpty,
                  emptyText: kind.emptyLabel(l),
                  emptyIcon: Icons.groups_outlined,
                  builder: (context) => ListView(
                    padding: AppSpacing.pageOf(context, fab: state.canManage),
                    children: [
                      for (final m in state.members)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            onTap: () => _open(context, m),
                            child: Row(
                              children: [
                                InitialsAvatar(m.name),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.name,
                                        style: context.text.titleSmall,
                                      ),
                                      Text(
                                        m.jobTitle.isEmpty
                                            ? m.email
                                            : '${m.jobTitle} · ${m.email}',
                                        style: context.text.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (!m.isActive)
                                  Text(
                                    l.stuRemoved,
                                    style: context.text.labelSmall,
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final bloc = context.read<MembersBloc>();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => MemberFormScreen(kind: kind)),
    );
    if (saved == true) bloc.add(const MembersStarted());
  }

  Future<void> _open(BuildContext context, Member member) async {
    final bloc = context.read<MembersBloc>();
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MemberDetailScreen(
          kind: kind,
          memberId: member.id,
          extra: detailExtra,
        ),
      ),
    );
    if (changed == true) bloc.add(const MembersStarted());
  }
}
