import '../entities/teaching_assignment.dart';

abstract interface class TeachingRepository {
  /// Every assignment on this phone (the Principal's phone has all teachers';
  /// a teacher's has their own).
  Future<List<TeachingAssignment>> getAll();

  /// A teacher asks to teach [subject] in [className]. Waits for the
  /// Principal. Does nothing if the same one is already allowed or waiting.
  Future<void> request({
    required String teacherId,
    required String className,
    required String subject,
  });

  /// The Principal gives a teacher a subject in a class directly.
  Future<void> allot({
    required String teacherId,
    required String className,
    required String subject,
  });

  /// The Principal accepts, turns down or re-opens a teacher's request.
  Future<void> decide(String id, AssignmentStatus status);

  /// Takes a subject away from a teacher (or cancels a waiting request).
  Future<void> remove(String id);
}
