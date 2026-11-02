import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/exams/domain/entities/paper_document.dart';
import 'package:shiksha_setu/features/exams/domain/repository/paper_document_repository.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/build_paper_document.dart';
import 'package:shiksha_setu/features/exams/presentation/bloc/paper_print_cubit.dart';
import 'package:shiksha_setu/features/printing/domain/entities/printer_device.dart';
import 'package:shiksha_setu/features/printing/domain/repository/document_printer_repository.dart';
import 'package:shiksha_setu/features/printing/domain/repository/thermal_printer_repository.dart';
import 'package:shiksha_setu/features/printing/domain/usecases/printer_usecases.dart';

class _Docs implements PaperDocumentRepository {
  final built = <(PaperLayout, bool)>[];
  bool fails = false;

  @override
  Future<Uint8List> build(PaperDocumentRequest r) async {
    if (fails) throw StateError('no pdf');
    built.add((r.layout, r.includeAnswerKey));
    return Uint8List.fromList([r.layout.index, r.includeAnswerKey ? 1 : 0]);
  }
}

class _Thermal implements ThermalPrinterRepository {
  ThermalAccess access = ThermalAccess.ready;
  List<PrinterDevice> devices = const [];
  ThermalFailure? failWith;
  final printed = <(PrinterDevice, ThermalWidth, int)>[];

  @override
  Future<ThermalAccess> checkAccess() async => access;

  @override
  Future<List<PrinterDevice>> pairedPrinters() async => devices;

  @override
  Future<void> printPdf({
    required PrinterDevice device,
    required Uint8List pdf,
    required ThermalWidth width,
    int copies = 1,
  }) async {
    if (failWith != null) throw ThermalPrintException(failWith!);
    printed.add((device, width, copies));
  }
}

class _System implements DocumentPrinterRepository {
  bool sent = true;
  int printCalls = 0;
  final shared = <String>[];

  @override
  Future<bool> printPdf({required String name, required Uint8List pdf}) async {
    printCalls++;
    return sent;
  }

  @override
  Future<void> sharePdf({
    required String filename,
    required Uint8List pdf,
  }) async => shared.add(filename);
}

void main() {
  late _Docs docs;
  late _Thermal thermal;
  late _System system;

  const rp = PrinterDevice(name: 'RP-80', address: 'AA:BB');
  const other = PrinterDevice(name: 'POS-58', address: 'CC:DD');

  PaperPrintCubit build() => PaperPrintCubit(
    paperTitle: 'Unit Test',
    requestFor: (layout, key) => PaperDocumentRequest(
      paper: ExamPaper(
        id: 'p',
        title: 'Unit Test',
        subject: 'Maths',
        classSection: '6-A',
        date: DateTime(2026),
        durationMinutes: 60,
        status: PaperStatus.approved,
        questions: const [],
      ),
      schoolName: 'S',
      labels: PaperLabels(
        classLabel: '',
        subjectLabel: '',
        dateLabel: '',
        timeLabel: '',
        maxMarksLabel: '',
        instructionsLabel: '',
        studentNameLabel: '',
        rollNoLabel: '',
        answerKeyLabel: '',
        columnA: '',
        columnB: '',
        trueLabel: '',
        falseLabel: '',
        endOfPaper: '',
        sectionTitles: const {},
        marksText: (m) => '$m',
        sectionText: (l) => l,
      ),
      dateText: '',
      durationText: '',
      includeAnswerKey: key,
      layout: layout,
    ),
    buildPaperDocument: BuildPaperDocument(docs),
    checkThermalAccess: CheckThermalAccess(thermal),
    getPairedPrinters: GetPairedPrinters(thermal),
    printOnThermal: PrintOnThermal(thermal),
    printWithSystemDialog: PrintWithSystemDialog(system),
    sharePdf: SharePdf(system),
  );

  setUp(() {
    docs = _Docs();
    thermal = _Thermal();
    system = _System();
  });

  test('start builds an A4 preview', () async {
    final c = build();
    await c.start();

    expect(docs.built, [(PaperLayout.a4, false)]);
    expect(c.state.building, isFalse);
    expect(c.state.pdf, isNotNull);
    expect(c.state.layout, PaperLayout.a4);
  });

  test('a failed build says so and stops loading', () async {
    docs.fails = true;
    final c = build();
    await c.start();

    expect(c.state.building, isFalse);
    expect(c.state.pdf, isNull);
    expect(c.state.notice, PrintNotice.failed);
  });

  test('thermal mode rebuilds for the roll width and lists printers', () async {
    thermal.devices = [rp, other];
    final c = build();
    await c.start();

    await c.setMode(PrintMode.thermal);
    await c.setWidth(ThermalWidth.mm80);

    expect(docs.built.map((b) => b.$1), [
      PaperLayout.a4,
      PaperLayout.thermal58,
      PaperLayout.thermal80,
    ]);
    expect(c.state.devices, [rp, other]);
    // Two printers: the user has to choose.
    expect(c.state.selected, isNull);
  });

  test('a single paired printer is chosen for you', () async {
    thermal.devices = [rp];
    final c = build();
    await c.setMode(PrintMode.thermal);

    expect(c.state.selected, rp);
  });

  test(
    'refreshing keeps the earlier choice while it is still paired',
    () async {
      thermal.devices = [rp, other];
      final c = build();
      await c.setMode(PrintMode.thermal);
      c.selectPrinter(other);

      await c.loadPrinters();
      expect(c.state.selected, other);

      thermal.devices = [rp];
      await c.loadPrinters();
      expect(c.state.selected, rp);
    },
  );

  test(
    'Bluetooth off or no permission is reported and no printers listed',
    () async {
      thermal.devices = [rp];
      thermal.access = ThermalAccess.bluetoothOff;
      final c = build();
      await c.setMode(PrintMode.thermal);

      expect(c.state.access, ThermalAccess.bluetoothOff);
      expect(c.state.devices, isEmpty);

      thermal.access = ThermalAccess.permissionDenied;
      await c.loadPrinters();
      expect(c.state.access, ThermalAccess.permissionDenied);
    },
  );

  test('the answer key switch rebuilds the paper with the key', () async {
    final c = build();
    await c.start();

    await c.setIncludeAnswerKey(true);

    expect(docs.built.last, (PaperLayout.a4, true));
  });

  test('copies stay between 1 and 20', () {
    final c = build()..setCopies(0);
    expect(c.state.copies, 1);
    c.setCopies(99);
    expect(c.state.copies, 20);
  });

  group('print', () {
    test('A4 goes through the system print dialog', () async {
      final c = build();
      await c.start();

      await c.print();

      expect(system.printCalls, 1);
      expect(c.state.notice, PrintNotice.sent);
      expect(c.state.busy, isFalse);
    });

    test('closing the system dialog without printing is "cancelled"', () async {
      system.sent = false;
      final c = build();
      await c.start();

      await c.print();

      expect(c.state.notice, PrintNotice.cancelled);
    });

    test('thermal needs a printer to be chosen', () async {
      thermal.devices = [rp, other];
      final c = build();
      await c.setMode(PrintMode.thermal);

      await c.print();

      expect(c.state.notice, PrintNotice.pickPrinter);
      expect(thermal.printed, isEmpty);
    });

    test(
      'thermal prints on the chosen printer with width and copies',
      () async {
        thermal.devices = [rp, other];
        final c = build();
        await c.setMode(PrintMode.thermal);
        await c.setWidth(ThermalWidth.mm80);
        c
          ..selectPrinter(other)
          ..setCopies(3);

        await c.print();

        expect(thermal.printed, [(other, ThermalWidth.mm80, 3)]);
        expect(c.state.notice, PrintNotice.sent);
      },
    );

    test('a printer that cannot be reached is reported', () async {
      thermal.devices = [rp];
      thermal.failWith = ThermalFailure.connectFailed;
      final c = build();
      await c.setMode(PrintMode.thermal);

      await c.print();

      expect(c.state.notice, PrintNotice.connectFailed);
      expect(c.state.busy, isFalse);
    });

    test('a printer that stops mid-way is reported', () async {
      thermal.devices = [rp];
      thermal.failWith = ThermalFailure.writeFailed;
      final c = build();
      await c.setMode(PrintMode.thermal);

      await c.print();

      expect(c.state.notice, PrintNotice.writeFailed);
    });

    test('every notice can be shown again (a new id each time)', () async {
      final c = build();
      await c.start();

      await c.print();
      final first = c.state.noticeId;
      await c.print();

      expect(c.state.noticeId, greaterThan(first));
    });

    test('nothing is printed before the paper is built', () async {
      docs.fails = true;
      final c = build();
      await c.start();
      final before = c.state.noticeId;

      await c.print();

      expect(system.printCalls, 0);
      expect(c.state.noticeId, before);
    });
  });

  test('share sends the PDF with the paper name', () async {
    final c = build();
    await c.start();

    await c.share();

    expect(system.shared, ['Unit Test.pdf']);
    expect(c.state.busy, isFalse);
  });

  blocTest<PaperPrintCubit, PaperPrintState>(
    'switching mode back to A4 does not look for printers',
    build: build,
    act: (c) async {
      await c.setMode(PrintMode.system);
    },
    expect: () => <PaperPrintState>[],
  );
}
