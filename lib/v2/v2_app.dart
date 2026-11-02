import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import '../features/settings/presentation/bloc/locale_cubit.dart';
import '../l10n/generated/app_localizations.dart';
import 'core/server/app_env.dart';
import 'di/v2_injector.dart';
import 'features/session/presentation/bloc/session_bloc.dart';
import 'features/session/presentation/screen/login_screen.dart';
import 'features/shell/presentation/screen/home_shell.dart';

/// Root of the server-backed app. [configureV2Dependencies] must have run.
class ShikshaSetuV2App extends StatelessWidget {
  const ShikshaSetuV2App({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => LocaleCubit()),
      BlocProvider(
        create: (_) => sl<SessionBloc>()..add(const SessionStarted()),
      ),
    ],
    child: BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) => MaterialApp(
        onGenerateTitle: (c) => AppLocalizations.of(c).appName,
        debugShowCheckedModeBanner: false,
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
        builder: (context, child) => AppEnv.current.showsBanner
            ? Banner(
                message: AppEnv.current.name.toUpperCase(),
                location: BannerLocation.topEnd,
                child: child!,
              )
            : child!,
        home: const _SessionGate(),
      ),
    ),
  );
}

/// Chooses the screen from the sign-in state.
class _SessionGate extends StatelessWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context) {
    final status = context.select((SessionBloc b) => b.state.status);
    return switch (status) {
      SessionStatus.checking => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      SessionStatus.signedOut => const LoginScreen(),
      SessionStatus.signedIn => const HomeShell(),
    };
  }
}
