import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bill_drafts.dart';
import '../../domain/entities/staff_bill.dart';
import '../../domain/usecases/bills_usecases.dart';

sealed class AddBillEvent extends Equatable {
  const AddBillEvent();

  @override
  List<Object?> get props => const [];
}

final class FuelKindChosen extends AddBillEvent {
  const FuelKindChosen(this.kind);

  final FuelKind kind;

  @override
  List<Object?> get props => [kind];
}

final class BillDateChosen extends AddBillEvent {
  const BillDateChosen(this.day);

  final DateTime day;

  @override
  List<Object?> get props => [day];
}

final class BillSubmitted extends AddBillEvent {
  const BillSubmitted({
    required this.amount,
    this.litres,
    this.note = '',
    this.photoPath,
  });

  final int amount;
  final double? litres;
  final String note;
  final String? photoPath;

  @override
  List<Object?> get props => [amount, litres, note, photoPath];
}

class AddBillState extends Equatable {
  const AddBillState({
    required this.day,
    this.kind = FuelKind.diesel,
    this.saving = false,
    this.problem,
    this.saved,
  });

  final DateTime day;
  final FuelKind kind;
  final bool saving;
  final BillProblem? problem;
  final StaffBill? saved;

  AddBillState copyWith({
    DateTime? day,
    FuelKind? kind,
    bool? saving,
    BillProblem? problem,
    bool clearProblem = false,
    StaffBill? saved,
  }) => AddBillState(
    day: day ?? this.day,
    kind: kind ?? this.kind,
    saving: saving ?? this.saving,
    problem: clearProblem ? null : (problem ?? this.problem),
    saved: saved ?? this.saved,
  );

  @override
  List<Object?> get props => [day, kind, saving, problem, saved];
}

/// Sending one fuel bill for approval.
class AddBillBloc extends Bloc<AddBillEvent, AddBillState> {
  AddBillBloc({
    required this.staffId,
    required AddBill addBill,
    DateTime Function()? now,
  }) : _add = addBill,
       super(AddBillState(day: (now ?? DateTime.now)())) {
    on<FuelKindChosen>((e, emit) => emit(state.copyWith(kind: e.kind)));
    on<BillDateChosen>((e, emit) => emit(state.copyWith(day: e.day)));
    on<BillSubmitted>(_onSubmitted);
  }

  final String staffId;
  final AddBill _add;

  Future<void> _onSubmitted(BillSubmitted e, Emitter<AddBillState> emit) async {
    emit(state.copyWith(saving: true, clearProblem: true));
    try {
      final bill = await _add(
        BillDraft(
          staffId: staffId,
          kind: state.kind,
          date: state.day,
          amount: e.amount,
          litres: e.litres,
          photoPath: e.photoPath,
          note: e.note,
        ),
      );
      emit(state.copyWith(saving: false, saved: bill));
    } on BillException catch (x) {
      emit(state.copyWith(saving: false, problem: x.problem));
    }
  }
}
