import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// The exam tables exactly as version 1 of the app made them.
const _v1 = [
  '''
CREATE TABLE exam_papers (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  subject TEXT NOT NULL,
  class_name TEXT NOT NULL,
  exam_date INTEGER NOT NULL,
  duration_minutes INTEGER NOT NULL,
  status TEXT NOT NULL,
  created_by TEXT
)''',
  '''
CREATE TABLE exam_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  paper_id TEXT NOT NULL REFERENCES exam_papers(id) ON DELETE CASCADE,
  position INTEGER NOT NULL,
  text TEXT NOT NULL,
  marks INTEGER NOT NULL
)''',
];

void main() {
  late Database db;

  setUp(() async {
    sqfliteFfiInit();
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final s in _v1) {
      await db.execute(s);
    }
    await db.insert('exam_papers', {
      'id': 'p1',
      'title': 'Old paper',
      'subject': 'Maths',
      'class_name': '6-A',
      'exam_date': 0,
      'duration_minutes': 60,
      'status': 'scheduled',
    });
    await db.insert('exam_papers', {
      'id': 'p2',
      'title': 'Old draft',
      'subject': 'Maths',
      'class_name': '6-A',
      'exam_date': 0,
      'duration_minutes': 60,
      'status': 'draft',
    });
    await db.insert('exam_questions', {
      'paper_id': 'p1',
      'position': 0,
      'text': 'Define force.',
      'marks': 2,
    });
  });

  tearDown(() => db.close());

  test('upgrade 1 → 2 keeps old papers and questions', () async {
    await AppDatabase.upgrade(db, 1, 2);

    final q = (await db.query('exam_questions')).single;
    expect(q['text'], 'Define force.');
    // Old questions read as short answers with no extra details.
    expect((q['type'], q['details']), ('shortAnswer', null));
  });

  test('upgrade 1 → 2 turns "scheduled" papers into "approved"', () async {
    await AppDatabase.upgrade(db, 1, 2);

    final status = {
      for (final r in await db.query('exam_papers')) r['id']: r['status'],
    };
    expect(status, {'p1': 'approved', 'p2': 'draft'});
  });

  test('upgrade 1 → 2 adds the master question bank', () async {
    await AppDatabase.upgrade(db, 1, 2);

    await db.insert('master_questions', {
      'id': 'm1',
      'type': 'mcq',
      'text': 'Q',
      'created_at': 0,
    });
    expect(await db.query('master_questions'), hasLength(1));
  });

  test('upgrade 1 → 2 adds the new paper columns', () async {
    await AppDatabase.upgrade(db, 1, 2);

    await db.update('exam_papers', {
      'instructions': 'Be neat.',
      'review_note': 'Shorter',
      'submitted_at': 5,
    }, where: "id = 'p2'");
    final r = (await db.query('exam_papers', where: "id = 'p2'")).single;
    expect(
      (r['instructions'], r['review_note'], r['submitted_at']),
      ('Be neat.', 'Shorter', 5),
    );
  });
}
