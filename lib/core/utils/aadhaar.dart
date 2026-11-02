import '../domain/gender.dart';
import 'aadhaar_card.dart';

/// Aadhaar number helpers. The full number is validated but never stored;
/// only the masked form is persisted.
class Aadhaar {
  Aadhaar._();

  // Verhoeff checksum tables.
  static const _d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  ];
  static const _p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
  ];

  static String digitsOnly(String v) => v.replaceAll(RegExp(r'\D'), '');

  /// 12 digits, not starting with 0 or 1, and a valid Verhoeff checksum.
  static bool isValid(String input) {
    final n = digitsOnly(input);
    if (n.length != 12 || n.startsWith('0') || n.startsWith('1')) {
      return false;
    }
    var c = 0;
    final digits = n.split('').reversed.map(int.parse).toList();
    for (var i = 0; i < digits.length; i++) {
      c = _d[c][_p[i % 8][digits[i]]];
    }
    return c == 0;
  }

  // 12 digits in groups of four, as printed on the card. Not part of a longer
  // run of digits, so the 16-digit Virtual ID is not mistaken for the number.
  static final _printed = RegExp(
    r'(?<!\d)(\d{4})[ \-]?(\d{4})[ \-]?(\d{4})(?![ \-]?\d)',
  );

  /// The first valid Aadhaar number found in text read from a card or photo,
  /// as 12 digits, or null. A number that fails the checksum is skipped, so a
  /// misread digit does not fill the form with a wrong number.
  static String? findIn(String text) {
    for (final m in _printed.allMatches(text)) {
      final n = '${m.group(1)}${m.group(2)}${m.group(3)}';
      if (isValid(n)) return n;
    }
    return null;
  }

  static final _masked = RegExp(r'[xX*•]{4}[ \-]?[xX*•]{4}[ \-]?\d{4}');
  static final _virtualId = RegExp(
    r'(?<!\d)\d{4}[ \-]?\d{4}[ \-]?\d{4}[ \-]?\d{4}(?!\d)',
  );

  /// Reads text taken from a photo of a card and says what was found, or, when
  /// no usable number was, why not.
  /// [text] is read with the Latin reader; [hindiText], when given, with the
  /// Devanagari reader, for the Hindi name and address.
  static AadhaarReading read(String text, {String? hindiText}) {
    if (text.trim().isEmpty && (hindiText ?? '').trim().isEmpty) {
      return const AadhaarReading(AadhaarProblem.noText);
    }
    // What the photo shows besides the number, whichever side of the card it
    // is: the front has the name, date of birth and gender; the back, the
    // address.
    final name = AadhaarCard.nameIn(text);
    final hindi = hindiText ?? '';
    // Digits are the same in both readers' output: use whichever has them.
    final both = '$text\n$hindi';
    final dob = AadhaarCard.dateOfBirthIn(both);
    final gender = AadhaarCard.genderIn(text);
    final address = AadhaarCard.addressIn(text);
    final nameHi = AadhaarCard.nameHiIn(hindi.isEmpty ? text : hindi);
    final addressHi = AadhaarCard.addressHiIn(hindi.isEmpty ? text : hindi);
    final genderAny = gender ?? AadhaarCard.genderIn(hindi);
    AadhaarReading with_(AadhaarProblem problem, [String? number]) =>
        AadhaarReading(
          problem,
          number: number,
          name: name,
          dateOfBirth: dob,
          gender: genderAny,
          address: address,
          nameHi: nameHi,
          addressHi: addressHi,
          debugText: 'LATIN READER:\n$text\n\nDEVANAGARI READER:\n$hindi',
        );

    final valid = findIn(text) ?? findIn(hindi);
    if (valid != null) return with_(AadhaarProblem.none, valid);
    if (_masked.hasMatch(both)) return with_(AadhaarProblem.masked);
    if (_virtualId.hasMatch(both)) return with_(AadhaarProblem.virtualId);
    // 12 digits were read, but they fail the checksum: one is probably misread.
    final m = _printed.firstMatch(both);
    if (m != null) {
      return with_(
        AadhaarProblem.badChecksum,
        '${m.group(1)}${m.group(2)}${m.group(3)}',
      );
    }
    return with_(AadhaarProblem.noNumber);
  }

  /// How many digit positions differ between two numbers (a large value for
  /// numbers of different length).
  static int digitDistance(String a, String b) {
    final x = digitsOnly(a), y = digitsOnly(b);
    if (x.length != y.length) return 99;
    var n = 0;
    for (var i = 0; i < x.length; i++) {
      if (x[i] != y[i]) n++;
    }
    return n;
  }

  static String mask(String input) {
    final n = digitsOnly(input);
    return 'XXXX XXXX ${n.substring(n.length - 4)}';
  }
}

/// Why a photo did not give an Aadhaar number.
enum AadhaarProblem {
  /// Nothing went wrong: [AadhaarReading.number] is a valid number.
  none,

  /// No text could be read at all (blurry, dark, or not a card).
  noText,

  /// Text was read but no 12-digit number was in it.
  noNumber,

  /// The card shows only the last four digits (XXXX XXXX 1234).
  masked,

  /// A 16-digit Virtual ID was read, not the 12-digit number.
  virtualId,

  /// 12 digits were read but fail the checksum, so one is probably misread.
  badChecksum,
}

class AadhaarReading {
  const AadhaarReading(
    this.problem, {
    this.number,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.nameHi,
    this.addressHi,
    this.debugText,
    this.conflictingNumber,
  });

  final AadhaarProblem problem;

  /// A valid number when [problem] is none; for [AadhaarProblem.badChecksum]
  /// the digits as read, so they can be corrected by hand.
  final String? number;

  /// The name and date of birth printed on the card, when they could be read
  /// alongside a valid number.
  final String? name;
  final DateTime? dateOfBirth;
  final Gender? gender;

  /// The address from the back of the card, when the photo shows it.
  final String? address;

  /// The same two, as printed in Hindi (Devanagari) on the card.
  final String? nameHi;
  final String? addressHi;

  /// The number on the back photo when it is a different (valid) number from
  /// the front's: the two photos are probably of different cards, so nothing
  /// from the back is used.
  final String? conflictingNumber;

  /// The raw text the readers produced, for finding out why a photo was not
  /// understood. Shown only in debug builds.
  final String? debugText;

  /// Something other than the number could be read (e.g. the address, from a
  /// photo of the back of the card).
  bool get hasDetails =>
      name != null ||
      dateOfBirth != null ||
      gender != null ||
      address != null ||
      nameHi != null ||
      addressHi != null;
}
