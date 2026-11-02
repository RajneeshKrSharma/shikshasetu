import '../../../../core/money.dart';
import '../entities/payments.dart';

abstract interface class PaymentsRepository {
  Future<List<Payee>> payees(PayeeGroup group, {String query = ''});

  Future<PersonAccount> account(String personId);

  Future<List<SalaryRate>> salaryHistory(String personId);

  Future<void> setSalary(String personId, Money amount, String fromMonth);

  Future<void> pay(PaymentDraft draft);

  Future<PersonAccount> myAccount();
}
