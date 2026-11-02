/// Which copy of the app this is. Set at build time:
/// `--dart-define=APP_ENV=debug|uat|prod` (debug when not given).
enum AppEnv {
  debug,
  uat,
  prod;

  static const _name = String.fromEnvironment('APP_ENV', defaultValue: 'debug');

  static AppEnv get current =>
      values.firstWhere((e) => e.name == _name, orElse: () => AppEnv.debug);

  /// Only the live app hides which copy it is.
  bool get showsBanner => this != AppEnv.prod;
}
