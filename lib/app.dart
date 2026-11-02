import 'features/backup/presentation/bloc/data_mirror_cubit.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'di/injector.dart';
import 'features/approvals/presentation/bloc/approvals_bloc.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/attendance/presentation/bloc/attendance_event.dart';
import 'features/attendance/presentation/bloc/attendance_state.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screen/login_screen.dart';
import 'features/auth/presentation/screen/school_setup_screen.dart';
import 'features/classes/presentation/bloc/classes_bloc.dart';
import 'features/exams/presentation/bloc/exams_bloc.dart';
import 'features/fees/presentation/bloc/fees_bloc.dart';
import 'features/home/presentation/bloc/dashboard_bloc.dart';
import 'features/home/presentation/bloc/home_nav_cubit.dart';
import 'features/home/presentation/screen/home_shell.dart';
import 'features/cloud_sync/domain/repository/cloud_sync_repositories.dart';
import 'features/cloud_sync/presentation/bloc/cloud_sync_cubit.dart';
import 'features/cloud_sync/presentation/bloc/school_refresh_cubit.dart';
import 'features/cloud_sync/presentation/screen/sync_details_screen.dart';
import 'features/master_questions/presentation/bloc/master_questions_bloc.dart';
import 'features/notices/presentation/bloc/notices_bloc.dart';
import 'features/registration/presentation/bloc/registration_bloc.dart';
import 'features/settings/presentation/bloc/locale_cubit.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/staff/presentation/bloc/staff_bloc.dart';
import 'features/teaching/presentation/bloc/teaching_bloc.dart';
import 'l10n/generated/app_localizations.dart';

/// Root of the app. Dependencies come from the service locator, so
/// [configureDependencies] must have run first.
class ShikshaSetuApp extends StatelessWidget {
  const ShikshaSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Blocs shared across screens live above the Navigator so that every
    // pushed screen can reach them.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(const AuthStarted())),
        BlocProvider(create: (_) => sl<LocaleCubit>()),
        BlocProvider(
          create: (_) => sl<SettingsBloc>()..add(const SettingsLoaded()),
        ),
        BlocProvider(create: (_) => sl<ClassesBloc>()),
        BlocProvider(create: (_) => sl<StaffBloc>()),
        BlocProvider(create: (_) => sl<AttendanceBloc>()),
        BlocProvider(create: (_) => sl<ApprovalsBloc>()),
        BlocProvider(create: (_) => sl<RegistrationBloc>()),
        BlocProvider(create: (_) => sl<ExamsBloc>()),
        BlocProvider(create: (_) => sl<FeesBloc>()),
        BlocProvider(create: (_) => sl<NoticesBloc>()),
        BlocProvider(create: (_) => sl<MasterQuestionsBloc>()),
        BlocProvider(create: (_) => sl<CloudSyncCubit>(), lazy: false),
        BlocProvider(create: (_) => sl<DataMirrorCubit>(), lazy: false),
        BlocProvider(create: (_) => sl<SchoolRefreshCubit>(), lazy: false),
        BlocProvider(create: (_) => sl<TeachingBloc>()),
      ],
      // The Principal's app login is also the cloud account: sync while they
      // are signed in, and stop when they sign out.
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (a, b) => a.status != b.status || a.user != b.user,
        listener: (context, auth) {
          // Settings were read before the school's data came down.
          if (auth.status == AuthStatus.signedIn) {
            context.read<SettingsBloc>().add(const SettingsLoaded());
          }
          final cloud = context.read<CloudSyncCubit>();
          final principalIn =
              auth.status == AuthStatus.signedIn &&
              (auth.user?.isPrincipal ?? false);
          if (principalIn) {
            cloud.start();
            context.read<DataMirrorCubit>().start();
          } else {
            cloud.stop();
            context.read<DataMirrorCubit>().stop();
          }
          // Teachers and the Principal exchange work while the app is open.
          final refresh = context.read<SchoolRefreshCubit>();
          if (auth.status == AuthStatus.signedIn && auth.user != null) {
            refresh.start(principal: auth.user!.isPrincipal);
          } else {
            refresh.stop();
          }
        },
        child: MultiBlocListener(
          listeners: [
            // New data came down: show it.
            BlocListener<SchoolRefreshCubit, SchoolExchangeState>(
              listenWhen: (a, b) => a.round != b.round,
              listener: (context, _) {
                context.read<AttendanceBloc>().add(const AttendanceRefreshed());
                context.read<NoticesBloc>().add(const NoticesLoaded());
                context.read<SettingsBloc>().add(const SettingsLoaded());
                context.read<ExamsBloc>().add(const ExamsLoaded());
                context.read<ApprovalsBloc>().add(const ApprovalsRequested());
                context.read<TeachingBloc>().add(const TeachingLoaded());
                context.read<StaffBloc>().add(const StaffLoaded());
                context.read<ClassesBloc>().add(const ClassesLoaded());
                context.read<RegistrationBloc>().add(const PeopleLoaded());
                context.read<FeesBloc>().add(const FeesLoaded());
                context.read<MasterQuestionsBloc>().add(
                  const MasterQuestionsLoaded(),
                );
              },
            ),
            // A teacher sent a paper or checked in: send it right away rather
            // than waiting for the next round.
            BlocListener<ExamsBloc, ExamsState>(
              listenWhen: (a, b) => a.papers != b.papers,
              listener: (context, _) =>
                  context.read<SchoolRefreshCubit>().refresh(),
            ),
            BlocListener<AttendanceBloc, AttendanceState>(
              listenWhen: (a, b) => a.overview != b.overview,
              listener: (context, _) =>
                  context.read<SchoolRefreshCubit>().refresh(),
            ),
            // The Principal answered: let the teachers have it soon, and
            // show the new subjects.
            BlocListener<ApprovalsBloc, ApprovalsState>(
              listenWhen: (a, b) => a.decidedCount != b.decidedCount,
              listener: (context, _) {
                context.read<TeachingBloc>().add(const TeachingLoaded());
                context.read<CloudSyncCubit>().syncNow(quiet: true);
              },
            ),
            // A subject was asked for (teacher) or given (Principal): send it
            // on right away.
            BlocListener<TeachingBloc, TeachingState>(
              listenWhen: (a, b) => a.changeId != b.changeId,
              listener: (context, _) {
                context.read<SchoolRefreshCubit>().refresh();
                context.read<CloudSyncCubit>().syncNow(quiet: true);
              },
            ),
          ],
          child: _SyncLifecycle(
            child: BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) => MaterialApp(
                navigatorKey: sl<GlobalKey<NavigatorState>>(),
                onGenerateTitle: (c) => AppLocalizations.of(c).appName,
                debugShowCheckedModeBanner: false,
                // One look, whatever the phone's light or dark setting.
                theme: AppTheme.light,
                themeMode: ThemeMode.light,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const _AuthGate(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tells the cloud sync when the app leaves and returns to the screen, so it
/// can save what is pending on the way out and only run its timer while the
/// app is open.
class _SyncLifecycle extends StatefulWidget {
  const _SyncLifecycle({required this.child});

  final Widget child;

  @override
  State<_SyncLifecycle> createState() => _SyncLifecycleState();
}

class _SyncLifecycleState extends State<_SyncLifecycle> {
  late final AppLifecycleListener _listener;
  StreamSubscription<void>? _taps;

  /// The notification was tapped before the Principal was signed in (the app
  /// was closed); the details open as soon as they are.
  bool _openWhenSignedIn = false;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: () {
        context.read<CloudSyncCubit>().onForeground();
        context.read<SchoolRefreshCubit>().refresh();
        context.read<AuthBloc>().add(const AuthEmailSyncRequested());
      },
      onHide: () => context.read<CloudSyncCubit>().onBackground(),
    );
    final notifier = sl<SyncNotifier>();
    _taps = notifier.opened.listen((_) => _openDetails());
    unawaited(notifier.init());
  }

  bool get _principalIn {
    final auth = context.read<AuthBloc>().state;
    return auth.status == AuthStatus.signedIn &&
        (auth.user?.isPrincipal ?? false);
  }

  void _openDetails() {
    if (!_principalIn) {
      _openWhenSignedIn = true;
      return;
    }
    sl<GlobalKey<NavigatorState>>().currentState?.push(
      MaterialPageRoute<void>(builder: (_) => const SyncDetailsScreen()),
    );
  }

  @override
  void dispose() {
    _taps?.cancel();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthState>(
    listenWhen: (a, b) => a.status != b.status || a.user != b.user,
    listener: (context, _) {
      if (_openWhenSignedIn && _principalIn) {
        _openWhenSignedIn = false;
        _openDetails();
      }
    },
    child: widget.child,
  );
}

/// Chooses the screen from the sign-in state.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final status = context.select((AuthBloc b) => b.state.status);
    return switch (status) {
      AuthStatus.loading => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AuthStatus.namingSchool => const SchoolSetupScreen(),
      AuthStatus.signedOut => const LoginScreen(),
      // Created per sign-in, so every login starts on the Dashboard.
      AuthStatus.signedIn => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<HomeNavCubit>()),
          BlocProvider(create: (_) => sl<DashboardBloc>()),
        ],
        child: const HomeShell(),
      ),
    };
  }
}
