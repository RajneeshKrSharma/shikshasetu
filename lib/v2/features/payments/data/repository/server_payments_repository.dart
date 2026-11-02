import '../../../../core/money.dart';
import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/payments.dart';
import '../../domain/repository/payments_repository.dart';
import '../models/payment_models.dart';

class ServerPaymentsRepository implements PaymentsRepository {
  ServerPaymentsRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<Payee>> payees(PayeeGroup group, {String query = ''}) async => [
    for (final p in jsonObjects(
      await _client.send(
        'GET',
        '/payments/people/',
        query: {'role': group.role, 'query': query, 'active': 'true'},
      ),
    ))
      PaymentModels.payee(p),
  ];

  @override
  Future<PersonAccount> account(String personId) async => PaymentModels.account(
    jsonObject(await _client.send('GET', '/payments/people/$personId/')),
  );

  @override
  Future<List<SalaryRate>> salaryHistory(String personId) async => [
    for (final r in jsonObjects(
      await _client.send('GET', '/payments/people/$personId/salary/'),
    ))
      PaymentModels.rate(r),
  ];

  @override
  Future<void> setSalary(String personId, Money amount, String fromMonth) =>
      _client.send(
        'PUT',
        '/payments/people/$personId/salary/',
        body: {'amount': amount.wire, 'effective_from': fromMonth},
      );

  @override
  Future<void> pay(PaymentDraft d) => _client.send(
    'POST',
    '/payments/',
    body: {
      'person_id': d.personId,
      'kind': d.kind.code,
      'amount': d.amount.wire,
      'mode': d.mode.code,
      'month': d.month,
      'fuel_bill_id': d.fuelBillId,
      if (d.note.trim().isNotEmpty) 'note': d.note.trim(),
    },
  );

  @override
  Future<PersonAccount> myAccount() async => PaymentModels.account(
    jsonObject(await _client.send('GET', '/payments/me/')),
  );
}
