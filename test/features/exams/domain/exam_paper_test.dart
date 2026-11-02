import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';

void main() {
  test('totalMarks: sums the marks of every question', () {
    final paper = ExamPaper(
      id: 'p',
      title: 'T',
      subject: 'Maths',
      classSection: '6-A',
      date: DateTime(2026, 9, 30),
      durationMinutes: 60,
      status: PaperStatus.draft,
      questions: const [
        Question(text: 'a', marks: 2),
        Question(text: 'b', marks: 3),
        Question(text: 'c', marks: 5),
      ],
    );

    expect(paper.totalMarks, 10);
  });
}
