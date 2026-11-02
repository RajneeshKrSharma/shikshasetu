part of 'paper_scan_bloc.dart';

sealed class PaperScanEvent extends Equatable {
  const PaperScanEvent();

  @override
  List<Object?> get props => const [];
}

final class PaperScanStarted extends PaperScanEvent {
  const PaperScanStarted();
}

final class AiKeySaved extends PaperScanEvent {
  const AiKeySaved(this.key);

  final String key;
}

final class AiKeyCleared extends PaperScanEvent {
  const AiKeyCleared();
}

final class PhotoRequested extends PaperScanEvent {
  const PhotoRequested(this.source);

  final PhotoSource source;

  @override
  List<Object?> get props => [source];
}

final class PageRemoved extends PaperScanEvent {
  const PageRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

final class ReadRequested extends PaperScanEvent {
  const ReadRequested();
}

final class QuestionTextChanged extends PaperScanEvent {
  const QuestionTextChanged(this.id, this.text);

  final int id;
  final String text;

  @override
  List<Object?> get props => [id, text];
}

/// The options as typed: one per line.
final class QuestionOptionsChanged extends PaperScanEvent {
  const QuestionOptionsChanged(this.id, this.text);

  final int id;
  final String text;

  @override
  List<Object?> get props => [id, text];
}

final class QuestionMarksChanged extends PaperScanEvent {
  const QuestionMarksChanged(this.id, this.text);

  final int id;
  final String text;

  @override
  List<Object?> get props => [id, text];
}

final class QuestionAdded extends PaperScanEvent {
  const QuestionAdded();
}

final class QuestionRemoved extends PaperScanEvent {
  const QuestionRemoved(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

final class SchoolNameChanged extends PaperScanEvent {
  const SchoolNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class LogoRequested extends PaperScanEvent {
  const LogoRequested();
}

final class DetailsChanged extends PaperScanEvent {
  const DetailsChanged(this.details);

  final PaperDetails details;

  @override
  List<Object?> get props => [details];
}

/// [labels] are the words printed on the paper, in the app's language.
final class PdfRequested extends PaperScanEvent {
  const PdfRequested(this.labels);

  final PaperLabels labels;
}

final class PrintRequested extends PaperScanEvent {
  const PrintRequested();
}

final class ShareRequested extends PaperScanEvent {
  const ShareRequested();
}

final class BackRequested extends PaperScanEvent {
  const BackRequested();
}
