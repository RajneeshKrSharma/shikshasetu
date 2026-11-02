import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/proof_source.dart';
import '../repository/proof_store.dart';

class CaptureProofPhotoParams extends Equatable {
  const CaptureProofPhotoParams(this.source, this.folder);

  final ProofSource source;
  final String folder;

  @override
  List<Object?> get props => [source, folder];
}

class CaptureProofPhoto implements UseCase<String?, CaptureProofPhotoParams> {
  const CaptureProofPhoto(this._store);

  final ProofStore _store;

  @override
  Future<String?> call(CaptureProofPhotoParams p) =>
      _store.capturePhoto(p.source, folder: p.folder);
}
