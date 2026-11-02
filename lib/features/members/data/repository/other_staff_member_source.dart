import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/member_kind.dart';
import '../../domain/entities/member_summary.dart';
import 'member_source.dart';

class OtherStaffMemberSource extends MemberSource {
  const OtherStaffMemberSource(this._database);

  final AppDatabase _database;

  @override
  MemberKind get kind => MemberKind.other;

  @override
  Future<List<MemberSummary>> list() async {
    final rows = await _database.db.query(
      'other_staff',
      orderBy: 'role_title COLLATE NOCASE, name COLLATE NOCASE',
    );
    return [
      for (final r in rows)
        MemberSummary(
          id: r['id']! as String,
          name: r['name']! as String,
          kind: kind,
          group: r['role_title']! as String,
          active: (r['active'] as int? ?? 1) == 1,
          parts: [
            SummaryPart(SummaryField.role, r['role_title']! as String),
            if ((r['vehicle_number'] as String?)?.isNotEmpty ?? false)
              SummaryPart(
                SummaryField.vehicleNumber,
                r['vehicle_number']! as String,
              ),
          ],
        ),
    ];
  }

  @override
  Future<void> setActive(String id, bool active) => _database.db.update(
    'other_staff',
    {'active': active ? 1 : 0},
    where: 'id = ?',
    whereArgs: [id],
  );
}
