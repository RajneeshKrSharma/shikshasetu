import 'package:equatable/equatable.dart';

/// A paired Bluetooth printer.
class PrinterDevice extends Equatable {
  const PrinterDevice({required this.name, required this.address});

  final String name;

  /// The Bluetooth address (MAC) used to connect.
  final String address;

  @override
  List<Object?> get props => [name, address];
}

/// Printable width of a thermal paper roll.
enum ThermalWidth {
  /// 58 mm roll: 48 mm printable, 384 dots.
  mm58(384),

  /// 80 mm roll: 72 mm printable, 576 dots.
  mm80(576);

  const ThermalWidth(this.dots);

  final int dots;
}

/// Whether the phone can talk to a Bluetooth printer right now.
enum ThermalAccess { ready, bluetoothOff, permissionDenied, unsupported }

enum ThermalFailure { connectFailed, writeFailed, unsupported }

class ThermalPrintException implements Exception {
  const ThermalPrintException(this.reason);

  final ThermalFailure reason;

  @override
  String toString() => 'ThermalPrintException($reason)';
}
