import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/exam_paper.dart';
import '../../domain/usecases/change_paper_status.dart';
import '../../domain/usecases/delete_paper.dart';
import '../../domain/usecases/get_papers.dart';
import '../../domain/usecases/mark_paper_conducted.dart';
import '../../domain/usecases/shuffle_paper.dart';

sealed class ExamsEvent extends Equatable {
  const ExamsEvent();

  @override
  List<Object?> get props => const [];
}

final class ExamsLoaded extends ExamsEvent {
  const ExamsLoaded();
}

/// The setter sends a finished paper to the Principal.
final class PaperSubmittedForApproval extends ExamsEvent {
  const PaperSubmittedForApproval(this.paperId);

  final String paperId;

  @override
  List<Object?> get props => [paperId];
}

final class PaperApproved extends ExamsEvent {
  const PaperApproved(this.paperId);

  final String paperId;

  @override
  List<Object?> get props => [paperId];
}

/// The Principal sends the paper back with a reason.
final class PaperSentBack extends ExamsEvent {
  const PaperSentBack(this.paperId, this.note);

  final String paperId;
  final String note;

  @override
  List<Object?> get props => [paperId, note];
}

final class PaperDeleted extends ExamsEvent {
  const PaperDeleted(this.paperId);

  final String paperId;

  @override
  List<Object?> get props => [paperId];
}

final class PaperShuffled extends ExamsEvent {
  const PaperShuffled(this.paperId, {this.options = false});

  final String paperId;
  final bool options;

  @override
  List<Object?> get props => [paperId, options];
}

final class PaperConducted extends ExamsEvent {
  const PaperConducted(this.paperId);

  final String paperId;

  @override
  List<Object?> get props => [paperId];
}

class ExamsState extends Equatable {
  const ExamsState({this.loading = true, this.papers = const []});

  final bool loading;
  final List<ExamPaper> papers;

  /// Papers still to be conducted, soonest first.
  List<ExamPaper> get upcoming =>
      papers.where((p) => !p.isPast).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  /// Waiting for the Principal, oldest submission first.
  List<ExamPaper> get awaitingApproval =>
      papers.where((p) => p.awaitsApproval).toList()..sort(
        (a, b) => (a.submittedAt ?? a.date).compareTo(b.submittedAt ?? b.date),
      );

  /// Approved and not yet conducted, soonest first.
  List<ExamPaper> get ready =>
      papers.where((p) => p.status == PaperStatus.approved).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  /// Still being written, or sent back for changes.
  List<ExamPaper> get inProgress =>
      papers.where((p) => p.isInProgress).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  /// Only what [userId] set (a teacher's own papers).
  ExamsState visibleTo(String userId, {required bool isPrincipal}) =>
      isPrincipal
      ? this
      : ExamsState(
          loading: loading,
          papers: [
            for (final p in papers)
              if (p.createdBy == userId) p,
          ],
        );

  /// Conducted papers, most recent first.
  List<ExamPaper> get past =>
      papers.where((p) => p.isPast).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  ExamPaper? paperById(String id) {
    for (final p in papers) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  List<Object?> get props => [loading, papers];
}

class ExamsBloc extends Bloc<ExamsEvent, ExamsState> {
  ExamsBloc({
    required GetPapers getPapers,
    required MarkPaperConducted markPaperConducted,
    required ChangePaperStatus changePaperStatus,
    required DeletePaper deletePaper,
    required ShufflePaper shufflePaper,
    DateTime Function()? now,
  }) : _getPapers = getPapers,
       _markConducted = markPaperConducted,
       _changeStatus = changePaperStatus,
       _delete = deletePaper,
       _shuffle = shufflePaper,
       _now = now ?? DateTime.now,
       super(const ExamsState()) {
    on<ExamsLoaded>(_onLoaded);
    on<PaperSubmittedForApproval>(
      (e, emit) => _change(e.paperId, PaperStatus.submitted, emit, at: _now()),
    );
    on<PaperApproved>(
      (e, emit) => _change(e.paperId, PaperStatus.approved, emit),
    );
    on<PaperSentBack>(
      (e, emit) =>
          _change(e.paperId, PaperStatus.changesRequested, emit, note: e.note),
    );
    on<PaperDeleted>((e, emit) async {
      await _delete(e.paperId);
      await _onLoaded(const ExamsLoaded(), emit);
    });
    on<PaperShuffled>((e, emit) async {
      final paper = state.paperById(e.paperId);
      if (paper == null) return;
      await _shuffle(ShufflePaperParams(paper, options: e.options));
      await _onLoaded(const ExamsLoaded(), emit);
    });
    on<PaperConducted>((e, emit) async {
      await _markConducted(e.paperId);
      await _onLoaded(const ExamsLoaded(), emit);
    });
  }

  final GetPapers _getPapers;
  final MarkPaperConducted _markConducted;
  final ChangePaperStatus _changeStatus;
  final DeletePaper _delete;
  final ShufflePaper _shuffle;
  final DateTime Function() _now;

  Future<void> _change(
    String id,
    PaperStatus status,
    Emitter<ExamsState> emit, {
    String? note,
    DateTime? at,
  }) async {
    await _changeStatus(
      ChangePaperStatusParams(id, status, note: note, at: at),
    );
    await _onLoaded(const ExamsLoaded(), emit);
  }

  Future<void> _onLoaded(ExamsEvent e, Emitter<ExamsState> emit) async {
    emit(
      ExamsState(loading: false, papers: await _getPapers(const NoParams())),
    );
  }
}
