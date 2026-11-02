import 'dart:typed_data';

import '../entities/proof_source.dart';

/// Keeps the photos and signatures that prove something was given, paid or
/// received. They stay on this phone, in a folder per kind of record.
abstract interface class ProofStore {
  /// A photo from [source], kept under [folder]. Null when the user
  /// cancelled.
  Future<String?> capturePhoto(ProofSource source, {required String folder});

  /// A signature drawn on the screen, as PNG bytes, kept under [folder].
  Future<String> saveSignature(Uint8List png, {required String folder});
}
