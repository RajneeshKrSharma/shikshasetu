import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_account.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_payment.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_payment_record.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_person.dart';
import 'package:shiksha_setu/features/fees/domain/repository/fees_repository.dart';
import 'package:shiksha_setu/features/fees/domain/repository/receipt_repository.dart';
import 'package:shiksha_setu/features/fees/domain/usecases/create_receipt.dart';
import 'package:shiksha_setu/features/fees/domain/usecases/get_fee_people.dart';

class FakeFees implements FeesRepository {
  FakeFees(this.people, this.accounts);

  final List<FeePerson> people;
  final List<FeeAccount> accounts;

  @override
  Future<List<FeePerson>> getPeople(FeeGroup group) async => people;

  @override
  Future<List<FeeAccount>> getAccounts() async => accounts;

  @override
  Future<void> createAccount({
    required FeeGroup group,
    required FeePerson person,
    required int total,
    required DateTime dueDate,
  }) async {}

  @override
  Future<FeePayment> recordPayment(String id, int amount, DateTime at) =>
      throw UnimplementedError();

  @override
  Future<List<FeePayment>> getPayments(String accountId) async => const [];

  @override
  Future<List<FeePaymentRecord>> getPaymentHistory() async => const [];
}

class CapturingReceipts implements ReceiptRepository {
  int? balance;

  @override
  Future<String> create({
    required String schoolName,
    required FeeAccount account,
    required FeePayment payment,
    required int balanceAfter,
  }) async {
    balance = balanceAfter;
    return '/r.pdf';
  }
}

void main() {
  FeeAccount account(String personId) => FeeAccount(
    id: 'a-$personId',
    name: personId,
    group: FeeGroup.student,
    personId: personId,
    subtitle: '6-A',
    total: 1000,
    paid: 0,
    dueDate: DateTime(2026, 12),
  );

  test(
    'GetFeePeople: people who already have a fee account are left out',
    () async {
      final useCase = GetFeePeople(
        FakeFees(
          const [
            FeePerson(id: 'p1', name: 'One', subtitle: ''),
            FeePerson(id: 'p2', name: 'Two', subtitle: ''),
          ],
          [account('p1')],
        ),
      );

      final result = await useCase(FeeGroup.student);

      expect(result.map((p) => p.id), ['p2']);
    },
  );

  test(
    'GetFeePeople: an account of another group does not hide a person',
    () async {
      final teacherAccount = FeeAccount(
        id: 'a',
        name: 'x',
        group: FeeGroup.teacher,
        personId: 'p1',
        subtitle: '',
        total: 1,
        paid: 0,
        dueDate: DateTime(2026),
      );
      final useCase = GetFeePeople(
        FakeFees(
          const [FeePerson(id: 'p1', name: 'One', subtitle: '')],
          [teacherAccount],
        ),
      );

      expect((await useCase(FeeGroup.student)).map((p) => p.id), ['p1']);
    },
  );

  group('CreateReceipt', () {
    final acc = account('p1');
    final first = FeePayment(
      id: 1,
      accountId: acc.id,
      amount: 300,
      paidAt: DateTime(2026, 10, 1),
    );
    final second = FeePayment(
      id: 2,
      accountId: acc.id,
      amount: 200,
      paidAt: DateTime(2026, 10, 5),
    );

    test(
      'balance is the total minus payments made up to that payment',
      () async {
        final receipts = CapturingReceipts();

        await CreateReceipt(receipts)(
          CreateReceiptParams(
            schoolName: 'S',
            account: acc,
            payment: first,
            allPayments: [second, first],
          ),
        );

        expect(receipts.balance, 700, reason: 'later payment not counted');
      },
    );

    test('the latest payment leaves the balance after all payments', () async {
      final receipts = CapturingReceipts();

      await CreateReceipt(receipts)(
        CreateReceiptParams(
          schoolName: 'S',
          account: acc,
          payment: second,
          allPayments: [second, first],
        ),
      );

      expect(receipts.balance, 500);
    });
  });
}
