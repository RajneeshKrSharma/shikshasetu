import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/proof_source.dart';
import '../../domain/repository/proof_store.dart';

/// Copies proofs into the app's own documents folder, so they are not lost
/// when the camera's or gallery's temporary copy is cleared.
class FileProofStore implements ProofStore {
  FileProofStore({Future<Directory> Function()? documentsDirectory})
    : _documents = documentsDirectory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _documents;

  Future<Directory> _folder(String folder) async {
    final dir = Directory(p.join((await _documents()).path, 'proofs', folder));
    await dir.create(recursive: true);
    return dir;
  }

  String _name(String extension) =>
      '${DateTime.now().microsecondsSinceEpoch}$extension';

  @override
  Future<String?> capturePhoto(
    ProofSource source, {
    required String folder,
  }) async {
    final photo = await ImagePicker().pickImage(
      source: switch (source) {
        ProofSource.camera => ImageSource.camera,
        ProofSource.gallery => ImageSource.gallery,
      },
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (photo == null) return null;
    final dir = await _folder(folder);
    final copy = p.join(dir.path, _name('.jpg'));
    await File(photo.path).copy(copy);
    return copy;
  }

  @override
  Future<String> saveSignature(Uint8List png, {required String folder}) async {
    final dir = await _folder(folder);
    final path = p.join(dir.path, _name('.png'));
    await File(path).writeAsBytes(png);
    return path;
  }
}
