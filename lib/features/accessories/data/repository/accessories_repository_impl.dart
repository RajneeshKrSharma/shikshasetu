import 'package:uuid/uuid.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/accessory_issue.dart';
import '../../domain/entities/accessory_record.dart';
import '../../domain/entities/accessory_kind.dart';
import '../../domain/entities/class_accessories.dart';
import '../../domain/entities/student_accessory_row.dart';
import '../../domain/repository/accessories_repository.dart';
import '../dto/accessory_dto.dart';
import '../models/accessory_models.dart';

class AccessoriesRepositoryImpl implements AccessoriesRepository {
  AccessoriesRepositoryImpl(this._database);

  final AppDatabase _database;

  static String _prefix(AccessoryKind k) =>
      k == AccessoryKind.dress ? 'DR' : 'BK';

  @override
  Future<ClassAccessories> getClass(
    String className,
    AccessoryKind kind,
  ) async {
    final db = _database.db;
    final items = [
      for (final r in await db.query(
        'accessory_items',
        where: 'class_name = ? AND kind = ?',
        whereArgs: [className, kind.name],
        orderBy: 'position',
      ))
        AccessoryItemModel.fromDto(AccessoryItemDto.fromMap(r)),
    ];
    final students = await db.query(
      'students',
      where: 'class_name = ? AND active = 1',
      whereArgs: [className],
      orderBy: 'roll_no',
    );
    final issues = [
      for (final r in await db.rawQuery(
        '''
SELECT i.* FROM accessory_issues i
JOIN students s ON s.id = i.student_id
WHERE s.class_name = ? AND i.kind = ?
ORDER BY i.issued_at DESC
''',
        [className, kind.name],
      ))
        AccessoryIssueModel.fromDto(AccessoryIssueDto.fromMap(r)),
    ];
    final byStudent = <String, List<AccessoryIssue>>{};
    for (final i in issues) {
      byStudent.putIfAbsent(i.studentId, () => []).add(i);
    }
    final names = {for (final i in items) i.name};
    return ClassAccessories(
      className: className,
      kind: kind,
      items: items,
      rows: [
        for (final s in students)
          StudentAccessoryRow(
            studentId: s['id']! as String,
            name: s['name']! as String,
            rollNo: s['roll_no']! as int,
            guardian: (s['guardian'] as String?) ?? '',
            size: s['dress_size'] as String?,
            itemCount: items.length,
            // Only pieces that are still in the class's set count.
            given: {
              for (final i in byStudent[s['id']] ?? const <AccessoryIssue>[])
                ...i.items.where(names.contains),
            },
            lastIssue: (byStudent[s['id']] ?? const []).firstOrNull,
          ),
      ],
    );
  }

  @override
  Future<void> saveItems(
    String className,
    AccessoryKind kind,
    List<String> names,
  ) => _database.db.transaction((txn) async {
    await txn.delete(
      'accessory_items',
      where: 'class_name = ? AND kind = ?',
      whereArgs: [className, kind.name],
    );
    for (var i = 0; i < names.length; i++) {
      await txn.insert(
        'accessory_items',
        AccessoryItemDto(
          id: const Uuid().v4(),
          className: className,
          kind: kind.name,
          name: names[i],
          position: i,
        ).toMap(),
      );
    }
  });

  @override
  Future<void> saveSizes(Map<String, String> sizes) =>
      _database.db.transaction((txn) async {
        for (final e in sizes.entries) {
          await txn.update(
            'students',
            {'dress_size': e.value.trim().isEmpty ? null : e.value.trim()},
            where: 'id = ?',
            whereArgs: [e.key],
          );
        }
      });

  @override
  Future<AccessoryIssue> issue({
    required String studentId,
    required AccessoryKind kind,
    required List<String> items,
    required String receivedBy,
    required String issuedBy,
    required DateTime at,
    String? size,
    int quantity = 1,
    String? signaturePath,
    String? photoPath,
  }) => _database.db.transaction((txn) async {
    final existing = await txn.query(
      'accessory_issues',
      columns: ['receipt_no'],
      where: 'kind = ?',
      whereArgs: [kind.name],
    );
    var last = 0;
    for (final r in existing) {
      final n = int.tryParse((r['receipt_no']! as String).split('-').last);
      if (n != null && n > last) last = n;
    }
    final issue = AccessoryIssueModel(
      id: const Uuid().v4(),
      receiptNo: '${_prefix(kind)}-${(last + 1).toString().padLeft(4, '0')}',
      studentId: studentId,
      kind: kind,
      items: items,
      size: size,
      quantity: quantity,
      receivedBy: receivedBy,
      issuedBy: issuedBy,
      issuedAt: at,
      signaturePath: signaturePath,
      photoPath: photoPath,
    );
    await txn.insert(
      'accessory_issues',
      AccessoryIssueModel.toDto(issue).toMap(),
    );
    // The size given is the student's size from now on.
    if (kind == AccessoryKind.dress && size != null && size.isNotEmpty) {
      await txn.update(
        'students',
        {'dress_size': size},
        where: 'id = ?',
        whereArgs: [studentId],
      );
    }
    return issue;
  });

  @override
  Future<List<AccessoryRecord>> getRecords() async {
    final rows = await _database.db.rawQuery('''
SELECT i.*, s.name AS student_name, s.class_name AS student_class
FROM accessory_issues i
LEFT JOIN students s ON s.id = i.student_id
ORDER BY i.issued_at DESC
''');
    return [
      for (final r in rows)
        AccessoryRecord(
          issue: AccessoryIssueModel.fromDto(AccessoryIssueDto.fromMap(r)),
          studentName: (r['student_name'] as String?) ?? '',
          className: r['student_class'] as String?,
        ),
    ];
  }

  @override
  Future<List<AccessoryIssue>> getIssues(String studentId) async {
    final rows = await _database.db.query(
      'accessory_issues',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'issued_at DESC',
    );
    return [
      for (final r in rows)
        AccessoryIssueModel.fromDto(AccessoryIssueDto.fromMap(r)),
    ];
  }
}
