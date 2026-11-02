import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_ledger.dart';
import '../../domain/usecases/get_fee_accounts.dart';

sealed class FeesEvent extends Equatable {
  const FeesEvent();

  @override
  List<Object?> get props => const [];
}

final class FeesLoaded extends FeesEvent {
  const FeesLoaded();
}

class FeesState extends Equatable {
  const FeesState({this.loading = true, this.accounts = const []});

  final bool loading;
  final List<FeeAccount> accounts;

  List<FeeAccount> accountsOf(FeeGroup group) =>
      accounts.where((a) => a.group == group).toList();

  /// One ledger per person of the group.
  List<FeeLedger> ledgersOf(FeeGroup group) =>
      FeeLedger.groupByPerson(accountsOf(group));

  /// Everything one person owes, or null if they owe nothing.
  FeeLedger? ledgerOf(String personId) {
    final mine = [
      for (final a in accounts)
        if ((a.personId ?? a.id) == personId) a,
    ];
    return mine.isEmpty ? null : FeeLedger(mine);
  }

  FeeAccount? accountById(String id) {
    for (final a in accounts) {
      if (a.id == id) return a;
    }
    return null;
  }

  int totalOf(FeeGroup? group) => _sum(group, (a) => a.total);
  int paidOf(FeeGroup? group) => _sum(group, (a) => a.paid);
  int pendingOf(FeeGroup? group) => totalOf(group) - paidOf(group);

  int _sum(FeeGroup? group, int Function(FeeAccount) pick) => accounts
      .where((a) => group == null || a.group == group)
      .fold(0, (s, a) => s + pick(a));

  @override
  List<Object?> get props => [loading, accounts];
}

/// All fee accounts, shared by the Fees screen and Analytics.
class FeesBloc extends Bloc<FeesEvent, FeesState> {
  FeesBloc({required GetFeeAccounts getFeeAccounts})
    : _get = getFeeAccounts,
      super(const FeesState()) {
    on<FeesLoaded>(
      (e, emit) async => emit(
        FeesState(loading: false, accounts: await _get(const NoParams())),
      ),
    );
  }

  final GetFeeAccounts _get;
}
