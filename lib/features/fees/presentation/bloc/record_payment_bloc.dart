import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/fee_payment.dart';
import '../../domain/entities/payment_draft.dart';
import '../../domain/usecases/record_payment.dart';

sealed class RecordPaymentEvent extends Equatable {
  const RecordPaymentEvent();

  @override
  List<Object?> get props => const [];
}

final class PaymentModeChosen extends RecordPaymentEvent {
  const PaymentModeChosen(this.mode);

  final PaymentMode mode;

  @override
  List<Object?> get props => [mode];
}

final class PaymentDateChosen extends RecordPaymentEvent {
  const PaymentDateChosen(this.day);

  final DateTime day;

  @override
  List<Object?> get props => [day];
}

final class PaymentSubmitted extends RecordPaymentEvent {
  const PaymentSubmitted({
    required this.amount,
    this.reference,
    this.proofPath,
  });

  final int amount;
  final String? reference;
  final String? proofPath;

  @override
  List<Object?> get props => [amount, reference, proofPath];
}

class RecordPaymentState extends Equatable {
  const RecordPaymentState({
    required this.day,
    this.mode = PaymentMode.cash,
    this.saving = false,
    this.problem,
    this.recorded,
  });

  final DateTime day;
  final PaymentMode mode;
  final bool saving;

  /// Why the last attempt was refused.
  final PaymentProblem? problem;

  /// The payment, once it is saved.
  final FeePayment? recorded;

  RecordPaymentState copyWith({
    DateTime? day,
    PaymentMode? mode,
    bool? saving,
    PaymentProblem? problem,
    bool clearProblem = false,
    FeePayment? recorded,
  }) => RecordPaymentState(
    day: day ?? this.day,
    mode: mode ?? this.mode,
    saving: saving ?? this.saving,
    problem: clearProblem ? null : (problem ?? this.problem),
    recorded: recorded ?? this.recorded,
  );

  @override
  List<Object?> get props => [day, mode, saving, problem, recorded];
}

/// Recording one payment against one fee.
class RecordPaymentBloc extends Bloc<RecordPaymentEvent, RecordPaymentState> {
  RecordPaymentBloc({
    required this.accountId,
    required RecordPayment recordPayment,
    DateTime Function()? now,
  }) : _record = recordPayment,
       _now = now ?? DateTime.now,
       super(RecordPaymentState(day: (now ?? DateTime.now)())) {
    on<PaymentModeChosen>(
      (e, emit) => emit(state.copyWith(mode: e.mode, clearProblem: true)),
    );
    on<PaymentDateChosen>((e, emit) => emit(state.copyWith(day: e.day)));
    on<PaymentSubmitted>(_onSubmitted);
  }

  final String accountId;
  final RecordPayment _record;
  final DateTime Function() _now;

  Future<void> _onSubmitted(
    PaymentSubmitted e,
    Emitter<RecordPaymentState> emit,
  ) async {
    emit(state.copyWith(saving: true, clearProblem: true));
    try {
      final now = _now();
      // The chosen day, at the time of day it is now.
      final at = DateTime(
        state.day.year,
        state.day.month,
        state.day.day,
        now.hour,
        now.minute,
      );
      final payment = await _record(
        RecordPaymentParams(
          accountId: accountId,
          amount: e.amount,
          at: at,
          mode: state.mode,
          reference: e.reference,
          proofPath: e.proofPath,
        ),
      );
      emit(state.copyWith(saving: false, recorded: payment));
    } on PaymentException catch (x) {
      emit(state.copyWith(saving: false, problem: x.problem));
    }
  }
}
