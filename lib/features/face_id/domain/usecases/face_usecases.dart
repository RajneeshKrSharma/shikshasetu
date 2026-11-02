import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/face_entities.dart';
import '../entities/face_matcher.dart';
import '../repository/face_repositories.dart';

class HasFaceEnrolled implements UseCase<bool, String> {
  const HasFaceEnrolled(this._templates);

  final FaceTemplateRepository _templates;

  @override
  Future<bool> call(String teacherId) async =>
      await _templates.get(teacherId) != null;
}

class GetEnrolledFaceIds implements UseCase<Set<String>, NoParams> {
  const GetEnrolledFaceIds(this._templates);

  final FaceTemplateRepository _templates;

  @override
  Future<Set<String>> call(NoParams params) => _templates.enrolledIds();
}

class EnrollFaceParams extends Equatable {
  const EnrollFaceParams({
    required this.teacherId,
    required this.imagePaths,
    this.enrolledBy,
  });

  final String teacherId;
  final List<String> imagePaths;
  final String? enrolledBy;

  @override
  List<Object?> get props => [teacherId, imagePaths, enrolledBy];
}

/// Sets up a teacher's face from a few pictures. Throws [FaceException] if
/// any picture has no clear single face.
class EnrollFace implements UseCase<void, EnrollFaceParams> {
  const EnrollFace(this._embedder, this._templates, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final FaceEmbedder _embedder;
  final FaceTemplateRepository _templates;
  final DateTime Function() _now;

  @override
  Future<void> call(EnrollFaceParams p) async {
    if (p.imagePaths.isEmpty) {
      throw const FaceException(FaceProblem.notFound);
    }
    final embeddings = <List<double>>[];
    for (final path in p.imagePaths) {
      embeddings.add(await _embedder.embed(path));
    }
    await _templates.save(
      FaceTemplate(
        teacherId: p.teacherId,
        embeddings: embeddings,
        enrolledAt: _now(),
        enrolledBy: p.enrolledBy,
      ),
    );
  }
}

class VerifyFaceParams extends Equatable {
  const VerifyFaceParams(this.teacherId, this.imagePath);

  final String teacherId;
  final String imagePath;

  @override
  List<Object?> get props => [teacherId, imagePath];
}

/// Compares the face in a picture with the teacher's set-up face. Throws
/// [FaceException].
class VerifyFace implements UseCase<FaceMatch, VerifyFaceParams> {
  const VerifyFace(
    this._embedder,
    this._templates, {
    this.matcher = const FaceMatcher(),
  });

  final FaceEmbedder _embedder;
  final FaceTemplateRepository _templates;
  final FaceMatcher matcher;

  @override
  Future<FaceMatch> call(VerifyFaceParams p) async {
    final template = await _templates.get(p.teacherId);
    if (template == null) {
      throw const FaceException(FaceProblem.notEnrolled);
    }
    return matcher.compare(await _embedder.embed(p.imagePath), template);
  }
}

class RemoveFace implements UseCase<void, String> {
  const RemoveFace(this._templates);

  final FaceTemplateRepository _templates;

  @override
  Future<void> call(String teacherId) => _templates.delete(teacherId);
}

/// When the teacher's Face ID was set up, or null if it is not set up.
class GetFaceEnrollment implements UseCase<DateTime?, String> {
  const GetFaceEnrollment(this._templates);

  final FaceTemplateRepository _templates;

  @override
  Future<DateTime?> call(String teacherId) async =>
      (await _templates.get(teacherId))?.enrolledAt;
}

class SetUpFaceParams extends Equatable {
  const SetUpFaceParams({
    required this.teacherId,
    required this.teacherName,
    this.enrolledBy,
  });

  final String teacherId;
  final String teacherName;
  final String? enrolledBy;

  @override
  List<Object?> get props => [teacherId, teacherName, enrolledBy];
}

/// Opens the live camera to take the set-up pictures, then saves the face.
/// False when the person backed out. Throws [FaceException].
class SetUpFace implements UseCase<bool, SetUpFaceParams> {
  const SetUpFace(this._capture, this._enroll);

  final FaceCapturePort _capture;
  final EnrollFace _enroll;

  @override
  Future<bool> call(SetUpFaceParams p) async {
    final shots = await _capture.capture(
      purpose: FaceCapturePurpose.enroll,
      personName: p.teacherName,
    );
    if (shots == null || shots.isEmpty) return false;
    await _enroll(
      EnrollFaceParams(
        teacherId: p.teacherId,
        imagePaths: shots,
        enrolledBy: p.enrolledBy,
      ),
    );
    return true;
  }
}
