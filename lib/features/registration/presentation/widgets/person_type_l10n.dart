import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/person.dart';

extension PersonTypeStyle on PersonType {
  String label(AppLocalizations l) => switch (this) {
    PersonType.student => l.personStudent,
    PersonType.teacher => l.personTeacher,
    PersonType.other => l.personOther,
  };

  /// Title of the form that adds this kind of person.
  String addTitle(AppLocalizations l) => switch (this) {
    PersonType.student => l.addStudentTitle,
    PersonType.teacher => l.addTeacherTitle,
    PersonType.other => l.addStaffTitle,
  };

  /// The label of the button that saves a new one.
  String saveLabel(AppLocalizations l) => switch (this) {
    PersonType.student => l.saveStudent,
    PersonType.teacher => l.saveTeacher,
    PersonType.other => l.saveStaff,
  };

  IconData get icon => switch (this) {
    PersonType.student => Icons.backpack_outlined,
    PersonType.teacher => Icons.badge_outlined,
    PersonType.other => Icons.directions_bus_outlined,
  };

  Color color(BrandColors brand) => switch (this) {
    PersonType.student => AppColors.present,
    PersonType.teacher => brand.primary,
    PersonType.other => AppColors.late,
  };

  Color background(BrandColors brand) => switch (this) {
    PersonType.student => AppColors.presentLight,
    PersonType.teacher => brand.primaryLight,
    PersonType.other => AppColors.lateLight,
  };
}
