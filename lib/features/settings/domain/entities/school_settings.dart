import 'package:equatable/equatable.dart';

class SchoolSettings extends Equatable {
  const SchoolSettings({
    required this.schoolName,
    this.latitude,
    this.longitude,
    this.radiusMeters,
    this.lastBackupAt,
    this.logoPath,
    this.announcement,
  });

  final String schoolName;
  final double? latitude;
  final double? longitude;

  /// How close a teacher must be to the school to check in. Set by the
  /// Principal; there is no default.
  final int? radiusMeters;
  final DateTime? lastBackupAt;

  /// Where the school's logo is kept on this phone; null if none was set.
  final String? logoPath;

  /// A message the Principal wants everyone to see running along the top of
  /// the Dashboard; null when there is none.
  final String? announcement;

  bool get hasLocation =>
      latitude != null && longitude != null && radiusMeters != null;

  @override
  List<Object?> get props => [
    schoolName,
    latitude,
    longitude,
    radiusMeters,
    lastBackupAt,
    logoPath,
    announcement,
  ];
}
