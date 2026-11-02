import 'package:equatable/equatable.dart';

/// What a teacher's face looks like to the matcher: a few embeddings (lists of
/// numbers describing a face), taken when the face was set up. The photos are
/// not kept, only these numbers.
class FaceTemplate extends Equatable {
  const FaceTemplate({
    required this.teacherId,
    required this.embeddings,
    required this.enrolledAt,
    this.enrolledBy,
  });

  final String teacherId;
  final List<List<double>> embeddings;
  final DateTime enrolledAt;
  final String? enrolledBy;

  @override
  List<Object?> get props => [teacherId, embeddings, enrolledAt, enrolledBy];
}

/// The result of comparing a face with a template.
class FaceMatch extends Equatable {
  const FaceMatch({required this.score, required this.matched});

  /// How alike the faces are, -1 to 1; higher is more alike.
  final double score;
  final bool matched;

  @override
  List<Object?> get props => [score, matched];
}

/// Why a face could not be compared at all.
enum FaceProblem {
  /// No face (or more than one) in the picture.
  notFound,

  /// The face model could not run.
  unavailable,

  /// The teacher has no face set up.
  notEnrolled,
}

class FaceException implements Exception {
  const FaceException(this.problem);

  final FaceProblem problem;

  @override
  String toString() => 'FaceException($problem)';
}

enum FaceCapturePurpose {
  /// Setting up: several still, frontal pictures.
  enroll,

  /// Checking in: one picture, after a blink proves it is a live person.
  verify,
}

/// What the live camera screen asks the person to do.
enum FaceNudge {
  starting,
  showFace,
  onlyOneFace,
  moveCloser,
  moveBack,
  centerFace,
  lookStraight,
  openEyes,
  holdStill,
  blinkNow,
  capturing,
}
