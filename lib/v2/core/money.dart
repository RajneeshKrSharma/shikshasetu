import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// An amount in rupees, kept as whole paise so no rounding ever creeps in.
class Money extends Equatable implements Comparable<Money> {
  const Money(this.paise);

  static const zero = Money(0);

  final int paise;

  /// From the server's text such as `2000.00`; null or blank is zero.
  factory Money.fromServer(Object? value) {
    final text = '${value ?? ''}'.trim();
    if (text.isEmpty) return zero;
    return Money.tryParse(text) ?? zero;
  }

  /// From what a person typed, such as `2000` or `1,250.50`; null when it is
  /// not an amount.
  static Money? tryParse(String text) {
    final cleaned = text.replaceAll(',', '').replaceAll('₹', '').trim();
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(cleaned);
    if (match == null) return null;
    final rupees = int.parse(match.group(1)!);
    final paise = int.parse((match.group(2) ?? '').padRight(2, '0'));
    return Money(rupees * 100 + paise);
  }

  bool get isZero => paise == 0;
  bool get isPositive => paise > 0;

  Money operator +(Money other) => Money(paise + other.paise);
  Money operator -(Money other) => Money(paise - other.paise);

  /// What goes to the server: `2000.00`.
  String get wire =>
      '${paise ~/ 100}.${(paise % 100).toString().padLeft(2, '0')}';

  /// Shown to a person: `₹2,000`, or `₹1,250.50` when there are paise.
  String format() => NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: paise % 100 == 0 ? 0 : 2,
  ).format(paise / 100);

  @override
  int compareTo(Money other) => paise.compareTo(other.paise);

  @override
  List<Object?> get props => [paise];
}
