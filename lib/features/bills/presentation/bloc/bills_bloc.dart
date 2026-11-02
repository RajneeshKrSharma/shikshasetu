import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/staff_bill.dart';
import '../../domain/usecases/bills_usecases.dart';

sealed class BillsEvent extends Equatable {
  const BillsEvent();

  @override
  List<Object?> get props => const [];
}

final class BillsStarted extends BillsEvent {
  const BillsStarted();
}

/// Show one phase only; null shows all.
final class BillsTabChosen extends BillsEvent {
  const BillsTabChosen(this.phase);

  final BillPhase? phase;

  @override
  List<Object?> get props => [phase];
}

class BillsState extends Equatable {
  const BillsState({this.loading = true, this.bills = const [], this.tab});

  final bool loading;
  final List<StaffBill> bills;
  final BillPhase? tab;

  List<StaffBill> get visible => [
    for (final b in bills)
      if (tab == null || b.phase == tab) b,
  ];

  int countOf(BillPhase? phase) => phase == null
      ? bills.length
      : bills.where((b) => b.phase == phase).length;

  @override
  List<Object?> get props => [loading, bills, tab];
}

/// The fuel bills of one staff member, or of everyone, by where they stand.
class BillsBloc extends Bloc<BillsEvent, BillsState> {
  BillsBloc({required this.staffId, required GetBills getBills})
    : _get = getBills,
      super(const BillsState()) {
    on<BillsStarted>(
      (e, emit) async => emit(
        BillsState(loading: false, bills: await _get(staffId), tab: state.tab),
      ),
    );
    on<BillsTabChosen>(
      (e, emit) =>
          emit(BillsState(loading: false, bills: state.bills, tab: e.phase)),
    );
  }

  final String? staffId;
  final GetBills _get;
}
