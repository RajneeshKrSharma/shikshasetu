import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bank_scope.dart';
import '../../domain/entities/bank_unit.dart';
import '../../domain/usecases/bank_usecases.dart';

class UnitQuestionsState extends Equatable {
  const UnitQuestionsState({this.questions = const [], this.loading = true});

  final List<BankQuestion> questions;
  final bool loading;

  @override
  List<Object?> get props => [questions, loading];
}

/// The questions of one unit, with a way to remove one.
class UnitQuestionsCubit extends Cubit<UnitQuestionsState> {
  UnitQuestionsCubit({
    required this.scope,
    required this.unitId,
    required GetUnitQuestions getQuestions,
    required DeleteBankQuestion delete,
  }) : _getQuestions = getQuestions,
       _delete = delete,
       super(const UnitQuestionsState());

  final BankScope scope;
  final String unitId;
  final GetUnitQuestions _getQuestions;
  final DeleteBankQuestion _delete;

  Future<void> load() async {
    final questions = await _getQuestions(UnitQuestionsParams(scope, unitId));
    if (!isClosed) {
      emit(UnitQuestionsState(questions: questions, loading: false));
    }
  }

  Future<void> remove(String id) async {
    await _delete(id);
    await load();
  }
}
