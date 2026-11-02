import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/master_questions/domain/entities/master_question.dart';
import 'package:shiksha_setu/features/master_questions/domain/repository/master_questions_repository.dart';
import 'package:shiksha_setu/features/master_questions/domain/usecases/delete_master_question.dart';
import 'package:shiksha_setu/features/master_questions/domain/usecases/get_master_questions.dart';
import 'package:shiksha_setu/features/master_questions/domain/usecases/save_master_question.dart';
import 'package:shiksha_setu/features/master_questions/presentation/bloc/master_browse_cubit.dart';
import 'package:shiksha_setu/features/master_questions/presentation/bloc/master_question_form_cubit.dart';
import 'package:shiksha_setu/features/master_questions/presentation/bloc/master_questions_bloc.dart';

class _Fake implements MasterQuestionsRepository {
  final items = <String, MasterQuestion>{};

  @override
  Future<List<MasterQuestion>> getAll() async => items.values.toList();

  @override
  Future<void> save(MasterQuestion q) async => items[q.id] = q;

  @override
  Future<void> delete(String id) async => items.remove(id);
}

void main() {
  late _Fake repo;
  var counter = 0;

  MasterQuestionsBloc build() => MasterQuestionsBloc(
    getMasterQuestions: GetMasterQuestions(repo),
    saveMasterQuestion: SaveMasterQuestion(repo),
    deleteMasterQuestion: DeleteMasterQuestion(repo),
    now: () => DateTime(2026, 10, 1),
    newId: () => 'id${counter++}',
  );

  setUp(() {
    repo = _Fake();
    counter = 0;
  });

  blocTest<MasterQuestionsBloc, MasterQuestionsState>(
    'MasterQuestionSaved: a new question gets an id and shows up',
    build: build,
    act: (b) => b.add(
      const MasterQuestionSaved(
        Question(text: 'Capital?', marks: 1),
        subject: 'Social Studies',
        createdBy: 'u1',
      ),
    ),
    verify: (b) {
      final m = b.state.questions.single;
      expect((m.id, m.subject, m.createdBy), ('id0', 'Social Studies', 'u1'));
      expect(b.state.loading, isFalse);
    },
  );

  blocTest<MasterQuestionsBloc, MasterQuestionsState>(
    'MasterQuestionSaved with an id edits that question',
    build: build,
    act: (b) => b
      ..add(const MasterQuestionSaved(Question(text: 'First', marks: 1)))
      ..add(
        const MasterQuestionSaved(
          Question(text: 'Edited', marks: 1),
          id: 'id0',
        ),
      ),
    verify: (b) => expect(
      [for (final m in b.state.questions) m.question.text],
      ['Edited'],
    ),
  );

  blocTest<MasterQuestionsBloc, MasterQuestionsState>(
    'MasterQuestionDeleted removes it',
    build: build,
    act: (b) => b
      ..add(const MasterQuestionSaved(Question(text: 'A', marks: 1)))
      ..add(const MasterQuestionDeleted('id0')),
    verify: (b) => expect(b.state.questions, isEmpty),
  );

  group('filtered', () {
    MasterQuestion m(
      String id,
      String text,
      QuestionType type, {
      String? subject,
    }) => MasterQuestion(
      id: id,
      question: Question(text: text, marks: 1, type: type),
      createdAt: DateTime(2026),
      subject: subject,
    );

    final state = MasterQuestionsState(
      loading: false,
      questions: [
        m(
          '1',
          'Capital of India?',
          QuestionType.mcq,
          subject: 'Social Studies',
        ),
        m(
          '2',
          'Water boils at ___',
          QuestionType.fillBlank,
          subject: 'Science',
        ),
        m('3', 'Define force', QuestionType.shortAnswer),
      ],
    );

    List<String> ids(List<MasterQuestion> l) => [for (final x in l) x.id];

    test('by text', () {
      expect(ids(state.filtered(query: 'CAPITAL')), ['1']);
    });

    test('by type, several at once', () {
      expect(
        ids(state.filtered(types: {QuestionType.mcq, QuestionType.fillBlank})),
        ['1', '2'],
      );
    });

    test('by subject keeps questions with no subject', () {
      expect(ids(state.filtered(subject: 'Science')), ['2', '3']);
    });

    test('filters combine', () {
      expect(
        ids(state.filtered(query: 'water', types: {QuestionType.fillBlank})),
        ['2'],
      );
    });
  });

  group('MasterBrowseCubit', () {
    test('type chips toggle and ticks toggle', () {
      final c = MasterBrowseCubit()
        ..toggleType(QuestionType.mcq)
        ..toggleType(QuestionType.trueFalse)
        ..toggleType(QuestionType.mcq)
        ..toggleSelected('a')
        ..toggleSelected('b')
        ..toggleSelected('a');

      expect(c.state.types, {QuestionType.trueFalse});
      expect(c.state.selected, {'b'});
    });
  });

  group('MasterQuestionFormCubit', () {
    test('a new question starts as the chosen type', () {
      final c = MasterQuestionFormCubit(type: QuestionType.matchFollowing);

      expect(c.state.draft.type, QuestionType.matchFollowing);
      expect(c.state.draft.pairs.length, 2);
      expect(c.id, isNull);
    });

    test('editing an existing one starts from it', () {
      final c = MasterQuestionFormCubit(
        initial: MasterQuestion(
          id: 'm1',
          createdAt: DateTime(2026),
          subject: 'Science',
          question: const Question(
            text: 'Capital?',
            marks: 1,
            type: QuestionType.mcq,
            options: ['Delhi', 'Pune'],
            correctIndex: 1,
          ),
        ),
      );

      expect(c.id, 'm1');
      expect(c.state.subject, 'Science');
      expect(c.state.draft.options, ['Delhi', 'Pune']);
      expect(c.state.draft.correctIndex, 1);
    });

    test('the editor handler updates the draft', () {
      final c = MasterQuestionFormCubit(type: QuestionType.mcq)
        ..text('Q')
        ..optionEdited(0, 'A')
        ..optionEdited(1, 'B')
        ..correct(1)
        ..marks('2');

      final q = c.state.draft.toQuestion();
      expect(q.text, 'Q');
      expect(q.options, ['A', 'B']);
      expect((q.correctIndex, q.marks), (1, 2));
    });
  });
}
