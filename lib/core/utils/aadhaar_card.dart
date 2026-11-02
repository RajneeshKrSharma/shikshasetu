import '../domain/gender.dart';

/// Reads the name, date of birth, gender and address printed on an Aadhaar card, from text a
/// photo of the card was read into. Both are best guesses from where things
/// usually sit on the card, so they are offered to the person to confirm, not
/// trusted.
class AadhaarCard {
  AadhaarCard._();

  static final _date = RegExp(
    r'(?<!\d)(\d{2})\s?[/\-.]\s?(\d{2})\s?[/\-.]\s?(\d{4})(?!\d)',
  );

  static final _gender = RegExp(
    r'\b(male|female|transgender)\b|पुरुष|महिला',
    caseSensitive: false,
  );

  static final _dobWords = RegExp(
    r'\bdob\b|date\s+of\s+birth|year\s+of\s+birth|जन्म',
    caseSensitive: false,
  );

  /// Words that mean a line is printed card text, not a person's name.
  static const _notNames = {
    'government',
    'india',
    'aadhaar',
    'aadhar',
    'unique',
    'identification',
    'authority',
    'uidai',
    'dob',
    'birth',
    'date',
    'year',
    'male',
    'female',
    'transgender',
    'address',
    'issued',
    'download',
    'virtual',
    'enrolment',
    'enrollment',
    'help',
    'my',
    'mera',
    'proof',
    'identity',
    'citizenship',
    'verify',
    'authentication',
    'qr',
    'code',
  };

  /// The first real date (day-month-year, in the past) in the text.
  static DateTime? dateOfBirthIn(String text, {DateTime? now}) {
    final today = now ?? DateTime.now();
    for (final m in _date.allMatches(text)) {
      final day = int.parse(m.group(1)!);
      final month = int.parse(m.group(2)!);
      final year = int.parse(m.group(3)!);
      if (year < 1900 || month < 1 || month > 12 || day < 1) continue;
      final date = DateTime(year, month, day);
      // DateTime rolls 31 Feb into March; a real date keeps its day and month.
      if (date.day != day || date.month != month) continue;
      if (date.isAfter(today)) continue;
      return date;
    }
    return null;
  }

  /// The gender printed on the front of the card.
  static Gender? genderIn(String text) {
    // "Female" contains "male", so it is looked for first.
    if (RegExp(r'\bfemale\b|महिला', caseSensitive: false).hasMatch(text)) {
      return Gender.female;
    }
    if (RegExp(
      r'\btransgender\b|ट्रांसजेंडर',
      caseSensitive: false,
    ).hasMatch(text)) {
      return Gender.other;
    }
    if (RegExp(r'\bmale\b|पुरुष', caseSensitive: false).hasMatch(text)) {
      return Gender.male;
    }
    return null;
  }

  // Lines that end the address on the back of the card (the footer).
  static final _addressEnd = RegExp(
    r'uidai|help@|1947|www\.|\bvid\b|aadhaar|aadhar|आधार|digitally|'
    r'\b\d{4}\s?\d{4}\s?\d{4}\b|authenticat|proof of|not a proof',
    caseSensitive: false,
  );

  // Stray printing that can land between address lines when the text is put
  // back in reading order, such as the sideways "Download Date: 12/03/2022"
  // along the edge of an e-Aadhaar. It is skipped, not treated as the end.
  static final _addressNoise = RegExp(
    r'download|date\s*:|डाउनलोड|\d{2}[/\-]\d{2}[/\-]\d{4}',
    caseSensitive: false,
  );

  /// The address text on one line. The reader joins things on the same row
  /// with a tab: the address and the QR code beside it, or the end of a wrapped
  /// address line and the line before. So: the first piece is kept (the
  /// leftmost, where the address starts); later pieces are kept only if they
  /// look like address too (a comma, or a PIN code), which keeps the wrapped
  /// "थाली, जयपुर," and drops the QR code's stray characters and headings.
  static String _addressPart(String line) {
    final parts = line
        .split(RegExp(r'\s*\t\s*'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty && !_addressNoise.hasMatch(p))
        .toList();
    if (parts.isEmpty) return '';
    final kept = [
      parts.first,
      for (final p in parts.skip(1))
        if (p.contains(',') || _pin.hasMatch(p)) p,
    ];
    return kept.join(' ');
  }

  /// A continuation line without a stray single letter in front (the sideways
  /// text on the card edge is sometimes read as one: "S Ramgarh", "g Rajasthan").
  static String _noLoneLetter(String line) => line.replaceFirst(
    RegExp(r'^[A-Za-z]\s+(?=[A-Za-z\u0900-\u097F]{2})'),
    '',
  );

  /// "W/ᴏ", "W/o" or "W|0" at the start as the card prints it: "W/O".
  static String _tidyRelation(String address) => address.replaceFirstMapped(
    RegExp(r'^([CSDWHcsdwh])\s*[/|\\]\s*[oO0\u1d0f](?=\s)'),
    (m) => '${m.group(1)!.toUpperCase()}/O',
  );

  static final _addressStart = RegExp(
    r'^\s*(?:address|पता)\s*[:\-]?\s*(.*)$',
    caseSensitive: false,
  );
  static final _relation = RegExp(
    // OCR reads "W/O" as "W/0", "W|O" or "WIO" as well.
    r'^\s*[CSDWH]\s*[/|I\\]\s*[O0]\b',
    caseSensitive: false,
  );
  static final _pin = RegExp(r'(?<!\d)[1-9]\d{5}(?!\d)');

  /// The address on the back of the card, in one line, ending at its PIN code.
  /// Starts at the English "Address:" line (or at "S/O", "C/O"... when the
  /// label is missing). A block with no PIN code is not accepted, so stray
  /// text is not mistaken for an address.
  static String? addressIn(String text) {
    final lines = text
        .split(RegExp(r'\r?\n'))
        .map(_addressPart)
        .where((l) => l.isNotEmpty)
        .toList();
    var start = -1;
    var first = '';
    for (var i = 0; i < lines.length; i++) {
      final m = _addressStart.firstMatch(lines[i]);
      // The English label: the Hindi one is not read by the Latin reader.
      if (m != null &&
          RegExp('address', caseSensitive: false).hasMatch(lines[i])) {
        start = i;
        first = m.group(1) ?? '';
        break;
      }
    }
    if (start < 0) {
      start = lines.indexWhere(_relation.hasMatch);
      if (start >= 0) first = lines[start];
    }
    if (start < 0) {
      // No label and no "S/O": work back from the PIN code line, which is the
      // last line of a postal address, taking the few lines above it.
      final pinLine = lines.lastIndexWhere(
        (l) => _pin.hasMatch(l) && !_addressEnd.hasMatch(l),
      );
      if (pinLine < 0) return null;
      var from = pinLine;
      while (from > 0 && pinLine - from < 4) {
        final above = lines[from - 1];
        if (_addressEnd.hasMatch(above) || _addressNoise.hasMatch(above)) {
          break;
        }
        from--;
      }
      return _joinAddress(lines.sublist(from, pinLine + 1));
    }
    final parts = <String>[if (first.isNotEmpty) first];
    for (var i = start + 1; i < lines.length && parts.length < 8; i++) {
      if (_addressEnd.hasMatch(lines[i])) break;
      if (_addressNoise.hasMatch(lines[i]) && !_pin.hasMatch(lines[i])) {
        continue;
      }
      parts.add(_noLoneLetter(lines[i]));
      if (_pin.hasMatch(lines[i])) break;
    }
    return _joinAddress(parts);
  }

  /// The lines as one address ending at its PIN code, or null if there is no
  /// PIN or too little text to be an address.
  static String? _joinAddress(List<String> parts, {int minLength = 15}) {
    final joined = parts
        .join(', ')
        .replaceAll(RegExp(r'\s*,\s*(,\s*)+'), ', ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[,\s]+|[,\s]+$'), '');
    final pin = _pin.allMatches(joined).lastOrNull;
    if (pin == null || joined.length < minLength) return null;
    return _tidyRelation(joined.substring(0, pin.end));
  }

  // A Hindi (Devanagari) name: letters, vowel signs, spaces and dots only.
  static final _hindiName = RegExp(r'^[\u0900-\u097F\u200c\u200d .]{3,60}$');

  /// Words printed on the card in Hindi that are not part of a name.
  static const _notHindiNames = {
    'भारत',
    'सरकार',
    'आधार',
    'मेरा',
    'जन्म',
    'तिथि',
    'तारीख',
    'पुरुष',
    'महिला',
    'पता',
    'पहचान',
    'प्राधिकरण',
    'विशिष्ट',
    'भारतीय',
    'वर्ष',
    'लिंग',
  };

  /// The name as printed in Hindi, from text read with the Devanagari reader:
  /// the Hindi line above the English name, which itself sits above the date
  /// of birth or gender.
  static String? nameHiIn(String text) {
    final lines = text
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final anchor = lines.indexWhere(
      (l) => _gender.hasMatch(l) || _dobWords.hasMatch(l) || _date.hasMatch(l),
    );
    if (anchor <= 0) return null;
    for (var i = anchor - 1; i >= 0; i--) {
      for (final part in lines[i].split(RegExp(r'\s*\t\s*'))) {
        final line = part.trim().replaceAll(RegExp(r'\s+'), ' ');
        if (!_hindiName.hasMatch(line)) continue;
        final words = line.split(' ');
        if (words.any(_notHindiNames.contains)) continue;
        return line;
      }
    }
    return null;
  }

  static final _hindiAddressStart = RegExp(r'^\s*पता\s*[:\-]?\s*(.*)$');

  /// The address as printed in Hindi on the back of the card, in one line,
  /// ending at its PIN code. It starts at the "पता:" label and stops where the
  /// English "Address:" begins.
  static String? addressHiIn(String text) {
    final lines = text
        .split(RegExp(r'\r?\n'))
        .map(_addressPart)
        .where((l) => l.isNotEmpty)
        .toList();
    final start = lines.indexWhere(_hindiAddressStart.hasMatch);
    if (start < 0) {
      // The "पता:" label was not read: work back from the first PIN code line
      // that has Hindi on it (the Hindi block comes before the English one).
      final devanagari = RegExp(r'[\u0900-\u097F]');
      final pinLine = lines.indexWhere(
        (l) => _pin.hasMatch(l) && devanagari.hasMatch(l),
      );
      if (pinLine < 0) return null;
      var from = pinLine;
      while (from > 0 && pinLine - from < 4) {
        final above = lines[from - 1];
        final hindiLike =
            devanagari.hasMatch(above) || _relation.hasMatch(above);
        // The card's own heading (भारतीय विशिष्ट पहचान प्राधिकरण) is not address.
        final heading = above.split(' ').any(_notHindiNames.contains);
        if (!hindiLike || heading || _addressEnd.hasMatch(above)) break;
        if (_addressNoise.hasMatch(above)) {
          from--;
          continue;
        }
        from--;
      }
      return _joinAddress([
        for (final l in lines.sublist(from, pinLine + 1))
          if (!_addressNoise.hasMatch(l) || _pin.hasMatch(l)) l,
      ], minLength: 12);
    }
    final parts = <String>[
      if ((_hindiAddressStart.firstMatch(lines[start])!.group(1) ?? '')
          .isNotEmpty)
        _hindiAddressStart.firstMatch(lines[start])!.group(1)!,
    ];
    for (var i = start + 1; i < lines.length && parts.length < 8; i++) {
      // The English block begins: the Hindi one is over.
      if (RegExp('address', caseSensitive: false).hasMatch(lines[i]) ||
          _addressEnd.hasMatch(lines[i])) {
        break;
      }
      if (_addressNoise.hasMatch(lines[i]) && !_pin.hasMatch(lines[i])) {
        continue;
      }
      // Hindi address lines have Hindi on them (or are the PIN line); a line
      // with none is the logo's text, such as "AADHa".
      if (!RegExp(r'[\u0900-\u097F]').hasMatch(lines[i]) &&
          !_pin.hasMatch(lines[i]) &&
          !_relation.hasMatch(lines[i])) {
        continue;
      }
      parts.add(lines[i]);
      if (_pin.hasMatch(lines[i])) break;
    }
    return _joinAddress(parts, minLength: 12);
  }

  /// The name: the nearest name-like line above the gender or date of birth,
  /// which is where it sits on the card. In Title Case.
  static String? nameIn(String text) {
    final lines = text
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final anchor = lines.indexWhere(
      (l) => _gender.hasMatch(l) || _dobWords.hasMatch(l) || _date.hasMatch(l),
    );
    if (anchor <= 0) return null;
    for (var i = anchor - 1; i >= 0; i--) {
      // Columns read side by side come joined with a tab.
      for (final part in lines[i].split(RegExp(r'\s*\t\s*'))) {
        final name = _asName(part);
        if (name != null) return name;
      }
    }
    return null;
  }

  static String? _asName(String raw) {
    final line = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (!RegExp(r"^[A-Za-z][A-Za-z.'\- ]{2,40}$").hasMatch(line)) return null;
    final words = line.split(' ');
    if (words.any((w) => _notNames.contains(w.toLowerCase()))) return null;
    // A name has at least one real word of three or more letters.
    if (!words.any((w) => w.replaceAll(RegExp('[^A-Za-z]'), '').length >= 3)) {
      return null;
    }
    return words
        .map(
          (w) => w.isEmpty
              ? w
              : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
