import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/teaching.dart';
import '../repository/teaching_repository.dart';

class GetAllotments implements UseCase<List<Allotment>, String?> {
  const GetAllotments(this._repository);

  final TeachingRepository _repository;

  /// [teacherId] narrows to one teacher; null is everyone's (or, for a
  /// teacher, their own).
  @override
  Future<List<Allotment>> call(String? teacherId) =>
      _repository.allotments(teacherId: teacherId);
}

class AllotClass implements UseCase<void, AllotmentDraft> {
  const AllotClass(this._repository);

  final TeachingRepository _repository;

  @override
  Future<void> call(AllotmentDraft draft) => _repository.allot(draft);
}

class RemoveAllotment implements UseCase<void, String> {
  const RemoveAllotment(this._repository);

  final TeachingRepository _repository;

  @override
  Future<void> call(String id) => _repository.removeAllotment(id);
}

class GetRecentLessons implements UseCase<List<Lesson>, DateTime> {
  const GetRecentLessons(this._repository);

  final TeachingRepository _repository;

  /// The lessons from [since] to today.
  @override
  Future<List<Lesson>> call(DateTime since) => _repository.lessons(from: since);
}

class RecordLessonParams extends Equatable {
  const RecordLessonParams({
    this.allotmentId,
    this.lessonId,
    required this.topic,
  });

  /// Set to record a new lesson; [lessonId] to change one.
  final String? allotmentId;
  final String? lessonId;
  final String topic;

  @override
  List<Object?> get props => [allotmentId, lessonId, topic];
}

class RecordLesson implements UseCase<void, RecordLessonParams> {
  const RecordLesson(this._repository);

  final TeachingRepository _repository;

  @override
  Future<void> call(RecordLessonParams p) => p.lessonId != null
      ? _repository.revise(lessonId: p.lessonId!, topic: p.topic.trim())
      : _repository.record(allotmentId: p.allotmentId!, topic: p.topic.trim());
}

class GetLessonBoard implements UseCase<List<LessonStatus>, DateTime> {
  const GetLessonBoard(this._repository);

  final TeachingRepository _repository;

  @override
  Future<List<LessonStatus>> call(DateTime day) => _repository.board(day);
}
