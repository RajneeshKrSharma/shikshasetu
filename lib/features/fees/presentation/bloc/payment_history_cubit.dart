import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_range.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_payment_record.dart';
import '../../domain/usecases/get_payment_history.dart';

class PaymentHistoryState extends Equatable {
  const PaymentHistoryState({
    this.loading = true,
    this.records = const [],
    this.query = '',
    this.groups = const {},
    this.classes = const {},
    this.range,
  });

  final bool loading;
  final List<FeePaymentRecord> records;
  final String query;
  final Set<FeeGroup> groups;
  final Set<String> classes;

  /// Payments made on any day of this range (a single day is allowed).
  final DateTimeRange? range;

  int get activeCount =>
      groups.length + classes.length + (range == null ? 0 : 1);

  /// Classes that appear in the history, in natural order.
  List<String> get classOptions {
    final names = {
      for (final r in records)
        if (r.classSection != null) r.classSection!,
    }.toList();
    int number(String s) =>
        int.tryParse(RegExp(r'\d+').firstMatch(s)?.group(0) ?? '') ?? 0;
    return names..sort((a, b) {
      final byNumber = number(a).compareTo(number(b));
      return byNumber != 0 ? byNumber : a.compareTo(b);
    });
  }

  List<FeePaymentRecord> get visible {
    final q = query.trim().toLowerCase();
    return [
      for (final r in records)
        if (r.personName.toLowerCase().contains(q) &&
            (groups.isEmpty || groups.contains(r.group)) &&
            (classes.isEmpty || classes.contains(r.classSection)) &&
            (range == null || DateRanges.contains(range!, r.payment.paidAt)))
          r,
    ];
  }

  int get visibleTotal => visible.fold(0, (s, r) => s + r.payment.amount);

  PaymentHistoryState copyWith({
    bool? loading,
    List<FeePaymentRecord>? records,
    String? query,
    Set<FeeGroup>? groups,
    Set<String>? classes,
    DateTimeRange? range,
    bool clearRange = false,
  }) => PaymentHistoryState(
    loading: loading ?? this.loading,
    records: records ?? this.records,
    query: query ?? this.query,
    groups: groups ?? this.groups,
    classes: classes ?? this.classes,
    range: clearRange ? null : (range ?? this.range),
  );

  @override
  List<Object?> get props => [loading, records, query, groups, classes, range];
}

/// Every payment, filtered by who paid, class and the day it was paid.
/// With a [personId] it shows only that person's payments.
class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  PaymentHistoryCubit({
    required GetPaymentHistory getPaymentHistory,
    this.personId,
  }) : _get = getPaymentHistory,
       super(const PaymentHistoryState());

  final GetPaymentHistory _get;
  final String? personId;

  Future<void> load() async {
    final all = await _get(const NoParams());
    emit(
      state.copyWith(
        loading: false,
        records: [
          for (final r in all)
            if (personId == null || r.personId == personId) r,
        ],
      ),
    );
  }

  void search(String query) => emit(state.copyWith(query: query));

  void toggleGroup(FeeGroup g) =>
      emit(state.copyWith(groups: _toggled(state.groups, g)));

  void toggleClass(String c) =>
      emit(state.copyWith(classes: _toggled(state.classes, c)));

  void setRange(DateTimeRange? range) => emit(
    range == null
        ? state.copyWith(clearRange: true)
        : state.copyWith(range: range),
  );

  void clear() => emit(
    state.copyWith(query: '', groups: {}, classes: {}, clearRange: true),
  );

  Set<T> _toggled<T>(Set<T> set, T v) =>
      set.contains(v) ? ({...set}..remove(v)) : {...set, v};
}
