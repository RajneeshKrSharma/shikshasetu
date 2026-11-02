import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/context_ext.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../members/domain/entities/member_kind.dart';
import '../../../members/presentation/screen/member_workspace_screen.dart';
import '../../../attendance/presentation/screen/my_class_screen.dart';
import '../../../exams/presentation/screen/exams_screen.dart';
import '../../../profile/presentation/screen/profile_screen.dart';
import '../../../../core/widgets/floating_nav_bar.dart';
import '../bloc/home_nav_cubit.dart';
import '../shared_data_loader.dart';
import 'dashboard_screen.dart';

/// The signed-in app: two tabs (everything else is in the drawer), and the initial load of shared data.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  @override
  void initState() {
    super.initState();
    // Load everything the tabs and screens share, once, when entering.
    SharedDataLoader(context)();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isPrincipal =
        context.select((AuthBloc b) => b.state.user?.isPrincipal) ?? false;
    // The Principal has one tab for each group of people; a teacher has just
    // the Dashboard and Profile.
    final pages = [
      const DashboardScreen(),
      if (isPrincipal) ...const [
        MemberWorkspaceScreen(kind: MemberKind.student),
        MemberWorkspaceScreen(kind: MemberKind.teacher),
        MemberWorkspaceScreen(kind: MemberKind.other),
      ],
      if (!isPrincipal) ...const [MyClassScreen(), ExamsScreen()],
      const ProfileScreen(),
    ];
    final waiting = context.select((ApprovalsBloc b) => b.state.pendingCount);
    return BlocBuilder<HomeNavCubit, HomeNavState>(
      builder: (context, nav) => Scaffold(
        body: IndexedStack(index: nav.tabIndex, children: pages),
        bottomNavigationBar: FloatingNavBar(
          selectedIndex: nav.tabIndex,
          onSelected: context.read<HomeNavCubit>().selectTab,
          items: [
            NavItem(
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard,
              label: l.navDashboard,
              badge: isPrincipal ? waiting : 0,
            ),
            if (isPrincipal) ...[
              NavItem(
                icon: Icons.backpack_outlined,
                selectedIcon: Icons.backpack,
                label: l.navStudents,
              ),
              NavItem(
                icon: Icons.badge_outlined,
                selectedIcon: Icons.badge,
                label: l.navTeachers,
              ),
              NavItem(
                icon: Icons.directions_bus_outlined,
                selectedIcon: Icons.directions_bus,
                label: l.navOthers,
              ),
            ] else ...[
              NavItem(
                icon: Icons.groups_outlined,
                selectedIcon: Icons.groups,
                label: l.navMyClass,
              ),
              NavItem(
                icon: Icons.description_outlined,
                selectedIcon: Icons.description,
                label: l.navExams,
              ),
            ],
            NavItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: l.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
