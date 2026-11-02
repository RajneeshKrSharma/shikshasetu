import '../../../../core/utils/aadhaar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'aadhaar_widgets.dart' show AadhaarInputFormatter;
import 'package:flutter/widgets.dart' show TextEditingValue;

/// What is wrong with an Aadhaar number that could not be read from a photo,
/// in words the person can act on.
extension AadhaarProblemL10n on AadhaarProblem {
  String title(AppLocalizations l) => switch (this) {
    AadhaarProblem.none => '',
    AadhaarProblem.noText => l.aadhaarProbTitleNoText,
    AadhaarProblem.noNumber => l.aadhaarProbTitleNoNumber,
    AadhaarProblem.masked => l.aadhaarProbTitleMasked,
    AadhaarProblem.virtualId => l.aadhaarProbTitleVid,
    AadhaarProblem.badChecksum => l.aadhaarProbTitleChecksum,
  };

  /// [number] is the digits as read, for [AadhaarProblem.badChecksum].
  String body(AppLocalizations l, {String? number}) => switch (this) {
    AadhaarProblem.none => '',
    AadhaarProblem.noText => l.aadhaarProbNoText,
    AadhaarProblem.noNumber => l.aadhaarProbNoNumber,
    AadhaarProblem.masked => l.aadhaarProbMasked,
    AadhaarProblem.virtualId => l.aadhaarProbVid,
    AadhaarProblem.badChecksum => l.aadhaarProbChecksum(
      AadhaarInputFormatter()
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: number ?? ''),
          )
          .text,
    ),
  };
}
