import '../../../../../core/usecase/usecase.dart';
import '../../../teaching/domain/repository/teaching_repository.dart';
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

/// The subjects of a class that have a teacher: only those can have a paper.
class GetClassSubjects implements UseCase<List<TimetableRow>, String> {
  const GetClassSubjects(this._teaching);

  final TeachingRepository _teaching;

  @override
  Future<List<TimetableRow>> call(String classId) async {
    final seen = <String>{};
    return [
      for (final a in await _teaching.allotments(classId: classId))
        if (seen.add(a.subject.toLowerCase())) TimetableRow(subject: a.subject),
    ];
  }
}

class SaveTimetable implements UseCase<List<String>, TimetableDraft> {
  const SaveTimetable(this._repository);

  final TimetableRepository _repository;

  @override
  Future<List<String>> call(TimetableDraft draft) => _repository.save(draft);
}
