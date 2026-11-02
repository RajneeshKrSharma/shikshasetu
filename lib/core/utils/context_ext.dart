import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/brand_colors.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  TextTheme get text => Theme.of(this).textTheme;

  /// The school's theme colors; they change when the Principal picks one.
  BrandColors get brand =>
      Theme.of(this).extension<BrandColors>() ?? BrandColors.monochrome;
}
