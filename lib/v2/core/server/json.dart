/// One JSON object as the server sends it.
typedef Json = Map<String, dynamic>;

/// Reading the server's JSON without casts scattered through the models.
extension JsonReader on Json {
  String string(String key) => (this[key] as String?) ?? '';

  String? stringOrNull(String key) {
    final value = this[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  int integer(String key) => (this[key] as num?)?.toInt() ?? 0;

  int? integerOrNull(String key) => (this[key] as num?)?.toInt();

  bool flag(String key, {bool otherwise = false}) =>
      (this[key] as bool?) ?? otherwise;

  /// A date such as `2026-10-26`, as a day with no time.
  DateTime? dayOrNull(String key) {
    final value = this[key];
    if (value is! String || value.isEmpty) return null;
    final parts = value.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2].substring(0, 2)),
    );
  }

  DateTime day(String key) => dayOrNull(key) ?? DateTime.now();

  /// A moment such as `2026-10-26T10:15:00+05:30`.
  DateTime? momentOrNull(String key) {
    final value = this[key];
    return value is String && value.isNotEmpty
        ? DateTime.tryParse(value)?.toLocal()
        : null;
  }

  /// A time of day such as `08:30` or `08:30:00`, as minutes since midnight.
  int? minuteOrNull(String key) {
    final value = this[key];
    if (value is! String || value.length < 5) return null;
    return int.parse(value.substring(0, 2)) * 60 +
        int.parse(value.substring(3, 5));
  }

  List<Json> list(String key) => [
    for (final item in (this[key] as List? ?? const [])) item as Json,
  ];

  Json? object(String key) => this[key] is Map ? this[key] as Json : null;

  List<String> strings(String key) => [
    for (final item in (this[key] as List? ?? const [])) '$item',
  ];
}

/// A JSON array of objects, from the body of a list answer.
List<Json> jsonObjects(Object? body) => [
  for (final item in (body as List? ?? const [])) item as Json,
];

/// A JSON object, from the body of a one-thing answer.
Json jsonObject(Object? body) => body as Json;

/// How days and times go back to the server.
class WireFormat {
  const WireFormat._();

  /// `2026-10-26`.
  static String day(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// `2026-10`.
  static String month(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

  /// `08:30` from minutes since midnight.
  static String minutes(int m) =>
      '${(m ~/ 60).toString().padLeft(2, '0')}:'
      '${(m % 60).toString().padLeft(2, '0')}';
}
