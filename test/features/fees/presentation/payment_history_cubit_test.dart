import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_account.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_payment.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_payment_record.dart';
import 'package:shiksha_setu/features/fees/domain/repository/fees_repository.dart';
import 'package:shiksha_setu/features/fees/domain/usecases/get_payment_history.dart';
import 'package:shiksha_setu/features/fees/presentation/bloc/payment_history_cubit.dart';

class _FakeFees implements FeesRepository {
  _FakeFees(this.history);

  final List<FeePaymentRecord> history;

  @override
  Future<List<FeePaymentRecord>> getPaymentHistory() async => history;

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError();
}

FeePaymentRecord _rec(
  int id,
  String name,
  FeeGroup group,
  DateTime at, {
  String? cls,
  String? personId,
  int amount = 100,
}) => FeePaymentRecord(
  payment: FeePayment(id: id, accountId: 'a$id', amount: amount, paidAt: at),
  personName: name,
  group: group,
  personId: personId ?? name,
  subtitle: cls ?? 'Maths',
  classSection: cls,
);

void main() {
  final history = [
    _rec(3, 'Anita', FeeGroup.teacher, DateTime(2026, 10, 3, 18)),
    _rec(2, 'Ravi', FeeGroup.student, DateTime(2026, 10, 2), cls: '6-B'),
    _rec(
      1,
      'Asha',
      FeeGroup.student,
      DateTime(2026, 10, 1),
      cls: '5-A',
      amount: 250,
    ),
  ];

  PaymentHistoryCubit build({String? personId}) => PaymentHistoryCubit(
    getPaymentHistory: GetPaymentHistory(_FakeFees(history)),
    personId: personId,
  );

  Future<PaymentHistoryCubit> loaded({String? personId}) async {
    final c = build(personId: personId);
    await c.load();
    return c;
  }

  test('load: lists everything, newest first', () async {
    final c = await loaded();
    expect(
      [for (final r in c.state.visible) r.personName],
      ['Anita', 'Ravi', 'Asha'],
    );
    expect(c.state.visibleTotal, 450);
  });

  test('a person id narrows the history to that person', () async {
    final c = await loaded(personId: 'Anita');
    expect([for (final r in c.state.visible) r.personName], ['Anita']);
  });

  test('same-day range includes payments made late in the day', () async {
    final c = await loaded()
      ..setRange(
        DateTimeRange(start: DateTime(2026, 10, 3), end: DateTime(2026, 10, 3)),
      );
    expect([for (final r in c.state.visible) r.personName], ['Anita']);
  });

  test('group, class and range filters combine', () async {
    final c = await loaded()
      ..toggleGroup(FeeGroup.student)
      ..toggleClass('5-A')
      ..setRange(
        DateTimeRange(start: DateTime(2026, 10, 1), end: DateTime(2026, 10, 2)),
      );
    expect([for (final r in c.state.visible) r.personName], ['Asha']);
    expect(c.state.activeCount, 3);
    expect(c.state.classOptions, ['5-A', '6-B']);

    c.clear();
    expect(c.state.visible, hasLength(3));
  });

  blocTest<PaymentHistoryCubit, PaymentHistoryState>(
    'search emits the new query',
    build: build,
    act: (c) => c.search('rav'),
    expect: () => [
      isA<PaymentHistoryState>().having((s) => s.query, 'query', 'rav'),
    ],
  );
}
