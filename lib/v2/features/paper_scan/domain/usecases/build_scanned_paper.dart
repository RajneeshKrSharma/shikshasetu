import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../../features/exams/domain/entities/exam_paper.dart';
import '../../../../../features/exams/domain/entities/paper_document.dart';
import '../../../../../features/exams/domain/usecases/build_paper_document.dart';
import '../entities/draft_question.dart';
import '../entities/paper_details.dart';
import '../entities/school_identity.dart';

class BuildScannedPaperParams extends Equatable {
  const BuildScannedPaperParams({
    required this.identity,
    required this.details,
    required this.questions,
    required this.labels,
  });

  final SchoolIdentity identity;
  final PaperDetails details;
  final List<DraftQuestion> questions;
  final PaperLabels labels;

  @override
  List<Object?> get props => [identity, details, questions];
}

/// Turns the checked questions and the header into the PDF.
class BuildScannedPaper implements UseCase<Uint8List, BuildScannedPaperParams> {
  const BuildScannedPaper(this._build);

  final BuildPaperDocument _build;

  @override
  Future<Uint8List> call(BuildScannedPaperParams p) {
    final paper = ExamPaper(
      id: 'scanned',
      title: p.details.examName.trim(),
      subject: p.details.subject.trim(),
      classSection: p.details.classSection.trim(),
      date: DateTime.now(),
      durationMinutes: 0,
      questions: [
        for (final q in p.questions)
          if (!q.isBlank) q.toQuestion(),
      ],
      status: PaperStatus.draft,
    );
    return _build(
      PaperDocumentRequest(
        paper: paper,
        schoolName: p.identity.name.trim(),
        logoPath: p.identity.logoPath,
        labels: p.labels,
        dateText: p.details.examDate.trim(),
        durationText: p.details.duration.trim(),
      ),
    );
  }
}
