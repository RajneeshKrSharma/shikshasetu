import '../entities/scanned_question.dart';

abstract interface class PhotoPickerRepository {
  /// Path of the chosen photo, or null if the user cancelled.
  Future<String?> pick(PhotoSource source);
}
