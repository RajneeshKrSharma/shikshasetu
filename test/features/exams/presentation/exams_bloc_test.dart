import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/exams/domain/repository/exams_repository.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/change_paper_status.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/delete_paper.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/get_papers.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/mark_paper_conducted.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/shuffle_paper.dart';
import 'package:shiksha_setu/features/exams/presentation/bloc/exams_bloc.dart';

class _InMemoryExams implements ExamsRepository {
  _InMemoryExams(List<ExamPaper> papers) : papers = [...papers];

  List<ExamPaper> papers;

  @override
  Future<List<ExamPaper>> getPapers() async => [...papers];

  @override
  Future<void> savePaper(ExamPaper paper, String createdBy) async {
    papers = [
      for (final p in papers)
        if (p.id == paper.id) paper else p,
    ];
  }

  @override
  Future<void> setStatus(
    String paperId,
    PaperStatus status, {
    String? note,
    DateTime? at,
  }) async {
    papers = [
      for (final p in papers)
        if (p.id == paperId)
          ExamPaper(
            id: p.id,
            title: p.title,
            subject: p.subject,
            classSection: p.classSection,
            date: p.date,
            durationMinutes: p.durationMinutes,
            questions: p.questions,
            status: status,
            createdBy: p.createdBy,
            reviewNote: note,
            submittedAt: at ?? p.submittedAt,
          )
        else
          p,
    ];
  }

  @override
  Future<void> deletePaper(String paperId) async => papers = [
    for (final p in papers)
      if (p.id != paperId) p,
  ];

  @override
  Future<void> markConducted(String paperId) =>
      setStatus(paperId, PaperStatus.conducted);

  @override
  Future<Map<String, int>> getMarks(String paperId) async => const {};

  @override
  Future<void> saveMarks(String paperId, Map<String, int> marks) async {}
}

ExamPaper _paper(
  String id,
  PaperStatus status, {
  String by = 't1',
  DateTime? date,
  DateTime? submittedAt,
  List<Question>? questions,
}) => ExamPaper(
  id: id,
  title: id,
  subject: 'Maths',
  classSection: '6-A',
  date: date ?? DateTime(2026, 10, 10),
  durationMinutes: 60,
  status: status,
  createdBy: by,
  submittedAt: submittedAt,
  questions:
      questions ??
      const [Question(text: 'A', marks: 1), Question(text: 'B', marks: 1)],
);

void main() {
  late _InMemoryExams repo;
  final now = DateTime(2026, 10, 1, 12);

  ExamsBloc build() => ExamsBloc(
    getPapers: GetPapers(repo),
    markPaperConducted: MarkPaperConducted(repo),
    changePaperStatus: ChangePaperStatus(repo),
    deletePaper: DeletePaper(repo),
    shufflePaper: ShufflePaper(repo, random: Random(1)),
    now: () => now,
  );

  setUp(
    () => repo = _InMemoryExams([
      _paper('draft', PaperStatus.draft),
      _paper(
        'waiting',
        PaperStatus.submitted,
        submittedAt: DateTime(2026, 9, 30),
      ),
      _paper('ready', PaperStatus.approved),
      _paper('back', PaperStatus.changesRequested),
      _paper('done', PaperStatus.conducted),
      _paper('other-waiting', PaperStatus.submitted, by: 't2'),
    ]),
  );

  Future<ExamsState> loaded() async {
    final bloc = build()..add(const ExamsLoaded());
    await bloc.stream.first;
    return bloc.state;
  }

  group('stages', () {
    test('papers are grouped by where they are in approval', () async {
      final s = await loaded();

      expect(
        {for (final p in s.awaitingApproval) p.id},
        {'waiting', 'other-waiting'},
      );
      expect([for (final p in s.ready) p.id], ['ready']);
      expect({for (final p in s.inProgress) p.id}, {'draft', 'back'});
      expect([for (final p in s.past) p.id], ['done']);
    });

    test('a teacher sees only the papers they set', () async {
      final mine = (await loaded()).visibleTo('t2', isPrincipal: false);

      expect([for (final p in mine.papers) p.id], ['other-waiting']);
    });

    test('the Principal sees every paper', () async {
      final all = (await loaded()).visibleTo('p0', isPrincipal: true);

      expect(all.papers.length, 6);
    });

    test('the longest-waiting submission comes first', () async {
      final s = await loaded();

      expect(s.awaitingApproval.first.id, 'waiting');
    });
  });

  group('approval flow', () {
    blocTest<ExamsBloc, ExamsState>(
      'a draft is submitted, stamped with the time',
      build: build,
      act: (b) => b.add(const PaperSubmittedForApproval('draft')),
      verify: (b) {
        final p = b.state.paperById('draft')!;
        expect((p.status, p.submittedAt), (PaperStatus.submitted, now));
      },
    );

    blocTest<ExamsBloc, ExamsState>(
      'the Principal approves a submitted paper',
      build: build,
      act: (b) => b.add(const PaperApproved('waiting')),
      verify: (b) =>
          expect(b.state.paperById('waiting')!.status, PaperStatus.approved),
    );

    blocTest<ExamsBloc, ExamsState>(
      'sending back stores the reason and returns it to the setter',
      build: build,
      act: (b) => b.add(const PaperSentBack('waiting', 'Too many MCQs')),
      verify: (b) {
        final p = b.state.paperById('waiting')!;
        expect(
          (p.status, p.reviewNote),
          (PaperStatus.changesRequested, 'Too many MCQs'),
        );
        expect(p.isInProgress, isTrue);
      },
    );

    blocTest<ExamsBloc, ExamsState>(
      'deleting a paper removes it',
      build: build,
      act: (b) => b.add(const PaperDeleted('draft')),
      verify: (b) => expect(b.state.paperById('draft'), isNull),
    );

    blocTest<ExamsBloc, ExamsState>(
      'shuffling keeps the same questions',
      build: build,
      seed: () => ExamsState(
        loading: false,
        papers: [
          _paper(
            'big',
            PaperStatus.submitted,
            questions: [
              for (var i = 0; i < 8; i++) Question(text: 'Q$i', marks: 1),
            ],
          ),
        ],
      ),
      setUp: () => repo = _InMemoryExams([
        _paper(
          'big',
          PaperStatus.submitted,
          questions: [
            for (var i = 0; i < 8; i++) Question(text: 'Q$i', marks: 1),
          ],
        ),
      ]),
      act: (b) => b.add(const PaperShuffled('big')),
      verify: (b) {
        final texts = [
          for (final q in b.state.paperById('big')!.questions) q.text,
        ];
        expect(texts.toSet(), {for (var i = 0; i < 8; i++) 'Q$i'});
        expect(texts, isNot([for (var i = 0; i < 8; i++) 'Q$i']));
      },
    );
  });
}
