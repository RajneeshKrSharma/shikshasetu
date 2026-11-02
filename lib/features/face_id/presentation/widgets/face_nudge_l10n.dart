import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/face_entities.dart';

extension FaceNudgeL10n on FaceNudge {
  String message(AppLocalizations l) => switch (this) {
    FaceNudge.starting => l.faceNudgeStarting,
    FaceNudge.showFace => l.faceNudgeShowFace,
    FaceNudge.onlyOneFace => l.faceNudgeOnlyOne,
    FaceNudge.moveCloser => l.faceNudgeCloser,
    FaceNudge.moveBack => l.faceNudgeBack,
    FaceNudge.centerFace => l.faceNudgeCenter,
    FaceNudge.lookStraight => l.faceNudgeStraight,
    FaceNudge.openEyes => l.faceNudgeOpenEyes,
    FaceNudge.holdStill => l.faceNudgeHold,
    FaceNudge.blinkNow => l.faceNudgeBlink,
    FaceNudge.capturing => l.faceNudgeCapturing,
  };

  IconData get icon => switch (this) {
    FaceNudge.starting => Icons.videocam_outlined,
    FaceNudge.showFace => Icons.face_retouching_natural,
    FaceNudge.onlyOneFace => Icons.groups_outlined,
    FaceNudge.moveCloser => Icons.zoom_in,
    FaceNudge.moveBack => Icons.zoom_out,
    FaceNudge.centerFace => Icons.center_focus_strong_outlined,
    FaceNudge.lookStraight => Icons.visibility_outlined,
    FaceNudge.openEyes => Icons.remove_red_eye_outlined,
    FaceNudge.holdStill => Icons.pause_circle_outline,
    FaceNudge.blinkNow => Icons.visibility_off_outlined,
    FaceNudge.capturing => Icons.check_circle_outline,
  };

  /// Whether the person is doing well (shown in green) or needs to adjust.
  bool get isGood =>
      this == FaceNudge.holdStill ||
      this == FaceNudge.blinkNow ||
      this == FaceNudge.capturing;
}
