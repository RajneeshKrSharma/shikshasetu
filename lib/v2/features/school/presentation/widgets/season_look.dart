import 'package:flutter/material.dart';

import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/school.dart';

extension SeasonLook on Season {
  String label(AppLocalizations l) => switch (this) {
    Season.summer => l.seasonSummer,
    Season.winter => l.seasonWinter,
  };

  IconData get icon => switch (this) {
    Season.summer => Icons.wb_sunny_outlined,
    Season.winter => Icons.ac_unit,
  };
}
