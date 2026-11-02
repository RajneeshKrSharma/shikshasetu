import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exams/domain/entities/exam_paper.dart';

class MasterBrowseState extends Equatable {
  const MasterBrowseState({
    this.query = '',
    this.types = const {},
    this.selected = const {},
  });

  final String query;

  /// Question types to show; empty shows every type.
  final Set<QuestionType> types;

  /// Ids ticked in the picker.
  final Set<String> selected;

  MasterBrowseState copyWith({
    String? query,
    Set<QuestionType>? types,
    Set<String>? selected,
  }) => MasterBrowseState(
    query: query ?? this.query,
    types: types ?? this.types,
    selected: selected ?? this.selected,
  );

  @override
  List<Object?> get props => [query, types, selected];
}

/// Search, type filter and (for the picker) the ticked questions.
class MasterBrowseCubit extends Cubit<MasterBrowseState> {
  MasterBrowseCubit() : super(const MasterBrowseState());

  void search(String query) => emit(state.copyWith(query: query));

  void toggleType(QuestionType t) => emit(
    state.copyWith(
      types: state.types.contains(t)
          ? ({...state.types}..remove(t))
          : {...state.types, t},
    ),
  );

  void toggleSelected(String id) => emit(
    state.copyWith(
      selected: state.selected.contains(id)
          ? ({...state.selected}..remove(id))
          : {...state.selected, id},
    ),
  );
}
