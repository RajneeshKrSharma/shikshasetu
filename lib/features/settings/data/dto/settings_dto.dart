/// The `app_settings` key/value rows that describe the school.
class SettingsDto {
  const SettingsDto({
    required this.schoolName,
    this.latitude,
    this.longitude,
    this.radiusMeters,
    this.lastBackupAt,
    this.logoPath,
    this.announcement,
  });

  final String schoolName;
  final String? latitude;
  final String? longitude;
  final String? radiusMeters;
  final String? lastBackupAt;
  final String? logoPath;
  final String? announcement;

  factory SettingsDto.fromKeyValues(Map<String, String> kv) => SettingsDto(
    schoolName: kv['school_name'] ?? '',
    latitude: kv['school_lat'],
    longitude: kv['school_lon'],
    radiusMeters: kv['school_radius_m'],
    lastBackupAt: kv['last_backup_at'],
    logoPath: kv['school_logo'],
    announcement: kv['announcement'],
  );
}
