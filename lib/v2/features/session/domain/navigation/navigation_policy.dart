import '../entities/account.dart';
import 'app_section.dart';

/// The areas of the app a person sees: a few as tabs along the bottom, the rest
/// under "More".
class AppNavigation {
  const AppNavigation({required this.tabs, required this.more});

  final List<AppSection> tabs;
  final List<AppSection> more;
}

/// Decides the order of the areas for one kind of person. The permissions
/// then decide which of them they actually get, so a Vice Principal with a few
/// permissions sees a shorter app than the Principal.
abstract class NavigationPolicy {
  const NavigationPolicy();

  /// Most important first.
  List<AppSection> get order;

  /// How many areas sit along the bottom before "More".
  int get tabCount => 4;

  AppNavigation build(Account account) {
    final available = [
      for (final section in order)
        if (section.isAvailableTo(account)) section,
    ];
    return AppNavigation(
      tabs: available.take(tabCount).toList(),
      more: available.skip(tabCount).toList(),
    );
  }
}

/// The Principal, and a Vice Principal for as far as they are given the right.
class ManagerNavigation extends NavigationPolicy {
  const ManagerNavigation();

  @override
  List<AppSection> get order => const [
    AppSection.home,
    AppSection.students,
    AppSection.teachers,
    AppSection.staff,
    AppSection.attendance,
    AppSection.requests,
    AppSection.exams,
    AppSection.payments,
    AppSection.analytics,
    AppSection.lessons,
    AppSection.school,
    AppSection.notices,
    AppSection.vicePrincipal,
    AppSection.profile,
  ];
}

class TeacherNavigation extends NavigationPolicy {
  const TeacherNavigation();

  @override
  List<AppSection> get order => const [
    AppSection.home,
    AppSection.lessons,
    AppSection.attendance,
    AppSection.exams,
    AppSection.requests,
    AppSection.students,
    AppSection.payments,
    AppSection.notices,
    AppSection.profile,
  ];
}

class StaffNavigation extends NavigationPolicy {
  const StaffNavigation();

  @override
  List<AppSection> get order => const [
    AppSection.home,
    AppSection.fuelBills,
    AppSection.requests,
    AppSection.payments,
    AppSection.notices,
    AppSection.profile,
  ];
}

/// Picks the policy for a person's role.
class NavigationPolicies {
  const NavigationPolicies();

  NavigationPolicy of(AccountRole role) => switch (role) {
    AccountRole.principal ||
    AccountRole.vicePrincipal => const ManagerNavigation(),
    AccountRole.teacher => const TeacherNavigation(),
    AccountRole.staff => const StaffNavigation(),
  };
}
