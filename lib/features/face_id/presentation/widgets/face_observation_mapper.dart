import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../domain/entities/face_guide.dart';

/// Reads ML Kit's result for one frame as a [FaceObservation].
/// [upright] is the size of the frame as it appears the right way up (the
/// size ML Kit's boxes are measured against).
FaceObservation observationFrom(List<Face> faces, Size upright) {
  if (faces.isEmpty) return const FaceObservation.none();
  if (faces.length > 1) return FaceObservation(faceCount: faces.length);
  final f = faces.first;
  final box = f.boundingBox;
  final dx = (box.center.dx - upright.width / 2) / upright.width;
  final dy = (box.center.dy - upright.height / 2) / upright.height;
  return FaceObservation(
    faceCount: 1,
    sizeRatio: box.width / upright.width,
    offCenter: Offset(dx, dy).distance,
    yaw: f.headEulerAngleY ?? 0,
    pitch: f.headEulerAngleX ?? 0,
    leftEyeOpen: f.leftEyeOpenProbability,
    rightEyeOpen: f.rightEyeOpenProbability,
  );
}
