part of 'paper_scan_bloc.dart';

enum PaperScanStep { pages, review, preview }

/// What happened that the screen should tell the user about.
enum PaperScanNotice {
  missingKey,
  noInternet,
  invalidKey,
  quotaExceeded,
  noCredit,
  timedOut,
  serviceBusy,
  tooLarge,
  badReply,
  noQuestions,
  serviceError,
  readFailed,
  buildFailed,
  printSent,
  printCancelled,
  printFailed,
}

class PaperScanState extends Equatable {
  const PaperScanState({
    this.step = PaperScanStep.pages,
    this.pages = const [],
    this.questions = const [],
    this.identity = const SchoolIdentity(),
    this.details = const PaperDetails(),
    this.pdf,
    this.hasAiKey = false,
    this.busy = false,
    this.notice,
    this.noticeDetail,
    this.noticeId = 0,
    this.nextId = 1,
  });

  final PaperScanStep step;

  /// Photo paths, in the order the pages are read.
  final List<String> pages;
  final List<DraftQuestion> questions;
  final SchoolIdentity identity;
  final PaperDetails details;
  final Uint8List? pdf;

  /// Reading, building or printing is in progress.
  final bool busy;

  /// An AI key is saved on this phone.
  final bool hasAiKey;
  final PaperScanNotice? notice;

  /// The service's own words for a [PaperScanNotice.serviceError].
  final String? noticeDetail;

  /// Changes with every notice so the same one can be shown twice.
  final int noticeId;
  final int nextId;

  bool get canBuild =>
      identity.name.trim().isNotEmpty && questions.any((q) => !q.isBlank);

  PaperScanState copyWith({
    PaperScanStep? step,
    List<String>? pages,
    List<DraftQuestion>? questions,
    SchoolIdentity? identity,
    PaperDetails? details,
    Uint8List? pdf,
    bool? busy,
    bool? hasAiKey,
    PaperScanNotice? notice,
    String? noticeDetail,
    int? noticeId,
    int? nextId,
  }) => PaperScanState(
    step: step ?? this.step,
    pages: pages ?? this.pages,
    questions: questions ?? this.questions,
    identity: identity ?? this.identity,
    details: details ?? this.details,
    pdf: pdf ?? this.pdf,
    busy: busy ?? this.busy,
    hasAiKey: hasAiKey ?? this.hasAiKey,
    notice: notice ?? this.notice,
    noticeDetail: noticeDetail,
    noticeId: noticeId ?? this.noticeId,
    nextId: nextId ?? this.nextId,
  );

  @override
  List<Object?> get props => [
    step,
    pages,
    questions,
    identity,
    details,
    pdf,
    busy,
    hasAiKey,
    notice,
    noticeDetail,
    noticeId,
    nextId,
  ];
}
