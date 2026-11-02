import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/get_people.dart';

sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => const [];
}

final class PeopleLoaded extends RegistrationEvent {
  const PeopleLoaded();
}

/// Narrows the list to one type; null shows everyone.
final class PersonFilterChanged extends RegistrationEvent {
  const PersonFilterChanged(this.type);

  final PersonType? type;

  @override
  List<Object?> get props => [type];
}

class RegistrationState extends Equatable {
  const RegistrationState({
    this.loading = true,
    this.people = const [],
    this.filter,
  });

  final bool loading;
  final List<Person> people;
  final PersonType? filter;

  List<Person> get visible =>
      filter == null ? people : people.where((p) => p.type == filter).toList();

  RegistrationState copyWith({
    bool? loading,
    List<Person>? people,
    PersonType? filter,
    bool clearFilter = false,
  }) => RegistrationState(
    loading: loading ?? this.loading,
    people: people ?? this.people,
    filter: clearFilter ? null : (filter ?? this.filter),
  );

  @override
  List<Object?> get props => [loading, people, filter];
}

/// The registry of everyone registered, with a type filter.
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({required GetPeople getPeople})
    : _getPeople = getPeople,
      super(const RegistrationState()) {
    on<PeopleLoaded>(
      (e, emit) async => emit(
        state.copyWith(
          loading: false,
          people: await _getPeople(const NoParams()),
        ),
      ),
    );
    on<PersonFilterChanged>(
      (e, emit) => emit(
        e.type == null
            ? state.copyWith(clearFilter: true)
            : state.copyWith(filter: e.type),
      ),
    );
  }

  final GetPeople _getPeople;
}
