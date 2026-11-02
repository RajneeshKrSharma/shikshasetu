import 'dart:convert';

import 'package:crypto/crypto.dart';

/// A fingerprint of a row. Equal rows give equal fingerprints whatever order
/// their columns came in, so a row is re-sent only when something in it
/// really changed.
String rowHash(Map<String, Object?> row) {
  final keys = row.keys.toList()..sort();
  final canonical = jsonEncode({for (final k in keys) k: row[k]});
  return sha256.convert(utf8.encode(canonical)).toString();
}
