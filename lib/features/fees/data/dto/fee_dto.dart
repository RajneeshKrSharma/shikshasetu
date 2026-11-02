/// A `fee_accounts` row with the sum of its payments.
class FeeAccountDto {
  const FeeAccountDto({
    required this.id,
    required this.groupType,
    required this.name,
    required this.subtitle,
    required this.total,
    required this.paid,
    required this.dueDate,
    this.head = 'academic',
    this.lastDate,
    this.dateNote,
    this.personId,
    this.classSection,
    this.rollNo,
  });

  final String id;
  final String groupType;
  final String name;
  final String subtitle;
  final int total;
  final int paid;
  final int dueDate;
  final String head;
  final int? lastDate;
  final String? dateNote;
  final String? personId;
  final String? classSection;
  final int? rollNo;

  factory FeeAccountDto.fromMap(Map<String, Object?> m) => FeeAccountDto(
    id: m['id']! as String,
    groupType: m['group_type']! as String,
    personId: m['person_id'] as String?,
    name: m['name']! as String,
    subtitle: m['subtitle']! as String,
    total: m['total']! as int,
    paid: m['paid']! as int,
    dueDate: m['due_date']! as int,
    head: (m['head'] as String?) ?? 'academic',
    lastDate: m['last_date'] as int?,
    dateNote: m['date_note'] as String?,
    classSection: m['live_class'] as String?,
    rollNo: m['live_roll'] as int?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'group_type': groupType,
    'person_id': personId,
    'name': name,
    'subtitle': subtitle,
    'total': total,
    'due_date': dueDate,
    'head': head,
    'last_date': lastDate,
    'date_note': dateNote,
  };
}

/// A row of the `fee_payments` table.
class FeePaymentDto {
  const FeePaymentDto({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.paidAt,
    this.mode = 'cash',
    this.reference,
    this.proofPath,
  });

  final int id;
  final String accountId;
  final int amount;
  final int paidAt;
  final String mode;
  final String? reference;
  final String? proofPath;

  factory FeePaymentDto.fromMap(Map<String, Object?> m) => FeePaymentDto(
    id: m['id']! as int,
    accountId: m['account_id']! as String,
    amount: m['amount']! as int,
    paidAt: m['paid_at']! as int,
    mode: (m['mode'] as String?) ?? 'cash',
    reference: m['reference'] as String?,
    proofPath: m['proof_path'] as String?,
  );
}

/// Someone selectable when assigning a fee.
class FeePersonDto {
  const FeePersonDto({
    required this.id,
    required this.name,
    required this.subtitle,
  });

  final String id;
  final String name;
  final String subtitle;

  factory FeePersonDto.fromMap(Map<String, Object?> m) => FeePersonDto(
    id: m['id']! as String,
    name: m['name']! as String,
    subtitle: m['sub']! as String,
  );
}

/// A payment joined with the account (and student) it belongs to.
class FeePaymentRecordDto {
  const FeePaymentRecordDto({
    required this.payment,
    required this.personName,
    required this.groupType,
    required this.subtitle,
    this.personId,
    this.classSection,
  });

  final FeePaymentDto payment;
  final String personName;
  final String groupType;
  final String subtitle;
  final String? personId;
  final String? classSection;

  factory FeePaymentRecordDto.fromMap(Map<String, Object?> m) =>
      FeePaymentRecordDto(
        payment: FeePaymentDto.fromMap(m),
        personName: m['person_name']! as String,
        groupType: m['group_type']! as String,
        subtitle: m['subtitle']! as String,
        personId: m['person_id'] as String?,
        classSection: m['live_class'] as String?,
      );
}

/// A row of the `fee_structure` table.
class FeeStructureDto {
  const FeeStructureDto({
    required this.className,
    required this.head,
    required this.amount,
    required this.dueDate,
    this.lastDate,
  });

  final String className;
  final String head;
  final int amount;
  final int dueDate;
  final int? lastDate;

  factory FeeStructureDto.fromMap(Map<String, Object?> m) => FeeStructureDto(
    className: m['class_name']! as String,
    head: m['head']! as String,
    amount: m['amount']! as int,
    dueDate: m['due_date']! as int,
    lastDate: m['last_date'] as int?,
  );

  Map<String, Object?> toMap() => {
    'class_name': className,
    'head': head,
    'amount': amount,
    'due_date': dueDate,
    'last_date': lastDate,
  };
}
