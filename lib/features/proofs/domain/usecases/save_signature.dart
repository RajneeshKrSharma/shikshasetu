import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/proof_store.dart';

class SaveSignatureParams extends Equatable {
  const SaveSignatureParams(this.png, this.folder);

  final Uint8List png;
  final String folder;

  @override
  List<Object?> get props => [png, folder];
}

class SaveSignature implements UseCase<String, SaveSignatureParams> {
  const SaveSignature(this._store);

  final ProofStore _store;

  @override
  Future<String> call(SaveSignatureParams p) =>
      _store.saveSignature(p.png, folder: p.folder);
}
