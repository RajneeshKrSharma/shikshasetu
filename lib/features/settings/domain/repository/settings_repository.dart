import '../entities/school_settings.dart';

abstract interface class SettingsRepository {
  Future<SchoolSettings> get();

  Future<void> saveSchool({
    required String schoolName,
    required double latitude,
    required double longitude,
    required int radiusMeters,
  });

  Future<void> setLastBackup(DateTime at);

  /// Keeps a copy of the picture at [sourcePath] as the school logo; null
  /// removes the logo.
  Future<void> setLogo(String? sourcePath);

  /// Sets the message that runs along the top of everyone's Dashboard; null
  /// stops it.
  Future<void> setAnnouncement(String? text);
}
