import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/usecases/assign_class_teacher.dart';
import '../../domain/usecases/get_staff.dart';
import '../../domain/usecases/set_staff_active.dart';

sealed class StaffEvent extends Equatable {
  const StaffEvent();

  @override
  List<Object?> get props => const [];
}

final class StaffLoaded extends StaffEvent {
  const StaffLoaded();
}

final class StaffActiveChanged extends StaffEvent {
  const StaffActiveChanged(this.staffId, this.active);

  final String staffId;
  final bool active;

  @override
  List<Object?> get props => [staffId, active];
}

final class ClassTeacherAssigned extends StaffEvent {
  const ClassTeacherAssigned(this.staffId, this.classSection);

  final String staffId;

  /// Null removes the teacher's current class.
  final String? classSection;

  @override
  List<Object?> get props => [staffId, classSection];
}

class StaffState extends Equatable {
  const StaffState({this.loading = true, this.staff = const []});

  final bool loading;
  final List<StaffMember> staff;

  /// Teacher who is class teacher of [classSection], if any.
  StaffMember? classTeacherOf(String classSection) {
    for (final m in staff) {
      if (m.classSection == classSection) return m;
    }
    return null;
  }

  /// The class [staffId] is class teacher of, if any.
  String? classOf(String staffId) {
    for (final m in staff) {
      if (m.id == staffId) return m.classSection;
    }
    return null;
  }

  @override
  List<Object?> get props => [loading, staff];
}

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc({
    required GetStaff getStaff,
    required SetStaffActive setStaffActive,
    required AssignClassTeacher assignClassTeacher,
  }) : _getStaff = getStaff,
       _setActive = setStaffActive,
       _assign = assignClassTeacher,
       super(const StaffState()) {
    on<StaffLoaded>(_onLoaded);
    on<StaffActiveChanged>((e, emit) async {
      await _setActive(SetStaffActiveParams(e.staffId, e.active));
      await _onLoaded(const StaffLoaded(), emit);
    });
    on<ClassTeacherAssigned>((e, emit) async {
      await _assign(AssignClassTeacherParams(e.staffId, e.classSection));
      await _onLoaded(const StaffLoaded(), emit);
    });
  }

  final GetStaff _getStaff;
  final SetStaffActive _setActive;
  final AssignClassTeacher _assign;

  Future<void> _onLoaded(StaffEvent e, Emitter<StaffState> emit) async {
    emit(StaffState(loading: false, staff: await _getStaff(const NoParams())));
  }
}
