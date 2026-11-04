import 'package:flutter/material.dart';

import '../../../analytics/presentation/screen/analytics_screen.dart';
import '../../../attendance/presentation/screen/attendance_screen.dart';
import '../../../exams/presentation/screen/exams_screen.dart';
import '../../../fleet/presentation/screen/fuel_bills_screen.dart';
import '../../../fleet/presentation/screen/staff_screen.dart';
import '../../../members/presentation/screen/vice_principals_screen.dart';
import '../../../notices/presentation/screen/notices_screen.dart';
import '../../../payments/presentation/screen/payments_screen.dart';
import '../../../requests/presentation/screen/requests_screen.dart';
import '../../../school/presentation/screen/school_screen.dart';
import '../../../session/domain/navigation/app_section.dart';
import '../../../session/presentation/screen/profile_screen.dart';
import '../../../students/presentation/screen/students_screen.dart';
import '../../../teaching/presentation/screen/my_lessons_screen.dart';
import '../../../timetable/presentation/screen/exam_timetable_screen.dart';
import '../../../teaching/presentation/screen/teachers_screen.dart';
import '../screen/home_screen.dart';

/// The screen each area opens.
class SectionScreens {
  const SectionScreens();

  Widget of(AppSection section) => switch (section) {
    AppSection.school => const SchoolScreen(),
    AppSection.teachers => const TeachersScreen(),
    AppSection.lessons => const MyLessonsScreen(),
    AppSection.staff => const StaffScreen(),
    AppSection.fuelBills => const FuelBillsScreen(),
    AppSection.attendance => const AttendanceScreen(),
    AppSection.requests => const RequestsScreen(),
    AppSection.exams => const ExamsScreen(),
    AppSection.examTimetable => const ExamTimetableScreen(),
    AppSection.payments => const PaymentsScreen(),
    AppSection.analytics => const AnalyticsScreen(),
    AppSection.home => const HomeScreen(),
    AppSection.vicePrincipal => const VicePrincipalsScreen(),
    AppSection.students => const StudentsScreen(),
    AppSection.notices => const NoticesScreen(),
    AppSection.profile => const ProfileScreen(),
  };
}
