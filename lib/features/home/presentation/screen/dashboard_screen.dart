import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/announcement_ticker.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../approvals/presentation/bloc/approvals_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../attendance/presentation/bloc/attendance_state.dart';
import '../../../attendance/presentation/widgets/check_in_reminder_strip.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../../master_questions/presentation/bloc/master_questions_bloc.dart';
import '../../../registration/presentation/bloc/registration_bloc.dart';
import '../../../teaching/presentation/bloc/teaching_bloc.dart';
import '../../../exams/presentation/bloc/exams_bloc.dart';
import '../../../fees/presentation/bloc/fees_bloc.dart';
import '../../../notices/presentation/bloc/notices_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../staff/presentation/bloc/staff_bloc.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../../cloud_sync/presentation/bloc/cloud_sync_cubit.dart';
import '../../../cloud_sync/presentation/bloc/school_refresh_cubit.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../cloud_sync/presentation/widgets/sync_status_strip.dart';
import '../widgets/dashboard_header.dart';
import '../../../cloud_sync/presentation/widgets/safety_pill.dart';
import '../widgets/principal_home_body.dart';
import '../widgets/teacher_home_sections.dart';
import '../widgets/teacher_today_card.dart';
import '../../../../di/injector.dart';
import '../../../school_day/presentation/bloc/teacher_day_cubit.dart';

/// Role-specific home. The Principal sees what needs attention first, then
/// the numbers; a teacher sees their own day.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final bool _isPrincipal;

  /// The refresh button is spinning (purely visual).
  late final ValueNotifier<bool> _refreshing;

  @override
  void initState() {
    super.initState();
    _isPrincipal = context.read<AuthBloc>().state.user?.isPrincipal ?? false;
    _refreshing = ValueNotifier(false);
    _refresh();
  }

  @override
  void dispose() {
    _refreshing.dispose();
    super.dispose();
  }

  /// Fetch what the other side sent, then recalculate. It never waits long:
  /// with no internet it just shows what it has.
  Future<void> _refreshFromCloud() async {
    if (_refreshing.value) return;
    _refreshing.value = true;
    final messenger = ScaffoldMessenger.of(context);
    final updated = context.l10n.dashRefreshed;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.dashSyncing)));
    final exchange = context.read<SchoolRefreshCubit>().refresh();
    // The Principal's phone also saves its changes to the cloud now, which is
    // what the "Last synced" line above shows.
    final upload = _isPrincipal
        ? context.read<CloudSyncCubit>().syncNow(quiet: true)
        : Future<void>.value();
    try {
      await Future.wait([
        exchange,
        upload,
      ]).timeout(const Duration(seconds: 20), onTimeout: () => const []);
    } finally {
      _refreshing.value = false;
    }
    if (!mounted) return;
    _reloadAll();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(updated)));
  }

  void _refresh() {
    context.read<DashboardBloc>().add(
      DashboardRequested(includeFees: _isPrincipal),
    );
    if (_isPrincipal) {
      context.read<ApprovalsBloc>().add(const ApprovalsRequested());
    }
  }

  /// After a manual sync: whatever the other side changed (a class teacher, a
  /// new student, fees, exams...) is shown again, not only the dashboard's own
  /// numbers. Kept apart from [_refresh], which those blocs' own changes call.
  void _reloadAll() {
    _refresh();
    context.read<StaffBloc>().add(const StaffLoaded());
    context.read<ClassesBloc>().add(const ClassesLoaded());
    context.read<AttendanceBloc>().add(const AttendanceRefreshed());
    context.read<RegistrationBloc>().add(const PeopleLoaded());
    context.read<ExamsBloc>().add(const ExamsLoaded());
    context.read<NoticesBloc>().add(const NoticesLoaded());
    context.read<SettingsBloc>().add(const SettingsLoaded());
    context.read<TeachingBloc>().add(const TeachingLoaded());
    context.read<MasterQuestionsBloc>().add(const MasterQuestionsLoaded());
    if (_isPrincipal) context.read<FeesBloc>().add(const FeesLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = context.select((AuthBloc b) => b.state.user);
    if (user == null) return const SizedBox.shrink();

    // Whatever the dashboard summarises changed, so summarise it again.
    return MultiBlocListener(
      listeners: [
        BlocListener<AttendanceBloc, AttendanceState>(
          listenWhen: (a, b) => a.overview != b.overview,
          listener: (_, _) => _refresh(),
        ),
        BlocListener<FeesBloc, FeesState>(
          listenWhen: (a, b) => a.accounts != b.accounts,
          listener: (_, _) => _refresh(),
        ),
        BlocListener<ExamsBloc, ExamsState>(
          listenWhen: (a, b) => a.papers != b.papers,
          listener: (_, _) => _refresh(),
        ),
        BlocListener<NoticesBloc, NoticesState>(
          listenWhen: (a, b) => a.notices != b.notices,
          listener: (_, _) => _refresh(),
        ),
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (a, b) => a.settings != b.settings,
          listener: (_, _) => _refresh(),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            final summary = state.summary;
            final announcement = context.select(
              (SettingsBloc b) => b.state.settings.announcement,
            );
            final schoolName = context.select(
              (SettingsBloc b) => b.state.settings.schoolName,
            );
            return RefreshIndicator(
              // Starts below the pinned header.
              edgeOffset: kToolbarHeight,
              onRefresh: _refreshFromCloud,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // A header that is tall with the greeting and shrinks to a
                  // plain bar as the page scrolls.
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _HeaderDelegate(
                      topInset: MediaQuery.paddingOf(context).top,
                      title: user.isPrincipal && schoolName.isNotEmpty
                          ? schoolName
                          : l.navDashboard,
                      hasMenu: false,
                      action: user.isPrincipal
                          ? const SafetyPill()
                          : ValueListenableBuilder<bool>(
                              valueListenable: _refreshing,
                              builder: (context, busy, _) => Tooltip(
                                message: l.actionSyncHint,
                                child: TextButton.icon(
                                  onPressed: busy ? null : _refreshFromCloud,
                                  icon: busy
                                      ? const SizedBox(
                                          width: AppIconSize.sm,
                                          height: AppIconSize.sm,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.sync,
                                          size: AppIconSize.md,
                                        ),
                                  label: Text(l.actionSync),
                                ),
                              ),
                            ),
                      greetingHeight: user.isPrincipal ? 30 : 68,
                      greeting: DashboardHeader(
                        user: user,
                        schoolName: schoolName,
                      ),
                    ),
                  ),
                  // The Principal's announcement stays pinned under the bar.
                  if (announcement != null)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _PinnedHeight(
                        height: AnnouncementTicker.height,
                        child: AnnouncementTicker(
                          text: announcement,
                          onStop: user.isPrincipal
                              ? () => context.read<SettingsBloc>().add(
                                  const AnnouncementChanged(null),
                                )
                              : null,
                        ),
                      ),
                    ),
                  // A teacher who has not checked in is reminded, in red.
                  if (!user.isPrincipal)
                    SliverToBoxAdapter(child: CheckInReminderStrip(user: user)),
                  // A Principal's sync status is the pill in the bar.
                  if (!user.isPrincipal) const SyncStatusSliver(),
                  if (summary == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    SliverPadding(
                      padding: AppSpacing.pageOf(context),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          user.isPrincipal
                              ? _principal(context, user, summary)
                              : _teacher(context, user, summary),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _principal(
    BuildContext context,
    AppUser user,
    DashboardSummary s,
  ) {
    return [PrincipalHomeBody(summary: s)];
  }

  List<Widget> _teacher(
    BuildContext context,
    AppUser user,
    DashboardSummary s,
  ) {
    const gap = SizedBox(height: AppSpacing.lg);
    final myClass = context.select((StaffBloc b) => b.state.classOf(user.id));
    return [
      TeacherTodayCard(user: user),
      if (myClass != null) ...[gap, TeacherClassAlert(classSection: myClass)],
      gap,
      BlocProvider(
        create: (_) => sl<TeacherDayCubit>(param1: user.id)..load(),
        child: TeacherDaySection(teacherId: user.id),
      ),
    ];
  }
}

/// Keeps a widget at one fixed height, pinned below the app bar.
class _PinnedHeight extends SliverPersistentHeaderDelegate {
  const _PinnedHeight({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(_PinnedHeight old) =>
      old.height != height || old.child != child;
}

/// The Dashboard's header: the bar (title, sync) with the greeting under it.
/// It stays pinned, at its full height, while the page below scrolls.
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HeaderDelegate({
    required this.topInset,
    required this.title,
    required this.hasMenu,
    required this.action,
    required this.greeting,
    required this.greetingHeight,
  });

  final double topInset;
  final String title;
  final bool hasMenu;
  final Widget action;
  final Widget greeting;

  /// The greeting's room under the bar.
  final double greetingHeight;

  // The header does not shrink: everything down to the sync status stays
  // where it is, and only what is below scrolls.
  @override
  double get minExtent => topInset + kToolbarHeight + greetingHeight;

  @override
  double get maxExtent => topInset + kToolbarHeight + greetingHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    const t = 0.0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: t)),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // The greeting, at the bottom, fading up and out.
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.md,
            child: Opacity(
              opacity: 1 - t,
              child: Transform.translate(
                offset: Offset(0, -16 * t),
                child: greeting,
              ),
            ),
          ),
          // The bar: always the same height, at the top.
          Positioned(
            left: 0,
            right: 0,
            top: topInset,
            height: kToolbarHeight,
            child: Row(
              children: [
                if (hasMenu)
                  IconButton(
                    icon: const Icon(Icons.menu, size: AppIconSize.lg),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )
                else
                  const SizedBox(width: AppSpacing.lg),
                Expanded(child: Text(title, style: context.text.titleLarge)),
                action,
                const SizedBox(width: AppSpacing.xs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_HeaderDelegate old) =>
      old.topInset != topInset ||
      old.title != title ||
      old.hasMenu != hasMenu ||
      old.action != action ||
      old.greeting != greeting ||
      old.greetingHeight != greetingHeight;
}
