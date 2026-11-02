import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_account.dart';

FeeAccount account({required int paid, required DateTime due}) => FeeAccount(
  id: 'a',
  name: 'Test',
  group: FeeGroup.student,
  subtitle: '6-A',
  total: 1000,
  paid: paid,
  dueDate: due,
);

void main() {
  final now = DateTime(2026, 9, 30);
  final past = DateTime(2026, 9, 1);
  final future = DateTime(2026, 10, 15);

  test('status: fully paid → paid even if past due date', () {
    expect(account(paid: 1000, due: past).statusAt(now), FeeStatus.paid);
  });

  test('status: unpaid balance after due date → overdue', () {
    expect(account(paid: 400, due: past).statusAt(now), FeeStatus.overdue);
  });

  test('status: part payment before due date → partial', () {
    expect(account(paid: 400, due: future).statusAt(now), FeeStatus.partial);
  });

  test('status: nothing paid before due date → due', () {
    expect(account(paid: 0, due: future).statusAt(now), FeeStatus.due);
  });

  test('pending: total minus paid', () {
    expect(account(paid: 400, due: future).pending, 600);
  });
}
