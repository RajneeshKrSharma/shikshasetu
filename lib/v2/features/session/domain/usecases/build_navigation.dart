import '../../../../../core/usecase/usecase.dart';
import '../entities/account.dart';
import '../navigation/navigation_policy.dart';

class BuildNavigation implements UseCase<AppNavigation, Account> {
  const BuildNavigation(this._policies);

  final NavigationPolicies _policies;

  @override
  Future<AppNavigation> call(Account account) async =>
      _policies.of(account.role).build(account);
}
