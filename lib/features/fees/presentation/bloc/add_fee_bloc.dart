import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_person.dart';
import '../../domain/usecases/create_fee_account.dart';
import '../../domain/usecases/get_fee_people.dart';

sealed class AddFeeEvent extends Equatable {
  const AddFeeEvent();

  @override
  List<Object?> get props => const [];
}

final class AddFeeStarted extends AddFeeEvent {
  const AddFeeStarted();
}

final class FeeGroupChanged extends AddFeeEvent {
  const FeeGroupChanged(this.group);

  final FeeGroup group;

  @override
  List<Object?> get props => [group];
}

final class FeePersonChosen extends AddFeeEvent {
  const FeePersonChosen(this.person);

  final FeePerson? person;

  @override
  List<Object?> get props => [person];
}

final class FeeDueDateChosen extends AddFeeEvent {
  const FeeDueDateChosen(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class FeeSubmitted extends AddFeeEvent {
  const FeeSubmitted(this.total);

  final int total;

  @override
  List<Object?> get props => [total];
}

class AddFeeState extends Equatable {
  const AddFeeState({
    required this.dueDate,
    this.group = FeeGroup.student,
    this.peopleLoaded = false,
    this.people = const [],
    this.person,
    this.saving = false,
    this.saved = false,
  });

  final FeeGroup group;

  /// The list of people without a fee has been read at least once.
  final bool peopleLoaded;
  final List<FeePerson> people;
  final FeePerson? person;
  final DateTime dueDate;
  final bool saving;
  final bool saved;

  AddFeeState copyWith({
    FeeGroup? group,
    bool? peopleLoaded,
    List<FeePerson>? people,
    FeePerson? person,
    bool clearPerson = false,
    DateTime? dueDate,
    bool? saving,
    bool? saved,
  }) => AddFeeState(
    group: group ?? this.group,
    peopleLoaded: peopleLoaded ?? this.peopleLoaded,
    people: people ?? this.people,
    person: clearPerson ? null : (person ?? this.person),
    dueDate: dueDate ?? this.dueDate,
    saving: saving ?? this.saving,
    saved: saved ?? this.saved,
  );

  @override
  List<Object?> get props => [
    group,
    peopleLoaded,
    people,
    person,
    dueDate,
    saving,
    saved,
  ];
}

/// Assigns a fee to a student, teacher or other staff member.
class AddFeeBloc extends Bloc<AddFeeEvent, AddFeeState> {
  AddFeeBloc({
    required GetFeePeople getFeePeople,
    required CreateFeeAccount createFeeAccount,
    DateTime Function()? now,
  }) : _getPeople = getFeePeople,
       _create = createFeeAccount,
       super(
         AddFeeState(
           dueDate: (now ?? DateTime.now)().add(const Duration(days: 30)),
         ),
       ) {
    on<AddFeeStarted>(_onStarted);
    on<FeeGroupChanged>(_onGroup);
    on<FeePersonChosen>(
      (e, emit) => emit(
        e.person == null
            ? state.copyWith(clearPerson: true)
            : state.copyWith(person: e.person),
      ),
    );
    on<FeeDueDateChosen>((e, emit) => emit(state.copyWith(dueDate: e.date)));
    on<FeeSubmitted>(_onSubmitted);
  }

  final GetFeePeople _getPeople;
  final CreateFeeAccount _create;

  Future<void> _onStarted(AddFeeStarted e, Emitter<AddFeeState> emit) async {
    emit(
      state.copyWith(peopleLoaded: true, people: await _getPeople(state.group)),
    );
  }

  Future<void> _onGroup(FeeGroupChanged e, Emitter<AddFeeState> emit) async {
    emit(
      state.copyWith(
        group: e.group,
        clearPerson: true,
        peopleLoaded: false,
        people: const [],
      ),
    );
    emit(state.copyWith(peopleLoaded: true, people: await _getPeople(e.group)));
  }

  Future<void> _onSubmitted(FeeSubmitted e, Emitter<AddFeeState> emit) async {
    emit(state.copyWith(saving: true));
    await _create(
      CreateFeeAccountParams(
        group: state.group,
        person: state.person!,
        total: e.total,
        dueDate: state.dueDate,
      ),
    );
    emit(state.copyWith(saving: false, saved: true));
  }
}
