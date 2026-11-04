import 'dart:typed_data';

import '../entities/timetable_sheet.dart';

/// Turns a [TimetableSheet] into a printable document (a PDF).
abstract interface class TimetableDocumentBuilder {
  Future<Uint8List> build(TimetableSheet sheet, TimetablePrintLabels labels);
}
