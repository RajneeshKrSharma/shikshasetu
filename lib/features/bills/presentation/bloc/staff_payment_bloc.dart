import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/staff_bill.dart';
import '../../domain/entities/staff_settlement.dart';
import '../../domain/usecases/bills_usecases.dart';

// ---- who can be paid

class StaffPayablesCubit extends Cubit<StaffPayablesState> {
  StaffPayablesCubit({required GetStaffPayables getPayables})
    : _get = getPayables,
      super(const StaffPayablesState());

  final GetStaffPayables _get;

  Future<void> load() async => emit(
    StaffPayablesState(loading: false, staff: await _get(const NoParams())),
  );
}

class StaffPayablesState extends Equatable {
  const StaffPayablesState({this.loading = true, this.staff = const []});

  final bool loading;
  final List<StaffPayable> staff;

  @override
  List<Object?> get props => [loading, staff];
}

// ---- one person's payment

sealed class StaffPaymentEvent extends Equatable {
  const StaffPaymentEvent();

  @override
  List<Object?> get props => const [];
}

final class StaffPaymentStarted extends StaffPaymentEvent {
  const StaffPaymentStarted();
}

final class BillToggled extends StaffPaymentEvent {
  const BillToggled(this.billId);

  final String billId;

  @override
  List<Object?> get props => [billId];
}

class StaffPaymentState extends Equatable {
  const StaffPaymentState({
    this.loading = true,
    this.bills = const [],
    this.selected = const {},
  });

  final bool loading;
  final List<StaffBill> bills;

  /// Ids of the bills ticked to be paid.
  final Set<String> selected;

  /// Approved and not yet paid: these can be paid.
  List<StaffBill> get payable => [
    for (final b in bills)
      if (b.isPayable) b,
  ];

  /// Waiting for the Principal: locked.
  List<StaffBill> get waiting => [
    for (final b in bills)
      if (b.phase == BillPhase.pending) b,
  ];

  List<StaffBill> get chosen => [
    for (final b in payable)
      if (selected.contains(b.id)) b,
  ];

  int get payableTotal => payable.fold(0, (s, b) => s + b.amount);
  int get chosenTotal => chosen.fold(0, (s, b) => s + b.amount);

  @override
  List<Object?> get props => [loading, bills, selected];
}

/// What can be paid to one staff member now, and what is still locked.
class StaffPaymentBloc extends Bloc<StaffPaymentEvent, StaffPaymentState> {
  StaffPaymentBloc({required this.staffId, required GetBills getBills})
    : _get = getBills,
      super(const StaffPaymentState()) {
    on<StaffPaymentStarted>((e, emit) async {
      final bills = await _get(staffId);
      emit(
        StaffPaymentState(
          loading: false,
          bills: bills,
          // Everything that can be paid starts ticked.
          selected: {
            for (final b in bills)
              if (b.isPayable) b.id,
          },
        ),
      );
    });
    on<BillToggled>((e, emit) {
      final next = {...state.selected};
      if (!next.remove(e.billId)) next.add(e.billId);
      emit(
        StaffPaymentState(loading: false, bills: state.bills, selected: next),
      );
    });
  }

  final String staffId;
  final GetBills _get;
}
