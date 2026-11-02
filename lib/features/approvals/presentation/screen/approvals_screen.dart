import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/vertical_scroll_hint.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../cloud_sync/presentation/bloc/school_refresh_cubit.dart';
import '../../domain/entities/approval_request.dart';
import '../bloc/approvals_bloc.dart';
import '../../../exams/presentation/screen/paper_detail_screen.dart';
import '../widgets/approval_card.dart';
import '../widgets/approval_l10n.dart';

/// Everything waiting for the Principal, filterable by category.
class ApprovalsScreen extends StatelessWidget {
  const ApprovalsScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const ApprovalsScreen()));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = context.read<AuthBloc>().state.user!.id;

    return BlocListener<ApprovalsBloc, ApprovalsState>(
      // A decision changes what other screens show, so they reload.
      listenWhen: (a, b) => a.decidedCount != b.decidedCount,
      listener: (context, state) =>
          context.read<AttendanceBloc>().add(const AttendanceRefreshed()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.approvalsTitle),
          actions: [
            BlocBuilder<ApprovalsBloc, ApprovalsState>(
              buildWhen: (a, b) => a.requests != b.requests,
              builder: (context, state) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: Center(
                  child: Text(
                    l.approvalsSubtitle(
                      state.pendingCount,
                      state.requests.length,
                    ),
                    style: context.text.bodySmall,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ApprovalsBloc, ApprovalsState>(
          builder: (context, state) {
            void decide(ApprovalRequest r, ApprovalStatus s) {
              HapticFeedback.mediumImpact();
              context.read<ApprovalsBloc>().add(
                ApprovalDecided(request: r, status: s, decidedBy: me),
              );
              if (s != ApprovalStatus.pending) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        s == ApprovalStatus.approved
                            ? l.approvalsDecidedApproved
                            : l.approvalsDecidedRejected,
                      ),
                    ),
                  );
              }
            }

            final bloc = context.read<ApprovalsBloc>();
            final rows = state.visible;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SearchBox(hint: l.approvalsSearchHint),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ChoiceChip(
                              label: Text(
                                l.approvalsChipCount(
                                  l.filterAll,
                                  state.waitingIn(null),
                                ),
                              ),
                              selected: state.category == null,
                              onSelected: (_) =>
                                  bloc.add(const ApprovalCategoryChanged(null)),
                            ),
                            for (final c in state.categories) ...[
                              const SizedBox(width: AppSpacing.sm),
                              ChoiceChip(
                                label: Text(
                                  l.approvalsChipCount(
                                    c.label(l),
                                    state.waitingIn(c),
                                  ),
                                ),
                                selected: state.category == c,
                                onSelected: (_) =>
                                    bloc.add(ApprovalCategoryChanged(c)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<ApprovalStatus>(
                          showSelectedIcon: false,
                          segments: [
                            ButtonSegment(
                              value: ApprovalStatus.pending,
                              label: Text(l.approvalTabWaiting),
                            ),
                            ButtonSegment(
                              value: ApprovalStatus.approved,
                              label: Text(l.approvalTabApproved),
                            ),
                            ButtonSegment(
                              value: ApprovalStatus.rejected,
                              label: Text(l.approvalTabRejected),
                            ),
                          ],
                          selected: {state.tab},
                          onSelectionChanged: (v) =>
                              bloc.add(ApprovalTabChosen(v.first)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    // Ask the cloud for new requests, then show them.
                    onRefresh: () async {
                      await context.read<SchoolRefreshCubit>().refresh();
                      bloc.add(const ApprovalsRequested());
                    },
                    child: VerticalScrollHint(
                      builder: (context, controller) => ListView(
                        controller: controller,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg + AppSpacing.sm,
                          AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
                        ),
                        children: [
                          if (rows.isEmpty) ...[
                            EmptyState(
                              icon: Icons.verified_outlined,
                              message: l.emptyApprovals,
                            ),
                            Center(
                              child: Text(
                                l.approvalsPullHint,
                                style: context.text.bodySmall,
                              ),
                            ),
                          ] else
                            for (final r in rows) ...[
                              ApprovalCard(
                                request: r,
                                onDecide: (s) => decide(r, s),
                                onReview:
                                    r.category == ApprovalCategory.examPaper
                                    ? () => Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => PaperDetailScreen(
                                            paperId: r.refId!,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The search box. It owns only its text controller.
class _SearchBox extends StatefulWidget {
  const _SearchBox({required this.hint});

  final String hint;

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    onChanged: (v) =>
        context.read<ApprovalsBloc>().add(ApprovalQueryChanged(v)),
    decoration: InputDecoration(
      hintText: widget.hint,
      prefixIcon: const Icon(Icons.search),
    ),
  );
}
