import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/exam_paper.dart';
import '../../domain/entities/paper_document.dart';
import '../../domain/repository/paper_document_repository.dart';

/// Builds the question paper PDF.
///
/// Text is set in Noto Sans with Noto Sans Devanagari as the fallback, so
/// English and Hindi papers both print correctly. The fonts are bundled, so
/// no internet is needed.
class PdfPaperDocumentRepository implements PaperDocumentRepository {
  PdfPaperDocumentRepository({Future<ByteData> Function(String)? loadAsset})
    : _loadAsset = loadAsset ?? rootBundle.load;

  final Future<ByteData> Function(String) _loadAsset;

  /// Sections are printed in this order, whatever order the questions were
  /// written in.
  static const _sectionOrder = [
    QuestionType.mcq,
    QuestionType.trueFalse,
    QuestionType.fillBlank,
    QuestionType.matchFollowing,
    QuestionType.shortAnswer,
    QuestionType.longAnswer,
  ];

  @override
  Future<Uint8List> build(PaperDocumentRequest r) async {
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
    final logo = await _logo(r.logoPath);
    final style = _Style(r.layout);
    final doc = pw.Document(
      title: r.paper.title,
      author: r.schoolName,
      theme: theme,
    );

    final body = _body(r, style, logo);
    if (r.layout.isThermal) {
      // A roll has no page breaks: one tall page that fits the content.
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            style.pageWidth,
            double.infinity,
            marginAll: style.margin,
          ),
          build: (_) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: body,
          ),
        ),
      );
    } else {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(style.margin),
          footer: (c) => pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              '${c.pageNumber} / ${c.pagesCount}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          ),
          build: (_) => body,
        ),
      );
    }
    return doc.save();
  }

  Future<pw.MemoryImage?> _logo(String? path) async {
    if (path == null) return null;
    try {
      final file = File(path);
      if (!await file.exists()) return null;
      return pw.MemoryImage(await file.readAsBytes());
    } catch (_) {
      // An unreadable picture should not stop the paper from printing.
      return null;
    }
  }

  List<pw.Widget> _body(
    PaperDocumentRequest r,
    _Style s,
    pw.MemoryImage? logo,
  ) {
    final paper = r.paper;
    final l = r.labels;
    final widgets = <pw.Widget>[
      _header(r, s, logo),
      pw.SizedBox(height: s.gap),
      _details(r, s),
    ];
    if (paper.instructions.trim().isNotEmpty) {
      widgets
        ..add(pw.SizedBox(height: s.gap))
        ..add(
          pw.Text(
            l.instructionsLabel,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: s.small,
            ),
          ),
        )
        ..add(
          pw.Text(
            paper.instructions.trim(),
            style: pw.TextStyle(fontSize: s.small),
          ),
        );
    }
    widgets
      ..add(pw.SizedBox(height: s.gap))
      ..add(pw.Divider(thickness: 1.2));

    var number = 0;
    var letter = 0;
    for (final type in _sectionOrder) {
      final inSection = [
        for (final q in paper.questions)
          if (q.type == type) q,
      ];
      if (inSection.isEmpty) continue;
      final total = inSection.fold(0, (a, q) => a + q.marks);
      widgets.add(
        pw.Padding(
          padding: pw.EdgeInsets.only(top: s.gap, bottom: s.gap / 2),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  '${l.sectionText(String.fromCharCode(0x41 + letter))}: '
                  '${l.sectionTitles[type]}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: s.body,
                  ),
                ),
              ),
              if (total > 0)
                pw.Text(
                  l.marksText(total),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: s.small,
                  ),
                ),
            ],
          ),
        ),
      );
      letter++;
      for (final q in inSection) {
        number++;
        widgets.add(_question(number, q, r, s));
      }
    }

    if (r.includeAnswerKey) widgets.addAll(_answerKey(r, s));

    widgets
      ..add(pw.SizedBox(height: s.gap))
      ..add(
        pw.Center(
          child: pw.Text(
            r.labels.endOfPaper,
            style: pw.TextStyle(fontSize: s.small, color: PdfColors.grey700),
          ),
        ),
      );
    return widgets;
  }

  pw.Widget _header(PaperDocumentRequest r, _Style s, pw.MemoryImage? logo) {
    final title = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          r.schoolName,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: s.title,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          r.paper.title,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: s.subtitle,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
    if (s.compact) {
      // On a narrow roll the logo sits above the name.
      return pw.Column(
        children: [
          if (logo != null) pw.SizedBox(height: s.logo, child: pw.Image(logo)),
          if (logo != null) pw.SizedBox(height: 4),
          title,
        ],
      );
    }
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(
          width: s.logo,
          height: s.logo,
          child: logo == null ? null : pw.Image(logo, fit: pw.BoxFit.contain),
        ),
        pw.Expanded(child: title),
        // Balances the logo so the name stays centred.
        pw.SizedBox(width: s.logo),
      ],
    );
  }

  pw.Widget _details(PaperDocumentRequest r, _Style s) {
    final l = r.labels;
    pw.Widget cell(String label, String value) => pw.RichText(
      text: pw.TextSpan(
        style: pw.TextStyle(fontSize: s.small),
        children: [
          pw.TextSpan(
            text: '$label: ',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: s.small,
            ),
          ),
          pw.TextSpan(text: value),
        ],
      ),
    );
    final cells = [
      cell(l.classLabel, r.paper.classSection),
      cell(l.subjectLabel, r.paper.subject),
      cell(l.dateLabel, r.dateText),
      cell(l.timeLabel, r.durationText),
      if (r.paper.totalMarks > 0)
        cell(l.maxMarksLabel, '${r.paper.totalMarks}'),
    ];
    final student = pw.Row(
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            '${l.studentNameLabel}: ______________________',
            style: pw.TextStyle(fontSize: s.small),
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            '${l.rollNoLabel}: ________',
            style: pw.TextStyle(fontSize: s.small),
          ),
        ),
      ],
    );
    if (s.compact) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (final c in cells)
            pw.Padding(padding: const pw.EdgeInsets.only(bottom: 1), child: c),
          pw.SizedBox(height: 3),
          pw.Text(
            '${l.studentNameLabel}: ____________',
            style: pw.TextStyle(fontSize: s.small),
          ),
          pw.Text(
            '${l.rollNoLabel}: ______',
            style: pw.TextStyle(fontSize: s.small),
          ),
        ],
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(thickness: 1.2),
        pw.Wrap(spacing: 16, runSpacing: 3, children: cells),
        pw.SizedBox(height: 6),
        student,
      ],
    );
  }

  pw.Widget _question(int n, Question q, PaperDocumentRequest r, _Style s) {
    final l = r.labels;
    final indent = s.compact ? 14.0 : 22.0;
    final head = pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: indent,
          child: pw.Text('$n.', style: pw.TextStyle(fontSize: s.body)),
        ),
        pw.Expanded(
          child: pw.Text(q.text, style: pw.TextStyle(fontSize: s.body)),
        ),
        pw.SizedBox(width: 6),
        // A paper without marks (e.g. one scanned from a photo) prints none.
        if (q.marks > 0)
          pw.Text(
            '[${q.marks}]',
            style: pw.TextStyle(
              fontSize: s.small,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
      ],
    );

    final extra = <pw.Widget>[];
    switch (q.type) {
      case QuestionType.mcq:
        extra.add(_options(q, s, indent));
      case QuestionType.trueFalse:
        extra.add(
          pw.Padding(
            padding: pw.EdgeInsets.only(left: indent, top: 2),
            child: pw.Text(
              '( ${l.trueLabel} / ${l.falseLabel} )',
              style: pw.TextStyle(fontSize: s.small, color: PdfColors.grey700),
            ),
          ),
        );
      case QuestionType.matchFollowing:
        extra.add(_matchTable(q, l, s, indent));
      case QuestionType.fillBlank:
      case QuestionType.shortAnswer:
      case QuestionType.longAnswer:
        break;
    }
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: s.gap),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [head, ...extra],
      ),
    );
  }

  pw.Widget _options(Question q, _Style s, double indent) {
    final longest = q.options.fold(0, (m, o) => o.length > m ? o.length : m);
    // Short options go two to a line, long ones one per line.
    final twoColumns = !s.compact && longest <= 26;
    final items = [
      for (var i = 0; i < q.options.length; i++)
        '(${String.fromCharCode(0x61 + i)}) ${q.options[i]}',
    ];
    if (!twoColumns) {
      return pw.Padding(
        padding: pw.EdgeInsets.only(left: indent, top: 3),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            for (final o in items)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 2),
                child: pw.Text(o, style: pw.TextStyle(fontSize: s.body)),
              ),
          ],
        ),
      );
    }
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: indent, top: 3),
      child: pw.Column(
        children: [
          for (var i = 0; i < items.length; i += 2)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      items[i],
                      style: pw.TextStyle(fontSize: s.body),
                    ),
                  ),
                  pw.Expanded(
                    child: i + 1 < items.length
                        ? pw.Text(
                            items[i + 1],
                            style: pw.TextStyle(fontSize: s.body),
                          )
                        : pw.SizedBox(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _matchTable(Question q, PaperLabels l, _Style s, double indent) {
    final order = matchOrder(q);
    pw.Widget cell(String text, {bool bold = false}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 3),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: s.body,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: indent, top: 3),
      child: pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(),
          1: const pw.FlexColumnWidth(),
        },
        children: [
          pw.TableRow(
            children: [
              cell(l.columnA, bold: true),
              cell(l.columnB, bold: true),
            ],
          ),
          for (var i = 0; i < q.pairs.length; i++)
            pw.TableRow(
              children: [
                cell('${i + 1}. ${q.pairs[i].left}'),
                cell(
                  '(${String.fromCharCode(0x61 + i)}) ${q.pairs[order[i]].right}',
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<pw.Widget> _answerKey(PaperDocumentRequest r, _Style s) {
    final l = r.labels;
    final lines = <String>[];
    var number = 0;
    for (final type in _sectionOrder) {
      for (final q in r.paper.questions.where((q) => q.type == type)) {
        number++;
        final answer = switch (q.type) {
          QuestionType.mcq =>
            q.correctIndex == null || q.correctIndex! >= q.options.length
                ? null
                : '(${String.fromCharCode(0x61 + q.correctIndex!)}) '
                      '${q.options[q.correctIndex!]}',
          QuestionType.trueFalse =>
            q.correctIndex == null
                ? null
                : (q.correctIndex == 0 ? l.trueLabel : l.falseLabel),
          QuestionType.fillBlank => q.answer.isEmpty ? null : q.answer,
          QuestionType.matchFollowing => _matchAnswer(q),
          _ => null,
        };
        if (answer != null) lines.add('$number. $answer');
      }
    }
    if (lines.isEmpty) return const [];
    return [
      pw.SizedBox(height: s.gap),
      pw.Divider(),
      pw.Text(
        l.answerKeyLabel,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: s.body),
      ),
      pw.SizedBox(height: 3),
      for (final line in lines)
        pw.Text(line, style: pw.TextStyle(fontSize: s.small)),
    ];
  }

  /// "1-c, 2-a, 3-b": each item of column A with the letter of its match in
  /// column B as printed.
  String? _matchAnswer(Question q) {
    if (q.pairs.isEmpty) return null;
    final order = matchOrder(q);
    return [
      for (var i = 0; i < q.pairs.length; i++)
        '${i + 1}-${String.fromCharCode(0x61 + order.indexOf(i))}',
    ].join(', ');
  }

  /// The order column B is printed in: `order[row]` is the pair whose right
  /// side appears on that row. It is mixed up the same way every time for the
  /// same question, and never left as written when there is more than one
  /// row.
  static List<int> matchOrder(Question q) {
    final n = q.pairs.length;
    final order = List<int>.generate(n, (i) => i);
    if (n < 2) return order;
    // A small deterministic generator (not Dart's, which is random).
    var seed = 17;
    for (final c in q.text.codeUnits) {
      seed = (seed * 31 + c) & 0x7fffffff;
    }
    for (var i = n - 1; i > 0; i--) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final j = seed % (i + 1);
      final t = order[i];
      order[i] = order[j];
      order[j] = t;
    }
    final unchanged = [for (var i = 0; i < n; i++) i];
    if (order.join(',') == unchanged.join(',')) {
      // Shift by one so the answers never line up with the questions.
      return [for (var i = 0; i < n; i++) (i + 1) % n];
    }
    return order;
  }
}

/// Sizes for a layout.
class _Style {
  _Style(PaperLayout layout)
    : compact = layout.isThermal,
      pageWidth = switch (layout) {
        PaperLayout.a4 => PdfPageFormat.a4.width,
        // Printable width of a 58 mm / 80 mm roll: 48 mm / 72 mm.
        PaperLayout.thermal58 => 48 * PdfPageFormat.mm,
        PaperLayout.thermal80 => 72 * PdfPageFormat.mm,
      };

  final bool compact;
  final double pageWidth;

  double get margin => compact ? 2 * PdfPageFormat.mm : 36;
  double get title => compact ? 11 : 18;
  double get subtitle => compact ? 9.5 : 14;
  double get body => compact ? 8 : 11;
  double get small => compact ? 7 : 9.5;
  double get gap => compact ? 5 : 9;
  double get logo => compact ? 40 : 56;
}
