import '../entities/teaching.dart';

abstract interface class TeachingRepository {
  Future<List<Allotment>> allotments({String? teacherId, String? classId});

  Future<void> allot(AllotmentDraft draft);

  Future<void> removeAllotment(String id);

  Future<List<Lesson>> lessons({DateTime? from, DateTime? to});

  Future<void> record({required String allotmentId, required String topic});

  Future<void> revise({required String lessonId, required String topic});

  Future<List<LessonStatus>> board(DateTime day);
}
