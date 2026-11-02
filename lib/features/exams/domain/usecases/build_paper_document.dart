import 'dart:typed_data';

import '../../../../core/usecase/usecase.dart';
import '../entities/paper_document.dart';
import '../repository/paper_document_repository.dart';

class BuildPaperDocument implements UseCase<Uint8List, PaperDocumentRequest> {
  const BuildPaperDocument(this._repository);

  final PaperDocumentRepository _repository;

  @override
  Future<Uint8List> call(PaperDocumentRequest request) =>
      _repository.build(request);
}
