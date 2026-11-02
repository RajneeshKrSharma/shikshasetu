import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../bloc/notices_bloc.dart';
import '../widgets/compose_notice_sheet.dart';
import '../widgets/notice_card.dart';

/// What the school has told everyone, newest first.
class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<NoticesBloc>(param1: account)..add(const NoticesStarted()),
      child: const _NoticesView(),
    );
  }
}

class _NoticesView extends StatelessWidget {
  const _NoticesView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<NoticesBloc, NoticesState>(
      failureOf: (s) => s.failure,
      child: BlocListener<NoticesBloc, NoticesState>(
        listenWhen: (a, b) => a.savedCount != b.savedCount,
        listener: (context, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageSaved))),
        child: BlocBuilder<NoticesBloc, NoticesState>(
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: Text(l.navNotices)),
            floatingActionButton: state.canPost
                ? FloatingActionButton.extended(
                    onPressed: state.busy
                        ? null
                        : () => showComposeNoticeSheet(context),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l.noticePost),
                  )
                : null,
            body: AsyncBody(
              status: state.status,
              failure: state.failure,
              onRetry: () =>
                  context.read<NoticesBloc>().add(const NoticesStarted()),
              isEmpty: state.notices.isEmpty,
              emptyText: l.emptyNotices,
              emptyIcon: Icons.campaign_outlined,
              builder: (context) => RefreshIndicator(
                onRefresh: () async =>
                    context.read<NoticesBloc>().add(const NoticesStarted()),
                child: ListView(
                  padding: AppSpacing.pageOf(context, fab: state.canPost),
                  children: [
                    for (final n in state.notices)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: NoticeCard(
                          notice: n,
                          canWithdraw: state.canPost,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
