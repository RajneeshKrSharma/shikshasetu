import 'package:equatable/equatable.dart';

/// The lines under the school name. All are free text the teacher types.
class PaperDetails extends Equatable {
  const PaperDetails({
    this.examName = '',
    this.classSection = '',
    this.subject = '',
    this.examDate = '',
    this.duration = '',
  });

  final String examName;
  final String classSection;
  final String subject;
  final String examDate;
  final String duration;

  PaperDetails copyWith({
    String? examName,
    String? classSection,
    String? subject,
    String? examDate,
    String? duration,
  }) => PaperDetails(
    examName: examName ?? this.examName,
    classSection: classSection ?? this.classSection,
    subject: subject ?? this.subject,
    examDate: examDate ?? this.examDate,
    duration: duration ?? this.duration,
  );

  @override
  List<Object?> get props => [
    examName,
    classSection,
    subject,
    examDate,
    duration,
  ];
}
