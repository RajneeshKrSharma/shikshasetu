import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/payments.dart';
import '../../domain/usecases/payments_usecases.dart';

sealed class PayeesEvent extends Equatable {
  const PayeesEvent();

  @override
  List<Object?> get props => const [];
}

final class PayeesStarted extends PayeesEvent {
  const PayeesStarted();
}

final class PayeesSearched extends PayeesEvent {
  const PayeesSearched(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class PayeesState extends Equatable {
  const PayeesState({
    this.status = ViewStatus.loading,
    this.failure,
    this.payees = const [],
    this.query = '',
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<Payee> payees;
  final String query;

  @override
  List<Object?> get props => [status, failure, payees, query];
}

/// The people of one group the school pays, with what each is owed.
class PayeesBloc extends Bloc<PayeesEvent, PayeesState> {
  PayeesBloc({required PayeeGroup group, required GetPayees getPayees})
    : _group = group,
      _get = getPayees,
      super(const PayeesState()) {
    on<PayeesStarted>((e, emit) => _load(emit, state.query));
    on<PayeesSearched>((e, emit) => _load(emit, e.query));
  }

  final PayeeGroup _group;
  final GetPayees _get;

  Future<void> _load(Emitter<PayeesState> emit, String query) async {
    emit(PayeesState(query: query, payees: state.payees));
    try {
      emit(
        PayeesState(
          status: ViewStatus.ready,
          query: query,
          payees: await _get(GetPayeesParams(_group, query: query)),
        ),
      );
    } on ServerException catch (error) {
      emit(
        PayeesState(
          status: ViewStatus.failed,
          query: query,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }
}
