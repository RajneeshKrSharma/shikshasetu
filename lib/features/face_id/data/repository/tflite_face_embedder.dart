import 'dart:io';
import 'dart:math';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_litert/flutter_litert.dart';

import '../../domain/entities/face_entities.dart';
import '../../domain/repository/face_repositories.dart';

/// Face embeddings on the phone: ML Kit finds the face in the picture, and the
/// bundled FaceNet model (160x160 in, 128 numbers out) describes it. Nothing
/// is uploaded.
class TfliteFaceEmbedder implements FaceEmbedder {
  static const _asset = 'assets/models/facenet.tflite';
  static const _size = 160;
  static const _dims = 128;

  /// A little of the surroundings is kept around the face box.
  static const _margin = 0.10;

  final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
  );
  Interpreter? _interpreter;

  Future<Interpreter> _model() async =>
      _interpreter ??= await Interpreter.fromAsset(_asset);

  @override
  Future<List<double>> embed(String imagePath) async {
    final faces = await _detector.processImage(
      InputImage.fromFilePath(imagePath),
    );
    if (faces.length != 1) {
      throw const FaceException(FaceProblem.notFound);
    }

    final decoded = img.decodeImage(await File(imagePath).readAsBytes());
    if (decoded == null) throw const FaceException(FaceProblem.notFound);
    // Same upright orientation ML Kit used for the box.
    final upright = img.bakeOrientation(decoded);

    final box = faces.first.boundingBox;
    final padX = box.width * _margin;
    final padY = box.height * _margin;
    final x = max(0, (box.left - padX).floor());
    final y = max(0, (box.top - padY).floor());
    final w = min(upright.width - x, (box.width + 2 * padX).ceil());
    final h = min(upright.height - y, (box.height + 2 * padY).ceil());
    if (w < 20 || h < 20) throw const FaceException(FaceProblem.notFound);

    final face = img.copyResize(
      img.copyCrop(upright, x: x, y: y, width: w, height: h),
      width: _size,
      height: _size,
      interpolation: img.Interpolation.linear,
    );

    try {
      final interpreter = await _model();
      final output = [List<double>.filled(_dims, 0)];
      interpreter.run(_input(face), output);
      return output.first;
    } catch (_) {
      throw const FaceException(FaceProblem.unavailable);
    }
  }

  /// The picture as [1][160][160][3] numbers, standardised the way the model
  /// was trained: subtract the mean and divide by the standard deviation of
  /// all values (with a floor so a flat image does not blow up).
  List<List<List<List<double>>>> _input(img.Image face) {
    final values = <double>[];
    for (var y = 0; y < _size; y++) {
      for (var x = 0; x < _size; x++) {
        final p = face.getPixel(x, y);
        values
          ..add(p.r.toDouble())
          ..add(p.g.toDouble())
          ..add(p.b.toDouble());
      }
    }
    final n = values.length;
    final mean = values.reduce((a, b) => a + b) / n;
    var variance = 0.0;
    for (final v in values) {
      variance += (v - mean) * (v - mean);
    }
    final std = max(sqrt(variance / n), 1 / sqrt(n));

    var i = 0;
    return [
      List.generate(
        _size,
        (_) => List.generate(_size, (_) {
          final pixel = [
            (values[i] - mean) / std,
            (values[i + 1] - mean) / std,
            (values[i + 2] - mean) / std,
          ];
          i += 3;
          return pixel;
        }),
      ),
    ];
  }

  Future<void> close() async {
    await _detector.close();
    _interpreter?.close();
  }
}
