import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../printing/domain/entities/printer_device.dart';
import '../../../printing/domain/usecases/printer_usecases.dart';
import '../../domain/entities/paper_document.dart';
import '../../domain/usecases/build_paper_document.dart';

enum PrintMode { system, thermal }

/// What happened to the last print or share, so the screen can say so.
enum PrintNotice {
  sent,
  cancelled,
  pickPrinter,
  connectFailed,
  writeFailed,
  unsupported,
  failed,
}

class PaperPrintState extends Equatable {
  const PaperPrintState({
    this.mode = PrintMode.system,
    this.width = ThermalWidth.mm58,
    this.includeAnswerKey = false,
    this.copies = 1,
    this.building = true,
    this.pdf,
    this.access,
    this.devices = const [],
    this.selected,
    this.busy = false,
    this.notice,
    this.noticeId = 0,
  });

  final PrintMode mode;
  final ThermalWidth width;
  final bool includeAnswerKey;
  final int copies;
  final bool building;
  final Uint8List? pdf;

  /// Bluetooth state; only known once thermal mode has been opened.
  final ThermalAccess? access;
  final List<PrinterDevice> devices;
  final PrinterDevice? selected;

  /// A print or share is in progress.
  final bool busy;
  final PrintNotice? notice;

  /// Changes with every notice so the same one can be shown twice.
  final int noticeId;

  /// How the paper is laid out for the chosen mode.
  PaperLayout get layout => switch (mode) {
    PrintMode.system => PaperLayout.a4,
    PrintMode.thermal =>
      width == ThermalWidth.mm58
          ? PaperLayout.thermal58
          : PaperLayout.thermal80,
  };

  PaperPrintState copyWith({
    PrintMode? mode,
    ThermalWidth? width,
    bool? includeAnswerKey,
    int? copies,
    bool? building,
    Uint8List? pdf,
    ThermalAccess? access,
    List<PrinterDevice>? devices,
    PrinterDevice? selected,
    bool clearSelected = false,
    bool? busy,
    PrintNotice? notice,
    int? noticeId,
  }) => PaperPrintState(
    mode: mode ?? this.mode,
    width: width ?? this.width,
    includeAnswerKey: includeAnswerKey ?? this.includeAnswerKey,
    copies: copies ?? this.copies,
    building: building ?? this.building,
    pdf: pdf ?? this.pdf,
    access: access ?? this.access,
    devices: devices ?? this.devices,
    selected: clearSelected ? null : (selected ?? this.selected),
    busy: busy ?? this.busy,
    notice: notice ?? this.notice,
    noticeId: noticeId ?? this.noticeId,
  );

  @override
  List<Object?> get props => [
    mode,
    width,
    includeAnswerKey,
    copies,
    building,
    pdf,
    access,
    devices,
    selected,
    busy,
    notice,
    noticeId,
  ];
}

/// Preview and print one paper: builds the PDF for the chosen layout and
/// sends it to the phone's print dialog or to a Bluetooth thermal printer.
class PaperPrintCubit extends Cubit<PaperPrintState> {
  PaperPrintCubit({
    required this.requestFor,
    required this.paperTitle,
    required BuildPaperDocument buildPaperDocument,
    required CheckThermalAccess checkThermalAccess,
    required GetPairedPrinters getPairedPrinters,
    required PrintOnThermal printOnThermal,
    required PrintWithSystemDialog printWithSystemDialog,
    required SharePdf sharePdf,
  }) : _build = buildPaperDocument,
       _checkAccess = checkThermalAccess,
       _getPrinters = getPairedPrinters,
       _printThermal = printOnThermal,
       _printSystem = printWithSystemDialog,
       _share = sharePdf,
       super(const PaperPrintState());

  /// Describes the document for a layout; built by the screen, which knows
  /// the words, school name and logo.
  final PaperDocumentRequest Function(PaperLayout layout, bool answerKey)
  requestFor;
  final String paperTitle;

  final BuildPaperDocument _build;
  final CheckThermalAccess _checkAccess;
  final GetPairedPrinters _getPrinters;
  final PrintOnThermal _printThermal;
  final PrintWithSystemDialog _printSystem;
  final SharePdf _share;

  int _noticeCounter = 0;

  /// Builds the first preview.
  Future<void> start() => _rebuild();

  Future<void> _rebuild() async {
    emit(state.copyWith(building: true));
    try {
      final pdf = await _build(
        requestFor(state.layout, state.includeAnswerKey),
      );
      emit(state.copyWith(building: false, pdf: pdf));
    } catch (_) {
      emit(state.copyWith(building: false));
      _tell(PrintNotice.failed);
    }
  }

  void _tell(PrintNotice notice) => emit(
    state.copyWith(notice: notice, noticeId: ++_noticeCounter, busy: false),
  );

  Future<void> setMode(PrintMode mode) async {
    if (mode == state.mode) return;
    emit(state.copyWith(mode: mode));
    await _rebuild();
    if (mode == PrintMode.thermal) await loadPrinters();
  }

  Future<void> setWidth(ThermalWidth width) async {
    if (width == state.width) return;
    emit(state.copyWith(width: width));
    await _rebuild();
  }

  Future<void> setIncludeAnswerKey(bool value) async {
    if (value == state.includeAnswerKey) return;
    emit(state.copyWith(includeAnswerKey: value));
    await _rebuild();
  }

  void setCopies(int copies) =>
      emit(state.copyWith(copies: copies.clamp(1, 20)));

  void selectPrinter(PrinterDevice device) =>
      emit(state.copyWith(selected: device));

  /// Checks Bluetooth and lists the paired printers.
  Future<void> loadPrinters() async {
    final access = await _checkAccess(const NoParams());
    if (access != ThermalAccess.ready) {
      emit(state.copyWith(access: access, devices: const []));
      return;
    }
    final devices = await _getPrinters(const NoParams());
    final keep = state.selected;
    emit(
      state.copyWith(
        access: access,
        devices: devices,
        // Keep the earlier choice if it is still paired; a single printer is
        // chosen for you.
        selected: devices.contains(keep)
            ? keep
            : (devices.length == 1 ? devices.single : null),
        clearSelected: !devices.contains(keep) && devices.length != 1,
      ),
    );
  }

  Future<void> print() async {
    final pdf = state.pdf;
    if (pdf == null || state.busy) return;
    emit(state.copyWith(busy: true));
    try {
      if (state.mode == PrintMode.system) {
        final sent = await _printSystem(PdfFileParams(paperTitle, pdf));
        _tell(sent ? PrintNotice.sent : PrintNotice.cancelled);
        return;
      }
      final device = state.selected;
      if (device == null) {
        _tell(PrintNotice.pickPrinter);
        return;
      }
      await _printThermal(
        PrintOnThermalParams(
          device: device,
          pdf: pdf,
          width: state.width,
          copies: state.copies,
        ),
      );
      _tell(PrintNotice.sent);
    } on ThermalPrintException catch (e) {
      _tell(switch (e.reason) {
        ThermalFailure.connectFailed => PrintNotice.connectFailed,
        ThermalFailure.writeFailed => PrintNotice.writeFailed,
        ThermalFailure.unsupported => PrintNotice.unsupported,
      });
    } catch (_) {
      _tell(PrintNotice.failed);
    }
  }

  Future<void> share() async {
    final pdf = state.pdf;
    if (pdf == null || state.busy) return;
    emit(state.copyWith(busy: true));
    try {
      await _share(PdfFileParams('$paperTitle.pdf', pdf));
      emit(state.copyWith(busy: false));
    } catch (_) {
      _tell(PrintNotice.failed);
    }
  }
}
