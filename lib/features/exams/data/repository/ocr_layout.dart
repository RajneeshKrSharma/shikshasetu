/// One recognised line of text and where it sits on the page.
class OcrLine {
  const OcrLine(this.text, this.left, this.top, this.right, this.bottom);

  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;

  double get centerY => (top + bottom) / 2;
  double get height => bottom - top;
}

/// Puts recognised lines back in reading order. Lines that share a row (such
/// as the two columns of a "match the following") are joined on one line with
/// a tab between them, so the parser can tell the columns apart.
String ocrLayoutText(List<OcrLine> lines) {
  final sorted = [...lines]..sort((a, b) => a.centerY.compareTo(b.centerY));
  final rows = <List<OcrLine>>[];
  for (final line in sorted) {
    if (rows.isNotEmpty) {
      final row = rows.last;
      final rowCenter =
          row.map((l) => l.centerY).reduce((a, b) => a + b) / row.length;
      final smallest = row.map((l) => l.height).reduce((a, b) => a < b ? a : b);
      final tolerance = (smallest < line.height ? smallest : line.height) * 0.5;
      if ((line.centerY - rowCenter).abs() <= tolerance) {
        row.add(line);
        continue;
      }
    }
    rows.add([line]);
  }
  return rows
      .map((row) {
        row.sort((a, b) => a.left.compareTo(b.left));
        return row.map((l) => l.text.trim()).join(' \t ');
      })
      .join('\n');
}
