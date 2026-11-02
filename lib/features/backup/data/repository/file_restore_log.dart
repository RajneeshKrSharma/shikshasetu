import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/restore_record.dart';
import '../../domain/repository/restore_log_repository.dart';

/// Keeps the log in a small file in the app's documents folder.
class FileRestoreLog implements RestoreLogRepository {
  FileRestoreLog({Future<Directory> Function()? documentsDirectory})
    : _documents = documentsDirectory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _documents;

  /// Only the last restore is kept: it is the one whose earlier data is still
  /// in Downloads.
  static const _keep = 1;

  Future<File> _file() async =>
      File(p.join((await _documents()).path, 'restore_log.json'));

  @override
  Future<List<RestoreRecord>> recent() async {
    final file = await _file();
    if (!await file.exists()) return const [];
    try {
      final list = jsonDecode(await file.readAsString()) as List;
      return [for (final m in list) _fromMap(m as Map<String, dynamic>)];
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> add(RestoreRecord record) async {
    final all = [record, ...await recent()].take(_keep).toList();
    await (await _file()).writeAsString(
      jsonEncode([for (final r in all) _toMap(r)]),
    );
  }

  Map<String, Object?> _toMap(RestoreRecord r) => {
    'at': r.at.millisecondsSinceEpoch,
    'backupAt': r.backupAt?.millisecondsSinceEpoch,
    'added': r.added,
    'changed': r.changed,
    'removed': r.removed,
    'appWasNewer': r.appWasNewer,
    'earlierDataFile': r.earlierDataFile,
  };

  RestoreRecord _fromMap(Map<String, dynamic> m) => RestoreRecord(
    at: DateTime.fromMillisecondsSinceEpoch(m['at'] as int),
    backupAt: m['backupAt'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(m['backupAt'] as int),
    added: m['added'] as int,
    changed: m['changed'] as int,
    removed: m['removed'] as int,
    appWasNewer: m['appWasNewer'] as bool,
    earlierDataFile: m['earlierDataFile'] as String?,
  );
}
