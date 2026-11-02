import 'package:intl/intl.dart';

final _fmt = DateFormat('yyyy-MM-dd');

/// Calendar-day key used in the database, e.g. "2026-09-30" (local time).
String dayKey(DateTime d) => _fmt.format(d);
