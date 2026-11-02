import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/data/local/app_database.dart';
import 'di/injector.dart';
import 'v2/di/v2_injector.dart';
import 'v2/v2_app.dart';

/// Build with `--dart-define=LEGACY_APP=true` to run the earlier app that keeps
/// everything on the phone. Without it, the app talks to the school's server.
const _legacyApp = bool.fromEnvironment('LEGACY_APP');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  if (_legacyApp) {
    await configureDependencies(
      database: await AppDatabase.open(),
      prefs: await SharedPreferences.getInstance(),
    );
    runApp(const ShikshaSetuApp());
    return;
  }
  await configureV2Dependencies();
  runApp(const ShikshaSetuV2App());
}
