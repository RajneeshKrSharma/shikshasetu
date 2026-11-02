import '../entities/face_entities.dart';

abstract interface class FaceTemplateRepository {
  Future<FaceTemplate?> get(String teacherId);
  Future<void> save(FaceTemplate template);
  Future<void> delete(String teacherId);

  /// Ids of the teachers who have a face set up.
  Future<Set<String>> enrolledIds();
}

/// Turns the face in a picture into numbers.
abstract interface class FaceEmbedder {
  /// The embedding of the one face in the picture at [imagePath]. Throws
  /// [FaceException] when there is no face, more than one, or the model
  /// cannot run.
  Future<List<double>> embed(String imagePath);
}

/// The live camera step, carried out by the screen layer. Opens the camera,
/// guides the person, and returns the pictures taken (one to verify, a few to
/// set up), or null if they backed out.
abstract interface class FaceCapturePort {
  Future<List<String>?> capture({
    required FaceCapturePurpose purpose,
    required String personName,
  });
}
