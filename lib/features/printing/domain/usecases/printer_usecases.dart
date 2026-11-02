import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/printer_device.dart';
import '../repository/document_printer_repository.dart';
import '../repository/thermal_printer_repository.dart';

class CheckThermalAccess implements UseCase<ThermalAccess, NoParams> {
  const CheckThermalAccess(this._repository);

  final ThermalPrinterRepository _repository;

  @override
  Future<ThermalAccess> call(NoParams params) => _repository.checkAccess();
}

class GetPairedPrinters implements UseCase<List<PrinterDevice>, NoParams> {
  const GetPairedPrinters(this._repository);

  final ThermalPrinterRepository _repository;

  @override
  Future<List<PrinterDevice>> call(NoParams params) =>
      _repository.pairedPrinters();
}

class PrintOnThermalParams extends Equatable {
  const PrintOnThermalParams({
    required this.device,
    required this.pdf,
    required this.width,
    this.copies = 1,
  });

  final PrinterDevice device;
  final Uint8List pdf;
  final ThermalWidth width;
  final int copies;

  @override
  List<Object?> get props => [device, pdf, width, copies];
}

class PrintOnThermal implements UseCase<void, PrintOnThermalParams> {
  const PrintOnThermal(this._repository);

  final ThermalPrinterRepository _repository;

  @override
  Future<void> call(PrintOnThermalParams p) => _repository.printPdf(
    device: p.device,
    pdf: p.pdf,
    width: p.width,
    copies: p.copies,
  );
}

class PdfFileParams extends Equatable {
  const PdfFileParams(this.name, this.pdf);

  /// A title (print jobs) or file name (sharing).
  final String name;
  final Uint8List pdf;

  @override
  List<Object?> get props => [name, pdf];
}

class PrintWithSystemDialog implements UseCase<bool, PdfFileParams> {
  const PrintWithSystemDialog(this._repository);

  final DocumentPrinterRepository _repository;

  @override
  Future<bool> call(PdfFileParams p) =>
      _repository.printPdf(name: p.name, pdf: p.pdf);
}

class SharePdf implements UseCase<void, PdfFileParams> {
  const SharePdf(this._repository);

  final DocumentPrinterRepository _repository;

  @override
  Future<void> call(PdfFileParams p) =>
      _repository.sharePdf(filename: p.name, pdf: p.pdf);
}
