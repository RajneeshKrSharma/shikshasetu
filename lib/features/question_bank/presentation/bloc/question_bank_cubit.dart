import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bank_scope.dart';
import '../../domain/entities/bank_unit.dart';
import '../../domain/usecases/bank_usecases.dart';

class QuestionBankState extends Equatable {
  const QuestionBankState({
    this.scopes = const [],
    this.scope,
    this.overview,
    this.loading = true,
  });

  final List<BankScope> scopes;
  final BankScope? scope;
  final BankOverview? overview;
  final bool loading;

  @override
  List<Object?> get props => [scopes, scope, overview, loading];
}

/// A teacher's bank: the class-and-subject banks they have, and the units of
/// the one on show.
class QuestionBankCubit extends Cubit<QuestionBankState> {
  QuestionBankCubit({
    required this.teacherId,
    required GetBankScopes getScopes,
    required GetBankOverview getOverview,
    required AddBankUnit addUnit,
    BankScope? initial,
  }) : _getScopes = getScopes,
       _getOverview = getOverview,
       _addUnit = addUnit,
       _initial = initial,
       super(const QuestionBankState());

  final String teacherId;
  final GetBankScopes _getScopes;
  final GetBankOverview _getOverview;
  final AddBankUnit _addUnit;
  final BankScope? _initial;

  Future<void> load() async {
    final scopes = await _getScopes(teacherId);
    final current = state.scope ?? _initial;
    final scope = scopes.contains(current)
        ? current
        : (scopes.isEmpty ? null : scopes.first);
    await _show(scopes, scope);
  }

  Future<void> unitAdded(String name) async {
    final scope = state.scope;
    if (scope == null) return;
    await _addUnit(AddUnitParams(scope, name));
    await _show(state.scopes, scope);
  }

  Future<void> select(BankScope scope) => _show(state.scopes, scope);

  Future<void> _show(List<BankScope> scopes, BankScope? scope) async {
    final overview = scope == null ? null : await _getOverview(scope);
    if (isClosed) return;
    emit(
      QuestionBankState(
        scopes: scopes,
        scope: scope,
        overview: overview,
        loading: false,
      ),
    );
  }
}
