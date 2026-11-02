import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/school_class.dart';

extension ClassLevelLabel on ClassLevel {
  /// The words for a level: "Nursery", "LKG", "Class 3".
  String label(AppLocalizations l) => switch (this) {
    ClassLevel.nursery => l.stuLevelNursery,
    ClassLevel.lkg => l.stuLevelLkg,
    ClassLevel.ukg => l.stuLevelUkg,
    _ => l.classTitle(code),
  };
}
