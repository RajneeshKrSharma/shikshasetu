import 'package:equatable/equatable.dart';

import '../../../../core/money.dart';
import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

enum PaymentKind {
  salary('salary'),
  fuelBill('fuel_bill');

  const PaymentKind(this.code);

  final String code;

  static PaymentKind fromCode(String? code) {
    for (final k in values) {
      if (k.code == code) return k;
    }
    return PaymentKind.salary;
  }
}

enum PaymentMode {
  cash('cash'),
  bank('bank'),
  upi('upi');

  const PaymentMode(this.code);

  final String code;

  static PaymentMode fromCode(String? code) {
    for (final m in values) {
      if (m.code == code) return m;
    }
    return PaymentMode.cash;
  }
}

/// Whom the school pays: teachers and staff.
enum PayeeGroup {
  teachers('teacher', Permission.manageTeacherPayments),
  staff('staff', Permission.manageStaffPayments);

  const PayeeGroup(this.role, this.permission);

  final String role;
  final Permission permission;
}

class Payee extends Equatable {
  const Payee({
    required this.personId,
    required this.name,
    required this.role,
    required this.currentSalary,
    required this.balance,
  });

  final String personId;
  final String name;
  final String role;
  final Money? currentSalary;
  final Money balance;

  @override
  List<Object?> get props => [personId, name, role, currentSalary, balance];
}

class SalaryMonth extends Equatable {
  const SalaryMonth({
    required this.month,
    required this.due,
    required this.paid,
    required this.balance,
  });

  /// `2026-10`.
  final String month;
  final Money due;
  final Money paid;
  final Money balance;

  @override
  List<Object?> get props => [month, due, paid, balance];
}

class FuelDue extends Equatable {
  const FuelDue({
    required this.billId,
    required this.billedOn,
    required this.vanName,
    required this.due,
    required this.paid,
    required this.balance,
  });

  final String billId;
  final DateTime billedOn;
  final String vanName;
  final Money due;
  final Money paid;
  final Money balance;

  @override
  List<Object?> get props => [billId, billedOn, vanName, due, paid, balance];
}

class Payment extends Equatable {
  const Payment({
    required this.id,
    required this.receiptNo,
    required this.kind,
    required this.amount,
    required this.paidOn,
    required this.mode,
    required this.note,
    required this.month,
  });

  final String id;
  final String receiptNo;
  final PaymentKind kind;
  final Money amount;
  final DateTime paidOn;
  final PaymentMode mode;
  final String note;
  final String? month;

  @override
  List<Object?> get props => [
    id,
    receiptNo,
    kind,
    amount,
    paidOn,
    mode,
    note,
    month,
  ];
}

class PersonAccount extends Equatable {
  const PersonAccount({
    required this.personId,
    required this.name,
    required this.currentSalary,
    required this.salary,
    required this.fuel,
    required this.totalDue,
    required this.totalPaid,
    required this.balance,
    required this.payments,
  });

  final String personId;
  final String name;
  final Money? currentSalary;
  final List<SalaryMonth> salary;
  final List<FuelDue> fuel;
  final Money totalDue;
  final Money totalPaid;
  final Money balance;
  final List<Payment> payments;

  @override
  List<Object?> get props => [
    personId,
    name,
    currentSalary,
    salary,
    fuel,
    totalDue,
    totalPaid,
    balance,
    payments,
  ];
}

class SalaryRate extends Equatable {
  const SalaryRate({required this.amount, required this.effectiveFrom});

  final Money amount;
  final String effectiveFrom;

  @override
  List<Object?> get props => [amount, effectiveFrom];
}

class PaymentDraft extends Equatable {
  const PaymentDraft({
    required this.personId,
    required this.kind,
    required this.amount,
    required this.mode,
    this.month,
    this.fuelBillId,
    this.note = '',
  });

  final String personId;
  final PaymentKind kind;
  final Money amount;
  final PaymentMode mode;
  final String? month;
  final String? fuelBillId;
  final String note;

  @override
  List<Object?> get props => [
    personId,
    kind,
    amount,
    mode,
    month,
    fuelBillId,
    note,
  ];
}

class PaymentsAccess {
  const PaymentsAccess._(this.groups, this.canSeeOwn);

  factory PaymentsAccess.of(Account account) => PaymentsAccess._([
    for (final g in PayeeGroup.values)
      if (account.can(g.permission)) g,
  ], account.can(Permission.viewOwnPayments));

  /// Whom this person may pay.
  final List<PayeeGroup> groups;
  final bool canSeeOwn;
}
