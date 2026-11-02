import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'v2/di/v2_injector.dart';
import 'v2/v2_app.dart';

/// The browser build: only the server-backed app (the earlier app keeps its
/// data in a phone database, which a browser does not have).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await configureV2Dependencies();
  runApp(const ShikshaSetuV2App());
}
