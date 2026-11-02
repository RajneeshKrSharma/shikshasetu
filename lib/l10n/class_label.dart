import 'generated/app_localizations.dart';

extension ClassLabel on AppLocalizations {
  /// "Class 5-A" for a class named by its number; a name that already says
  /// what it is ("Nursery", "LKG", "Class 3") is shown as it is.
  String classLabel(String name) {
    final plain =
        !RegExp(r'\d').hasMatch(name) ||
        name.trim().toLowerCase().startsWith('class');
    return plain ? name : classTitle(name);
  }
}
