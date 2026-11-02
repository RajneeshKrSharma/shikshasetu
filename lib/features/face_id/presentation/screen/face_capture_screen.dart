import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../domain/entities/face_entities.dart';
import '../bloc/face_capture_cubit.dart';
import '../widgets/face_nudge_l10n.dart';
import '../widgets/face_observation_mapper.dart';

/// Live camera (front first; it can be flipped) with spoken-style nudges ("move closer", "blink once").
/// Pops with the pictures taken, or null if the person backs out. Expects a
/// [FaceCaptureCubit] above it.
class FaceCaptureScreen extends StatefulWidget {
  const FaceCaptureScreen({super.key, required this.personName});

  final String personName;

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _camera;
  late final FaceDetector _detector;

  /// Which camera is open. The front one first; the flip button swaps it
  /// (useful on an emulator, where the back camera shows a picture of a face).
  CameraLensDirection _lens = CameraLensDirection.front;

  /// More than one camera exists, so the flip button is shown.
  late final ValueNotifier<bool> _canFlip;

  /// Frames are looked at one at a time, a few times a second.
  bool _analysing = false;
  DateTime _lastFrame = DateTime.fromMillisecondsSinceEpoch(0);
  static const _frameGap = Duration(milliseconds: 120);

  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    _canFlip = ValueNotifier(false);
    _openCamera();
  }

  @override
  void dispose() {
    final camera = _camera;
    if (camera != null) {
      if (camera.value.isStreamingImages) camera.stopImageStream();
      camera.dispose();
    }
    _detector.close();
    _canFlip.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    final cubit = context.read<FaceCaptureCubit>();
    try {
      final cameras = await availableCameras();
      _canFlip.value = cameras.map((c) => c.lensDirection).toSet().containsAll({
        CameraLensDirection.front,
        CameraLensDirection.back,
      });
      final front = cameras.where((c) => c.lensDirection == _lens).firstOrNull;
      if (front == null) {
        cubit.cameraFailed(CaptureError.cameraUnavailable);
        return;
      }
      final controller = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      _camera = controller;
      cubit.cameraReady();
      await controller.startImageStream(_onFrame);
      setState(() {}); // the preview can show now
    } on CameraException catch (e) {
      cubit.cameraFailed(
        e.code.contains('Denied') || e.code.contains('Restricted')
            ? CaptureError.cameraDenied
            : CaptureError.cameraUnavailable,
      );
    } catch (_) {
      cubit.cameraFailed(CaptureError.cameraUnavailable);
    }
  }

  /// Swaps between the front and the back camera.
  Future<void> _flipCamera() async {
    final old = _camera;
    if (old == null) return;
    _camera = null;
    setState(() {}); // hides the old preview before it is disposed
    if (old.value.isStreamingImages) await old.stopImageStream();
    await old.dispose();
    _lens = _lens == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;
    if (mounted) await _openCamera();
  }

  Future<void> _onFrame(CameraImage frame) async {
    final now = DateTime.now();
    if (_analysing || now.difference(_lastFrame) < _frameGap) return;
    _analysing = true;
    _lastFrame = now;
    try {
      final input = _inputImage(frame);
      if (input == null) return;
      final faces = await _detector.processImage(input);
      if (!mounted) return;
      final rotation = input.metadata!.rotation;
      final sideways =
          rotation == InputImageRotation.rotation90deg ||
          rotation == InputImageRotation.rotation270deg;
      final upright = sideways
          ? Size(frame.height.toDouble(), frame.width.toDouble())
          : Size(frame.width.toDouble(), frame.height.toDouble());
      context.read<FaceCaptureCubit>().observe(observationFrom(faces, upright));
    } finally {
      _analysing = false;
    }
  }

  /// A camera frame in the form ML Kit reads (the standard recipe: one plane,
  /// NV21 on Android and BGRA on iOS, with the rotation that makes it upright).
  InputImage? _inputImage(CameraImage image) {
    final camera = _camera;
    if (camera == null) return null;
    final description = camera.description;
    final sensor = description.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensor);
    } else {
      final device = _orientations[camera.value.deviceOrientation] ?? 0;
      final compensation =
          description.lensDirection == CameraLensDirection.front
          ? (sensor + device) % 360
          : (sensor - device + 360) % 360;
      rotation = InputImageRotationValue.fromRawValue(compensation);
    }
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (rotation == null ||
        format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888) ||
        image.planes.length != 1) {
      return null;
    }
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Future<void> _takePicture() async {
    final cubit = context.read<FaceCaptureCubit>();
    final camera = _camera;
    if (camera == null) return;
    try {
      if (camera.value.isStreamingImages) await camera.stopImageStream();
      final shot = await camera.takePicture();
      cubit.shotTaken(shot.path);
      if (!cubit.state.done && mounted) await camera.startImageStream(_onFrame);
    } catch (_) {
      cubit.shotFailed();
      if (mounted && !camera.value.isStreamingImages) {
        try {
          await camera.startImageStream(_onFrame);
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<FaceCaptureCubit>();
    final enrolling = cubit.purpose == FaceCapturePurpose.enroll;
    return MultiBlocListener(
      listeners: [
        BlocListener<FaceCaptureCubit, FaceCaptureState>(
          listenWhen: (a, b) => a.captureRequestId != b.captureRequestId,
          listener: (context, s) => _takePicture(),
        ),
        BlocListener<FaceCaptureCubit, FaceCaptureState>(
          listenWhen: (a, b) => !a.done && b.done,
          listener: (context, s) => Navigator.of(context).pop(s.shots),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(
            enrolling ? l.faceCaptureEnrollTitle : l.faceCaptureVerifyTitle,
          ),
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: _canFlip,
              builder: (context, canFlip, _) => canFlip
                  ? IconButton(
                      tooltip: l.faceFlipCamera,
                      icon: const Icon(Icons.cameraswitch_outlined),
                      onPressed: _flipCamera,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<FaceCaptureCubit, FaceCaptureState>(
            builder: (context, s) {
              if (s.phase == CapturePhase.error) {
                return _ErrorView(error: s.error!);
              }
              final good = s.nudge.isGood;
              final color = good ? AppColors.present : Colors.white;
              return Column(
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    widget.personName,
                    style: context.text.titleMedium!.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  if (enrolling)
                    Text(
                      l.faceCaptureStep(
                        (s.shots.length + 1).clamp(1, s.needed),
                        s.needed,
                      ),
                      style: context.text.labelMedium!.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 280,
                            height: 280,
                            child: _camera?.value.isInitialized == true
                                ? FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _camera!.value.previewSize!.height,
                                      height: _camera!.value.previewSize!.width,
                                      child: CameraPreview(_camera!),
                                    ),
                                  )
                                : const ColoredBox(color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: CircularProgressIndicator(
                            value: good ? s.progress.clamp(0, 1) : 0,
                            strokeWidth: 6,
                            color: AppColors.present,
                            backgroundColor: good
                                ? Colors.white24
                                : Colors.white24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(s.nudge.icon, color: color),
                        const SizedBox(width: AppSpacing.md),
                        Flexible(
                          child: Text(
                            s.nudge.message(l),
                            textAlign: TextAlign.center,
                            style: context.text.titleLarge!.copyWith(
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l.actionCancel,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final CaptureError error;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: AppSpacing.pageOf(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              size: AppIconSize.hero,
              color: Colors.white70,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              error == CaptureError.cameraDenied
                  ? l.faceCameraDenied
                  : l.faceCameraMissing,
              textAlign: TextAlign.center,
              style: context.text.bodyLarge!.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.actionCancel),
            ),
          ],
        ),
      ),
    );
  }
}
