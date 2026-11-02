import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/usecases/members_usecases.dart';
import '../../../session/domain/entities/account.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../domain/entities/teaching.dart';
import '../../domain/usecases/teaching_usecases.dart';

sealed class AllotmentsEvent extends Equatable {
  const AllotmentsEvent();

  @override
  List<Object?> get props => const [];
}

final class AllotmentsStarted extends AllotmentsEvent {
  const AllotmentsStarted();
}

final class ClassAllotted extends AllotmentsEvent {
  const ClassAllotted(this.draft);

  final AllotmentDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class AllotmentRemoved extends AllotmentsEvent {
  const AllotmentRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class AllotmentsState extends Equatable {
  const AllotmentsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.allotments = const [],
    this.teachers = const [],
    this.classes = const [],
    this.canAllot = false,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Allotment> allotments;
  final List<Member> teachers;
  final List<SchoolClass> classes;
  final bool canAllot;
  final bool busy;

  AllotmentsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<Allotment>? allotments,
    List<Member>? teachers,
    List<SchoolClass>? classes,
    bool? canAllot,
    bool? busy,
  }) => AllotmentsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    allotments: allotments ?? this.allotments,
    teachers: teachers ?? this.teachers,
    classes: classes ?? this.classes,
    canAllot: canAllot ?? this.canAllot,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    allotments,
    teachers,
    classes,
    canAllot,
    busy,
  ];
}

class AllotmentsBloc extends Bloc<AllotmentsEvent, AllotmentsState> {
  AllotmentsBloc({
    required Account account,
    required GetAllotments getAllotments,
    required AllotClass allotClass,
    required RemoveAllotment removeAllotment,
    required GetMembers getTeachers,
    required GetClasses getClasses,
  }) : _account = account,
       _get = getAllotments,
       _allot = allotClass,
       _remove = removeAllotment,
       _teachers = getTeachers,
       _classes = getClasses,
       super(const AllotmentsState()) {
    on<AllotmentsStarted>(_onStarted);
    on<ClassAllotted>((e, emit) => _change(emit, () => _allot(e.draft)));
    on<AllotmentRemoved>((e, emit) => _change(emit, () => _remove(e.id)));
  }

  final Account _account;
  final GetAllotments _get;
  final AllotClass _allot;
  final RemoveAllotment _remove;
  final GetMembers _teachers;
  final GetClasses _classes;

  Future<void> _onStarted(
    AllotmentsStarted e,
    Emitter<AllotmentsState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          allotments: await _get(null),
          teachers: await _teachers(const GetMembersParams()),
          classes: await _classes(const NoParams()),
          canAllot: TeachingAccess.of(_account).canAllot,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _change(
    Emitter<AllotmentsState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(state.copyWith(busy: false, allotments: await _get(null)));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
