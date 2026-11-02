import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/data/local/app_database.dart';
import 'modules/blocs.dart';
import 'modules/repositories.dart';
import 'modules/use_cases.dart';

/// The app's service locator. Everything is registered against its
/// abstraction (repository contract), so tests can swap in fakes.
final GetIt sl = GetIt.instance;

/// Registers every dependency. Safe to call again (used by tests).
Future<void> configureDependencies({
  required AppDatabase database,
  required SharedPreferences prefs,
}) async {
  await sl.reset();
  sl.allowReassignment = true;

  sl
    ..registerSingleton<AppDatabase>(database)
    ..registerSingleton<SharedPreferences>(prefs)
    // Lets code with no screen of its own open one (the Face ID camera).
    ..registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

  registerRepositories(sl);
  registerUseCases(sl);
  registerBlocs(sl);
}
