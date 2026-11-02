import '../entities/exam_paper.dart';
import '../entities/scanned_question.dart';

/// Splits OCR (or pasted) text into questions and works out each one's shape.
///
/// A new question starts at a line beginning with a number marker such as
/// `1.`, `2)`, `Q3.` or `Q. 4:`. Lines without a marker continue the previous
/// question (wrapped text, MCQ options).
///
/// Recognised shapes:
/// * **MCQ** – a heading followed by options marked `(a)`, `a)`, `A.` or
///   `(क)`, on separate lines or all on one line.
/// * **Fill in the blank** – a blank written as `____`, `.....` or `…`.
/// * **True or false** – "state true or false", "T/F".
/// * **Match the following** – a heading with "match" and two columns, either
///   side by side (separated by a tab) or one after the other.
/// * Anything else is a short answer.
///
/// Instruction lines such as "Section B", "Fill in the blanks" or "Choose the
/// correct answer" are not questions; they set the shape of the questions
/// that follow. The result is only a suggestion; the teacher reviews it.
class QuestionParser {
  const QuestionParser();

  static final _start = RegExp(
    r'^\s*(Q(?:uestion)?\.?\s*)?(\d{1,3})\s*[.)\]:\-]\s+(?=\S)',
    caseSensitive: false,
  );

  // "[5]", "(5)", "(5 marks)", "5 marks", "5 M" at the end of a question.
  static final _marks = RegExp(
    r'\s*(?:[\[(]\s*(\d{1,3})\s*(?:marks?|m)?\s*[\])]|(\d{1,3})\s*marks?)\s*$',
    caseSensitive: false,
  );

  static final _section = RegExp(
    r'^\s*(?:section|part|खंड|भाग)\s+[A-Za-z0-9IVXअ-ज]{1,3}\b',
    caseSensitive: false,
  );

  static final _blank = RegExp(r'_{2,}|\.{5,}|…{2,}|\s—{2,}');

  // An option at the start of a line: "(a)", "a)", "A." or "(क)".
  static final _optionLead = RegExp(
    r'^\s*(?:\(\s*([A-Ea-e])\s*\)|([A-Ea-e])[.)]|\(\s*([कखगघङ])\s*\)|([कखगघ])[.)])\s*',
  );

  // "(a)" in the middle of a line, for options printed on one line.
  static final _optionInline = RegExp(r'\(\s*([A-Ea-e]|[कखगघ])\s*\)');

  static final _trueFalse = RegExp(
    r'true\s*(?:or|/|&)\s*false|\bt\s*/\s*f\b|सत्य\s*(?:या|/)\s*असत्य',
    caseSensitive: false,
  );

  // Instruction headings and the shape of the questions they introduce.
  static final _hints = <QuestionType, RegExp>{
    QuestionType.fillBlank: RegExp(
      r'fill\s+in\s+the\s+blanks?|रिक्त\s*स्थान',
      caseSensitive: false,
    ),
    QuestionType.mcq: RegExp(
      r'choose\s+the\s+(?:correct|right|best)|multiple\s+choice|\bmcqs?\b|सही\s+विकल्प',
      caseSensitive: false,
    ),
    QuestionType.trueFalse: RegExp(
      r'true\s*(?:or|/)\s*false|सत्य\s*(?:या|/)\s*असत्य',
      caseSensitive: false,
    ),
    QuestionType.shortAnswer: RegExp(
      r'short\s+answers?|very\s+short|answer\s+in\s+(?:one|a)\s+(?:word|sentence)|लघु\s*उत्तर',
      caseSensitive: false,
    ),
    QuestionType.longAnswer: RegExp(
      r'long\s+answers?|answer\s+in\s+detail|दीर्घ\s*उत्तर',
      caseSensitive: false,
    ),
  };

  static final _matchWord = RegExp(
    r'\bmatch\b|मिलान|मिलाइए|मिलाएँ|मिलाएं',
    caseSensitive: false,
  );

  static final _columnHeader = RegExp(
    r'^\s*(?:column|col\.?|कॉलम|स्तंभ)\s*[A-Za-z0-9अ-ज]\b',
    caseSensitive: false,
  );

  List<ScannedQuestion> parse(String raw) {
    final lines = raw
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty);

    final blocks = <_Block>[];
    _Block? current;
    var last = 0;
    QuestionType? hint;

    for (final line in lines) {
      final m = _start.firstMatch(line);
      if (m == null) {
        if (_isHeadingLine(line)) {
          hint = _hintOf(line);
          last = 0;
          current = null;
        } else if (current == null) {
          blocks.add(current = _Block(line, hint));
        } else {
          current.lines.add(line);
        }
        continue;
      }
      final number = int.parse(m.group(2)!);
      final hasQ = m.group(1) != null;
      final body = line.substring(m.end);
      final isMatchItem =
          current != null &&
          current.isMatch &&
          !hasQ &&
          number == current.items + 1;
      if (isMatchItem) {
        current.lines.add(line);
        current.items++;
      } else if (_isHeadingText(body)) {
        // "1. Fill in the blanks:" introduces questions; it is not one.
        hint = _hintOf(body);
        last = 0;
        current = null;
      } else if (current == null || hasQ || number > last) {
        blocks.add(current = _Block(body, hint));
        last = number;
      } else {
        // A smaller number than the last question: an option such as "2)".
        current.lines.add(line);
      }
    }

    return [
      for (final b in blocks)
        if (b.head.trim().isNotEmpty || b.lines.isNotEmpty) _convert(b),
    ];
  }

  bool _isHeadingLine(String line) {
    if (_section.hasMatch(line)) return true;
    return _isHeadingText(line);
  }

  /// Short instruction text with no blank or options, naming a question shape
  /// and little else ("Fill in the blanks:", not "State true or false: Ice is
  /// cold.").
  bool _isHeadingText(String text) {
    if (text.length > 90 ||
        _blank.hasMatch(text) ||
        _optionInline.hasMatch(text)) {
      return false;
    }
    for (final re in _hints.values) {
      final m = re.firstMatch(text);
      if (m == null) continue;
      final rest = text
          .replaceRange(m.start, m.end, '')
          .replaceAll(RegExp(r'[^\p{L}]', unicode: true), '');
      return rest.length <= 12 ||
          (text.trimRight().endsWith(':') && rest.length <= 40);
    }
    return false;
  }

  QuestionType? _hintOf(String text) {
    for (final e in _hints.entries) {
      if (e.value.hasMatch(text)) return e.key;
    }
    return null;
  }

  ScannedQuestion _convert(_Block b) {
    if (b.isMatch) return _match(b);

    // Break every line into plain text and options.
    final heading = StringBuffer();
    final options = <StringBuffer>[];
    void addText(String t) {
      if (t.trim().isEmpty) return;
      final target = options.isEmpty ? heading : options.last;
      if (target.isNotEmpty) target.write(' ');
      target.write(t.trim());
    }

    for (final line in [b.head, ...b.lines]) {
      final lead = _optionLead.firstMatch(line);
      final inline = _optionInline.allMatches(line).toList();
      if (lead != null) {
        _splitInline(line, options, heading);
      } else if (inline.length >= 2) {
        // "Capital of India is (a) Delhi (b) Mumbai": text, then options.
        final first = inline.first.start;
        addText(line.substring(0, first));
        _splitInline(line.substring(first), options, heading);
      } else {
        addText(line);
      }
    }

    var text = heading.toString().trim();
    var optionTexts = [for (final o in options) o.toString().trim()];

    int? marks;
    // Marks are written last: on the final option, or on the heading.
    if (optionTexts.isNotEmpty) {
      final r = _takeMarks(optionTexts.last);
      optionTexts[optionTexts.length - 1] = r.$1;
      marks = r.$2;
    }
    if (marks == null || optionTexts.isEmpty) {
      final r = _takeMarks(text);
      text = r.$1;
      marks ??= r.$2;
    }

    if (optionTexts.length >= 2 && text.isNotEmpty) {
      if (_isTrueFalse(text, optionTexts)) {
        return ScannedQuestion(
          text: text,
          marks: marks,
          type: QuestionType.trueFalse,
        );
      }
      return ScannedQuestion(
        text: text,
        marks: marks,
        type: QuestionType.mcq,
        options: optionTexts,
      );
    }

    // Not a real option list: put the text back together.
    final whole = [
      text,
      for (final o in options) o.toString(),
    ].where((s) => s.isNotEmpty).join(' ');
    final r = _takeMarks(whole);
    final plain = r.$1;
    marks ??= r.$2;

    if (_trueFalse.hasMatch(plain) || b.hint == QuestionType.trueFalse) {
      return ScannedQuestion(
        text: plain,
        marks: marks,
        type: QuestionType.trueFalse,
      );
    }
    if (_blank.hasMatch(plain)) {
      return ScannedQuestion(
        text: plain.replaceAll(_blank, '_____'),
        marks: marks,
        type: QuestionType.fillBlank,
      );
    }
    return ScannedQuestion(
      text: plain,
      marks: marks,
      type: b.hint == QuestionType.longAnswer
          ? QuestionType.longAnswer
          : QuestionType.shortAnswer,
    );
  }

  bool _isTrueFalse(String heading, List<String> options) {
    final words = {for (final o in options) o.toLowerCase().trim()};
    return _trueFalse.hasMatch(heading) ||
        (words.length == 2 && words.containsAll(['true', 'false']));
  }

  /// Splits a line that starts at an option marker into its options.
  void _splitInline(
    String line,
    List<StringBuffer> options,
    StringBuffer heading,
  ) {
    final markers = <(int, int)>[]; // start, end of each marker
    final lead = _optionLead.firstMatch(line);
    if (lead != null) markers.add((lead.start, lead.end));
    for (final m in _optionInline.allMatches(line)) {
      if (lead != null && m.start < lead.end) continue;
      markers.add((m.start, m.end));
    }
    if (markers.isEmpty) return;
    for (var i = 0; i < markers.length; i++) {
      final end = i + 1 < markers.length ? markers[i + 1].$1 : line.length;
      options.add(StringBuffer(line.substring(markers[i].$2, end).trim()));
    }
  }

  ScannedQuestion _match(_Block b) {
    final lefts = <String>[];
    final rights = <String>[];
    final rows = <MatchPair>[];
    final headParts = <String>[];

    String stripLeft(String s) =>
        s.replaceFirst(RegExp(r'^\d{1,2}\s*[.)]\s*'), '');
    String stripRight(String s) => s.replaceFirst(
      RegExp(r'^\(?[A-Ea-e]\)?\s*[.)]?\s+|^\(?[कखगघ]\)\s*'),
      '',
    );

    for (final line in b.lines) {
      if (_columnHeader.hasMatch(line)) continue;
      final cols = line
          .split(RegExp(r'\s*\t\s*|\s{3,}'))
          .where((c) => c.isNotEmpty)
          .toList();
      if (cols.length >= 2) {
        rows.add(MatchPair(stripLeft(cols.first), stripRight(cols[1])));
      } else if (RegExp(r'^\s*\d{1,2}\s*[.)]\s').hasMatch(line)) {
        lefts.add(stripLeft(line));
      } else if (_optionLead.hasMatch(line) ||
          RegExp(r'^[A-Ea-e]\s*[.)]').hasMatch(line)) {
        rights.add(stripRight(line));
      } else if (lefts.isEmpty && rights.isEmpty && rows.isEmpty) {
        headParts.add(line);
      } else if (rights.isNotEmpty) {
        rights[rights.length - 1] = '${rights.last} $line';
      } else if (lefts.isNotEmpty) {
        lefts[lefts.length - 1] = '${lefts.last} $line';
      }
    }
    for (var i = 0; i < lefts.length && i < rights.length; i++) {
      rows.add(MatchPair(lefts[i], rights[i]));
    }

    var text = [b.head, ...headParts].join(' ').trim();
    var marks = _takeMarks(text);
    text = marks.$1;
    int? m = marks.$2;
    if (m == null && rows.isNotEmpty) {
      final r = _takeMarks(rows.last.right);
      if (r.$2 != null) {
        rows[rows.length - 1] = MatchPair(rows.last.left, r.$1);
        m = r.$2;
      }
    }
    if (rows.length < 2) {
      // Could not read two columns: keep everything as plain text.
      final whole = [b.head, ...b.lines].join(' ').trim();
      final r = _takeMarks(whole);
      return ScannedQuestion(text: r.$1, marks: r.$2);
    }
    return ScannedQuestion(
      text: text,
      marks: m,
      type: QuestionType.matchFollowing,
      pairs: rows,
    );
  }

  (String, int?) _takeMarks(String text) {
    final m = _marks.firstMatch(text);
    if (m == null) return (text, null);
    final marks = int.parse(m.group(1) ?? m.group(2)!);
    final cleaned = text.substring(0, m.start).trim();
    // Keep the text if stripping the marks would leave nothing.
    return cleaned.isEmpty ? (text, null) : (cleaned, marks > 0 ? marks : null);
  }
}

class _Block {
  _Block(this.head, this.hint);

  final String head;
  final List<String> lines = [];

  /// Shape announced by the heading above this question, if any.
  final QuestionType? hint;

  /// Numbered left-column rows absorbed so far (match the following).
  int items = 0;

  bool get isMatch =>
      QuestionParser._matchWord.hasMatch(head) &&
      !QuestionParser._blank.hasMatch(head);
}
