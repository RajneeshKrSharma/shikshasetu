import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/aadhaar.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../../../exams/domain/usecases/pick_photo.dart';
import '../../domain/usecases/read_aadhaar_card.dart';

enum AadhaarSide { front, back }

class AadhaarCaptureState extends Equatable {
  const AadhaarCaptureState({
    this.frontPath,
    this.backPath,
    this.reading = false,
    this.result,
    this.failed = false,
  });

  final String? frontPath;
  final String? backPath;

  /// The photos are being read.
  final bool reading;

  /// What the two photos gave; null until they have been read.
  final AadhaarReading? result;

  /// The photos could not be read at all (an error, not just "nothing found").
  final bool failed;

  /// The front is needed for the number, name, gender and date of birth.
  bool get canRead => frontPath != null && !reading;

  AadhaarCaptureState copyWith({
    String? frontPath,
    String? backPath,
    bool? reading,
    AadhaarReading? result,
    bool clearResult = false,
    bool? failed,
  }) => AadhaarCaptureState(
    frontPath: frontPath ?? this.frontPath,
    backPath: backPath ?? this.backPath,
    reading: reading ?? this.reading,
    result: clearResult ? null : (result ?? this.result),
    failed: failed ?? this.failed,
  );

  @override
  List<Object?> get props => [frontPath, backPath, reading, result, failed];
}

/// Takes the front and back photos of an Aadhaar card on one screen, reads
/// them, and holds what was found until the person accepts it.
class AadhaarCaptureCubit extends Cubit<AadhaarCaptureState> {
  AadhaarCaptureCubit({
    required PickPhoto pickPhoto,
    required ReadAadhaarCard readAadhaarCard,
  }) : _pick = pickPhoto,
       _read = readAadhaarCard,
       super(const AadhaarCaptureState());

  final PickPhoto _pick;
  final ReadAadhaarCard _read;

  /// Photographs (or picks) one side. A new photo clears an earlier reading.
  Future<void> pick(AadhaarSide side, PhotoSource source) async {
    final path = await _pick(source);
    if (path == null) return; // cancelled
    emit(
      side == AadhaarSide.front
          ? state.copyWith(frontPath: path, clearResult: true, failed: false)
          : state.copyWith(backPath: path, clearResult: true, failed: false),
    );
  }

  Future<void> read() async {
    if (!state.canRead) return;
    emit(state.copyWith(reading: true, failed: false));
    try {
      final result = await _read(
        AadhaarPhotos(front: state.frontPath, back: state.backPath),
      );
      emit(state.copyWith(reading: false, result: result));
    } catch (_) {
      emit(state.copyWith(reading: false, failed: true));
    }
  }

  /// Back to taking photos, keeping nothing.
  void startOver() => emit(const AadhaarCaptureState());
}
