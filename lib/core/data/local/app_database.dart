import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Thin wrapper around the app's single SQLite database.
///
/// Every repository receives this and talks to [db]. Foreign keys are on, so
/// deleting or renaming a class cascades to its students and their marks.
class AppDatabase {
  AppDatabase(this.db);

  final Database db;

  static const schemaVersion = 21;
  static const _fileName = 'shiksha_setu.db';

  static Future<AppDatabase> open() async {
    final path = p.join(await getDatabasesPath(), _fileName);
    return AppDatabase(
      await openDatabase(
        path,
        version: schemaVersion,
        onConfigure: configure,
        onCreate: create,
        onUpgrade: upgrade,
      ),
    );
  }

  static Future<void> configure(Database db) =>
      db.execute('PRAGMA foreign_keys = ON');

  static Future<void> create(Database db, int version) async {
    for (final statement in _schema) {
      await db.execute(statement);
    }
  }

  /// Brings a database made by an older version up to [to], one step at a
  /// time. Each step only adds; nothing existing is dropped.
  static Future<void> upgrade(Database db, int from, int to) async {
    for (var v = from + 1; v <= to; v++) {
      for (final statement in _migrations[v] ?? const <String>[]) {
        await db.execute(statement);
      }
    }
  }

  Future<void> close() => db.close();

  /// Tables copied into a backup, in an order that respects foreign keys.
  static const backupTables = [
    'app_settings',
    'users',
    'classes',
    'students',
    'other_staff',
    'school_days',
    'teacher_attendance',
    'student_attendance',
    'exam_papers',
    'exam_questions',
    'exam_marks',
    'fee_accounts',
    'fee_payments',
    'notices',
    'master_questions',
    'school_day_changes',
    'teacher_subjects',
    'staff_attendance',
    'fee_structure',
    'accessory_items',
    'accessory_issues',
    'school_timings',
    'bell_slots',
    'assembly_duty',
    'timetable_entries',
    // A bill points at the settlement that paid it, so that comes first.
    'staff_settlements',
    'staff_bills',
    'question_units',
  ];

  /// Tables a backup made by an older app version does not have yet.
  static const tableAddedIn = {
    'master_questions': 2,
    'school_day_changes': 7,
    'teacher_subjects': 9,
    'staff_attendance': 14,
    'fee_structure': 15,
    'accessory_items': 16,
    'accessory_issues': 16,
    'school_timings': 17,
    'bell_slots': 17,
    'assembly_duty': 17,
    'timetable_entries': 17,
    'staff_bills': 18,
    'staff_settlements': 18,
    'question_units': 19,
  };

  static final _schema = [
    '''
CREATE TABLE app_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
)''',
    '''
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE COLLATE NOCASE,
  role TEXT NOT NULL,
  phone TEXT NOT NULL,
  employee_id TEXT NOT NULL,
  joined_on INTEGER NOT NULL,
  subject TEXT,
  aadhaar_masked TEXT,
  aadhaar_reason TEXT,
  dob INTEGER,
  gender TEXT,
  address TEXT,
  password_hash TEXT NOT NULL,
  password_salt TEXT NOT NULL,
  active INTEGER NOT NULL DEFAULT 1
)''',
    '''
CREATE TABLE classes (
  name TEXT PRIMARY KEY COLLATE NOCASE,
  class_teacher_id TEXT UNIQUE REFERENCES users(id) ON DELETE SET NULL
)''',
    '''
CREATE TABLE students (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  roll_no INTEGER NOT NULL,
  class_name TEXT NOT NULL
    REFERENCES classes(name) ON UPDATE CASCADE ON DELETE CASCADE,
  guardian TEXT,
  phone TEXT,
  aadhaar_masked TEXT,
  aadhaar_reason TEXT,
  dob INTEGER,
  gender TEXT,
  address TEXT,
  registered_on INTEGER NOT NULL,
  active INTEGER NOT NULL DEFAULT 1,
  vehicle_number TEXT,
  dress_size TEXT
)''',
    '''
CREATE TABLE other_staff (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role_title TEXT NOT NULL,
  phone TEXT NOT NULL,
  aadhaar_masked TEXT,
  aadhaar_reason TEXT,
  dob INTEGER,
  gender TEXT,
  address TEXT,
  registered_on INTEGER NOT NULL,
  active INTEGER NOT NULL DEFAULT 1,
  vehicle_number TEXT
)''',
    '''
CREATE TABLE school_days (
  day TEXT PRIMARY KEY,
  status TEXT NOT NULL,
  decided_by TEXT,
  decided_at INTEGER,
  reason TEXT,
  kind TEXT
)''',
    '''
CREATE TABLE teacher_attendance (
  teacher_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  day TEXT NOT NULL,
  check_in INTEGER,
  check_out INTEGER,
  in_lat REAL, in_lon REAL, in_distance REAL, in_selfie TEXT, in_face_score REAL,
  out_lat REAL, out_lon REAL, out_distance REAL, out_selfie TEXT, out_face_score REAL,
  PRIMARY KEY (teacher_id, day)
)''',
    '''
CREATE TABLE student_attendance (
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  day TEXT NOT NULL,
  status TEXT NOT NULL,
  PRIMARY KEY (student_id, day)
)''',
    '''
CREATE TABLE exam_papers (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  subject TEXT NOT NULL,
  class_name TEXT NOT NULL,
  exam_date INTEGER NOT NULL,
  duration_minutes INTEGER NOT NULL,
  status TEXT NOT NULL,
  created_by TEXT,
  instructions TEXT,
  review_note TEXT,
  submitted_at INTEGER,
  exam_type TEXT
)''',
    '''
CREATE TABLE exam_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  paper_id TEXT NOT NULL REFERENCES exam_papers(id) ON DELETE CASCADE,
  position INTEGER NOT NULL,
  text TEXT NOT NULL,
  marks INTEGER NOT NULL,
  type TEXT NOT NULL DEFAULT 'shortAnswer',
  details TEXT
)''',
    '''
CREATE TABLE exam_marks (
  paper_id TEXT NOT NULL REFERENCES exam_papers(id) ON DELETE CASCADE,
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  marks_obtained INTEGER NOT NULL,
  PRIMARY KEY (paper_id, student_id)
)''',
    '''
CREATE TABLE fee_accounts (
  id TEXT PRIMARY KEY,
  group_type TEXT NOT NULL,
  person_id TEXT,
  name TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  total INTEGER NOT NULL,
  due_date INTEGER NOT NULL,
  head TEXT NOT NULL DEFAULT 'academic',
  last_date INTEGER,
  date_note TEXT
)''',
    '''
CREATE TABLE fee_payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id TEXT NOT NULL REFERENCES fee_accounts(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  paid_at INTEGER NOT NULL,
  mode TEXT NOT NULL DEFAULT 'cash',
  reference TEXT,
  proof_path TEXT
)''',
    '''
CREATE TABLE notices (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  posted_by TEXT NOT NULL,
  posted_at INTEGER NOT NULL
)''',
    _masterQuestions,
    _syncState,
    _faceTemplates,
    _schoolDayChanges,
    _teacherSubjects,
    _teacherSubjectsIndex,
    _staffAttendance,
    _feeStructure,
    _accessoryItems,
    _accessoryIssues,
    _schoolTimings,
    _bellSlots,
    _assemblyDuty,
    _timetableEntries,
    _staffSettlements,
    _staffBills,
    _questionUnits,
    _syncFlag,
    ..._syncTriggers,
  ];

  static const _masterQuestions = '''
CREATE TABLE master_questions (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  text TEXT NOT NULL,
  marks INTEGER,
  details TEXT,
  subject TEXT,
  class_name TEXT,
  created_by TEXT,
  created_at INTEGER NOT NULL,
  unit_id TEXT
)''';

  /// A unit of a teacher's question bank: one subject of one class.
  static const _questionUnits = '''
CREATE TABLE question_units (
  id TEXT PRIMARY KEY,
  teacher_id TEXT NOT NULL,
  class_name TEXT NOT NULL,
  subject TEXT NOT NULL,
  name TEXT NOT NULL,
  position INTEGER NOT NULL,
  created_at INTEGER NOT NULL
)''';

  /// Counts every change to school data, so the app knows when something
  /// is waiting to go to the cloud (and still knows after the app is closed).
  /// `synced_seq` is what the cloud has been sent up to, `mirrored_seq` what
  /// the data file has been written up to, and `changed_at` when school data
  /// last changed.
  static const _syncFlag = '''
CREATE TABLE sync_flag (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  seq INTEGER NOT NULL,
  synced_seq INTEGER NOT NULL,
  mirrored_seq INTEGER NOT NULL DEFAULT 0,
  changed_at INTEGER NOT NULL DEFAULT 0
)''';

  /// One trigger per change kind on every backed-up table. Settings that
  /// describe this phone (`cloud_...`, the logo) are not school data.
  static List<String> get _syncTriggers => [
    "INSERT INTO sync_flag (id, seq, synced_seq) VALUES (1, 0, 0)",
    for (final t in backupTables)
      for (final (name, event, row) in const [
        ('i', 'INSERT', 'NEW'),
        ('u', 'UPDATE', 'NEW'),
        ('d', 'DELETE', 'OLD'),
      ])
        '''
CREATE TRIGGER trg_sync_${t}_$name AFTER $event ON $t
${t == 'app_settings' ? "WHEN $row.key NOT LIKE 'cloud\\_%' ESCAPE '\\' AND $row.key <> 'school_logo'" : ''}
BEGIN UPDATE sync_flag SET seq = seq + 1,
  changed_at = CAST(strftime('%s', 'now') AS INTEGER) * 1000; END''',
  ];

  /// Takes the change counter and its triggers away, to be made again.
  static List<String> get _dropSyncTriggers => [
    for (final t in backupTables)
      for (final name in const ['i', 'u', 'd'])
        'DROP TRIGGER IF EXISTS trg_sync_${t}_$name',
    'DROP TABLE IF EXISTS sync_flag',
  ];

  /// What the cloud already has, per row, so only changes are sent. Local to
  /// the phone: never backed up and never sent.
  static const _syncState = '''
CREATE TABLE sync_state (
  table_name TEXT NOT NULL,
  row_key TEXT NOT NULL,
  hash TEXT NOT NULL,
  snapshot TEXT,
  PRIMARY KEY (table_name, row_key)
)''';

  /// Each teacher's face as numbers (never the photos). Local to the phone: not
  /// backed up and not sent to the cloud.
  static const _faceTemplates = '''
CREATE TABLE face_templates (
  teacher_id TEXT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  embeddings TEXT NOT NULL,
  enrolled_at INTEGER NOT NULL,
  enrolled_by TEXT
)''';

  /// Every edit of a school day, with who made it and why.
  static const _schoolDayChanges = '''
CREATE TABLE school_day_changes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  day TEXT NOT NULL,
  old_status TEXT NOT NULL,
  new_status TEXT NOT NULL,
  reason TEXT,
  changed_by TEXT,
  changed_at INTEGER NOT NULL
)''';

  /// The subjects each teacher teaches, per class. A teacher can have many.
  /// "pending" is a request from the teacher waiting for the Principal;
  /// "approved" is allowed (the Principal allotted it or accepted the
  /// request); "rejected" was turned down.
  static const _teacherSubjects = '''
CREATE TABLE teacher_subjects (
  id TEXT PRIMARY KEY,
  teacher_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  class_name TEXT NOT NULL,
  subject TEXT NOT NULL,
  status TEXT NOT NULL,
  requested_by TEXT NOT NULL,
  requested_at INTEGER NOT NULL,
  decided_at INTEGER
)''';

  /// Whether each other staff member (driver, helper...) came, per day. The
  /// Principal marks it; they have no login of their own.
  static const _staffAttendance = '''
CREATE TABLE staff_attendance (
  staff_id TEXT NOT NULL REFERENCES other_staff(id) ON DELETE CASCADE,
  day TEXT NOT NULL,
  status TEXT NOT NULL,
  PRIMARY KEY (staff_id, day)
)''';

  /// What each class pays for each kind of fee, and when it falls due. The
  /// last date is when payment stops being on time.
  static const _feeStructure = '''
CREATE TABLE fee_structure (
  class_name TEXT NOT NULL REFERENCES classes(name)
    ON UPDATE CASCADE ON DELETE CASCADE,
  head TEXT NOT NULL,
  amount INTEGER NOT NULL,
  due_date INTEGER NOT NULL,
  last_date INTEGER,
  PRIMARY KEY (class_name, head)
)''';

  /// What a class is given: the pieces of its dress, and its books.
  static const _accessoryItems = '''
CREATE TABLE accessory_items (
  id TEXT PRIMARY KEY,
  class_name TEXT NOT NULL REFERENCES classes(name)
    ON UPDATE CASCADE ON DELETE CASCADE,
  kind TEXT NOT NULL,
  name TEXT NOT NULL,
  position INTEGER NOT NULL
)''';

  /// Each time dress or books were handed to a student: what, to whom, and
  /// the proof (a signature, and a photo if one was taken).
  static const _accessoryIssues = '''
CREATE TABLE accessory_issues (
  id TEXT PRIMARY KEY,
  receipt_no TEXT NOT NULL,
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  kind TEXT NOT NULL,
  items TEXT NOT NULL,
  size TEXT,
  quantity INTEGER NOT NULL DEFAULT 1,
  received_by TEXT NOT NULL,
  signature_path TEXT,
  photo_path TEXT,
  issued_by TEXT NOT NULL,
  issued_at INTEGER NOT NULL
)''';

  /// Timings other than the school's own: for some classes (the youngest, for
  /// one), or from a date (summer and winter). Minutes since midnight.
  static const _schoolTimings = '''
CREATE TABLE school_timings (
  id TEXT PRIMARY KEY,
  class_names TEXT,
  start_min INTEGER NOT NULL,
  end_min INTEGER NOT NULL,
  from_date INTEGER
)''';

  /// The school's bell: each period and break of the day, in order.
  static const _bellSlots = '''
CREATE TABLE bell_slots (
  id TEXT PRIMARY KEY,
  position INTEGER NOT NULL,
  kind TEXT NOT NULL,
  label TEXT NOT NULL,
  start_min INTEGER NOT NULL,
  end_min INTEGER NOT NULL
)''';

  /// Which class (and teacher) leads the assembly on each weekday (1 = Monday).
  static const _assemblyDuty = '''
CREATE TABLE assembly_duty (
  weekday INTEGER PRIMARY KEY,
  class_name TEXT,
  teacher_id TEXT REFERENCES users(id) ON DELETE SET NULL
)''';

  /// What each class has in each period of each weekday, and who teaches it.
  static const _timetableEntries = '''
CREATE TABLE timetable_entries (
  class_name TEXT NOT NULL REFERENCES classes(name)
    ON UPDATE CASCADE ON DELETE CASCADE,
  weekday INTEGER NOT NULL,
  slot_id TEXT NOT NULL REFERENCES bell_slots(id) ON DELETE CASCADE,
  subject TEXT NOT NULL,
  teacher_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  PRIMARY KEY (class_name, weekday, slot_id)
)''';

  /// A payment to a staff member for the bills they brought, with proof.
  static const _staffSettlements = '''
CREATE TABLE staff_settlements (
  id TEXT PRIMARY KEY,
  voucher_no TEXT NOT NULL,
  staff_id TEXT NOT NULL REFERENCES other_staff(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  paid_at INTEGER NOT NULL,
  mode TEXT NOT NULL,
  reference TEXT,
  proof_path TEXT,
  paid_by TEXT NOT NULL
)''';

  /// A fuel bill of a staff member (a driver). It is paid only once the
  /// Principal has approved it.
  static const _staffBills = '''
CREATE TABLE staff_bills (
  id TEXT PRIMARY KEY,
  staff_id TEXT NOT NULL REFERENCES other_staff(id) ON DELETE CASCADE,
  kind TEXT NOT NULL,
  bill_date INTEGER NOT NULL,
  litres REAL,
  amount INTEGER NOT NULL,
  photo_path TEXT,
  note TEXT,
  status TEXT NOT NULL DEFAULT 'pending',
  decided_at INTEGER,
  settlement_id TEXT REFERENCES staff_settlements(id) ON DELETE SET NULL
)''';

  static const _teacherSubjectsIndex =
      'CREATE INDEX idx_teacher_subjects_teacher ON teacher_subjects(teacher_id)';

  /// What each version added on top of the one before it.
  static final _migrations = {
    2: [
      'ALTER TABLE exam_papers ADD COLUMN instructions TEXT',
      'ALTER TABLE exam_papers ADD COLUMN review_note TEXT',
      'ALTER TABLE exam_papers ADD COLUMN submitted_at INTEGER',
      // "scheduled" became "approved" when the approval step was added.
      "UPDATE exam_papers SET status = 'approved' WHERE status = 'scheduled'",
      "ALTER TABLE exam_questions ADD COLUMN type TEXT NOT NULL DEFAULT 'shortAnswer'",
      'ALTER TABLE exam_questions ADD COLUMN details TEXT',
      _masterQuestions,
    ],
    3: [_syncState],
    4: [
      'ALTER TABLE teacher_attendance ADD COLUMN in_face_score REAL',
      'ALTER TABLE teacher_attendance ADD COLUMN out_face_score REAL',
      _faceTemplates,
    ],
    5: [
      // Date of birth, read from the Aadhaar card when registering.
      'ALTER TABLE users ADD COLUMN dob INTEGER',
      'ALTER TABLE students ADD COLUMN dob INTEGER',
      'ALTER TABLE other_staff ADD COLUMN dob INTEGER',
    ],
    6: [
      // Gender and address, read from the Aadhaar card when registering.
      'ALTER TABLE users ADD COLUMN gender TEXT',
      'ALTER TABLE users ADD COLUMN address TEXT',
      'ALTER TABLE students ADD COLUMN gender TEXT',
      'ALTER TABLE students ADD COLUMN address TEXT',
      'ALTER TABLE other_staff ADD COLUMN gender TEXT',
      'ALTER TABLE other_staff ADD COLUMN address TEXT',
    ],
    7: [
      // Why a school day was marked open or closed, and a log of the edits.
      'ALTER TABLE school_days ADD COLUMN reason TEXT',
      _schoolDayChanges,
    ],
    8: [
      // "holiday" marks a closed day that is on the planned holiday list.
      'ALTER TABLE school_days ADD COLUMN kind TEXT',
    ],
    9: [_teacherSubjects, _teacherSubjectsIndex],
    21: [..._dropSyncTriggers, _syncFlag, ..._syncTriggers],
    20: [_syncFlag, ..._syncTriggers],
    19: [
      _questionUnits,
      'ALTER TABLE master_questions ADD COLUMN unit_id TEXT',
      'ALTER TABLE exam_papers ADD COLUMN exam_type TEXT',
    ],
    18: [_staffSettlements, _staffBills],
    17: [_schoolTimings, _bellSlots, _assemblyDuty, _timetableEntries],
    16: [
      'ALTER TABLE students ADD COLUMN dress_size TEXT',
      _accessoryItems,
      _accessoryIssues,
    ],
    15: [
      // Fees are kept per kind of fee (academic, dress, books, van), each with
      // a last date, and every payment says how it was paid and keeps proof.
      "ALTER TABLE fee_accounts ADD COLUMN head TEXT NOT NULL DEFAULT 'academic'",
      'ALTER TABLE fee_accounts ADD COLUMN last_date INTEGER',
      'ALTER TABLE fee_accounts ADD COLUMN date_note TEXT',
      "UPDATE fee_accounts SET head = 'payment' WHERE group_type != 'student'",
      "ALTER TABLE fee_payments ADD COLUMN mode TEXT NOT NULL DEFAULT 'cash'",
      'ALTER TABLE fee_payments ADD COLUMN reference TEXT',
      'ALTER TABLE fee_payments ADD COLUMN proof_path TEXT',
      // The van a student travels by.
      'ALTER TABLE students ADD COLUMN vehicle_number TEXT',
      _feeStructure,
    ],
    14: [_staffAttendance],
    13: [
      // A student or staff member who has left is made inactive, not deleted,
      // so their attendance, marks and fees stay on record.
      'ALTER TABLE students ADD COLUMN active INTEGER NOT NULL DEFAULT 1',
      'ALTER TABLE other_staff ADD COLUMN active INTEGER NOT NULL DEFAULT 1',
      // The van a driver drives.
      'ALTER TABLE other_staff ADD COLUMN vehicle_number TEXT',
    ],
    12: [
      // The row as last sent, so the next sync can show what it was before.
      'ALTER TABLE sync_state ADD COLUMN snapshot TEXT',
    ],
    11: [
      // The day the school was registered, where the calendar starts. It is a
      // school setting so it reaches the teachers' phones too. Schools made
      // before this take the day their Principal's account was made.
      "INSERT OR IGNORE INTO app_settings (key, value) "
          "SELECT 'school_registered_on', CAST(joined_on AS TEXT) "
          "FROM users WHERE role = 'principal' "
          "ORDER BY joined_on LIMIT 1",
    ],
    10: [
      // The Aadhaar number became optional; the reason it is missing is kept.
      'ALTER TABLE users ADD COLUMN aadhaar_reason TEXT',
      'ALTER TABLE students ADD COLUMN aadhaar_reason TEXT',
      // other_staff.aadhaar_masked was NOT NULL, so the table is rebuilt.
      '''
CREATE TABLE other_staff_new (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role_title TEXT NOT NULL,
  phone TEXT NOT NULL,
  aadhaar_masked TEXT,
  aadhaar_reason TEXT,
  dob INTEGER,
  gender TEXT,
  address TEXT,
  registered_on INTEGER NOT NULL
)''',
      'INSERT INTO other_staff_new (id, name, role_title, phone, aadhaar_masked, '
          'dob, gender, address, registered_on) '
          'SELECT id, name, role_title, phone, aadhaar_masked, dob, gender, '
          'address, registered_on FROM other_staff',
      'DROP TABLE other_staff',
      'ALTER TABLE other_staff_new RENAME TO other_staff',
    ],
  };
}
