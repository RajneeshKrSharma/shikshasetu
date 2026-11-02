import '../../../../core/server/json.dart';
import '../../domain/entities/exams.dart';

class ExamModels {
  const ExamModels._();

  static Exam exam(Json j) => Exam(
    id: j.string('id'),
    type: ExamType.fromCode(j.stringOrNull('exam_type')),
    classId: j.string('class_id'),
    className: j.string('class_name'),
    subject: j.string('subject'),
    heldOn: j.day('held_on'),
    maxMarks: j.integer('max_marks'),
    teacherId: j.stringOrNull('teacher_id'),
    teacherName: j.string('teacher_name'),
    paperStatus: PaperStatus.fromCode(j.stringOrNull('paper_status')),
  );

  static ExamResults results(Json j) => ExamResults(
    entered: j.integer('entered'),
    absent: j.integer('absent'),
    average: j.stringOrNull('average'),
    highest: j.integerOrNull('highest'),
    lowest: j.integerOrNull('lowest'),
    lines: [
      for (final s in j.list('students'))
        MarkLine(
          studentId: s.string('student_id'),
          name: s.string('name'),
          rollNumber: s.string('roll_number'),
          marks: s.integerOrNull('marks'),
          absent: s.flag('absent'),
          entered: s.flag('entered'),
          percentage: s.stringOrNull('percentage'),
        ),
    ],
  );

  static StudentResults studentResults(Json j) => StudentResults(
    totalObtained: j.integer('total_obtained'),
    totalOutOf: j.integer('total_out_of'),
    percentage: j.stringOrNull('percentage'),
    exams: [
      for (final e in j.list('exams'))
        ExamLineResult(
          type: ExamType.fromCode(e.stringOrNull('exam_type')),
          subject: e.string('subject'),
          heldOn: e.day('held_on'),
          maxMarks: e.integer('max_marks'),
          marks: e.integerOrNull('marks'),
          absent: e.flag('absent'),
          percentage: e.stringOrNull('percentage'),
        ),
    ],
  );

  static QuestionUnit unit(Json j) => QuestionUnit(
    id: j.string('id'),
    teacherName: j.string('teacher_name'),
    classId: j.string('class_id'),
    className: j.string('class_name'),
    subject: j.string('subject'),
    name: j.string('name'),
  );

  static Question question(Json j) => Question(
    id: j.string('id'),
    unitId: j.string('unit_id'),
    text: j.string('text'),
    marks: j.integer('marks'),
    type: QuestionType.fromCode(j.stringOrNull('question_type')),
  );

  static Paper paper(Json j) => Paper(
    examId: j.string('exam_id'),
    status: PaperStatus.fromCode(j.stringOrNull('status')) ?? PaperStatus.draft,
    totalMarks: j.integer('total_marks'),
    preparedByName: j.string('prepared_by_name'),
    decisionNote: j.string('decision_note'),
    questions: [
      for (final q in j.list('questions'))
        PaperQuestion(
          position: q.integer('position'),
          questionId: q.stringOrNull('question_id'),
          text: q.string('text'),
          marks: q.integer('marks'),
          type: QuestionType.fromCode(q.stringOrNull('question_type')),
        ),
    ],
  );
}
