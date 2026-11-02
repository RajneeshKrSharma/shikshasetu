import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../core/widgets/time_format.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/request.dart';
import '../../domain/usecases/requests_usecases.dart';
import '../bloc/requests_bloc.dart';
import '../widgets/request_dialogs.dart';
import '../widgets/request_labels.dart';

/// Leave and meeting requests: raise yours, or decide those you may.
class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<RequestsBloc>(param1: account)..add(const RequestsStarted()),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<RequestsBloc, RequestsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<RequestsBloc, RequestsState>(
        builder: (context, state) {
          final raisable = state.access?.raisable.toList() ?? const [];
          return Scaffold(
            appBar: AppBar(title: Text(l.reqTitle)),
            floatingActionButton: raisable.isEmpty
                ? null
                : PopupMenuButton<RequestKind>(
                    enabled: !state.busy,
                    onSelected: (k) => _raise(context, k),
                    itemBuilder: (_) => [
                      for (final k in raisable)
                        PopupMenuItem(value: k, child: Text(k.raiseLabel(l))),
                    ],
                    child: IgnorePointer(
                      child: FloatingActionButton.extended(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: Text(l.reqSend),
                      ),
                    ),
                  ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      ChoiceChip(
                        label: Text(l.reqAllKinds),
                        selected: state.kind == null,
                        onSelected: (_) => context.read<RequestsBloc>().add(
                          RequestsFiltered(status: state.requestStatus),
                        ),
                      ),
                      for (final k in RequestKind.values)
                        ChoiceChip(
                          label: Text(k.label(l)),
                          selected: state.kind == k,
                          onSelected: (_) => context.read<RequestsBloc>().add(
                            RequestsFiltered(
                              kind: k,
                              status: state.requestStatus,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      for (final s in RequestStatus.values)
                        ChoiceChip(
                          label: Text(s.label(l)),
                          selected: state.requestStatus == s,
                          onSelected: (on) => context.read<RequestsBloc>().add(
                            RequestsFiltered(
                              kind: state.kind,
                              status: on ? s : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: AsyncBody(
                    status: state.status,
                    failure: state.failure,
                    onRetry: () => context.read<RequestsBloc>().add(
                      const RequestsStarted(),
                    ),
                    isEmpty: state.requests.isEmpty,
                    emptyText: l.reqEmpty,
                    emptyIcon: Icons.forum_outlined,
                    builder: (context) => ListView(
                      padding: AppSpacing.pageOf(context, fab: true),
                      children: [
                        for (final r in state.requests)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: _RequestCard(request: r, state: state),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _raise(BuildContext context, RequestKind kind) async {
    final bloc = context.read<RequestsBloc>();
    final Future<RequestDraft?> asked = switch (kind) {
      RequestKind.leave => showLeaveDialog(context),
      RequestKind.meeting => showMeetingDialog(context),
    };
    final draft = await asked;
    if (draft != null) bloc.add(RequestRaised(draft));
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.state});

  final Request request;
  final RequestsState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<RequestsBloc>();
    final access = state.access;
    final mine = access?.isMine(request) ?? false;
    final canDecide =
        request.isPending &&
        !mine &&
        (access?.canDecide(request.kind) ?? false);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.kind == RequestKind.leave
                      ? request.reason
                      : request.subject,
                  style: context.text.titleSmall,
                ),
              ),
              Text(request.status.label(l), style: context.text.labelLarge),
            ],
          ),
          Text(
            '${request.kind.label(l)} · ${l.reqBy(request.requesterName)}',
            style: context.text.bodySmall,
          ),
          if (request.startsOn != null && request.endsOn != null)
            Text(
              '${formatShortDate(context, request.startsOn!)} – '
              '${formatShortDate(context, request.endsOn!)}',
              style: context.text.bodySmall,
            ),
          if (request.details.isNotEmpty)
            Text(request.details, style: context.text.bodySmall),
          if (request.meetingOn != null && request.meetingAt != null)
            Text(
              l.reqMeetingFixed(
                formatShortDate(context, request.meetingOn!),
                request.meetingAt!.clock(context),
              ),
              style: context.text.bodySmall,
            ),
          if (request.decisionNote.isNotEmpty)
            Text(
              l.reqNote(request.decisionNote),
              style: context.text.bodySmall,
            ),
          if (request.decidedByName.isNotEmpty && request.decidedOn != null)
            Text(
              l.reqDecidedBy(
                request.decidedByName,
                formatShortDate(context, request.decidedOn!),
              ),
              style: context.text.bodySmall,
            ),
          if (request.isPending)
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                if (canDecide) ...[
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: AppSizes.dialogButton,
                    ),
                    onPressed: state.busy
                        ? null
                        : () => _approve(context, bloc),
                    child: Text(l.reqApprove),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: AppSizes.dialogButton,
                    ),
                    onPressed: state.busy ? null : () => _reject(context, bloc),
                    child: Text(l.reqReject),
                  ),
                ],
                if (mine)
                  TextButton(
                    onPressed: state.busy
                        ? null
                        : () => bloc.add(RequestWithdrawn(request.id)),
                    child: Text(l.reqWithdraw),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _approve(BuildContext context, RequestsBloc bloc) async {
    if (request.kind == RequestKind.meeting) {
      final when = await showMeetingTimeDialog(context);
      if (when == null) return;
      bloc.add(
        RequestApproved(
          ApproveRequestParams(
            request.id,
            meetingOn: when.day,
            meetingAt: when.at,
          ),
        ),
      );
      return;
    }
    bloc.add(RequestApproved(ApproveRequestParams(request.id)));
  }

  Future<void> _reject(BuildContext context, RequestsBloc bloc) async {
    final reason = await showRejectDialog(context);
    if (reason != null) bloc.add(RequestRejected(request.id, reason));
  }
}
