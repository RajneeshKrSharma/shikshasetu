import 'package:equatable/equatable.dart';

import 'fee_account.dart';

/// Everything one person owes, kept together: a student's academic, dress,
/// books and van fees; a teacher's or other staff member's payment.
class FeeLedger extends Equatable {
  const FeeLedger(this.accounts);

  /// At least one; all of the same person.
  final List<FeeAccount> accounts;

  FeeAccount get _first => accounts.first;

  String get personId => _first.personId ?? _first.id;
  String get name => _first.name;
  FeeGroup get group => _first.group;
  String get subtitle => _first.subtitle;
  String? get classSection => _first.classSection;
  int? get rollNo => _first.rollNo;

  int get total => accounts.fold(0, (s, a) => s + a.total);
  int get paid => accounts.fold(0, (s, a) => s + a.paid);
  int get pending => total - paid;

  /// How the person stands: the most urgent state of any of their fees.
  FeeStatus statusAt(DateTime now) {
    final statuses = [for (final a in accounts) a.statusAt(now)];
    for (final s in const [
      FeeStatus.overdue,
      FeeStatus.due,
      FeeStatus.partial,
    ]) {
      if (statuses.contains(s)) return s;
    }
    return FeeStatus.paid;
  }

  /// Their account for [head], if they have one.
  FeeAccount? of(FeeHead head) {
    for (final a in accounts) {
      if (a.head == head) return a;
    }
    return null;
  }

  /// One ledger per person, in the order the accounts come.
  static List<FeeLedger> groupByPerson(List<FeeAccount> accounts) {
    final byPerson = <String, List<FeeAccount>>{};
    for (final a in accounts) {
      byPerson.putIfAbsent(a.personId ?? a.id, () => []).add(a);
    }
    return [for (final list in byPerson.values) FeeLedger(list)];
  }

  @override
  List<Object?> get props => [accounts];
}
