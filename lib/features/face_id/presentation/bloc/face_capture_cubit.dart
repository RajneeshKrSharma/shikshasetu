import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/face_entities.dart';
import '../../domain/entities/face_guide.dart';

enum CapturePhase { starting, active, error }

enum CaptureError { cameraDenied, cameraUnavailable }

class FaceCaptureState extends Equatable {
  const FaceCaptureState({
    this.phase = CapturePhase.starting,
    this.error,
    this.nudge = FaceNudge.starting,
    this.progress = 0,
    this.shots = const [],
    this.needed = 1,
    this.captureRequestId = 0,
    this.capturing = false,
    this.done = false,
  });

  final CapturePhase phase;
  final CaptureError? error;
  final FaceNudge nudge;

  /// How far the current hold is, 0 to 1.
  final double progress;

  /// Pictures taken so far.
  final List<String> shots;
  final int needed;

  /// Goes up each time the screen should take a picture.
  final int captureRequestId;

  /// A picture is being taken.
  final bool capturing;
  final bool done;

  FaceCaptureState copyWith({
    CapturePhase? phase,
    CaptureError? error,
    FaceNudge? nudge,
    double? progress,
    List<String>? shots,
    int? captureRequestId,
    bool? capturing,
    bool? done,
  }) => FaceCaptureState(
    phase: phase ?? this.phase,
    error: error ?? this.error,
    nudge: nudge ?? this.nudge,
    progress: progress ?? this.progress,
    shots: shots ?? this.shots,
    needed: needed,
    captureRequestId: captureRequestId ?? this.captureRequestId,
    capturing: capturing ?? this.capturing,
    done: done ?? this.done,
  );

  @override
  List<Object?> get props => [
    phase,
    error,
    nudge,
    progress,
    shots,
    needed,
    captureRequestId,
    capturing,
    done,
  ];
}

/// The live camera step. The screen reports what the camera sees; this decides
/// what to tell the person and when to take each picture.
class FaceCaptureCubit extends Cubit<FaceCaptureState> {
  /// Setting up takes [enrollShots] pictures and needs no blink; checking in
  /// takes one, after a blink.
  FaceCaptureCubit({
    required this.purpose,
    this.enrollShots = 3,
    DateTime Function()? now,
  }) : _guide = FaceGuide(requireBlink: purpose == FaceCapturePurpose.verify),
       _now = now ?? DateTime.now,
       super(
         FaceCaptureState(
           needed: purpose == FaceCapturePurpose.enroll ? enrollShots : 1,
         ),
       );

  final FaceCapturePurpose purpose;
  final int enrollShots;
  final FaceGuide _guide;
  final DateTime Function() _now;

  void cameraReady() => emit(
    state.copyWith(phase: CapturePhase.active, nudge: FaceNudge.showFace),
  );

  void cameraFailed(CaptureError error) =>
      emit(state.copyWith(phase: CapturePhase.error, error: error));

  /// One camera frame's observation (null when no face was found).
  void observe(FaceObservation? observation) {
    if (state.phase != CapturePhase.active || state.capturing || state.done) {
      return;
    }
    final step = _guide.update(observation, _now());
    emit(
      state.copyWith(
        nudge: step.nudge,
        progress: step.progress,
        capturing: step.captureNow,
        captureRequestId: step.captureNow
            ? state.captureRequestId + 1
            : state.captureRequestId,
      ),
    );
  }

  /// The picture the screen was asked for.
  void shotTaken(String path) {
    final shots = [...state.shots, path];
    final done = shots.length >= state.needed;
    _guide.restart();
    emit(
      state.copyWith(
        shots: shots,
        capturing: false,
        done: done,
        nudge: done ? FaceNudge.capturing : FaceNudge.showFace,
        progress: 0,
      ),
    );
  }

  /// Taking the picture failed; start the guidance over.
  void shotFailed() {
    _guide.restart();
    emit(
      state.copyWith(capturing: false, nudge: FaceNudge.showFace, progress: 0),
    );
  }
}
