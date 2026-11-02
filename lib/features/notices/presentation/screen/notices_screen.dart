import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/usecases/post_notice.dart';
import '../bloc/notices_bloc.dart';
import '../widgets/compose_notice_sheet.dart';
import '../widgets/notice_card.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  Future<void> _compose(BuildContext context) async {
    final bloc = context.read<NoticesBloc>();
    final author = context.read<AuthBloc>().state.user!.name;
    final settings = context.read<SettingsBloc>();
    final result = await showModalBottomSheet<(String, String, bool)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const ComposeNoticeSheet(),
    );
    if (result == null) return;
    if (result.$3) {
      settings.add(
        AnnouncementChanged('${result.$1.trim()}: ${result.$2.trim()}'),
      );
    }
    bloc.add(
      NoticePosted(
        PostNoticeParams(title: result.$1, body: result.$2, postedBy: author),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isPrincipal = context.select(
      (AuthBloc b) => b.state.user?.isPrincipal ?? false,
    );

    return BlocListener<NoticesBloc, NoticesState>(
      listenWhen: (a, b) => a.postedCount != b.postedCount,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.messageNoticePosted))),
      child: Scaffold(
        appBar: AppBar(title: Text(l.noticesTitle)),
        floatingActionButton: isPrincipal
            ? FloatingActionButton.extended(
                heroTag: null,
                onPressed: () => _compose(context),
                icon: const Icon(Icons.campaign_outlined),
                label: Text(l.actionPostNotice),
              )
            : null,
        body: BlocBuilder<NoticesBloc, NoticesState>(
          builder: (context, state) {
            if (state.notices.isEmpty) {
              return EmptyState(
                icon: Icons.campaign_outlined,
                message: l.emptyNotices,
              );
            }
            return ListView.separated(
              padding: AppSpacing.pageOf(context, fab: true),
              itemCount: state.notices.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => NoticeCard(notice: state.notices[i]),
            );
          },
        ),
      ),
    );
  }
}
