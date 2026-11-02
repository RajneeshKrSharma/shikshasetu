import '../entities/fee_account.dart';
import '../entities/fee_payment.dart';
import '../entities/fee_payment_record.dart';
import '../entities/fee_person.dart';
import '../entities/fee_structure_item.dart';

abstract interface class FeesRepository {
  Future<List<FeeAccount>> getAccounts();
  Future<FeeAccount?> getAccount(String id);
  Future<List<FeePerson>> getPeople(FeeGroup group);

  Future<void> createAccount({
    required FeeGroup group,
    required FeePerson person,
    required int total,
    required DateTime dueDate,
    FeeHead head = FeeHead.academic,
  });

  /// Records a payment and returns it.
  Future<FeePayment> recordPayment({
    required String accountId,
    required int amount,
    required DateTime at,
    required PaymentMode mode,
    String? reference,
    String? proofPath,
  });
  Future<List<FeePayment>> getPayments(String accountId);

  /// Every payment ever recorded, newest first.
  Future<List<FeePaymentRecord>> getPaymentHistory();

  /// Gives one fee dates of its own, with the reason.
  Future<void> changeDates({
    required String accountId,
    required DateTime dueDate,
    DateTime? lastDate,
    required String note,
  });

  /// What each class pays, for every kind of fee that has been set up.
  Future<List<FeeStructureItem>> getStructure();
  Future<void> saveStructureItem(FeeStructureItem item);

  /// Gives every active student of [className] a fee for [head] from the
  /// class's setup (only those without one yet; a van fee only to students
  /// who travel by van). Returns how many were given one.
  Future<int> applyStructure(String className, FeeHead head);
}
