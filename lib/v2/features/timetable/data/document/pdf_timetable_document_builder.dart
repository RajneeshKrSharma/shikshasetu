import 'dart:typed_data';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/timetable_sheet.dart';
import '../../domain/repository/timetable_document_builder.dart';

/// Draws the timetable on an A4 page: the logo and school name on top, the
/// exam and class under them, then Date, Day and Subject for each day.
///
/// Noto Sans with Noto Sans Devanagari as the fallback prints English and
/// Hindi alike; the fonts are bundled, so nothing needs the internet.
class PdfTimetableDocumentBuilder implements TimetableDocumentBuilder {
  PdfTimetableDocumentBuilder(
    this._letterhead, {
    Future<ByteData> Function(String)? loadAsset,
  }) : _loadAsset = loadAsset ?? rootBundle.load;

  final PrintLetterhead _letterhead;

  final Future<ByteData> Function(String) _loadAsset;

  static const _margin = 28.0;

  /// One copy fills one half of the page; if it were ever taller it shrinks
  /// to fit instead of running over the cut line.
  pw.Widget _half(pw.Widget copy) => pw.Expanded(
    child: pw.FittedBox(
      fit: pw.BoxFit.scaleDown,
      alignment: pw.Alignment.center,
      child: pw.SizedBox(
        width: PdfPageFormat.a4.width - 2 * _margin,
        child: copy,
      ),
    ),
  );

  @override
  Future<Uint8List> build(
    TimetableSheet sheet,
    TimetablePrintLabels labels,
  ) async {
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await _loadAsset('assets/fonts/NotoSans-Regular.ttf')),
      bold: pw.Font.ttf(await _loadAsset('assets/fonts/NotoSans-Bold.ttf')),
      fontFallback: [
        pw.Font.ttf(
          await _loadAsset('assets/fonts/NotoSansDevanagari-Regular.ttf'),
        ),
        pw.Font.ttf(
          await _loadAsset('assets/fonts/NotoSansDevanagari-Bold.ttf'),
        ),
      ],
    );
    final logo = pw.MemoryImage(
      (await _loadAsset(_letterhead.logoAsset)).buffer.asUint8List(),
    );
    final doc = pw.Document(
      title: '${sheet.examLabel} · ${labels.classWord} ${sheet.className}',
      author: sheet.schoolName,
      theme: theme,
    );
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(_margin),
        build: (_) => pw.Column(
          children: [
            _half(_copy(sheet, labels, logo)),
            pw.Divider(
              height: 12,
              thickness: 0.8,
              color: PdfColors.grey600,
              borderStyle: pw.BorderStyle.dashed,
            ),
            _half(_copy(sheet, labels, logo)),
          ],
        ),
      ),
    );
    return doc.save();
  }

  pw.Widget _copy(
    TimetableSheet sheet,
    TimetablePrintLabels labels,
    pw.ImageProvider logo,
  ) {
    final locale = labels.localeCode;
    final dateFormat = DateFormat('dd MMM yyyy', locale);
    final dayFormat = DateFormat('EEEE', locale);
    const ink = PdfColors.grey900;
    final line = pw.BorderSide(color: PdfColors.grey700, width: 0.8);

    pw.Widget cell(String text, {bool head = false, pw.TextAlign? align}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: pw.Text(
            text,
            textAlign: align,
            style: pw.TextStyle(
              fontSize: head ? 10 : 12,
              fontWeight: head ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: head ? PdfColors.grey700 : ink,
            ),
          ),
        );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(width: 60, height: 60, child: pw.Image(logo)),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    sheet.schoolName.toUpperCase(),
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF2E3192),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    _letterhead.address,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 11, color: ink),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Container(height: 1.2, color: PdfColors.grey800),
        pw.SizedBox(height: 8),
        pw.Center(
          child: pw.Text(
            labels.title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${sheet.examLabel} ${sheet.academicYear}',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '${labels.classWord} ${sheet.className}',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder(
            top: line,
            bottom: line,
            horizontalInside: pw.BorderSide(
              color: PdfColors.grey400,
              width: 0.5,
            ),
          ),
          columnWidths: const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(3.4),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                cell(labels.dateColumn, head: true),
                cell(labels.dayColumn, head: true),
                cell(labels.subjectColumn, head: true),
              ],
            ),
            for (final d in sheet.days)
              pw.TableRow(
                children: [
                  cell(dateFormat.format(d.day)),
                  cell(dayFormat.format(d.day)),
                  cell(d.subjects.join(', ')),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
