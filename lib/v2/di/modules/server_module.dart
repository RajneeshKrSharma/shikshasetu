import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../core/network/http_inspector.dart';
import '../../core/server/api_config.dart';
import '../../core/server/server_client.dart';
import '../../core/server/token_store.dart';

/// What every feature needs to talk to the school's server.
void registerServer(GetIt sl) {
  sl
    ..registerLazySingleton<HttpInspector>(
      () => kDebugMode ? ConsoleInspector() : const NoInspector(),
    )
    ..registerLazySingleton<TokenStore>(() => const SecureTokenStore())
    ..registerLazySingleton<ServerClient>(
      () => ServerClient(const ApiConfig(), sl(), sl()),
    );
}
