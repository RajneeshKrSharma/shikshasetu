import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_paper_marks.dart';
import '../../domain/usecases/save_paper_marks.dart';

sealed class MarksEntryEvent extends Equatable {
  const MarksEntryEvent();

  @override
  List<Object?> get props => const [];
}

final class MarksEntryStarted extends MarksEntryEvent {
  const MarksEntryStarted();
}

/// A student's marks field changed (kept as typed).
final class StudentMarksEdited extends MarksEntryEvent {
  const StudentMarksEdited(this.studentId, this.value);

  final String studentId;
  final String value;

  @override
  List<Object?> get props => [studentId, value];
}

final class MarksEntrySaved extends MarksEntryEvent {
  const MarksEntrySaved();
}

class MarksEntryState extends Equatable {
  const MarksEntryState({
    this.loading = true,
    this.values = const {},
    this.saving = false,
    this.saved = false,
  });

  final bool loading;

  /// Student id → marks as typed.
  final Map<String, String> values;
  final bool saving;
  final bool saved;

  MarksEntryState copyWith({
    bool? loading,
    Map<String, String>? values,
    bool? saving,
    bool? saved,
  }) => MarksEntryState(
    loading: loading ?? this.loading,
    values: values ?? this.values,
    saving: saving ?? this.saving,
    saved: saved ?? this.saved,
  );

  @override
  List<Object?> get props => [loading, values, saving, saved];
}

/// Marks each student obtained in one conducted paper.
class MarksEntryBloc extends Bloc<MarksEntryEvent, MarksEntryState> {
  MarksEntryBloc({
    required this.paperId,
    required GetPaperMarks getPaperMarks,
    required SavePaperMarks savePaperMarks,
  }) : _get = getPaperMarks,
       _save = savePaperMarks,
       super(const MarksEntryState()) {
    on<MarksEntryStarted>(_onStarted);
    on<StudentMarksEdited>(
      (e, emit) =>
          emit(state.copyWith(values: {...state.values, e.studentId: e.value})),
    );
    on<MarksEntrySaved>(_onSaved);
  }

  final String paperId;
  final GetPaperMarks _get;
  final SavePaperMarks _save;

  Future<void> _onStarted(
    MarksEntryStarted e,
    Emitter<MarksEntryState> emit,
  ) async {
    final saved = await _get(paperId);
    emit(
      state.copyWith(
        loading: false,
        values: {for (final m in saved.entries) m.key: '${m.value}'},
      ),
    );
  }

  Future<void> _onSaved(
    MarksEntrySaved e,
    Emitter<MarksEntryState> emit,
  ) async {
    emit(state.copyWith(saving: true));
    await _save(
      SavePaperMarksParams(paperId, {
        for (final v in state.values.entries)
          if (v.value.trim().isNotEmpty) v.key: int.parse(v.value.trim()),
      }),
    );
    emit(state.copyWith(saving: false, saved: true));
  }
}
