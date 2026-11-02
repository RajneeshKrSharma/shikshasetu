import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/payments.dart';
import '../../domain/usecases/payments_usecases.dart';

sealed class PersonAccountEvent extends Equatable {
  const PersonAccountEvent();

  @override
  List<Object?> get props => const [];
}

final class PersonAccountStarted extends PersonAccountEvent {
  const PersonAccountStarted();
}

final class SalarySet extends PersonAccountEvent {
  const SalarySet(this.params);

  final SetSalaryParams params;

  @override
  List<Object?> get props => [params];
}

final class PaymentMade extends PersonAccountEvent {
  const PaymentMade(this.draft);

  final PaymentDraft draft;

  @override
  List<Object?> get props => [draft];
}

class PersonAccountState extends Equatable {
  const PersonAccountState({
    this.status = ViewStatus.loading,
    this.failure,
    this.account,
    this.history = const [],
    this.canManage = false,
    this.busy = false,
    this.changedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final PersonAccount? account;
  final List<SalaryRate> history;
  final bool canManage;
  final bool busy;
  final int changedCount;

  PersonAccountState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    PersonAccount? account,
    List<SalaryRate>? history,
    bool? canManage,
    bool? busy,
    int? changedCount,
  }) => PersonAccountState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    account: account ?? this.account,
    history: history ?? this.history,
    canManage: canManage ?? this.canManage,
    busy: busy ?? this.busy,
    changedCount: changedCount ?? this.changedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    account,
    history,
    canManage,
    busy,
    changedCount,
  ];
}

/// One person's salary, fuel dues and payments; the Principal sets the
/// salary and pays.
class PersonAccountBloc extends Bloc<PersonAccountEvent, PersonAccountState> {
  PersonAccountBloc({
    required String personId,
    required bool canManage,
    required GetPersonAccount getPersonAccount,
    required GetSalaryHistory getSalaryHistory,
    required SetSalary setSalary,
    required PayPerson payPerson,
  }) : _id = personId,
       _canManage = canManage,
       _account = getPersonAccount,
       _history = getSalaryHistory,
       _setSalary = setSalary,
       _pay = payPerson,
       super(const PersonAccountState()) {
    on<PersonAccountStarted>((e, emit) async {
      try {
        emit(
          state.copyWith(
            status: ViewStatus.ready,
            account: await _account(_id),
            history: await _history(_id),
            canManage: _canManage,
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
    });
    on<SalarySet>((e, emit) => _change(emit, () => _setSalary(e.params)));
    on<PaymentMade>((e, emit) => _change(emit, () => _pay(e.draft)));
  }

  final String _id;
  final bool _canManage;
  final GetPersonAccount _account;
  final GetSalaryHistory _history;
  final SetSalary _setSalary;
  final PayPerson _pay;

  Future<void> _change(
    Emitter<PersonAccountState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(
        state.copyWith(
          busy: false,
          account: await _account(_id),
          history: await _history(_id),
          changedCount: state.changedCount + 1,
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
