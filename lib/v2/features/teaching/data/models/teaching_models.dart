import '../../../../core/server/json.dart';
import '../../domain/entities/teaching.dart';

class TeachingModels {
  const TeachingModels._();

  static Allotment allotment(Json j) => Allotment(
    id: j.string('id'),
    teacherId: j.string('teacher_id'),
    teacherName: j.string('teacher_name'),
    classId: j.string('class_id'),
    className: j.string('class_name'),
    subject: j.string('subject'),
  );

  static Lesson lesson(Json j) => Lesson(
    id: j.string('id'),
    allotmentId: j.string('allotment_id'),
    teacherName: j.string('teacher_name'),
    className: j.string('class_name'),
    subject: j.string('subject'),
    takenOn: j.day('taught_on'),
    topic: j.string('topic'),
  );

  static LessonStatus status(Json j) => LessonStatus(
    allotment: Allotment(
      id: j.string('allotment_id'),
      teacherId: j.string('teacher_id'),
      teacherName: j.string('teacher_name'),
      classId: j.string('class_id'),
      className: j.string('class_name'),
      subject: j.string('subject'),
    ),
    lesson: j.object('lesson') == null ? null : lesson(j.object('lesson')!),
  );
}
