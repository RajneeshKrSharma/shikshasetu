import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/classes/data/repository/classes_repository_impl.dart';
import 'package:shiksha_setu/features/fees/data/repository/fees_repository_impl.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_account.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_person.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late FeesRepositoryImpl repo;

  setUp(() async {
    database = await openTestDatabase();
    repo = FeesRepositoryImpl(database);
    await ClassesRepositoryImpl(database).add('6-A');
    await insertStudent(database, 's1', '6-A');
    await insertTeacher(database, 't1', name: 'Anita', subject: 'Maths');
  });

  tearDown(() => database.close());

  Future<FeeAccount> createFor(FeePerson p, {int total = 1000}) async {
    await repo.createAccount(
      group: FeeGroup.student,
      person: p,
      total: total,
      dueDate: DateTime(2026, 12, 1),
    );
    return (await repo.getAccounts()).single;
  }

  test('getPeople: students are listed with their class', () async {
    final people = await repo.getPeople(FeeGroup.student);

    expect((people.single.id, people.single.subtitle), ('s1', '6-A'));
  });

  test('getPeople: teachers are listed with their subject', () async {
    final people = await repo.getPeople(FeeGroup.teacher);

    expect((people.single.name, people.single.subtitle), ('Anita', 'Maths'));
  });

  test('createAccount: starts with nothing paid', () async {
    final a = await createFor(
      const FeePerson(id: 's1', name: 'Student s1', subtitle: '6-A'),
    );

    expect((a.total, a.paid, a.pending), (1000, 0, 1000));
  });

  test('recordPayment: paid is the sum of all payments', () async {
    final a = await createFor(
      const FeePerson(id: 's1', name: 'Student s1', subtitle: '6-A'),
    );

    await repo.recordPayment(a.id, 300, DateTime(2026, 10, 1));
    await repo.recordPayment(a.id, 200, DateTime(2026, 10, 2));

    final updated = (await repo.getAccounts()).single;
    expect((updated.paid, updated.pending), (500, 500));
  });

  test('getPayments: newest first, with receipt numbers', () async {
    final a = await createFor(
      const FeePerson(id: 's1', name: 'Student s1', subtitle: '6-A'),
    );
    final first = await repo.recordPayment(a.id, 300, DateTime(2026, 10, 1));
    await repo.recordPayment(a.id, 200, DateTime(2026, 10, 2));

    final payments = await repo.getPayments(a.id);

    expect(payments.map((p) => p.amount), [200, 300]);
    expect(first.receiptNo, 'R-00001');
  });

  test(
    'getAccounts: a student shows the current class and roll number',
    () async {
      await createFor(
        const FeePerson(id: 's1', name: 'Student s1', subtitle: '6-A'),
      );
      await ClassesRepositoryImpl(database).rename('6-A', '7-A');

      final a = (await repo.getAccounts()).single;

      expect((a.classSection, a.rollNo, a.subtitle), ('7-A', 1, '7-A'));
    },
  );

  test(
    'getPaymentHistory: every payment with who paid, newest first',
    () async {
      final a = await createFor(
        const FeePerson(id: 's1', name: 'Student s1', subtitle: '6-A'),
      );
      await repo.createAccount(
        group: FeeGroup.teacher,
        person: const FeePerson(id: 't1', name: 'Anita', subtitle: 'Maths'),
        total: 500,
        dueDate: DateTime(2026, 12, 1),
      );
      final teacher = (await repo.getAccounts()).firstWhere(
        (x) => x.group == FeeGroup.teacher,
      );
      await repo.recordPayment(a.id, 300, DateTime(2026, 10, 1));
      await repo.recordPayment(teacher.id, 100, DateTime(2026, 10, 3));

      final history = await repo.getPaymentHistory();

      expect(
        [
          for (final r in history)
            (r.personName, r.payment.amount, r.classSection),
        ],
        [('Anita', 100, null), ('Student s1', 300, '6-A')],
      );
      expect(history.first.personId, 't1');
    },
  );
}
