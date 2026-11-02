import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_range.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_ledger.dart';

enum FeeSort { urgency, name, pending, dueDate }

/// Everything that narrows and orders one tab's accounts. An empty set means
/// "no restriction", so filters combine with AND across kinds and OR within
/// one kind (e.g. class 5-A or 6-B, and overdue or partial).
class FeeFilterState extends Equatable {
  const FeeFilterState({
    this.query = '',
    this.statuses = const {},
    this.classes = const {},
    this.dueRange,
    this.sort = FeeSort.urgency,
  });

  final String query;
  final Set<FeeStatus> statuses;
  final Set<String> classes;

  /// Accounts due on any day of this range (a single day is allowed).
  final DateTimeRange? dueRange;
  final FeeSort sort;

  /// How many filters are on, not counting the search text and the sort.
  int get activeCount =>
      statuses.length + classes.length + (dueRange == null ? 0 : 1);

  bool get isFiltering => activeCount > 0 || query.trim().isNotEmpty;

  FeeFilterState copyWith({
    String? query,
    Set<FeeStatus>? statuses,
    Set<String>? classes,
    DateTimeRange? dueRange,
    bool clearDueRange = false,
    FeeSort? sort,
  }) => FeeFilterState(
    query: query ?? this.query,
    statuses: statuses ?? this.statuses,
    classes: classes ?? this.classes,
    dueRange: clearDueRange ? null : (dueRange ?? this.dueRange),
    sort: sort ?? this.sort,
  );

  /// People whose fees match every filter, in the chosen order. A person
  /// counts as due in a range if any of their fees is.
  List<FeeLedger> applyToLedgers(List<FeeLedger> ledgers, DateTime now) {
    int urgency(FeeStatus s) => switch (s) {
      FeeStatus.overdue => 0,
      FeeStatus.due => 1,
      FeeStatus.partial => 2,
      FeeStatus.paid => 3,
    };
    final q = query.trim().toLowerCase();
    bool matches(FeeLedger l) =>
        l.name.toLowerCase().contains(q) &&
        (statuses.isEmpty || statuses.contains(l.statusAt(now))) &&
        (classes.isEmpty || classes.contains(l.classSection)) &&
        (dueRange == null ||
            l.accounts.any((a) => DateRanges.contains(dueRange!, a.dueDate)));

    int byName(FeeLedger a, FeeLedger b) =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase());
    return ledgers.where(matches).toList()..sort((a, b) {
      final primary = switch (sort) {
        FeeSort.urgency => urgency(
          a.statusAt(now),
        ).compareTo(urgency(b.statusAt(now))),
        FeeSort.name => 0,
        FeeSort.pending => b.pending.compareTo(a.pending),
        FeeSort.dueDate =>
          a.accounts
              .map((x) => x.dueDate)
              .reduce((x, y) => x.isBefore(y) ? x : y)
              .compareTo(
                b.accounts
                    .map((x) => x.dueDate)
                    .reduce((x, y) => x.isBefore(y) ? x : y),
              ),
      };
      return primary != 0 ? primary : byName(a, b);
    });
  }

  /// Accounts matching every filter, in the chosen order.
  List<FeeAccount> apply(List<FeeAccount> accounts, DateTime now) {
    int urgency(FeeStatus s) => switch (s) {
      FeeStatus.overdue => 0,
      FeeStatus.due => 1,
      FeeStatus.partial => 2,
      FeeStatus.paid => 3,
    };
    final q = query.trim().toLowerCase();
    bool matches(FeeAccount a) =>
        a.name.toLowerCase().contains(q) &&
        (statuses.isEmpty || statuses.contains(a.statusAt(now))) &&
        (classes.isEmpty || classes.contains(a.classSection)) &&
        (dueRange == null || DateRanges.contains(dueRange!, a.dueDate));

    int byName(FeeAccount a, FeeAccount b) =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase());
    return accounts.where(matches).toList()..sort((a, b) {
      final primary = switch (sort) {
        FeeSort.urgency => urgency(
          a.statusAt(now),
        ).compareTo(urgency(b.statusAt(now))),
        FeeSort.name => 0,
        FeeSort.pending => b.pending.compareTo(a.pending),
        FeeSort.dueDate => a.dueDate.compareTo(b.dueDate),
      };
      return primary != 0 ? primary : byName(a, b);
    });
  }

  @override
  List<Object?> get props => [query, statuses, classes, dueRange, sort];
}

/// Search, filters and sort of one fees tab.
class FeeFilterCubit extends Cubit<FeeFilterState> {
  FeeFilterCubit() : super(const FeeFilterState());

  void search(String query) => emit(state.copyWith(query: query));

  void toggleStatus(FeeStatus status) =>
      emit(state.copyWith(statuses: {...state.statuses}..toggle(status)));

  /// Shows one status only, or every status when [status] is null.
  void chooseStatus(FeeStatus? status) =>
      emit(state.copyWith(statuses: status == null ? <FeeStatus>{} : {status}));

  /// Shows one class only, or every class when [name] is null.
  void chooseClass(String? name) =>
      emit(state.copyWith(classes: name == null ? <String>{} : {name}));

  void toggleClass(String name) =>
      emit(state.copyWith(classes: {...state.classes}..toggle(name)));

  void setDueRange(DateTimeRange? range) => emit(
    range == null
        ? state.copyWith(clearDueRange: true)
        : state.copyWith(dueRange: range),
  );

  void setSort(FeeSort sort) => emit(state.copyWith(sort: sort));

  /// Drops every filter and the search text; the sort stays.
  void clear() => emit(
    state.copyWith(query: '', statuses: {}, classes: {}, clearDueRange: true),
  );
}

extension _Toggle<T> on Set<T> {
  void toggle(T v) => contains(v) ? remove(v) : add(v);
}
