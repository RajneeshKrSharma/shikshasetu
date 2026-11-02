import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/exams/data/repository/ocr_layout.dart';

void main() {
  test('lines come back in reading order', () {
    final text = ocrLayoutText(const [
      OcrLine('second', 0, 60, 100, 80),
      OcrLine('first', 0, 10, 100, 30),
    ]);

    expect(text, 'first\nsecond');
  });

  test('two columns on one row are joined with a tab, left to right', () {
    final text = ocrLayoutText(const [
      OcrLine('a. Meow', 300, 12, 400, 32),
      OcrLine('1. Cat', 0, 10, 100, 30),
      OcrLine('b. Bark', 300, 52, 400, 72),
      OcrLine('2. Dog', 0, 50, 100, 70),
    ]);

    expect(text, '1. Cat \t a. Meow\n2. Dog \t b. Bark');
  });

  test('a slightly lower line is its own row', () {
    final text = ocrLayoutText(const [
      OcrLine('one', 0, 10, 100, 30),
      OcrLine('two', 0, 32, 100, 52),
    ]);

    expect(text, 'one\ntwo');
  });

  test('no lines gives empty text', () {
    expect(ocrLayoutText(const []), '');
  });
}
