import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/attendance_status.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/check_point.dart';
import 'package:shiksha_setu/features/attendance/domain/entities/teacher_attendance.dart';
import 'package:shiksha_setu/features/attendance/domain/repository/attendance_repository.dart';
import 'package:shiksha_setu/features/attendance/domain/usecases/get_attendance_overview.dart';
import 'package:shiksha_setu/features/classes/domain/entities/class_summary.dart';
import 'package:shiksha_setu/features/classes/domain/repository/classes_repository.dart';
import 'package:shiksha_setu/features/exams/domain/entities/exam_paper.dart';
import 'package:shiksha_setu/features/exams/domain/repository/exams_repository.dart';
import 'package:shiksha_setu/features/exams/domain/usecases/get_papers.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_account.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_payment.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_payment_record.dart';
import 'package:shiksha_setu/features/fees/domain/entities/fee_person.dart';
import 'package:shiksha_setu/features/fees/domain/repository/fees_repository.dart';
import 'package:shiksha_setu/features/fees/domain/usecases/get_fee_accounts.dart';
import 'package:shiksha_setu/features/home/domain/entities/dashboard_summary.dart';
import 'package:shiksha_setu/features/home/domain/usecases/get_dashboard_summary.dart';
import 'package:shiksha_setu/features/notices/domain/entities/notice.dart';
import 'package:shiksha_setu/features/notices/domain/repository/notices_repository.dart';
import 'package:shiksha_setu/features/notices/domain/usecases/get_notices.dart';
import 'package:shiksha_setu/features/settings/domain/entities/school_settings.dart';
import 'package:shiksha_setu/features/settings/domain/repository/settings_repository.dart';
import 'package:shiksha_setu/features/settings/domain/usecases/get_school_settings.dart';
import 'package:shiksha_setu/features/students/domain/entities/student.dart';
import 'package:shiksha_setu/features/students/domain/repository/students_repository.dart';

class FakeAttendance implements AttendanceRepository {
  SchoolDayStatus day = SchoolDayStatus.approved;
  List<TeacherAttendance> teachers = const [];
  Map<String, Map<String, AttendanceStatus>?> marks = {};

  @override
  Future<SchoolDayStatus> getDayStatus(DateTime d) async => day;
  @override
  Future<List<TeacherAttendance>> getTeacherRecords(DateTime d) async =>
      teachers;
  @override
  Future<Map<String, AttendanceStatus>?> getClassAttendance(
    String c,
    DateTime d,
  ) async => marks[c];
  @override
  Future<void> setDayStatus(DateTime d, SchoolDayStatus s, String by) async {}
  @override
  Future<void> checkIn(String id, DateTime at, CheckPoint p) async {}
  @override
  Future<void> checkOut(String id, DateTime at, CheckPoint p) async {}
  @override
  Future<void> saveClassAttendance(
    String c,
    DateTime d,
    Map<String, AttendanceStatus> m,
  ) async {}
}

class FakeClasses implements ClassesRepository {
  List<String> names = const [];

  @override
  Future<List<ClassSummary>> getClasses() async => [
    for (final n in names) ClassSummary(name: n, studentCount: 2),
  ];
  @override
  Future<void> add(String name) async {}
  @override
  Future<void> rename(String a, String b) async {}
  @override
  Future<void> delete(String name) async {}
}

class FakeStudents implements StudentsRepository {
  @override
  Future<List<Student>> getByClass(String c) async => [
    Student(id: '$c-1', name: 'A', rollNo: 1, classSection: c),
    Student(id: '$c-2', name: 'B', rollNo: 2, classSection: c),
  ];
  @override
  Future<void> add({
    required String name,
    required String classSection,
    required String guardian,
    required String phone,
    required String aadhaarMasked,
  }) async {}
}

class FakeFees implements FeesRepository {
  List<FeeAccount> accounts = const [];

  @override
  Future<List<FeeAccount>> getAccounts() async => accounts;
  @override
  Future<List<FeePerson>> getPeople(FeeGroup g) async => const [];
  @override
  Future<void> createAccount({
    required FeeGroup group,
    required FeePerson person,
    required int total,
    required DateTime dueDate,
  }) async {}
  @override
  Future<FeePayment> recordPayment(String id, int a, DateTime at) =>
      throw UnimplementedError();
  @override
  Future<List<FeePayment>> getPayments(String id) async => const [];
  @override
  Future<List<FeePaymentRecord>> getPaymentHistory() async => const [];
}

class FakeExams implements ExamsRepository {
  List<ExamPaper> papers = const [];

  @override
  Future<List<ExamPaper>> getPapers() async => papers;
  @override
  Future<void> savePaper(ExamPaper p, String by) async {}
  @override
  Future<void> setStatus(
    String id,
    PaperStatus status, {
    String? note,
    DateTime? at,
  }) async {}
  @override
  Future<void> deletePaper(String id) async {}
  @override
  Future<void> markConducted(String id) async {}
  @override
  Future<Map<String, int>> getMarks(String id) async => const {};
  @override
  Future<void> saveMarks(String id, Map<String, int> m) async {}
}

class FakeNotices implements NoticesRepository {
  List<Notice> notices = const [];

  @override
  Future<List<Notice>> getNotices() async => notices;
  @override
  Future<void> post(Notice n) async {}
}

class FakeSettings implements SettingsRepository {
  SchoolSettings settings = SchoolSettings(
    schoolName: 'S',
    latitude: 1,
    longitude: 1,
    radiusMeters: 100,
    lastBackupAt: DateTime(2026),
  );

  @override
  Future<SchoolSettings> get() async => settings;
  @override
  Future<void> setThemeColor(int? argb) async {}
  @override
  Future<void> setAccentColor(int? argb) async {}
  @override
  Future<void> saveSchool({
    required String schoolName,
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {}
  @override
  Future<void> setLastBackup(DateTime at) async {}
  @override
  Future<void> setLogo(String? sourcePath) async {}
}

void main() {
  final now = DateTime(2026, 9, 30, 10);
  late FakeAttendance attendance;
  late FakeClasses classes;
  late FakeFees fees;
  late FakeExams exams;
  late FakeNotices notices;
  late FakeSettings settings;

  GetDashboardSummary build() => GetDashboardSummary(
    getOverview: GetAttendanceOverview(attendance, classes, FakeStudents()),
    getFeeAccounts: GetFeeAccounts(fees),
    getPapers: GetPapers(exams),
    getNotices: GetNotices(notices),
    getSettings: GetSchoolSettings(settings),
  );

  Future<DashboardSummary> run({bool includeFees = true}) =>
      build()(DashboardQuery(now: now, includeFees: includeFees));

  List<AttentionKind> kinds(DashboardSummary s) => [
    for (final a in s.attention) a.kind,
  ];

  TeacherAttendance teacher(String id, {bool in_ = false}) => TeacherAttendance(
    teacherId: id,
    teacherName: id,
    checkIn: in_ ? now : null,
  );

  FeeAccount account(String id, {required int paid, required DateTime due}) =>
      FeeAccount(
        id: id,
        name: id,
        group: FeeGroup.student,
        subtitle: '',
        total: 1000,
        paid: paid,
        dueDate: due,
      );

  setUp(() {
    attendance = FakeAttendance();
    classes = FakeClasses();
    fees = FakeFees();
    exams = FakeExams();
    notices = FakeNotices();
    settings = FakeSettings();
  });

  test('nothing wrong → no attention items', () async {
    expect((await run()).attention, isEmpty);
  });

  test('day still pending → no teacher or class alerts yet', () async {
    attendance.day = SchoolDayStatus.pending;
    attendance.teachers = [teacher('t1')];

    final s = await run();

    // Nobody can be "late" or "unmarked" on a day that is not open yet; the
    // approval itself is shown by the Approvals tile, not here.
    expect(kinds(s), isEmpty);
  });

  test('open day: teachers who have not checked in are counted', () async {
    attendance.teachers = [
      teacher('t1', in_: true),
      teacher('t2'),
      teacher('t3'),
    ];

    final s = await run();

    expect(s.attention.single.kind, AttentionKind.teachersNotIn);
    expect(s.attention.single.count, 2);
    expect((s.teachersPresent, s.teachersTotal), (1, 3));
  });

  test('open day: classes with no attendance are counted', () async {
    classes.names = ['6-A', '7-A'];
    attendance.marks = {
      '6-A': {
        '6-A-1': AttendanceStatus.present,
        '6-A-2': AttendanceStatus.absent,
      },
    };

    final s = await run();

    expect(s.attention.single.kind, AttentionKind.classesNotMarked);
    expect(s.attention.single.count, 1);
    expect(s.classesMarked, 1);
  });

  test('student totals only cover classes that were marked', () async {
    classes.names = ['6-A', '7-A'];
    attendance.marks = {
      '6-A': {'6-A-1': AttendanceStatus.late, '6-A-2': AttendanceStatus.absent},
    };

    final totals = (await run()).studentTotals;

    expect((totals.present, totals.total), (1, 2));
  });

  test('overdue fees: count and the amount still owed', () async {
    fees.accounts = [
      account('late-half', paid: 400, due: DateTime(2026, 9, 1)),
      account('late-none', paid: 0, due: DateTime(2026, 9, 10)),
      account('not-due', paid: 0, due: DateTime(2026, 12)),
      account('settled', paid: 1000, due: DateTime(2026, 9, 1)),
    ];

    final s = await run();
    final item = s.attention.single;

    expect(item.kind, AttentionKind.overdueFees);
    expect((item.count, item.amount), (2, 600 + 1000));
    expect(s.fees!.collected, 1400);
    expect(s.fees!.pending, 2600);
  });

  test('a teacher (no fee access) gets no fee data or fee alerts', () async {
    fees.accounts = [account('late', paid: 0, due: DateTime(2026, 9, 1))];

    final s = await run(includeFees: false);

    expect(s.fees, isNull);
    expect(kinds(s), isNot(contains(AttentionKind.overdueFees)));
  });

  test('missing school location and backup raise setup reminders', () async {
    settings.settings = const SchoolSettings(schoolName: 'S');

    expect(kinds(await run()), [
      AttentionKind.schoolLocationMissing,
      AttentionKind.neverBackedUp,
    ]);
  });

  test(
    'upcoming exams: only scheduled, not past, soonest first, max 3',
    () async {
      ExamPaper paper(String id, DateTime d, PaperStatus s) => ExamPaper(
        id: id,
        title: id,
        subject: 'M',
        classSection: '6-A',
        date: d,
        durationMinutes: 60,
        status: s,
        questions: const [Question(text: 'q', marks: 1)],
      );
      exams.papers = [
        paper('later', DateTime(2026, 11), PaperStatus.approved),
        paper('draft', DateTime(2026, 10, 2), PaperStatus.draft),
        paper('past', DateTime(2026, 9, 1), PaperStatus.approved),
        paper('today', DateTime(2026, 9, 30), PaperStatus.approved),
        paper('soon', DateTime(2026, 10, 5), PaperStatus.approved),
        paper('mid', DateTime(2026, 10, 20), PaperStatus.approved),
      ];

      final s = await run();

      expect(s.upcomingExams.map((p) => p.id), ['today', 'soon', 'mid']);
    },
  );

  test('latest notice is the newest one', () async {
    notices.notices = [
      Notice(
        id: 'n2',
        title: 'New',
        body: 'b',
        postedBy: 'p',
        postedAt: DateTime(2026, 9, 29),
      ),
      Notice(
        id: 'n1',
        title: 'Old',
        body: 'b',
        postedBy: 'p',
        postedAt: DateTime(2026, 9, 1),
      ),
    ];

    expect((await run()).latestNotice?.title, 'New');
  });

  test('attention order: approval, teachers, classes, fees, setup', () async {
    attendance.teachers = [teacher('t1')];
    classes.names = ['6-A'];
    fees.accounts = [account('late', paid: 0, due: DateTime(2026, 9, 1))];
    settings.settings = const SchoolSettings(schoolName: 'S');

    expect(kinds(await run()), [
      AttentionKind.teachersNotIn,
      AttentionKind.classesNotMarked,
      AttentionKind.overdueFees,
      AttentionKind.schoolLocationMissing,
      AttentionKind.neverBackedUp,
    ]);
  });
}
