import 'dart:typed_data';

import 'package:printing/printing.dart';

import '../../domain/repository/document_printer_repository.dart';

/// Prints through the phone's own print service, so every printer the phone
/// can reach is available without extra setup.
class SystemDocumentPrinterRepository implements DocumentPrinterRepository {
  @override
  Future<bool> printPdf({required String name, required Uint8List pdf}) =>
      Printing.layoutPdf(name: name, onLayout: (_) async => pdf);

  @override
  Future<void> sharePdf({required String filename, required Uint8List pdf}) =>
      Printing.sharePdf(bytes: pdf, filename: filename);
}
