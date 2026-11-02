import '../../../../core/money.dart';
import '../../../../core/server/json.dart';
import '../../domain/entities/payments.dart';

class PaymentModels {
  const PaymentModels._();

  static Money? _optional(Object? v) => v == null ? null : Money.fromServer(v);

  static Payee payee(Json j) => Payee(
    personId: j.string('person_id'),
    name: j.string('name'),
    role: j.string('role'),
    currentSalary: _optional(j['current_salary']),
    balance: Money.fromServer(j['balance']),
  );

  static Payment payment(Json j) => Payment(
    id: j.string('id'),
    receiptNo: j.string('receipt_no'),
    kind: PaymentKind.fromCode(j.stringOrNull('kind')),
    amount: Money.fromServer(j['amount']),
    paidOn: j.day('paid_on'),
    mode: PaymentMode.fromCode(j.stringOrNull('mode')),
    note: j.string('note'),
    month: j.stringOrNull('month'),
  );

  static PersonAccount account(Json j) => PersonAccount(
    personId: j.string('person_id'),
    name: j.string('name'),
    currentSalary: _optional(j['current_salary']),
    salary: [
      for (final s in j.list('salary'))
        SalaryMonth(
          month: s.string('month'),
          due: Money.fromServer(s['due']),
          paid: Money.fromServer(s['paid']),
          balance: Money.fromServer(s['balance']),
        ),
    ],
    fuel: [
      for (final f in j.list('fuel_bills'))
        FuelDue(
          billId: f.string('bill_id'),
          billedOn: f.day('billed_on'),
          vanName: f.string('van_name'),
          due: Money.fromServer(f['due']),
          paid: Money.fromServer(f['paid']),
          balance: Money.fromServer(f['balance']),
        ),
    ],
    totalDue: Money.fromServer(j['total_due']),
    totalPaid: Money.fromServer(j['total_paid']),
    balance: Money.fromServer(j['balance']),
    payments: [for (final p in j.list('payments')) payment(p)],
  );

  static SalaryRate rate(Json j) => SalaryRate(
    amount: Money.fromServer(j['amount']),
    effectiveFrom: j.string('effective_from'),
  );
}
