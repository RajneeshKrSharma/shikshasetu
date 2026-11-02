import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/member_kind.dart';
import '../../domain/entities/member_summary.dart';
import 'member_source.dart';

class StudentMemberSource extends MemberSource {
  const StudentMemberSource(this._database);

  final AppDatabase _database;

  @override
  MemberKind get kind => MemberKind.student;

  @override
  Future<List<MemberSummary>> list() async {
    final rows = await _database.db.query(
      'students',
      orderBy: 'class_name COLLATE NOCASE, roll_no',
    );
    return [
      for (final r in rows)
        MemberSummary(
          id: r['id']! as String,
          name: r['name']! as String,
          kind: kind,
          group: r['class_name']! as String,
          active: (r['active'] as int? ?? 1) == 1,
          parts: [
            SummaryPart(SummaryField.className, r['class_name']! as String),
            SummaryPart(SummaryField.rollNo, '${r['roll_no']}'),
          ],
        ),
    ];
  }

  @override
  Future<void> setActive(String id, bool active) => _database.db.update(
    'students',
    {'active': active ? 1 : 0},
    where: 'id = ?',
    whereArgs: [id],
  );
}
