import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/utils/aadhaar.dart';

void main() {
  // Synthetic number whose Verhoeff check digit is correct.
  const valid = '2345 6789 0124';

  group('isValid', () {
    test('accepts a number with a correct checksum', () {
      expect(Aadhaar.isValid(valid), isTrue);
    });

    test('rejects a number with a wrong check digit', () {
      expect(Aadhaar.isValid('2345 6789 0125'), isFalse);
    });

    test('rejects numbers that are not 12 digits', () {
      expect(Aadhaar.isValid('2345 6789 012'), isFalse);
    });

    test('rejects numbers starting with 0 or 1', () {
      expect(Aadhaar.isValid('1234 5678 9012'), isFalse);
    });
  });

  test('mask: keeps only the last four digits', () {
    expect(Aadhaar.mask(valid), 'XXXX XXXX 0124');
  });
}
