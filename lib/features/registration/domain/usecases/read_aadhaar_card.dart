import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/aadhaar.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../../../exams/domain/repository/question_scanner_repository.dart';

/// The photos of the two sides of an Aadhaar card. Either may be missing.
class AadhaarPhotos extends Equatable {
  const AadhaarPhotos({this.front, this.back});

  final String? front;
  final String? back;

  @override
  List<Object?> get props => [front, back];
}

/// Reads an Aadhaar card from photos of its sides, on the phone.
///
/// The front gives the Aadhaar number, name, gender and date of birth; the
/// back gives the address. Each is taken from the side that normally carries
/// it, but if a photo turns out to be the other side (or one page showing
/// everything, like an e-Aadhaar), what it shows is still used. The number
/// must pass the Aadhaar checksum. Nothing is stored or sent.
class ReadAadhaarCard implements UseCase<AadhaarReading, AadhaarPhotos> {
  const ReadAadhaarCard(this._scanner);

  final QuestionScannerRepository _scanner;

  @override
  Future<AadhaarReading> call(AadhaarPhotos photos) async {
    // Cards print everything in Hindi and English, so each photo is read with
    // both readers: Latin for the English text and the number, Devanagari for
    // the Hindi name and address.
    Future<AadhaarReading?> read(String? path) async {
      if (path == null) return null;
      final latin = await _scanner.recognize(path, script: ScanScript.latin);
      String hindi;
      try {
        hindi = await _scanner.recognize(path, script: ScanScript.devanagari);
      } catch (_) {
        // The Hindi reader failing must not lose what the English one found.
        hindi = '';
      }
      return Aadhaar.read(latin, hindiText: hindi);
    }

    final front = await read(photos.front);
    final back = await read(photos.back);

    final frontNumber = front?.number;
    final backNumber = back?.number;
    final frontValid = front?.problem == AadhaarProblem.none;
    final backValid = back?.problem == AadhaarProblem.none;

    // Two photos that show different Aadhaar numbers are of different cards
    // (or one is misread badly). A valid back number that differs from the
    // front's by one or two digits only is taken as the front misread, and the
    // back's valid number wins; anything further apart is a different card.
    final misreadFront =
        !frontValid &&
        frontNumber != null &&
        backValid &&
        Aadhaar.digitDistance(frontNumber, backNumber!) <= 2;
    final conflict =
        frontNumber != null &&
        backValid &&
        backNumber != frontNumber &&
        !misreadFront;

    // The front decides the number; the back may supply one if the front gave
    // none that was valid (e.g. the two photos were taken the other way round).
    // With a conflict the front stays in charge (as read, even if invalid):
    // the back's number is another card's and is never taken.
    final main = misreadFront
        ? back
        : (conflict || frontValid || !backValid ? front : back);
    final other = identical(main, front) ? back : front;

    return AadhaarReading(
      main?.problem ?? other?.problem ?? AadhaarProblem.noNumber,
      number: main?.number ?? other?.number,
      name: main?.name ?? other?.name,
      dateOfBirth: main?.dateOfBirth ?? other?.dateOfBirth,
      gender: main?.gender ?? other?.gender,
      // The address belongs to the back, whichever photo showed it, unless
      // the back is another person's card.
      address: conflict ? null : (back?.address ?? front?.address),
      nameHi: main?.nameHi ?? other?.nameHi,
      addressHi: conflict ? null : (back?.addressHi ?? front?.addressHi),
      conflictingNumber: conflict ? backNumber : null,
      debugText: [
        if (front != null) 'FRONT PHOTO\n${front.debugText}',
        if (back != null) 'BACK PHOTO\n${back.debugText}',
      ].join('\n\n----------\n\n'),
    );
  }
}
