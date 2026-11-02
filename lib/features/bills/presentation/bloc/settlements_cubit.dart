import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/staff_settlement.dart';
import '../../domain/usecases/bills_usecases.dart';

class SettlementsState extends Equatable {
  const SettlementsState({this.loading = true, this.settlements = const []});

  final bool loading;

  /// Newest first.
  final List<StaffSettlement> settlements;

  @override
  List<Object?> get props => [loading, settlements];
}

/// Every payment made to staff for their bills, with its proof.
class SettlementsCubit extends Cubit<SettlementsState> {
  SettlementsCubit({required this.staffId, required GetSettlements getAll})
    : _get = getAll,
      super(const SettlementsState());

  final String? staffId;
  final GetSettlements _get;

  Future<void> load() async =>
      emit(SettlementsState(loading: false, settlements: await _get(staffId)));
}
