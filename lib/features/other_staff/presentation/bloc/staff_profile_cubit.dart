import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bills/domain/entities/staff_settlement.dart';
import '../../../bills/domain/usecases/bills_usecases.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../members/domain/usecases/member_crud.dart';
import '../../domain/entities/other_staff.dart';

class StaffProfileState extends Equatable {
  const StaffProfileState({this.loading = true, this.staff, this.payable});

  final bool loading;

  /// Null when there is no such person.
  final OtherStaff? staff;

  /// What they can be paid now and what waits for approval; null when they
  /// have no bills.
  final StaffPayable? payable;

  @override
  List<Object?> get props => [loading, staff, payable];
}

/// One staff member's details, with where their bills and payment stand.
class StaffProfileCubit extends Cubit<StaffProfileState> {
  StaffProfileCubit({
    required this.staffId,
    required GetMember<OtherStaff> getStaff,
    required GetStaffPayables getPayables,
  }) : _getStaff = getStaff,
       _getPayables = getPayables,
       super(const StaffProfileState());

  final String staffId;
  final GetMember<OtherStaff> _getStaff;
  final GetStaffPayables _getPayables;

  Future<void> load() async {
    final staff = await _getStaff(staffId);
    final payables = await _getPayables(const NoParams());
    emit(
      StaffProfileState(
        loading: false,
        staff: staff,
        payable: payables.where((p) => p.staffId == staffId).firstOrNull,
      ),
    );
  }
}
