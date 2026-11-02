import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import 'package:file_picker/file_picker.dart';

import '../../domain/repository/backup_storage_repository.dart';

class FilePickerBackupStorage implements BackupStorageRepository {
  @override
  Future<bool> saveToDevice(String path, String name) async {
    final bytes = await File(path).readAsBytes();
    final saved = await FilePicker.saveFile(
      fileName: name,
      bytes: Uint8List.fromList(bytes),
    );
    return saved != null;
  }

  @override
  Future<String?> pickBackupText() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'zip'],
    );
    final path = picked?.files.single.path;
    if (path == null) return null;
    if (!path.toLowerCase().endsWith('.zip')) return File(path).readAsString();
    // A ZIP made by "Share backup as ZIP": the backup is the JSON inside.
    final archive = ZipDecoder().decodeBytes(await File(path).readAsBytes());
    for (final f in archive) {
      if (f.isFile && f.name.toLowerCase().endsWith('.json')) {
        return utf8.decode(f.content);
      }
    }
    return null;
  }
}
