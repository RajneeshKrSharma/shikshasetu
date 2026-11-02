import 'face_entities.dart';

/// What the camera saw in one frame.
class FaceObservation {
  const FaceObservation({
    required this.faceCount,
    this.sizeRatio = 0,
    this.offCenter = 0,
    this.yaw = 0,
    this.pitch = 0,
    this.leftEyeOpen,
    this.rightEyeOpen,
  });

  const FaceObservation.none() : this(faceCount: 0);

  final int faceCount;

  /// Width of the face as a fraction of the picture's width.
  final double sizeRatio;

  /// Distance of the face from the picture's centre, as a fraction of the
  /// picture's size (0 = centred).
  final double offCenter;

  /// Head turn left/right and up/down, in degrees.
  final double yaw;
  final double pitch;

  /// 0 (closed) to 1 (open); null when the phone could not tell.
  final double? leftEyeOpen;
  final double? rightEyeOpen;

  bool get eyesKnown => leftEyeOpen != null && rightEyeOpen != null;
  bool get eyesOpen =>
      eyesKnown && leftEyeOpen! > _open && rightEyeOpen! > _open;
  bool get eyesClosed =>
      eyesKnown && leftEyeOpen! < _closed && rightEyeOpen! < _closed;

  static const _open = 0.65;
  static const _closed = 0.35;
}

/// The camera screen's next instruction.
class FaceGuideStep {
  const FaceGuideStep(this.nudge, {this.progress = 0, this.captureNow = false});

  final FaceNudge nudge;

  /// How far along the current hold is, 0 to 1.
  final double progress;

  /// The moment to take the picture.
  final bool captureNow;
}

/// Turns what the camera sees into one instruction at a time, and decides
/// when to take the picture:
///
/// 1. the face must be one, a good size, centred, facing the camera, eyes open;
/// 2. hold still for [hold];
/// 3. when [requireBlink], blink once (eyes close then open) to show it is a
///    live person and not a photo; then the picture is taken.
///
/// No clocks or cameras in here: callers pass the time in, so it can be
/// tested frame by frame.
class FaceGuide {
  FaceGuide({
    this.requireBlink = true,
    this.hold = const Duration(milliseconds: 700),
  });

  final bool requireBlink;
  final Duration hold;

  // How good a pose has to be. Fractions of the picture, and degrees.
  static const minSize = 0.30;
  static const maxSize = 0.75;
  static const maxOffCenter = 0.25;
  static const maxYaw = 12.0;
  static const maxPitch = 15.0;

  DateTime? _steadySince;
  bool _eyesWereClosed = false;

  /// Forget progress, e.g. before the next picture of a set.
  void restart() {
    _steadySince = null;
    _eyesWereClosed = false;
  }

  FaceGuideStep update(FaceObservation? obs, DateTime now) {
    if (obs == null || obs.faceCount == 0) {
      restart();
      return const FaceGuideStep(FaceNudge.showFace);
    }
    if (obs.faceCount > 1) {
      restart();
      return const FaceGuideStep(FaceNudge.onlyOneFace);
    }
    if (obs.sizeRatio < minSize) return _lose(FaceNudge.moveCloser);
    if (obs.sizeRatio > maxSize) return _lose(FaceNudge.moveBack);
    if (obs.offCenter > maxOffCenter) return _lose(FaceNudge.centerFace);
    if (obs.yaw.abs() > maxYaw || obs.pitch.abs() > maxPitch) {
      return _lose(FaceNudge.lookStraight);
    }

    // The blink itself: eyes close, then open again.
    if (_steadySince != null && requireBlink && _blinkPhase(now)) {
      if (obs.eyesClosed) {
        _eyesWereClosed = true;
        return const FaceGuideStep(FaceNudge.blinkNow, progress: 1);
      }
      if (_eyesWereClosed && obs.eyesOpen) {
        return const FaceGuideStep(
          FaceNudge.capturing,
          progress: 1,
          captureNow: true,
        );
      }
      return const FaceGuideStep(FaceNudge.blinkNow, progress: 1);
    }

    if (!obs.eyesOpen) {
      // Eyes shut before the blink step is just a blink in progress; but
      // when they stay unreadable or closed this early, ask to open them.
      if (_steadySince == null) return _lose(FaceNudge.openEyes);
    }

    _steadySince ??= now;
    final held = now.difference(_steadySince!);
    if (held < hold) {
      return FaceGuideStep(
        FaceNudge.holdStill,
        progress: held.inMilliseconds / hold.inMilliseconds,
      );
    }
    if (requireBlink) {
      return const FaceGuideStep(FaceNudge.blinkNow, progress: 1);
    }
    return const FaceGuideStep(
      FaceNudge.capturing,
      progress: 1,
      captureNow: true,
    );
  }

  bool _blinkPhase(DateTime now) => now.difference(_steadySince!) >= hold;

  FaceGuideStep _lose(FaceNudge nudge) {
    restart();
    return FaceGuideStep(nudge);
  }
}
