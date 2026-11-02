/// Paths of the pictures bundled with the app (listed in pubspec.yaml).
class AppImages {
  AppImages._();

  /// The illustrated school banner at the top of the login page. 941×1671;
  /// the picture fills roughly the top 43% and fades into white below.
  static const loginBackground = 'assets/images/login_background.jpg';
  static const loginBackgroundAspect = 941 / 1671;

  /// How much of the picture's height holds the artwork (the rest is plain
  /// white, which the page itself supplies).
  static const loginBackgroundArtHeight = 0.46;
}
