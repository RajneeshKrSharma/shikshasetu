import 'dart:convert';

import 'package:crypto/crypto.dart';

/// The JSON document a backup is stored as.
class BackupDto {
  const BackupDto({
    required this.format,
    required this.schemaVersion,
    required this.createdAt,
    required this.tables,
    this.checksum,
    this.writtenBy,
  });

  static const formatName = 'shiksha_setu_backup';

  final String format;
  final int schemaVersion;
  final String createdAt;

  /// Table name → rows.
  final Map<String, List<Map<String, Object?>>> tables;

  /// The id of the Principal whose phone wrote this file (null in files made
  /// before this was recorded).
  final String? writtenBy;

  /// SHA-256 of [tables] as written; null in backups made before checksums.
  final String? checksum;

  /// Rows per table, so a damaged or cut-short file is noticed.
  Map<String, int> get counts => {
    for (final e in tables.entries) e.key: e.value.length,
  };

  /// The checksum of [tables] as they are now.
  String computeChecksum() =>
      sha256.convert(utf8.encode(jsonEncode(tables))).toString();

  factory BackupDto.fromJson(Map<String, dynamic> json) => BackupDto(
    format: json['format'] as String? ?? '',
    schemaVersion: json['schemaVersion'] as int? ?? 0,
    createdAt: json['createdAt'] as String? ?? '',
    checksum: json['checksum'] as String?,
    writtenBy: json['writtenBy'] as String?,
    tables: {
      for (final e in (json['tables'] as Map<String, dynamic>).entries)
        e.key: [
          for (final r in e.value as List) Map<String, Object?>.from(r as Map),
        ],
    },
  );

  Map<String, Object?> toJson() => {
    'format': format,
    'schemaVersion': schemaVersion,
    'createdAt': createdAt,
    'writtenBy': writtenBy,
    'counts': counts,
    'checksum': checksum ?? computeChecksum(),
    'tables': tables,
  };
}
