import 'dart:typed_data';

abstract interface class DocumentPrinterRepository {
  /// Opens the phone's own print dialog (printer choice, copies, page range)
  /// for [pdf]. Works with any printer the phone can reach: Wi-Fi, USB or
  /// Bluetooth ink-tank, inkjet and laser printers. True when it was sent.
  Future<bool> printPdf({required String name, required Uint8List pdf});

  /// Opens the share sheet with [pdf] as a file.
  Future<void> sharePdf({required String filename, required Uint8List pdf});
}
