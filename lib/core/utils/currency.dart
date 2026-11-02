import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatRupees(BuildContext context, num amount) => NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
).format(amount);

/// A short amount for a summary: ₹18.4L, ₹2.1Cr, or the plain amount below a
/// lakh.
String formatRupeesCompact(BuildContext context, num amount) {
  String one(double v) =>
      v.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '');
  if (amount >= 10000000) return '₹${one(amount / 10000000)}Cr';
  if (amount >= 100000) return '₹${one(amount / 100000)}L';
  return formatRupees(context, amount);
}
