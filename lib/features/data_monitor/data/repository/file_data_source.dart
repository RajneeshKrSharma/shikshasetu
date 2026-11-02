import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../backup/data/repository/backup_repository_impl.dart';
import '../../domain/entities/data_source_kind.dart';
import '../../domain/entities/source_summary.dart';
import '../../domain/repository/data_source.dart';
import 'backup_rows.dart';

/// The data file kept beside the database.
class FileDataSource implements DataSource {
  FileDataSource(this._documentsDirectory, {required this.tables});

  final Future<Directory> Function() _documentsDirectory;
  final List<String> tables;

  DateTime? _loadedFrom;
  Map<String, Map<String, Map<String, Object?>>> _rows = const {};
  DateTime? _madeAt;

  @override
  DataSourceKind get kind => DataSourceKind.file;

  Future<File> _file() async => File(
    p.join(
      (await _documentsDirectory()).path,
      BackupRepositoryImpl.mirrorFolder,
      BackupRepositoryImpl.mirrorFile,
    ),
  );

  /// Reads the file again when it changed. Returns false if there is none.
  Future<bool> _load() async {
    final file = await _file();
    if (!await file.exists()) return false;
    final modified = await file.lastModified();
    if (_loadedFrom == modified) return true;
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final read = BackupRows.fromJson(json, tables);
    _madeAt = read.createdAt;
    _rows = read.tables;
    _loadedFrom = modified;
    return true;
  }

  @override
  Future<SourceSummary> summary() async {
    try {
      if (!await _load()) {
        return SourceSummary.unavailable(kind, SourceProblem.missing);
      }
      return SourceSummary(
        kind: kind,
        counts: {for (final e in _rows.entries) e.key: e.value.length},
        asOf: _madeAt,
      );
    } catch (_) {
      return SourceSummary.unavailable(kind, SourceProblem.other);
    }
  }

  @override
  Future<Map<String, Map<String, Object?>>> rows(String table) async {
    if (!await _load()) return const {};
    return _rows[table] ?? const {};
  }

  @override
  Future<String?> nameOf(String table, String key) async {
    if (!await _load()) return null;
    final row = _rows[table]?[key];
    if (row == null) return null;
    for (final c in const ['name', 'title', 'text', 'key', 'day']) {
      final v = row[c];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }
}
