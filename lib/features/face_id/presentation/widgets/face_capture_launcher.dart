import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/face_entities.dart';
import '../../domain/repository/face_repositories.dart';
import '../bloc/face_capture_cubit.dart';
import '../screen/face_capture_screen.dart';

/// Opens the live camera screen on top of whatever is showing, from places
/// that have no screen of their own (a use case in the middle of check-in).
class FaceCaptureLauncher implements FaceCapturePort {
  FaceCaptureLauncher(this._navigator);

  final GlobalKey<NavigatorState> _navigator;

  @override
  Future<List<String>?> capture({
    required FaceCapturePurpose purpose,
    required String personName,
  }) async {
    final nav = _navigator.currentState;
    if (nav == null) return null;
    return nav.push<List<String>>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider(
          create: (_) => FaceCaptureCubit(purpose: purpose),
          child: FaceCaptureScreen(personName: personName),
        ),
      ),
    );
  }
}
