import 'dart:io';
import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:printing/printing.dart';

import '../../domain/entities/printer_device.dart';
import '../../domain/repository/thermal_printer_repository.dart';

/// Prints on a Bluetooth ESC/POS thermal printer (58 mm or 80 mm).
///
/// Thermal printers have no fonts for Hindi or a logo, so each page of the
/// PDF is drawn to a picture at the printer's resolution and sent as an ESC/POS
/// raster image. What you see in the preview is what comes out.
class BluetoothThermalPrinterRepository implements ThermalPrinterRepository {
  /// Typical thermal printers are 203 dpi.
  static const _dpi = 203.0;

  /// Rows sent per command; very tall images overflow some printers' buffers.
  static const _sliceRows = 256;

  /// Bytes per Bluetooth write.
  static const _chunk = 2048;

  @override
  Future<ThermalAccess> checkAccess() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return ThermalAccess.unsupported;
    }
    if (!await PrintBluetoothThermal.isPermissionBluetoothGranted) {
      return ThermalAccess.permissionDenied;
    }
    if (!await PrintBluetoothThermal.bluetoothEnabled) {
      return ThermalAccess.bluetoothOff;
    }
    return ThermalAccess.ready;
  }

  @override
  Future<List<PrinterDevice>> pairedPrinters() async => [
    for (final d in await PrintBluetoothThermal.pairedBluetooths)
      PrinterDevice(name: d.name, address: d.macAdress),
  ];

  @override
  Future<void> printPdf({
    required PrinterDevice device,
    required Uint8List pdf,
    required ThermalWidth width,
    int copies = 1,
  }) async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      throw const ThermalPrintException(ThermalFailure.unsupported);
    }
    final pages = await _pages(pdf, width);
    final profile = await CapabilityProfile.load();
    final generator = Generator(
      width == ThermalWidth.mm58 ? PaperSize.mm58 : PaperSize.mm80,
      profile,
    );

    final bytes = <int>[...generator.reset()];
    for (var c = 0; c < copies; c++) {
      for (final page in pages) {
        for (var y = 0; y < page.height; y += _sliceRows) {
          final rows = y + _sliceRows > page.height
              ? page.height - y
              : _sliceRows;
          bytes.addAll(
            generator.imageRaster(
              img.copyCrop(page, x: 0, y: y, width: page.width, height: rows),
              align: PosAlign.left,
            ),
          );
        }
      }
      bytes
        ..addAll(generator.feed(3))
        ..addAll(generator.cut());
    }

    if (!await PrintBluetoothThermal.connectionStatus) {
      final ok = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.address,
      );
      if (!ok) throw const ThermalPrintException(ThermalFailure.connectFailed);
    }
    try {
      for (var i = 0; i < bytes.length; i += _chunk) {
        final end = i + _chunk > bytes.length ? bytes.length : i + _chunk;
        final ok = await PrintBluetoothThermal.writeBytes(
          bytes.sublist(i, end),
        );
        if (!ok) throw const ThermalPrintException(ThermalFailure.writeFailed);
      }
    } finally {
      await PrintBluetoothThermal.disconnect;
    }
  }

  /// Each PDF page as a black-on-white picture exactly as wide as the printer.
  Future<List<img.Image>> _pages(Uint8List pdf, ThermalWidth width) async {
    final pages = <img.Image>[];
    await for (final raster in Printing.raster(pdf, dpi: _dpi)) {
      final decoded = img.decodePng(await raster.toPng());
      if (decoded == null) continue;
      // Put the page on white: a transparent background would print black.
      final white = img.Image(width: decoded.width, height: decoded.height)
        ..clear(img.ColorRgb8(255, 255, 255));
      img.compositeImage(white, decoded);
      pages.add(
        white.width == width.dots
            ? white
            : img.copyResize(white, width: width.dots),
      );
    }
    return pages;
  }
}
