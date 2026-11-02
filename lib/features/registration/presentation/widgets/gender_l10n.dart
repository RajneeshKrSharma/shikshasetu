import '../../../../core/domain/gender.dart';
import '../../../../l10n/generated/app_localizations.dart';

extension GenderL10n on Gender {
  String label(AppLocalizations l) => switch (this) {
    Gender.male => l.genderMale,
    Gender.female => l.genderFemale,
    Gender.other => l.genderOther,
  };
}
