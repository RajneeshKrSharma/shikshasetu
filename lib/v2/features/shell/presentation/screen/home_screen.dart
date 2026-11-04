import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/feature_tile.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../di/v2_injector.dart';
import '../../../notices/presentation/bloc/notices_bloc.dart';
import '../../../session/domain/navigation/app_section.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../../session/presentation/widgets/role_label.dart';
import '../widgets/section_look.dart';
import '../widgets/section_screens.dart';

/// The first page: a greeting, the person's areas, and the latest notice.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionBloc>().state;
    final account = session.account;
    final navigation = session.navigation;
    if (account == null || navigation == null) return const SizedBox.shrink();
    final areas = [
      for (final s in [...navigation.tabs, ...navigation.more])
        if (s != AppSection.home && s != AppSection.profile) s,
    ];
    return BlocProvider(
      create: (_) =>
          sl<NoticesBloc>(param1: account)..add(const NoticesStarted()),
      child: Scaffold(
        appBar: AppBar(title: Text(l.navDashboard)),
        body: ListView(
          padding: AppSpacing.pageOf(context),
          children: [
            Text(
              l.homeGreeting(account.name),
              style: context.text.headlineSmall,
            ),
            Text(account.role.label(l), style: context.text.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            SectionTitle(l.homeAreas),
            AdaptiveFeatureGrid(
              tiles: [
                for (final s in areas)
                  FeatureTile(
                    icon: s.icon,
                    label: s.label(l),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SectionScreens().of(s),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionTitle(l.homeLatestNotice),
            BlocBuilder<NoticesBloc, NoticesState>(
              builder: (context, state) {
                if (state.notices.isEmpty) {
                  return Text(l.homeNoNotice);
                }
                final n = state.notices.first;
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: context.text.titleSmall),
                      if (n.body.isNotEmpty)
                        Text(
                          n.body,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodyMedium,
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
