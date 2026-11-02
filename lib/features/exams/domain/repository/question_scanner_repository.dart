import '../entities/scanned_question.dart';

abstract interface class QuestionScannerRepository {
  /// Recognizes the text in the image at [imagePath]. Returns an empty
  /// string when nothing readable is found.
  Future<String> recognize(String imagePath, {required ScanScript script});
}
