import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../../features/exams/domain/entities/paper_document.dart';
import '../../../../../features/exams/domain/entities/scanned_question.dart';
import '../../../../../features/exams/domain/usecases/pick_photo.dart';
import '../../../../../features/printing/domain/usecases/printer_usecases.dart';
import '../../domain/entities/draft_question.dart';
import '../../domain/entities/paper_details.dart';
import '../../domain/entities/paper_read_failure.dart';
import '../../domain/entities/school_identity.dart';
import '../../domain/usecases/ai_key_usecases.dart';
import '../../domain/usecases/build_scanned_paper.dart';
import '../../domain/usecases/scan_paper_pages.dart';
import '../../domain/usecases/school_identity_usecases.dart';

part 'paper_scan_event.dart';
part 'paper_scan_state.dart';

/// Drives the three steps: add photos, check the questions, get the PDF.
class PaperScanBloc extends Bloc<PaperScanEvent, PaperScanState> {
  PaperScanBloc({
    required HasAiKey hasAiKey,
    required SaveAiKey saveAiKey,
    required ClearAiKey clearAiKey,
    required PickPhoto pickPhoto,
    required ScanPaperPages scanPages,
    required LoadSchoolIdentity loadIdentity,
    required SaveSchoolIdentity saveIdentity,
    required PickSchoolLogo pickLogo,
    required BuildScannedPaper buildPaper,
    required PrintWithSystemDialog printPdf,
    required SharePdf sharePdf,
  }) : _hasAiKey = hasAiKey,
       _saveAiKey = saveAiKey,
       _clearAiKey = clearAiKey,
       _pickPhoto = pickPhoto,
       _scanPages = scanPages,
       _loadIdentity = loadIdentity,
       _saveIdentity = saveIdentity,
       _pickLogo = pickLogo,
       _buildPaper = buildPaper,
       _printPdf = printPdf,
       _sharePdf = sharePdf,
       super(const PaperScanState()) {
    on<PaperScanStarted>(_onStarted);
    on<AiKeySaved>(_onKeySaved);
    on<AiKeyCleared>(_onKeyCleared);
    on<PhotoRequested>(_onPhoto);
    on<PageRemoved>(_onPageRemoved);
    on<ReadRequested>(_onRead);
    on<QuestionTextChanged>(
      (e, emit) => _edit(e.id, emit, (q) => q.copyWith(text: e.text)),
    );
    on<QuestionOptionsChanged>(
      (e, emit) =>
          _edit(e.id, emit, (q) => q.copyWith(options: e.text.split('\n'))),
    );
    on<QuestionMarksChanged>(
      (e, emit) => _edit(
        e.id,
        emit,
        (q) => q.copyWith(marks: int.tryParse(e.text.trim()) ?? 0),
      ),
    );
    on<QuestionAdded>(_onAdded);
    on<QuestionRemoved>(_onRemoved);
    on<SchoolNameChanged>(
      (e, emit) =>
          emit(state.copyWith(identity: state.identity.copyWith(name: e.name))),
    );
    on<LogoRequested>(_onLogo);
    on<DetailsChanged>((e, emit) => emit(state.copyWith(details: e.details)));
    on<PdfRequested>(_onPdf);
    on<PrintRequested>(_onPrint);
    on<ShareRequested>(_onShare);
    on<BackRequested>(_onBack);
  }

  final HasAiKey _hasAiKey;
  final SaveAiKey _saveAiKey;
  final ClearAiKey _clearAiKey;
  final PickPhoto _pickPhoto;
  final ScanPaperPages _scanPages;
  final LoadSchoolIdentity _loadIdentity;
  final SaveSchoolIdentity _saveIdentity;
  final PickSchoolLogo _pickLogo;
  final BuildScannedPaper _buildPaper;
  final PrintWithSystemDialog _printPdf;
  final SharePdf _sharePdf;

  PaperScanState _tell(PaperScanNotice notice, [String? detail]) =>
      state.copyWith(
        notice: notice,
        noticeDetail: detail,
        noticeId: state.noticeId + 1,
        busy: false,
      );

  PaperScanState _tellReadFailure(PaperReadException e) =>
      _tell(switch (e.reason) {
        PaperReadFailure.missingKey => PaperScanNotice.missingKey,
        PaperReadFailure.noInternet => PaperScanNotice.noInternet,
        PaperReadFailure.invalidKey => PaperScanNotice.invalidKey,
        PaperReadFailure.quotaExceeded => PaperScanNotice.quotaExceeded,
        PaperReadFailure.noCredit => PaperScanNotice.noCredit,
        PaperReadFailure.timedOut => PaperScanNotice.timedOut,
        PaperReadFailure.serviceBusy => PaperScanNotice.serviceBusy,
        PaperReadFailure.tooLarge => PaperScanNotice.tooLarge,
        PaperReadFailure.badReply => PaperScanNotice.badReply,
        PaperReadFailure.noQuestions => PaperScanNotice.noQuestions,
        PaperReadFailure.serviceError => PaperScanNotice.serviceError,
      }, e.detail);

  Future<void> _onStarted(
    PaperScanStarted event,
    Emitter<PaperScanState> emit,
  ) async {
    final identity = await _loadIdentity(const NoParams());
    final hasKey = await _hasAiKey(const NoParams());
    emit(state.copyWith(identity: identity, hasAiKey: hasKey));
  }

  Future<void> _onKeySaved(
    AiKeySaved event,
    Emitter<PaperScanState> emit,
  ) async {
    if (event.key.trim().isEmpty) return;
    await _saveAiKey(event.key);
    emit(state.copyWith(hasAiKey: true));
  }

  Future<void> _onKeyCleared(
    AiKeyCleared event,
    Emitter<PaperScanState> emit,
  ) async {
    await _clearAiKey(const NoParams());
    emit(state.copyWith(hasAiKey: false));
  }

  Future<void> _onPhoto(
    PhotoRequested event,
    Emitter<PaperScanState> emit,
  ) async {
    final path = await _pickPhoto(event.source);
    if (path == null) return;
    emit(state.copyWith(pages: [...state.pages, path]));
  }

  void _onPageRemoved(PageRemoved event, Emitter<PaperScanState> emit) {
    final pages = [...state.pages]..removeAt(event.index);
    emit(state.copyWith(pages: pages));
  }

  Future<void> _onRead(
    ReadRequested event,
    Emitter<PaperScanState> emit,
  ) async {
    if (state.pages.isEmpty || state.busy) return;
    emit(state.copyWith(busy: true));
    try {
      final scanned = await _scanPages(state.pages);
      var id = state.nextId;
      emit(
        state.copyWith(
          step: PaperScanStep.review,
          busy: false,
          questions: [
            for (final q in scanned) DraftQuestion.fromScanned(id++, q),
          ],
          nextId: id,
        ),
      );
    } on PaperReadException catch (e) {
      emit(_tellReadFailure(e));
    } catch (_) {
      emit(_tell(PaperScanNotice.readFailed));
    }
  }

  void _edit(
    int id,
    Emitter<PaperScanState> emit,
    DraftQuestion Function(DraftQuestion) change,
  ) => emit(
    state.copyWith(
      questions: [for (final q in state.questions) q.id == id ? change(q) : q],
    ),
  );

  void _onAdded(QuestionAdded event, Emitter<PaperScanState> emit) => emit(
    state.copyWith(
      questions: [
        ...state.questions,
        DraftQuestion(id: state.nextId),
      ],
      nextId: state.nextId + 1,
    ),
  );

  void _onRemoved(QuestionRemoved event, Emitter<PaperScanState> emit) => emit(
    state.copyWith(
      questions: [
        for (final q in state.questions)
          if (q.id != event.id) q,
      ],
    ),
  );

  Future<void> _onLogo(
    LogoRequested event,
    Emitter<PaperScanState> emit,
  ) async {
    final path = await _pickLogo(const NoParams());
    if (path == null) return;
    emit(state.copyWith(identity: state.identity.copyWith(logoPath: path)));
  }

  Future<void> _onPdf(PdfRequested event, Emitter<PaperScanState> emit) async {
    if (!state.canBuild || state.busy) return;
    emit(state.copyWith(busy: true));
    try {
      // The name and logo are kept so the teacher never types them again.
      final identity = await _saveIdentity(state.identity);
      final pdf = await _buildPaper(
        BuildScannedPaperParams(
          identity: identity,
          details: state.details,
          questions: state.questions,
          labels: event.labels,
        ),
      );
      emit(
        state.copyWith(
          step: PaperScanStep.preview,
          identity: identity,
          pdf: pdf,
          busy: false,
        ),
      );
    } catch (_) {
      emit(_tell(PaperScanNotice.buildFailed));
    }
  }

  Future<void> _onPrint(
    PrintRequested event,
    Emitter<PaperScanState> emit,
  ) async {
    final pdf = state.pdf;
    if (pdf == null || state.busy) return;
    emit(state.copyWith(busy: true));
    try {
      final sent = await _printPdf(PdfFileParams(_fileName, pdf));
      emit(
        _tell(
          sent ? PaperScanNotice.printSent : PaperScanNotice.printCancelled,
        ),
      );
    } catch (_) {
      emit(_tell(PaperScanNotice.printFailed));
    }
  }

  Future<void> _onShare(
    ShareRequested event,
    Emitter<PaperScanState> emit,
  ) async {
    final pdf = state.pdf;
    if (pdf == null || state.busy) return;
    emit(state.copyWith(busy: true));
    try {
      await _sharePdf(PdfFileParams('$_fileName.pdf', pdf));
      emit(state.copyWith(busy: false));
    } catch (_) {
      emit(_tell(PaperScanNotice.printFailed));
    }
  }

  String get _fileName {
    final name = state.details.examName.trim();
    return name.isEmpty ? 'question_paper' : name;
  }

  void _onBack(BackRequested event, Emitter<PaperScanState> emit) {
    switch (state.step) {
      case PaperScanStep.preview:
        emit(state.copyWith(step: PaperScanStep.review));
      case PaperScanStep.review:
        emit(state.copyWith(step: PaperScanStep.pages));
      case PaperScanStep.pages:
        break;
    }
  }
}
