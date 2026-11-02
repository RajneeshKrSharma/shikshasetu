import 'dart:math';

import 'face_entities.dart';

/// Compares face embeddings.
class FaceMatcher {
  const FaceMatcher({this.threshold = defaultThreshold});

  /// Cosine similarity at or above which two faces count as the same person.
  ///
  /// A starting point, not a proven value: it sits just above the 0.4 the
  /// FaceNet model's author uses for general recognition, because here a wrong
  /// match lets someone mark attendance for another. Check the scores that are
  /// saved with each check-in and adjust.
  static const defaultThreshold = 0.5;

  final double threshold;

  /// 1 for the same direction, 0 for unrelated, -1 for opposite.
  static double cosine(List<double> a, List<double> b) {
    if (a.length != b.length || a.isEmpty) return -1;
    var dot = 0.0, na = 0.0, nb = 0.0;
    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    if (na == 0 || nb == 0) return -1;
    return dot / (sqrt(na) * sqrt(nb));
  }

  /// The best score of [face] against any of the template's embeddings.
  FaceMatch compare(List<double> face, FaceTemplate template) {
    var best = -1.0;
    for (final e in template.embeddings) {
      final s = cosine(face, e);
      if (s > best) best = s;
    }
    return FaceMatch(score: best, matched: best >= threshold);
  }
}
