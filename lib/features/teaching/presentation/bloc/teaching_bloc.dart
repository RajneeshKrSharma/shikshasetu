import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/teaching_assignment.dart';
import '../../domain/usecases/teaching_usecases.dart';

sealed class TeachingEvent extends Equatable {
  const TeachingEvent();

  @override
  List<Object?> get props => const [];
}

final class TeachingLoaded extends TeachingEvent {
  const TeachingLoaded();
}

/// A teacher asks to teach a subject in a class.
final class SubjectRequested extends TeachingEvent {
  const SubjectRequested(this.params);

  final TeachingParams params;

  @override
  List<Object?> get props => [params];
}

/// The Principal gives a teacher a subject in a class.
final class SubjectAllotted extends TeachingEvent {
  const SubjectAllotted(this.params);

  final TeachingParams params;

  @override
  List<Object?> get props => [params];
}

final class AssignmentRemoved extends TeachingEvent {
  const AssignmentRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class TeachingState extends Equatable {
  const TeachingState({
    this.loading = true,
    this.assignments = const [],
    this.changeId = 0,
  });

  final bool loading;
  final List<TeachingAssignment> assignments;

  /// Goes up each time the user changed something, so it can be sent on.
  final int changeId;

  List<TeachingAssignment> of(String teacherId) => [
    for (final a in assignments)
      if (a.teacherId == teacherId) a,
  ];

  @override
  List<Object?> get props => [loading, assignments, changeId];
}

/// The subjects each teacher teaches, per class.
class TeachingBloc extends Bloc<TeachingEvent, TeachingState> {
  TeachingBloc({
    required GetTeachingAssignments getAssignments,
    required RequestSubject requestSubject,
    required AllotSubject allotSubject,
    required RemoveTeachingAssignment removeAssignment,
  }) : _get = getAssignments,
       _request = requestSubject,
       _allot = allotSubject,
       _remove = removeAssignment,
       super(const TeachingState()) {
    on<TeachingLoaded>((e, emit) async => emit(await _loaded()));
    on<SubjectRequested>((e, emit) async {
      await _request(e.params);
      emit(await _loaded(changed: true));
    });
    on<SubjectAllotted>((e, emit) async {
      await _allot(e.params);
      emit(await _loaded(changed: true));
    });
    on<AssignmentRemoved>((e, emit) async {
      await _remove(e.id);
      emit(await _loaded(changed: true));
    });
  }

  final GetTeachingAssignments _get;
  final RequestSubject _request;
  final AllotSubject _allot;
  final RemoveTeachingAssignment _remove;

  Future<TeachingState> _loaded({bool changed = false}) async => TeachingState(
    loading: false,
    assignments: await _get(const NoParams()),
    changeId: state.changeId + (changed ? 1 : 0),
  );
}
