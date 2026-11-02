import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/data/local/app_database.dart';
import 'package:shiksha_setu/features/approvals/data/repository/approvals_repository_impl.dart';
import 'package:shiksha_setu/features/approvals/domain/entities/approval_request.dart';
import 'package:shiksha_setu/features/attendance/data/repository/attendance_repository_impl.dart';
import 'package:shiksha_setu/features/exams/data/repository/exams_repository_impl.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late AttendanceRepositoryImpl attendance;
  late ApprovalsRepositoryImpl approvals;

  final today = DateTime(2026, 10, 1, 9);

  setUp(() async {
    database = await openTestDatabase();
    attendance = AttendanceRepositoryImpl(database);
    approvals = ApprovalsRepositoryImpl(
      attendance,
      ExamsRepositoryImpl(database),
    );
  });

  tearDown(() => database.close());

  test('getRequests: an undecided school day is a pending request', () async {
    final r = (await approvals.getRequests(today)).single;

    expect(r.category, ApprovalCategory.schoolDay);
    expect(r.status, ApprovalStatus.pending);
    expect(r.date, DateTime(2026, 10, 1));
  });

  test('decide(approved): the school day becomes open', () async {
    final r = (await approvals.getRequests(today)).single;

    await approvals.decide(r, ApprovalStatus.approved, 'p1');

    expect(await attendance.getDayStatus(today), SchoolDayStatus.approved);
    expect(
      (await approvals.getRequests(today)).single.status,
      ApprovalStatus.approved,
    );
  });

  test('decide(rejected): the school day is closed', () async {
    final r = (await approvals.getRequests(today)).single;

    await approvals.decide(r, ApprovalStatus.rejected, 'p1');

    expect(await attendance.getDayStatus(today), SchoolDayStatus.rejected);
  });

  test('decide(pending): takes the decision back', () async {
    final r = (await approvals.getRequests(today)).single;
    await approvals.decide(r, ApprovalStatus.approved, 'p1');

    await approvals.decide(r, ApprovalStatus.pending, 'p1');

    expect(
      (await approvals.getRequests(today)).single.status,
      ApprovalStatus.pending,
    );
  });

  group('question papers', () {
    late ExamsRepositoryImpl exams;

    setUp(() => exams = ExamsRepositoryImpl(database));

    ExamPaper paper(String id, PaperStatus status, {DateTime? submittedAt}) =>
        ExamPaper(
          id: id,
          title: 'Paper $id',
          subject: 'Maths',
          classSection: '6-A',
          date: DateTime(2026, 11, 1),
          durationMinutes: 60,
          status: status,
          submittedAt: submittedAt,
          questions: const [Question(text: 'Q', marks: 1)],
        );

    Future<List<ApprovalRequest>> papers() async => [
      for (final r in await approvals.getRequests(today))
        if (r.category == ApprovalCategory.examPaper) r,
    ];

    setUp(() async {
      await database.db.insert('classes', {'name': '6-A'});
    });

    test('a draft is not a request', () async {
      await exams.savePaper(paper('d', PaperStatus.draft), 't1');

      expect(await papers(), isEmpty);
    });

    test(
      'a paper sent for approval is a pending request about that paper',
      () async {
        await exams.savePaper(
          paper(
            's',
            PaperStatus.submitted,
            submittedAt: DateTime(2026, 9, 30, 8),
          ),
          't1',
        );

        final r = (await papers()).single;

        expect(r.isPending, isTrue);
        expect((r.refId, r.title, r.detail), ('s', 'Paper s', 'Maths · 6-A'));
        expect(r.date, DateTime(2026, 9, 30));
      },
    );

    test('approved and sent-back papers are decided requests', () async {
      final at = DateTime(2026, 9, 30);
      await exams.savePaper(
        paper('a', PaperStatus.approved, submittedAt: at),
        't1',
      );
      await exams.savePaper(
        paper('b', PaperStatus.changesRequested, submittedAt: at),
        't1',
      );

      final status = {for (final r in await papers()) r.refId: r.status};

      expect(status, {
        'a': ApprovalStatus.approved,
        'b': ApprovalStatus.rejected,
      });
    });

    test(
      'a paper the Principal approved directly was never a request',
      () async {
        await exams.savePaper(paper('p', PaperStatus.approved), 'principal');

        expect(await papers(), isEmpty);
      },
    );

    test('decide(approved) approves the paper', () async {
      await exams.savePaper(
        paper('s', PaperStatus.submitted, submittedAt: DateTime(2026, 9, 30)),
        't1',
      );
      final r = (await papers()).single;

      await approvals.decide(r, ApprovalStatus.approved, 'p1');

      expect((await exams.getPapers()).single.status, PaperStatus.approved);
      expect((await papers()).single.status, ApprovalStatus.approved);
    });
  });
}
