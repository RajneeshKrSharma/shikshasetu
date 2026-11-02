import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_payment.dart';
import '../../domain/entities/fee_payment_record.dart';
import '../../domain/entities/fee_person.dart';
import '../../domain/entities/fee_structure_item.dart';
import '../dto/fee_dto.dart';

class FeeAccountModel extends FeeAccount {
  const FeeAccountModel({
    required super.id,
    required super.name,
    required super.group,
    required super.subtitle,
    required super.total,
    required super.paid,
    required super.dueDate,
    super.head,
    super.lastDate,
    super.dateNote,
    super.personId,
    super.classSection,
    super.rollNo,
  });

  factory FeeAccountModel.fromDto(FeeAccountDto d) => FeeAccountModel(
    id: d.id,
    name: d.name,
    group: FeeGroup.values.byName(d.groupType),
    personId: d.personId,
    // A student's class follows the class table, so a rename shows up here.
    subtitle: d.classSection ?? d.subtitle,
    classSection: d.classSection,
    rollNo: d.rollNo,
    total: d.total,
    paid: d.paid,
    dueDate: DateTime.fromMillisecondsSinceEpoch(d.dueDate),
    head: FeeHead.values.byName(d.head),
    lastDate: d.lastDate == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(d.lastDate!),
    dateNote: d.dateNote,
  );
}

class FeePaymentModel extends FeePayment {
  const FeePaymentModel({
    required super.id,
    required super.accountId,
    required super.amount,
    required super.paidAt,
    super.mode,
    super.reference,
    super.proofPath,
  });

  factory FeePaymentModel.fromDto(FeePaymentDto d) => FeePaymentModel(
    id: d.id,
    accountId: d.accountId,
    amount: d.amount,
    paidAt: DateTime.fromMillisecondsSinceEpoch(d.paidAt),
    mode: PaymentMode.values.byName(d.mode),
    reference: d.reference,
    proofPath: d.proofPath,
  );
}

class FeePersonModel extends FeePerson {
  const FeePersonModel({
    required super.id,
    required super.name,
    required super.subtitle,
  });

  factory FeePersonModel.fromDto(FeePersonDto d) =>
      FeePersonModel(id: d.id, name: d.name, subtitle: d.subtitle);
}

class FeePaymentRecordModel extends FeePaymentRecord {
  const FeePaymentRecordModel({
    required super.payment,
    required super.personName,
    required super.group,
    required super.subtitle,
    super.personId,
    super.classSection,
  });

  factory FeePaymentRecordModel.fromDto(FeePaymentRecordDto d) =>
      FeePaymentRecordModel(
        payment: FeePaymentModel.fromDto(d.payment),
        personName: d.personName,
        group: FeeGroup.values.byName(d.groupType),
        personId: d.personId,
        subtitle: d.classSection ?? d.subtitle,
        classSection: d.classSection,
      );
}

class FeeStructureModel extends FeeStructureItem {
  const FeeStructureModel({
    required super.className,
    required super.head,
    required super.amount,
    required super.dueDate,
    super.lastDate,
  });

  factory FeeStructureModel.fromDto(FeeStructureDto d) => FeeStructureModel(
    className: d.className,
    head: FeeHead.values.byName(d.head),
    amount: d.amount,
    dueDate: DateTime.fromMillisecondsSinceEpoch(d.dueDate),
    lastDate: d.lastDate == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(d.lastDate!),
  );

  static FeeStructureDto toDto(FeeStructureItem i) => FeeStructureDto(
    className: i.className,
    head: i.head.name,
    amount: i.amount,
    dueDate: i.dueDate.millisecondsSinceEpoch,
    lastDate: i.lastDate?.millisecondsSinceEpoch,
  );
}
