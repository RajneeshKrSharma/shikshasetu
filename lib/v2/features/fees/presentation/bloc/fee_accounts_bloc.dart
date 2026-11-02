import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../domain/entities/fees.dart';
import '../../domain/usecases/fees_usecases.dart';

sealed class FeeAccountsEvent extends Equatable {
  const FeeAccountsEvent();

  @override
  List<Object?> get props => const [];
}

final class FeeAccountsStarted extends FeeAccountsEvent {
  const FeeAccountsStarted();
}

final class FeeAccountsFiltered extends FeeAccountsEvent {
  const FeeAccountsFiltered(this.filter);

  final FeeAccountsParams filter;

  @override
  List<Object?> get props => [filter];
}

class FeeAccountsState extends Equatable {
  const FeeAccountsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.accounts = const [],
    this.classes = const [],
    this.filter = const FeeAccountsParams(),
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<FeeStatement> accounts;
  final List<SchoolClass> classes;
  final FeeAccountsParams filter;

  FeeAccountsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<FeeStatement>? accounts,
    List<SchoolClass>? classes,
    FeeAccountsParams? filter,
  }) => FeeAccountsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    accounts: accounts ?? this.accounts,
    classes: classes ?? this.classes,
    filter: filter ?? this.filter,
  );

  @override
  List<Object?> get props => [status, failure, accounts, classes, filter];
}

class FeeAccountsBloc extends Bloc<FeeAccountsEvent, FeeAccountsState> {
  FeeAccountsBloc({
    required GetFeeAccounts getFeeAccounts,
    required GetClasses getClasses,
  }) : _accounts = getFeeAccounts,
       _classes = getClasses,
       super(const FeeAccountsState()) {
    on<FeeAccountsStarted>((e, emit) async {
      try {
        emit(state.copyWith(classes: await _classes(const NoParams())));
      } on ServerException catch (error) {
        emit(
          state.copyWith(
            status: ViewStatus.failed,
            failure: ViewFailure.from(error),
          ),
        );
        return;
      }
      await _load(emit, state.filter);
    });
    on<FeeAccountsFiltered>((e, emit) => _load(emit, e.filter));
  }

  final GetFeeAccounts _accounts;
  final GetClasses _classes;

  Future<void> _load(
    Emitter<FeeAccountsState> emit,
    FeeAccountsParams filter,
  ) async {
    emit(
      state.copyWith(
        status: ViewStatus.loading,
        filter: filter,
        clearFailure: true,
      ),
    );
    try {
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          accounts: await _accounts(filter),
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
}
