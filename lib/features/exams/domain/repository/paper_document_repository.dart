import 'dart:typed_data';

import '../entities/paper_document.dart';

abstract interface class PaperDocumentRepository {
  /// The paper as a PDF: school logo and name at the top, details, general
  /// instructions, questions in sections, and optionally an answer key.
  Future<Uint8List> build(PaperDocumentRequest request);
}
