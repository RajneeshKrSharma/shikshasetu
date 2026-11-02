import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/change_fee_dates.dart';

class FeeDatesState extends Equatable {
  const FeeDatesState({this.saving = false, this.saved = false});

  final bool saving;
  final bool saved;

  @override
  List<Object?> get props => [saving, saved];
}

/// Giving one student's fee dates of its own.
class FeeDatesCubit extends Cubit<FeeDatesState> {
  FeeDatesCubit({required this.accountId, required ChangeFeeDates changeDates})
    : _change = changeDates,
      super(const FeeDatesState());

  final String accountId;
  final ChangeFeeDates _change;

  Future<void> save({
    required DateTime dueDate,
    DateTime? lastDate,
    required String note,
  }) async {
    emit(const FeeDatesState(saving: true));
    await _change(
      ChangeFeeDatesParams(
        accountId: accountId,
        dueDate: dueDate,
        lastDate: lastDate,
        note: note,
      ),
    );
    emit(const FeeDatesState(saved: true));
  }
}
