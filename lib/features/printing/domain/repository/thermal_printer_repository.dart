import 'dart:typed_data';

import '../entities/printer_device.dart';

abstract interface class ThermalPrinterRepository {
  Future<ThermalAccess> checkAccess();

  /// Printers already paired in the phone's Bluetooth settings.
  Future<List<PrinterDevice>> pairedPrinters();

  /// Prints every page of [pdf] on the printer, [copies] times. The pages are
  /// drawn as pictures, so any language and the school logo print correctly.
  /// Throws [ThermalPrintException] when it cannot connect or send.
  Future<void> printPdf({
    required PrinterDevice device,
    required Uint8List pdf,
    required ThermalWidth width,
    int copies = 1,
  });
}
