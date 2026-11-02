import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_payment.dart';
import '../../domain/entities/fee_payment_record.dart';
import '../../domain/entities/fee_person.dart';
import '../../domain/entities/fee_structure_item.dart';
import '../../domain/repository/fees_repository.dart';
import '../dto/fee_dto.dart';
import '../models/fee_models.dart';

class FeesRepositoryImpl implements FeesRepository {
  FeesRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<List<FeeAccount>> getAccounts() async {
    final rows = await _db.rawQuery('''
SELECT a.*, COALESCE(SUM(p.amount), 0) AS paid,
  s.class_name AS live_class, s.roll_no AS live_roll
FROM fee_accounts a
LEFT JOIN fee_payments p ON p.account_id = a.id
LEFT JOIN students s ON a.group_type = 'student' AND s.id = a.person_id
GROUP BY a.id
ORDER BY a.name COLLATE NOCASE
''');
    return [
      for (final r in rows) FeeAccountModel.fromDto(FeeAccountDto.fromMap(r)),
    ];
  }

  @override
  Future<FeeAccount?> getAccount(String id) async {
    final rows = await _db.rawQuery(
      '''
SELECT a.*, COALESCE(SUM(p.amount), 0) AS paid,
  s.class_name AS live_class, s.roll_no AS live_roll
FROM fee_accounts a
LEFT JOIN fee_payments p ON p.account_id = a.id
LEFT JOIN students s ON a.group_type = 'student' AND s.id = a.person_id
WHERE a.id = ?
GROUP BY a.id
''',
      [id],
    );
    return rows.isEmpty
        ? null
        : FeeAccountModel.fromDto(FeeAccountDto.fromMap(rows.first));
  }

  @override
  Future<List<FeePerson>> getPeople(FeeGroup group) async {
    final rows = switch (group) {
      FeeGroup.student => await _db.rawQuery(
        'SELECT id, name, class_name AS sub FROM students ORDER BY name',
      ),
      FeeGroup.teacher => await _db.rawQuery(
        "SELECT id, name, COALESCE(subject, '') AS sub FROM users "
        "WHERE role = 'teacher' ORDER BY name",
      ),
      FeeGroup.other => await _db.rawQuery(
        'SELECT id, name, role_title AS sub FROM other_staff ORDER BY name',
      ),
    };
    return [
      for (final r in rows) FeePersonModel.fromDto(FeePersonDto.fromMap(r)),
    ];
  }

  @override
  Future<void> createAccount({
    required FeeGroup group,
    required FeePerson person,
    required int total,
    required DateTime dueDate,
    FeeHead head = FeeHead.academic,
  }) => _db.insert(
    'fee_accounts',
    FeeAccountDto(
      id: const Uuid().v4(),
      groupType: group.name,
      personId: person.id,
      name: person.name,
      subtitle: person.subtitle,
      total: total,
      paid: 0,
      dueDate: dueDate.millisecondsSinceEpoch,
      head: group == FeeGroup.student ? head.name : FeeHead.payment.name,
    ).toMap(),
  );

  @override
  Future<FeePayment> recordPayment({
    required String accountId,
    required int amount,
    required DateTime at,
    required PaymentMode mode,
    String? reference,
    String? proofPath,
  }) async {
    final id = await _db.insert('fee_payments', {
      'account_id': accountId,
      'amount': amount,
      'paid_at': at.millisecondsSinceEpoch,
      'mode': mode.name,
      'reference': (reference?.trim().isEmpty ?? true)
          ? null
          : reference!.trim(),
      'proof_path': proofPath,
    });
    return FeePaymentModel(
      id: id,
      accountId: accountId,
      amount: amount,
      paidAt: at,
      mode: mode,
      reference: reference,
      proofPath: proofPath,
    );
  }

  @override
  Future<void> changeDates({
    required String accountId,
    required DateTime dueDate,
    DateTime? lastDate,
    required String note,
  }) => _db.update(
    'fee_accounts',
    {
      'due_date': dueDate.millisecondsSinceEpoch,
      'last_date': lastDate?.millisecondsSinceEpoch,
      'date_note': note.trim(),
    },
    where: 'id = ?',
    whereArgs: [accountId],
  );

  @override
  Future<List<FeeStructureItem>> getStructure() async {
    final rows = await _db.query('fee_structure');
    return [
      for (final r in rows)
        FeeStructureModel.fromDto(FeeStructureDto.fromMap(r)),
    ];
  }

  @override
  Future<void> saveStructureItem(FeeStructureItem item) => _db.insert(
    'fee_structure',
    FeeStructureModel.toDto(item).toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  @override
  Future<int> applyStructure(String className, FeeHead head) =>
      _db.transaction((txn) async {
        final item = await txn.query(
          'fee_structure',
          where: 'class_name = ? AND head = ?',
          whereArgs: [className, head.name],
        );
        if (item.isEmpty) return 0;
        final s = FeeStructureDto.fromMap(item.first);
        final students = await txn.rawQuery(
          '''
SELECT id, name, class_name FROM students
WHERE class_name = ? AND active = 1
  AND (? != 'van' OR (vehicle_number IS NOT NULL AND vehicle_number != ''))
  AND id NOT IN (
    SELECT person_id FROM fee_accounts
    WHERE group_type = 'student' AND head = ? AND person_id IS NOT NULL)
''',
          [className, head.name, head.name],
        );
        for (final st in students) {
          await txn.insert(
            'fee_accounts',
            FeeAccountDto(
              id: const Uuid().v4(),
              groupType: FeeGroup.student.name,
              personId: st['id']! as String,
              name: st['name']! as String,
              subtitle: st['class_name']! as String,
              total: s.amount,
              paid: 0,
              dueDate: s.dueDate,
              lastDate: s.lastDate,
              head: head.name,
            ).toMap(),
          );
        }
        return students.length;
      });

  @override
  Future<List<FeePayment>> getPayments(String accountId) async {
    final rows = await _db.query(
      'fee_payments',
      where: 'account_id = ?',
      whereArgs: [accountId],
      orderBy: 'paid_at DESC',
    );
    return [
      for (final r in rows) FeePaymentModel.fromDto(FeePaymentDto.fromMap(r)),
    ];
  }

  @override
  Future<List<FeePaymentRecord>> getPaymentHistory() async {
    final rows = await _db.rawQuery('''
SELECT p.id, p.account_id, p.amount, p.paid_at,
  a.name AS person_name, a.group_type, a.subtitle, a.person_id,
  s.class_name AS live_class
FROM fee_payments p
JOIN fee_accounts a ON a.id = p.account_id
LEFT JOIN students s ON a.group_type = 'student' AND s.id = a.person_id
ORDER BY p.paid_at DESC, p.id DESC
''');
    return [
      for (final r in rows)
        FeePaymentRecordModel.fromDto(FeePaymentRecordDto.fromMap(r)),
    ];
  }
}
