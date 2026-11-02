import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/widgets/floating_nav_bar.dart';
import '../../../session/domain/navigation/navigation_policy.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../bloc/shell_nav_cubit.dart';
import '../widgets/section_look.dart';
import '../widgets/section_screens.dart';
import 'more_screen.dart';

/// The signed-in app: the person's main areas along the bottom, and the rest
/// under "More". Which areas they get comes from what they may do.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = context.select((SessionBloc b) => b.state.navigation);
    if (navigation == null) return const SizedBox.shrink();
    return BlocProvider(
      create: (_) => ShellNavCubit(),
      child: _Tabs(navigation: navigation),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.navigation});

  final AppNavigation navigation;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const screens = SectionScreens();
    final hasMore = navigation.more.isNotEmpty;
    final pages = <Widget Function()>[
      for (final section in navigation.tabs) () => screens.of(section),
      if (hasMore) () => MoreScreen(sections: navigation.more),
    ];
    return BlocBuilder<ShellNavCubit, ShellNavState>(
      builder: (context, nav) => Scaffold(
        body: IndexedStack(
          index: nav.index,
          children: [
            for (var i = 0; i < pages.length; i++)
              nav.visited.contains(i) ? pages[i]() : const SizedBox.shrink(),
          ],
        ),
        bottomNavigationBar: FloatingNavBar(
          selectedIndex: nav.index,
          onSelected: context.read<ShellNavCubit>().select,
          items: [
            for (final section in navigation.tabs)
              NavItem(
                icon: section.icon,
                selectedIcon: section.selectedIcon,
                label: section.label(l),
              ),
            if (hasMore)
              NavItem(
                icon: Icons.apps_outlined,
                selectedIcon: Icons.apps,
                label: l.navMore,
              ),
          ],
        ),
      ),
    );
  }
}
