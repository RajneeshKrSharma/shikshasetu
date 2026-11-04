import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../exams/domain/entities/exams.dart';
import '../../../exams/domain/repository/exams_repository.dart';
import '../../../school/domain/repository/school_repository.dart';
import '../entities/timetable.dart';
import '../entities/timetable_sheet.dart';
import '../repository/timetable_document_builder.dart';
import '../repository/timetable_repository.dart';

class GetTimetableSettings implements UseCase<TimetableSettings, NoParams> {
  const GetTimetableSettings(this._repository);

  final TimetableRepository _repository;

  @override
  Future<TimetableSettings> call(NoParams params) => _repository.settings();
}

class SaveTimetableSettings
    implements UseCase<TimetableSettings, TimetableSettings> {
  const SaveTimetableSettings(this._repository);

  final TimetableRepository _repository;

  @override
  Future<TimetableSettings> call(TimetableSettings settings) =>
      _repository.saveSettings(settings);
}

/// The subjects a class already has an exam for. The Principal types any
/// other; the timetable does not depend on teachers.
class GetClassSubjects implements UseCase<List<TimetableRow>, String> {
  const GetClassSubjects(this._exams);

  final ExamsRepository _exams;

  @override
  Future<List<TimetableRow>> call(String classId) async {
    final seen = <String>{};
    final names = [
      for (final e in await _exams.exams(classId: classId)) e.subject,
    ];
    return [
      for (final n in names)
        if (seen.add(n.trim().toLowerCase())) TimetableRow(subject: n.trim()),
    ];
  }
}

class SaveTimetable implements UseCase<List<String>, TimetableDraft> {
  const SaveTimetable(this._repository);

  final TimetableRepository _repository;

  @override
  Future<List<String>> call(TimetableDraft draft) => _repository.save(draft);
}

class BuildTimetablePdfParams extends Equatable {
  const BuildTimetablePdfParams({
    required this.classId,
    required this.type,
    required this.labels,
  });

  final String classId;
  final ExamType type;
  final TimetablePrintLabels labels;

  @override
  List<Object?> get props => [classId, type, labels];
}

/// Makes the printable sheet of a class's saved timetable: the school's name,
/// the exam, the class, and one line per day with its papers.
class BuildTimetablePdf implements UseCase<Uint8List, BuildTimetablePdfParams> {
  const BuildTimetablePdf(
    this._school,
    this._timetable,
    this._exams,
    this._document,
  );

  final SchoolRepository _school;
  final TimetableRepository _timetable;
  final ExamsRepository _exams;
  final TimetableDocumentBuilder _document;

  @override
  Future<Uint8List> call(BuildTimetablePdfParams params) async {
    final school = await _school.getSchool();
    final settings = await _timetable.settings();
    final papers = [
      for (final e in await _exams.exams(classId: params.classId))
        if (e.type == params.type) e,
    ]..sort((a, b) => a.heldOn.compareTo(b.heldOn));

    final days = <TimetableSheetDay>[];
    for (final p in papers) {
      final last = days.isEmpty ? null : days.last;
      if (last != null && _sameDay(last.day, p.heldOn)) {
        days[days.length - 1] = TimetableSheetDay(
          day: last.day,
          subjects: [...last.subjects, p.subject],
        );
      } else {
        days.add(TimetableSheetDay(day: p.heldOn, subjects: [p.subject]));
      }
    }

    return _document.build(
      TimetableSheet(
        schoolName: school.name,
        examLabel: settings.labelOf(params.type),
        className: papers.isEmpty ? '' : papers.first.className,
        academicYear: papers.isEmpty ? '' : _academicYear(papers.first.heldOn),
        days: days,
      ),
      params.labels,
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// The school year starts in April: November 2026 falls in "2026-27".
  String _academicYear(DateTime day) {
    final start = day.month >= 4 ? day.year : day.year - 1;
    final end = ((start + 1) % 100).toString().padLeft(2, '0');
    return '$start-$end';
  }
}
