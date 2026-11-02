import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/payments.dart';
import '../../domain/usecases/payments_usecases.dart';

sealed class MyAccountEvent extends Equatable {
  const MyAccountEvent();

  @override
  List<Object?> get props => const [];
}

final class MyAccountStarted extends MyAccountEvent {
  const MyAccountStarted();
}

class MyAccountState extends Equatable {
  const MyAccountState({
    this.status = ViewStatus.loading,
    this.failure,
    this.account,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final PersonAccount? account;

  @override
  List<Object?> get props => [status, failure, account];
}

class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState> {
  MyAccountBloc({required GetMyAccount getMyAccount})
    : _get = getMyAccount,
      super(const MyAccountState()) {
    on<MyAccountStarted>((e, emit) async {
      try {
        emit(
          MyAccountState(
            status: ViewStatus.ready,
            account: await _get(const NoPaymentParams()),
          ),
        );
      } on ServerException catch (error) {
        emit(
          MyAccountState(
            status: ViewStatus.failed,
            failure: ViewFailure.from(error),
          ),
        );
      }
    });
  }

  final GetMyAccount _get;
}
