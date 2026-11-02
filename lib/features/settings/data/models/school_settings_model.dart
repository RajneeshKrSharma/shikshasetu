import '../../domain/entities/school_settings.dart';
import '../dto/settings_dto.dart';

class SchoolSettingsModel extends SchoolSettings {
  const SchoolSettingsModel({
    required super.schoolName,
    super.latitude,
    super.longitude,
    super.radiusMeters,
    super.lastBackupAt,
    super.logoPath,
    super.announcement,
  });

  factory SchoolSettingsModel.fromDto(SettingsDto d) {
    final backup = int.tryParse(d.lastBackupAt ?? '');
    return SchoolSettingsModel(
      schoolName: d.schoolName,
      latitude: double.tryParse(d.latitude ?? ''),
      longitude: double.tryParse(d.longitude ?? ''),
      radiusMeters: int.tryParse(d.radiusMeters ?? ''),
      lastBackupAt: backup == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(backup),
      logoPath: d.logoPath,
      announcement: (d.announcement?.trim().isEmpty ?? true)
          ? null
          : d.announcement!.trim(),
    );
  }
}
