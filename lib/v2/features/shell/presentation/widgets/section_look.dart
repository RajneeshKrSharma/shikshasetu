import 'package:flutter/material.dart';

import '../../../../../l10n/generated/app_localizations.dart';
import '../../../session/domain/navigation/app_section.dart';

/// How each area is named and drawn in the bars and lists.
extension AppSectionLook on AppSection {
  String label(AppLocalizations l) => switch (this) {
    AppSection.home => l.navDashboard,
    AppSection.students => l.navStudents,
    AppSection.teachers => l.navTeachers,
    AppSection.staff => l.navStaff,
    AppSection.attendance => l.navAttendance,
    AppSection.requests => l.navRequests,
    AppSection.exams => l.navExams,
    AppSection.payments => l.navPayments,
    AppSection.analytics => l.navAnalytics,
    AppSection.lessons => l.navLessons,
    AppSection.school => l.navSchool,
    AppSection.notices => l.navNotices,
    AppSection.fuelBills => l.navFuelBills,
    AppSection.vicePrincipal => l.navVicePrincipal,
    AppSection.profile => l.navProfile,
  };

  IconData get icon => switch (this) {
    AppSection.home => Icons.dashboard_outlined,
    AppSection.students => Icons.backpack_outlined,
    AppSection.teachers => Icons.badge_outlined,
    AppSection.staff => Icons.directions_bus_outlined,
    AppSection.attendance => Icons.how_to_reg_outlined,
    AppSection.requests => Icons.forum_outlined,
    AppSection.exams => Icons.description_outlined,
    AppSection.payments => Icons.payments_outlined,
    AppSection.analytics => Icons.insights_outlined,
    AppSection.lessons => Icons.menu_book_outlined,
    AppSection.school => Icons.school_outlined,
    AppSection.notices => Icons.campaign_outlined,
    AppSection.fuelBills => Icons.local_gas_station_outlined,
    AppSection.vicePrincipal => Icons.supervisor_account_outlined,
    AppSection.profile => Icons.person_outline,
  };

  IconData get selectedIcon => switch (this) {
    AppSection.home => Icons.dashboard,
    AppSection.students => Icons.backpack,
    AppSection.teachers => Icons.badge,
    AppSection.staff => Icons.directions_bus,
    AppSection.attendance => Icons.how_to_reg,
    AppSection.requests => Icons.forum,
    AppSection.exams => Icons.description,
    AppSection.payments => Icons.payments,
    AppSection.analytics => Icons.insights,
    AppSection.lessons => Icons.menu_book,
    AppSection.school => Icons.school,
    AppSection.notices => Icons.campaign,
    AppSection.fuelBills => Icons.local_gas_station,
    AppSection.vicePrincipal => Icons.supervisor_account,
    AppSection.profile => Icons.person,
  };
}
