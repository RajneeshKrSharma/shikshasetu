import '../../../../core/money.dart';
import '../../../../core/server/json.dart';
import '../../domain/entities/fees.dart';

class FeeModels {
  const FeeModels._();

  static FeeStructureLine structureLine(Json j) => FeeStructureLine(
    head: FeeHead.fromCode(j.stringOrNull('head')) ?? FeeHead.tuition,
    amount: j['amount'] == null ? null : Money.fromServer(j['amount']),
  );

  static FeePayment payment(Json j) => FeePayment(
    id: j.string('id'),
    receiptNo: j.string('receipt_no'),
    head: FeeHead.fromCode(j.stringOrNull('head')) ?? FeeHead.tuition,
    amount: Money.fromServer(j['amount']),
    paidOn: j.day('paid_on'),
    note: j.string('note'),
  );

  static FeeStatement statement(Json j) => FeeStatement(
    studentId: j.string('student_id'),
    studentName: j.string('student_name'),
    rollNumber: j.string('roll_number'),
    classId: j.string('class_id'),
    className: j.string('class_name'),
    usesVan: j.flag('uses_van'),
    lines: [
      for (final l in j.list('heads'))
        FeeLine(
          head: FeeHead.fromCode(l.stringOrNull('head')) ?? FeeHead.tuition,
          due: Money.fromServer(l['due']),
          paid: Money.fromServer(l['paid']),
          balance: Money.fromServer(l['balance']),
        ),
    ],
    totalDue: Money.fromServer(j['total_due']),
    totalPaid: Money.fromServer(j['total_paid']),
    balance: Money.fromServer(j['balance']),
    payments: [for (final p in j.list('payments')) payment(p)],
  );
}
