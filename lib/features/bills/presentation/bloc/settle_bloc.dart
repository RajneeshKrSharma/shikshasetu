import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../fees/domain/entities/fee_payment.dart';
import '../../../fees/domain/entities/payment_draft.dart';
import '../../domain/entities/bill_drafts.dart';
import '../../domain/entities/staff_bill.dart';
import '../../domain/entities/staff_settlement.dart';
import '../../domain/usecases/bills_usecases.dart';

/// What a [SettleBloc] pays: whose bills, and which.
class SettleArgs extends Equatable {
  const SettleArgs({
    required this.staffId,
    required this.staffName,
    required this.bills,
    this.vehicleNumber,
  });

  final String staffId;
  final String staffName;
  final String? vehicleNumber;
  final List<StaffBill> bills;

  int get total => bills.fold(0, (s, b) => s + b.amount);

  @override
  List<Object?> get props => [staffId, staffName, vehicleNumber, bills];
}

sealed class SettleEvent extends Equatable {
  const SettleEvent();

  @override
  List<Object?> get props => const [];
}

final class SettleModeChosen extends SettleEvent {
  const SettleModeChosen(this.mode);

  final PaymentMode mode;

  @override
  List<Object?> get props => [mode];
}

final class SettleDateChosen extends SettleEvent {
  const SettleDateChosen(this.day);

  final DateTime day;

  @override
  List<Object?> get props => [day];
}

final class SettleConfirmed extends SettleEvent {
  const SettleConfirmed({required this.paidBy, this.reference, this.proofPath});

  final String paidBy;
  final String? reference;
  final String? proofPath;

  @override
  List<Object?> get props => [paidBy, reference, proofPath];
}

class SettleState extends Equatable {
  const SettleState({
    required this.day,
    this.mode = PaymentMode.cash,
    this.saving = false,
    this.paymentProblem,
    this.settleProblem,
    this.settled,
  });

  final DateTime day;
  final PaymentMode mode;
  final bool saving;
  final PaymentProblem? paymentProblem;
  final SettleProblem? settleProblem;
  final StaffSettlement? settled;

  SettleState copyWith({
    DateTime? day,
    PaymentMode? mode,
    bool? saving,
    PaymentProblem? paymentProblem,
    SettleProblem? settleProblem,
    bool clearProblems = false,
    StaffSettlement? settled,
  }) => SettleState(
    day: day ?? this.day,
    mode: mode ?? this.mode,
    saving: saving ?? this.saving,
    paymentProblem: clearProblems
        ? null
        : (paymentProblem ?? this.paymentProblem),
    settleProblem: clearProblems ? null : (settleProblem ?? this.settleProblem),
    settled: settled ?? this.settled,
  );

  @override
  List<Object?> get props => [
    day,
    mode,
    saving,
    paymentProblem,
    settleProblem,
    settled,
  ];
}

/// Paying approved bills: how, when, with what proof.
class SettleBloc extends Bloc<SettleEvent, SettleState> {
  SettleBloc({
    required this.args,
    required SettleBills settleBills,
    DateTime Function()? now,
  }) : _settle = settleBills,
       _now = now ?? DateTime.now,
       super(SettleState(day: (now ?? DateTime.now)())) {
    on<SettleModeChosen>(
      (e, emit) => emit(state.copyWith(mode: e.mode, clearProblems: true)),
    );
    on<SettleDateChosen>((e, emit) => emit(state.copyWith(day: e.day)));
    on<SettleConfirmed>(_onConfirmed);
  }

  final SettleArgs args;
  final SettleBills _settle;
  final DateTime Function() _now;

  Future<void> _onConfirmed(
    SettleConfirmed e,
    Emitter<SettleState> emit,
  ) async {
    emit(state.copyWith(saving: true, clearProblems: true));
    try {
      final now = _now();
      final settlement = await _settle(
        SettleBillsParams(
          staffId: args.staffId,
          bills: args.bills,
          mode: state.mode,
          paidBy: e.paidBy,
          at: DateTime(
            state.day.year,
            state.day.month,
            state.day.day,
            now.hour,
            now.minute,
          ),
          reference: e.reference,
          proofPath: e.proofPath,
        ),
      );
      emit(state.copyWith(saving: false, settled: settlement));
    } on PaymentException catch (x) {
      emit(state.copyWith(saving: false, paymentProblem: x.problem));
    } on SettleException catch (x) {
      emit(state.copyWith(saving: false, settleProblem: x.problem));
    }
  }
}
