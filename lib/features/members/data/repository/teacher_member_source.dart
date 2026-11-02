import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/member_kind.dart';
import '../../domain/entities/member_summary.dart';
import 'member_source.dart';

class TeacherMemberSource extends MemberSource {
  const TeacherMemberSource(this._database);

  final AppDatabase _database;

  @override
  MemberKind get kind => MemberKind.teacher;

  @override
  Future<List<MemberSummary>> list() async {
    final rows = await _database.db.rawQuery('''
SELECT u.id, u.name, u.subject, u.active, c.name AS class_name
FROM users u
LEFT JOIN classes c ON c.class_teacher_id = u.id
WHERE u.role = 'teacher'
ORDER BY u.name COLLATE NOCASE
''');
    return [
      for (final r in rows)
        MemberSummary(
          id: r['id']! as String,
          name: r['name']! as String,
          kind: kind,
          active: (r['active']! as int) == 1,
          parts: [
            if ((r['subject'] as String?)?.isNotEmpty ?? false)
              SummaryPart(SummaryField.subject, r['subject']! as String),
            if (r['class_name'] != null)
              SummaryPart(
                SummaryField.classTeacherOf,
                r['class_name']! as String,
              ),
          ],
        ),
    ];
  }

  @override
  Future<void> setActive(String id, bool active) => _database.db.update(
    'users',
    {'active': active ? 1 : 0},
    where: "id = ? AND role = 'teacher'",
    whereArgs: [id],
  );
}
