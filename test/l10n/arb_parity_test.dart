import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Set<String> _keys(String path) =>
    (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
        .where((k) => !k.startsWith('@'))
        .toSet();

void main() {
  test('Hindi ARB has exactly the same keys as English', () {
    final en = _keys('lib/l10n/app_en.arb');
    final hi = _keys('lib/l10n/app_hi.arb');

    expect(en.difference(hi), isEmpty, reason: 'missing in Hindi');
    expect(hi.difference(en), isEmpty, reason: 'extra in Hindi');
  });
}
