import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/proof_source.dart';
import '../../domain/usecases/capture_proof_photo.dart';
import '../../domain/usecases/save_signature.dart';

class ProofState extends Equatable {
  const ProofState({this.photoPath, this.signaturePath, this.busy = false});

  final String? photoPath;
  final String? signaturePath;
  final bool busy;

  bool get hasPhoto => photoPath != null;
  bool get hasSignature => signaturePath != null;

  ProofState copyWith({
    String? photoPath,
    bool clearPhoto = false,
    String? signaturePath,
    bool clearSignature = false,
    bool? busy,
  }) => ProofState(
    photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
    signaturePath: clearSignature
        ? null
        : (signaturePath ?? this.signaturePath),
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [photoPath, signaturePath, busy];
}

/// The proof being gathered on one form: a photo and/or a signature. The
/// form reads the paths when it is saved.
class ProofCubit extends Cubit<ProofState> {
  ProofCubit({
    required this.folder,
    required CaptureProofPhoto capturePhoto,
    required SaveSignature saveSignature,
  }) : _capture = capturePhoto,
       _saveSignature = saveSignature,
       super(const ProofState());

  /// The folder the proofs are kept in: "fees", "accessories"...
  final String folder;
  final CaptureProofPhoto _capture;
  final SaveSignature _saveSignature;

  Future<void> takePhoto(ProofSource source) async {
    emit(state.copyWith(busy: true));
    final path = await _capture(CaptureProofPhotoParams(source, folder));
    emit(
      path == null
          ? state.copyWith(busy: false)
          : state.copyWith(photoPath: path, busy: false),
    );
  }

  void removePhoto() => emit(state.copyWith(clearPhoto: true));

  Future<void> signed(Uint8List png) async {
    final path = await _saveSignature(SaveSignatureParams(png, folder));
    emit(state.copyWith(signaturePath: path));
  }

  void clearSignature() => emit(state.copyWith(clearSignature: true));
}
