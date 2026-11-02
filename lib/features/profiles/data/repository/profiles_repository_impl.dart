import 'package:sqflite/sqflite.dart';

import '../../../../core/data/local/app_database.dart';
import '../../../../core/domain/gender.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../exams/domain/entities/exam_paper.dart';
import '../../domain/entities/profile_entities.dart';
import '../../domain/repository/profiles_repository.dart';

/// Reads everything about one person across the tables that mention them.
class ProfilesRepositoryImpl implements ProfilesRepository {
  ProfilesRepositoryImpl(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  DateTime _ms(Object? v) => DateTime.fromMillisecondsSinceEpoch(v! as int);
  DateTime? _msOrNull(Object? v) => v == null ? null : _ms(v);

  @override
  Future<StudentProfile?> student(String id) async {
    final rows = await _db.query('students', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    final r = rows.first;

    final attendance = await _db.query(
      'student_attendance',
      where: 'student_id = ?',
      whereArgs: [id],
      orderBy: 'day DESC',
    );
    final results = await _db.rawQuery(
      '''
SELECT m.paper_id, m.marks_obtained, p.title, p.subject, p.exam_date,
  (SELECT COALESCE(SUM(q.marks), 0) FROM exam_questions q
    WHERE q.paper_id = p.id) AS total
FROM exam_marks m
JOIN exam_papers p ON p.id = m.paper_id
WHERE m.student_id = ?
ORDER BY p.exam_date DESC
''',
      [id],
    );

    return StudentProfile(
      details: ProfileDetails(
        id: id,
        name: r['name']! as String,
        phone: (r['phone'] as String?) ?? '',
        aadhaarMasked: (r['aadhaar_masked'] as String?) ?? '',
        address: r['address'] as String?,
        gender: Gender.parse(r['gender'] as String?),
        dateOfBirth: _msOrNull(r['dob']),
        registeredOn: _ms(r['registered_on']),
      ),
      classSection: r['class_name']! as String,
      rollNo: r['roll_no']! as int,
      guardian: r['guardian'] as String?,
      attendance: [
        for (final a in attendance)
          StudentAttendanceEntry(
            DateTime.parse(a['day']! as String),
            AttendanceStatus.values.byName(a['status']! as String),
          ),
      ],
      fees: await _fees('student', id),
      results: [
        for (final m in results)
          ExamResult(
            paperId: m['paper_id']! as String,
            title: m['title']! as String,
            subject: m['subject']! as String,
            date: _ms(m['exam_date']),
            obtained: m['marks_obtained']! as int,
            total: m['total']! as int,
          ),
      ],
    );
  }

  @override
  Future<TeacherProfile?> teacher(String id) async {
    final rows = await _db.query(
      'users',
      where: "id = ? AND role = 'teacher'",
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    final r = rows.first;

    final classRow = await _db.query(
      'classes',
      where: 'class_teacher_id = ?',
      whereArgs: [id],
    );
    final days = await _db.query(
      'teacher_attendance',
      where: 'teacher_id = ?',
      whereArgs: [id],
      orderBy: 'day DESC',
    );
    final papers = await _db.query(
      'exam_papers',
      where: 'created_by = ?',
      whereArgs: [id],
      orderBy: 'exam_date DESC',
    );

    return TeacherProfile(
      details: ProfileDetails(
        id: id,
        name: r['name']! as String,
        phone: r['phone']! as String,
        aadhaarMasked: (r['aadhaar_masked'] as String?) ?? '',
        address: r['address'] as String?,
        gender: Gender.parse(r['gender'] as String?),
        dateOfBirth: _msOrNull(r['dob']),
        registeredOn: _ms(r['joined_on']),
      ),
      email: r['email']! as String,
      employeeId: r['employee_id']! as String,
      active: (r['active']! as int) == 1,
      subject: r['subject'] as String?,
      classSection: classRow.isEmpty ? null : classRow.first['name'] as String?,
      attendance: [
        for (final d in days)
          TeacherDayRecord(
            day: DateTime.parse(d['day']! as String),
            checkIn: _msOrNull(d['check_in']),
            checkOut: _msOrNull(d['check_out']),
            distanceMeters: d['in_distance'] as double?,
            faceScore: d['in_face_score'] as double?,
          ),
      ],
      papers: [
        for (final p in papers)
          TeacherPaper(
            id: p['id']! as String,
            title: p['title']! as String,
            subject: p['subject']! as String,
            classSection: p['class_name']! as String,
            date: _ms(p['exam_date']),
            status: PaperStatus.parse(p['status']! as String),
          ),
      ],
      fees: await _fees('teacher', id),
    );
  }

  /// The person's fee accounts with the payments made against each.
  Future<List<ProfileFee>> _fees(String group, String personId) async {
    final accounts = await _db.rawQuery(
      '''
SELECT a.id, a.total, a.due_date, COALESCE(SUM(p.amount), 0) AS paid
FROM fee_accounts a
LEFT JOIN fee_payments p ON p.account_id = a.id
WHERE a.group_type = ? AND a.person_id = ?
GROUP BY a.id
ORDER BY a.due_date DESC
''',
      [group, personId],
    );
    final payments = await _db.rawQuery(
      '''
SELECT p.id, p.account_id, p.amount, p.paid_at
FROM fee_payments p
JOIN fee_accounts a ON a.id = p.account_id
WHERE a.group_type = ? AND a.person_id = ?
ORDER BY p.paid_at DESC, p.id DESC
''',
      [group, personId],
    );
    final byAccount = <String, List<ProfilePayment>>{};
    for (final p in payments) {
      byAccount
          .putIfAbsent(p['account_id']! as String, () => [])
          .add(
            ProfilePayment(
              id: p['id']! as int,
              amount: p['amount']! as int,
              paidAt: _ms(p['paid_at']),
            ),
          );
    }
    return [
      for (final a in accounts)
        ProfileFee(
          accountId: a['id']! as String,
          total: a['total']! as int,
          paid: a['paid']! as int,
          dueDate: _ms(a['due_date']),
          payments: byAccount[a['id']! as String] ?? const [],
        ),
    ];
  }
}
