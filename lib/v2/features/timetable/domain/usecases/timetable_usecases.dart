import '../../../../../core/usecase/usecase.dart';
import '../../../exams/domain/repository/exams_repository.dart';
import '../entities/timetable.dart';
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
