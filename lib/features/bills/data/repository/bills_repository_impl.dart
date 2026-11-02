import 'package:uuid/uuid.dart';

import '../../../../core/data/local/app_database.dart';
import '../../../fees/domain/entities/fee_payment.dart';
import '../../domain/entities/bill_drafts.dart';
import '../../domain/entities/staff_bill.dart';
import '../../domain/entities/staff_settlement.dart';
import '../../domain/repository/bills_repository.dart';
import '../dto/bills_dto.dart';
import '../models/bills_models.dart';

class BillsRepositoryImpl implements BillsRepository {
  BillsRepositoryImpl(this._database);

  final AppDatabase _database;

  static const _billSelect = '''
SELECT b.*, s.name AS staff_name, s.vehicle_number AS vehicle_number
FROM staff_bills b
JOIN other_staff s ON s.id = b.staff_id
''';

  @override
  Future<List<StaffBill>> getBills({String? staffId}) async {
    final rows = await _database.db.rawQuery(
      '$_billSelect ${staffId == null ? '' : 'WHERE b.staff_id = ?'} '
      'ORDER BY b.bill_date DESC, b.id',
      [?staffId],
    );
    return [
      for (final r in rows) StaffBillModel.fromDto(StaffBillDto.fromMap(r)),
    ];
  }

  @override
  Future<StaffBill> add(BillDraft d) async {
    final id = const Uuid().v4();
    await _database.db.insert(
      'staff_bills',
      StaffBillDto(
        id: id,
        staffId: d.staffId,
        kind: d.kind.name,
        billDate: d.date.millisecondsSinceEpoch,
        amount: d.amount,
        status: BillStatus.pending.name,
        litres: d.litres,
        photoPath: d.photoPath,
        note: d.note.trim().isEmpty ? null : d.note.trim(),
      ).toMap(),
    );
    final rows = await _database.db.rawQuery('$_billSelect WHERE b.id = ?', [
      id,
    ]);
    return StaffBillModel.fromDto(StaffBillDto.fromMap(rows.first));
  }

  @override
  Future<void> decide(String billId, BillStatus status, DateTime at) =>
      _database.db.update(
        'staff_bills',
        {
          'status': status.name,
          'decided_at': status == BillStatus.pending
              ? null
              : at.millisecondsSinceEpoch,
        },
        // A bill that is paid stays as it is.
        where: 'id = ? AND settlement_id IS NULL',
        whereArgs: [billId],
      );

  @override
  Future<List<StaffPayable>> getPayables() async {
    final rows = await _database.db.rawQuery('''
SELECT s.id, s.name, s.role_title, s.vehicle_number,
  COALESCE(SUM(CASE WHEN b.status = 'approved' AND b.settlement_id IS NULL
    THEN b.amount END), 0) AS payable,
  COALESCE(SUM(CASE WHEN b.status = 'approved' AND b.settlement_id IS NULL
    THEN 1 END), 0) AS payable_count,
  COALESCE(SUM(CASE WHEN b.status = 'pending' THEN 1 END), 0) AS waiting
FROM other_staff s
JOIN staff_bills b ON b.staff_id = s.id
WHERE s.active = 1
GROUP BY s.id
ORDER BY s.name COLLATE NOCASE
''');
    return [
      for (final r in rows)
        StaffPayable(
          staffId: r['id']! as String,
          name: r['name']! as String,
          role: r['role_title']! as String,
          vehicleNumber: r['vehicle_number'] as String?,
          payableAmount: r['payable']! as int,
          payableCount: r['payable_count']! as int,
          waitingCount: r['waiting']! as int,
        ),
    ];
  }

  @override
  Future<StaffSettlement> settle({
    required String staffId,
    required List<String> billIds,
    required PaymentMode mode,
    required String paidBy,
    required DateTime at,
    String? reference,
    String? proofPath,
  }) => _database.db.transaction((txn) async {
    final marks = List.filled(billIds.length, '?').join(',');
    final bills = await txn.query(
      'staff_bills',
      where:
          "id IN ($marks) AND staff_id = ? AND status = 'approved' "
          'AND settlement_id IS NULL',
      whereArgs: [...billIds, staffId],
    );
    // Something changed since the list was shown: pay nothing.
    if (bills.length != billIds.length) {
      throw const SettleException(SettleProblem.notApproved);
    }
    final total = bills.fold(0, (s, b) => s + (b['amount']! as int));
    var last = 0;
    for (final r in await txn.query(
      'staff_settlements',
      columns: ['voucher_no'],
    )) {
      final n = int.tryParse((r['voucher_no']! as String).split('-').last);
      if (n != null && n > last) last = n;
    }
    final id = const Uuid().v4();
    final voucher = 'PV-${(last + 1).toString().padLeft(4, '0')}';
    await txn.insert(
      'staff_settlements',
      StaffSettlementDto(
        id: id,
        voucherNo: voucher,
        staffId: staffId,
        amount: total,
        paidAt: at.millisecondsSinceEpoch,
        mode: mode.name,
        paidBy: paidBy,
        reference: (reference?.trim().isEmpty ?? true)
            ? null
            : reference!.trim(),
        proofPath: proofPath,
      ).toMap(),
    );
    await txn.update(
      'staff_bills',
      {'settlement_id': id},
      where: 'id IN ($marks)',
      whereArgs: billIds,
    );
    final name =
        (await txn.query(
              'other_staff',
              columns: ['name'],
              where: 'id = ?',
              whereArgs: [staffId],
            )).first['name']!
            as String;
    return StaffSettlementModel(
      id: id,
      voucherNo: voucher,
      staffId: staffId,
      staffName: name,
      amount: total,
      paidAt: at,
      mode: mode,
      paidBy: paidBy,
      reference: reference,
      proofPath: proofPath,
      billCount: billIds.length,
    );
  });

  @override
  Future<List<StaffSettlement>> getSettlements({String? staffId}) async {
    final rows = await _database.db.rawQuery(
      '''
SELECT t.*, s.name AS staff_name,
  (SELECT COUNT(*) FROM staff_bills b WHERE b.settlement_id = t.id)
    AS bill_count
FROM staff_settlements t
JOIN other_staff s ON s.id = t.staff_id
${staffId == null ? '' : 'WHERE t.staff_id = ?'}
ORDER BY t.paid_at DESC, t.voucher_no DESC
''',
      [?staffId],
    );
    return [
      for (final r in rows)
        StaffSettlementModel.fromDto(StaffSettlementDto.fromMap(r)),
    ];
  }
}
