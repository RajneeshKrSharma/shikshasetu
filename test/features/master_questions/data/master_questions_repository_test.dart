import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/master_questions/data/repository/master_questions_repository_impl.dart';
import 'package:shiksha_setu/features/master_questions/domain/entities/master_question.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late MasterQuestionsRepositoryImpl repo;

  setUp(() async {
    database = await openTestDatabase();
    repo = MasterQuestionsRepositoryImpl(database);
  });

  tearDown(() => database.close());

  MasterQuestion item(String id, Question q, {int day = 1, String? subject}) =>
      MasterQuestion(
        id: id,
        question: q,
        createdAt: DateTime(2026, 10, day),
        subject: subject,
        createdBy: 'u1',
      );

  test('a question of any type comes back as it was saved', () async {
    const match = Question(
      text: 'Match the following',
      marks: 4,
      type: QuestionType.matchFollowing,
      pairs: [MatchPair('Cat', 'Meow'), MatchPair('Dog', 'Bark')],
    );
    const mcq = Question(
      text: 'Capital?',
      marks: 1,
      type: QuestionType.mcq,
      options: ['Delhi', 'Pune'],
      correctIndex: 0,
    );
    await repo.save(item('a', match, day: 1, subject: 'Science'));
    await repo.save(item('b', mcq, day: 2));

    final all = await repo.getAll();

    expect(all.map((m) => m.question), [mcq, match]);
    expect(all.last.subject, 'Science');
    expect(all.first.createdBy, 'u1');
  });

  test('newest first', () async {
    await repo.save(item('old', const Question(text: 'Old', marks: 1), day: 1));
    await repo.save(item('new', const Question(text: 'New', marks: 1), day: 5));

    expect([for (final m in await repo.getAll()) m.id], ['new', 'old']);
  });

  test('saving the same id again edits it', () async {
    await repo.save(item('a', const Question(text: 'First', marks: 1)));
    await repo.save(item('a', const Question(text: 'Edited', marks: 2)));

    final all = await repo.getAll();
    expect(all.length, 1);
    expect(all.single.question.text, 'Edited');
  });

  test('marks are only a suggestion: none is stored as 0', () async {
    await repo.save(item('a', const Question(text: 'No marks', marks: 0)));

    expect((await repo.getAll()).single.question.marks, 0);
    expect(
      (await database.db.query('master_questions')).single['marks'],
      isNull,
    );
  });

  test('delete removes only that question', () async {
    await repo.save(item('a', const Question(text: 'A', marks: 1)));
    await repo.save(item('b', const Question(text: 'B', marks: 1)));

    await repo.delete('a');

    expect([for (final m in await repo.getAll()) m.id], ['b']);
  });
}
