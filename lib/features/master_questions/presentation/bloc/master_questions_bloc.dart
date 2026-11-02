import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../domain/entities/master_question.dart';
import '../../domain/usecases/delete_master_question.dart';
import '../../domain/usecases/get_master_questions.dart';
import '../../domain/usecases/save_master_question.dart';

sealed class MasterQuestionsEvent extends Equatable {
  const MasterQuestionsEvent();

  @override
  List<Object?> get props => const [];
}

final class MasterQuestionsLoaded extends MasterQuestionsEvent {
  const MasterQuestionsLoaded();
}

/// Adds a new question to the bank, or (with an [id]) edits one.
final class MasterQuestionSaved extends MasterQuestionsEvent {
  const MasterQuestionSaved(
    this.question, {
    this.id,
    this.subject,
    this.classSection,
    this.createdBy,
  });

  final Question question;
  final String? id;
  final String? subject;
  final String? classSection;
  final String? createdBy;

  @override
  List<Object?> get props => [question, id, subject, classSection, createdBy];
}

final class MasterQuestionDeleted extends MasterQuestionsEvent {
  const MasterQuestionDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class MasterQuestionsState extends Equatable {
  const MasterQuestionsState({this.loading = true, this.questions = const []});

  final bool loading;
  final List<MasterQuestion> questions;

  /// The questions matching every given filter; null or empty means "any".
  List<MasterQuestion> filtered({
    String query = '',
    Set<QuestionType> types = const {},
    String? subject,
  }) {
    final q = query.trim().toLowerCase();
    return [
      for (final m in questions)
        if ((q.isEmpty || m.question.text.toLowerCase().contains(q)) &&
            (types.isEmpty || types.contains(m.question.type)) &&
            (subject == null || m.subject == null || m.subject == subject))
          m,
    ];
  }

  @override
  List<Object?> get props => [loading, questions];
}

/// The shared bank of reusable questions.
class MasterQuestionsBloc
    extends Bloc<MasterQuestionsEvent, MasterQuestionsState> {
  MasterQuestionsBloc({
    required GetMasterQuestions getMasterQuestions,
    required SaveMasterQuestion saveMasterQuestion,
    required DeleteMasterQuestion deleteMasterQuestion,
    DateTime Function()? now,
    String Function()? newId,
  }) : _get = getMasterQuestions,
       _save = saveMasterQuestion,
       _delete = deleteMasterQuestion,
       _now = now ?? DateTime.now,
       _newId = newId ?? (() => const Uuid().v4()),
       super(const MasterQuestionsState()) {
    on<MasterQuestionsLoaded>(_onLoaded);
    on<MasterQuestionSaved>((e, emit) async {
      await _save(
        MasterQuestion(
          id: e.id ?? _newId(),
          question: e.question,
          createdAt: _now(),
          subject: e.subject,
          classSection: e.classSection,
          createdBy: e.createdBy,
        ),
      );
      await _onLoaded(const MasterQuestionsLoaded(), emit);
    });
    on<MasterQuestionDeleted>((e, emit) async {
      await _delete(e.id);
      await _onLoaded(const MasterQuestionsLoaded(), emit);
    });
  }

  final GetMasterQuestions _get;
  final SaveMasterQuestion _save;
  final DeleteMasterQuestion _delete;
  final DateTime Function() _now;
  final String Function() _newId;

  Future<void> _onLoaded(
    MasterQuestionsEvent e,
    Emitter<MasterQuestionsState> emit,
  ) async => emit(
    MasterQuestionsState(
      loading: false,
      questions: await _get(const NoParams()),
    ),
  );
}
