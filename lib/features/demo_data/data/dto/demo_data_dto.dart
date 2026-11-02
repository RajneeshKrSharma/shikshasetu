import 'dart:convert';
import 'dart:math';

import '../../../../core/data/local/day_key.dart';

typedef DemoRow = Map<String, Object?>;

/// Every id of demo data starts with this, so it can be found and removed.
const demoIdPrefix = 'demo-';

/// Where the demo school is, when the Principal has not set a location yet.
const demoSchoolLat = 26.8467;
const demoSchoolLon = 80.9462;
const demoSchoolRadiusMeters = 200;

/// The rows of a whole demo school, one list per table, in the shape the
/// database stores them: Nursery to Class 8, male and female teachers, other
/// staff, a term of attendance, exams, fees, notices and more.
///
/// Built from a fixed seed, so the same day always gives the same school.
class DemoDataDto {
  DemoDataDto._(_Builder b)
    : classes = b.classes,
      users = b.users,
      students = b.students,
      otherStaff = b.otherStaff,
      schoolDays = b.schoolDays,
      schoolDayChanges = b.schoolDayChanges,
      teacherAttendance = b.teacherAttendance,
      studentAttendance = b.studentAttendance,
      staffAttendance = b.staffAttendance,
      examPapers = b.examPapers,
      examQuestions = b.examQuestions,
      examMarks = b.examMarks,
      feeAccounts = b.feeAccounts,
      feePayments = b.feePayments,
      feeStructure = b.feeStructure,
      accessoryItems = b.accessoryItems,
      accessoryIssues = b.accessoryIssues,
      bellSlots = b.bellSlots,
      timetableEntries = b.timetableEntries,
      assemblyDuty = b.assemblyDuty,
      schoolTimings = b.schoolTimings,
      daySettings = b.daySettings,
      staffBills = b.staffBills,
      staffSettlements = b.staffSettlements,
      notices = b.notices,
      masterQuestions = b.masterQuestions,
      questionUnits = b.questionUnits,
      teacherSubjects = b.teacherSubjects,
      yearStart = b.yearStart,
      dayKeys = b.dayKeys;

  factory DemoDataDto.build({
    required String principalId,
    required String principalName,
    required DateTime now,
    double lat = demoSchoolLat,
    double lon = demoSchoolLon,
  }) {
    final b = _Builder(
      principalId: principalId,
      principalName: principalName,
      now: now,
      lat: lat,
      lon: lon,
    )..build();
    return DemoDataDto._(b);
  }

  final List<DemoRow> classes;
  final List<DemoRow> users;
  final List<DemoRow> students;
  final List<DemoRow> otherStaff;
  final List<DemoRow> schoolDays;
  final List<DemoRow> schoolDayChanges;
  final List<DemoRow> teacherAttendance;
  final List<DemoRow> studentAttendance;
  final List<DemoRow> staffAttendance;
  final List<DemoRow> examPapers;
  final List<DemoRow> examQuestions;
  final List<DemoRow> examMarks;
  final List<DemoRow> feeAccounts;
  final List<DemoRow> feePayments;
  final List<DemoRow> feeStructure;
  final List<DemoRow> accessoryItems;
  final List<DemoRow> accessoryIssues;
  final List<DemoRow> bellSlots;
  final List<DemoRow> timetableEntries;
  final List<DemoRow> assemblyDuty;
  final List<DemoRow> schoolTimings;
  final List<DemoRow> staffBills;
  final List<DemoRow> staffSettlements;

  /// `app_settings` keys for the school day, with their values.
  final Map<String, String> daySettings;
  final List<DemoRow> notices;
  final List<DemoRow> masterQuestions;

  /// The units of the teachers' own banks.
  final List<DemoRow> questionUnits;
  final List<DemoRow> teacherSubjects;

  /// The first day of the academic year, where the school calendar starts.
  final DateTime yearStart;

  /// Every school day written, so they can be taken out again.
  final List<String> dayKeys;

  List<String> get classNames => [
    for (final c in classes) c['name']! as String,
  ];

  /// The announcement shown on the dashboard when the school has none.
  static const announcement =
      'Half-yearly results will be shared with parents next week.';
}

// ---------------------------------------------------------------------------

const _classNames = [
  'Nursery',
  'LKG',
  'UKG',
  'Class 1',
  'Class 2',
  'Class 3',
  'Class 4',
  'Class 5',
  'Class 6',
  'Class 7',
  'Class 8',
];

/// Students in each class, in the order of [_classNames].
const _classSizes = [10, 11, 12, 12, 13, 12, 14, 13, 12, 12, 11];

/// Fee for the year, per class (rupees).
int _feeOf(int c) => c <= 2 ? 18000 : (c <= 7 ? 24000 : 30000);

const _boys = [
  'Aarav',
  'Vivaan',
  'Aditya',
  'Arjun',
  'Reyansh',
  'Krishna',
  'Ishaan',
  'Rohan',
  'Kabir',
  'Ayaan',
  'Dev',
  'Harsh',
  'Yash',
  'Mohit',
  'Karan',
  'Nikhil',
  'Rahul',
  'Saurabh',
  'Tanmay',
  'Vedant',
  'Shaurya',
  'Ansh',
  'Atharv',
  'Dhruv',
  'Lakshya',
  'Pranav',
  'Samar',
  'Tushar',
  'Utkarsh',
  'Zaid',
];

const _girls = [
  'Ananya',
  'Diya',
  'Isha',
  'Kavya',
  'Myra',
  'Saanvi',
  'Aadhya',
  'Riya',
  'Pari',
  'Navya',
  'Tanvi',
  'Anika',
  'Priyanka',
  'Sneha',
  'Shruti',
  'Aarohi',
  'Ira',
  'Khushi',
  'Muskan',
  'Nisha',
  'Palak',
  'Roshni',
  'Simran',
  'Tara',
  'Vanya',
  'Zoya',
  'Aisha',
  'Bhavya',
  'Charvi',
  'Divya',
];

const _surnames = [
  'Sharma',
  'Verma',
  'Gupta',
  'Singh',
  'Yadav',
  'Mishra',
  'Pandey',
  'Tiwari',
  'Agarwal',
  'Srivastava',
  'Chauhan',
  'Joshi',
  'Khan',
  'Ansari',
  'Kumar',
  'Maurya',
  'Patel',
  'Dubey',
  'Saxena',
  'Rastogi',
];

const _areas = [
  'Gomti Nagar',
  'Indira Nagar',
  'Aliganj',
  'Alambagh',
  'Mahanagar',
  'Chinhat',
  'Rajajipuram',
  'Jankipuram',
];

class _Teacher {
  const _Teacher(this.name, this.gender, this.subject);
  final String name;
  final String gender;
  final String subject;
}

const _teachers = [
  _Teacher('Rajesh Kumar', 'male', 'Maths'), // 0
  _Teacher('Anil Verma', 'male', 'Science'), // 1
  _Teacher('Sunil Yadav', 'male', 'Computer'), // 2
  _Teacher('Manoj Tiwari', 'male', 'Social Science'), // 3
  _Teacher('Vikram Singh', 'male', 'Physical Education'), // 4
  _Teacher('Deepak Mishra', 'male', 'Hindi'), // 5
  _Teacher('Amit Srivastava', 'male', 'English'), // 6
  _Teacher('Sunita Sharma', 'female', 'English'), // 7
  _Teacher('Kavita Gupta', 'female', 'Hindi'), // 8
  _Teacher('Priya Singh', 'female', 'EVS'), // 9
  _Teacher('Neha Agarwal', 'female', 'Maths'), // 10
  _Teacher('Anjali Pandey', 'female', 'Science'), // 11
  _Teacher('Pooja Chauhan', 'female', 'English'), // 12
  _Teacher('Meena Joshi', 'female', 'Art & Craft'), // 13
];

/// The class teacher of each class (index into [_teachers]), in class order.
const _classTeacher = [12, 13, 9, 8, 10, 11, 7, 4, 1, 3, 5];

const _otherStaff = [
  ('Ramesh Prasad', 'Peon', 'male'),
  ('Shanti Devi', 'Helper', 'female'),
  ('Mohan Lal', 'Security Guard', 'male'),
  ('Suresh Chandra', 'Bus Driver', 'male'),
  ('Rekha Rani', 'Office Clerk', 'female'),
  ('Girish Narayan', 'Accountant', 'male'),
];

/// Subjects taught in a class (index in [_classNames]).
List<String> _subjectsOf(int c) {
  if (c <= 2) return ['English', 'Hindi', 'Maths', 'EVS', 'Art & Craft'];
  if (c <= 7) {
    return [
      'English',
      'Hindi',
      'Maths',
      'EVS',
      'Art & Craft',
      if (c >= 5) 'Computer',
    ];
  }
  return [
    'English',
    'Hindi',
    'Maths',
    'Science',
    'Social Science',
    'Computer',
    'Physical Education',
  ];
}

/// Who teaches [subject] in class [c] (index into [_teachers]).
int _ownerOf(String subject, int c) {
  if (c <= 2) {
    return subject == 'Art & Craft' ? 13 : _classTeacher[c];
  }
  final senior = c >= 8;
  return switch (subject) {
    'English' => senior ? 6 : 7,
    'Hindi' => senior ? 5 : 8,
    'Maths' => senior ? 0 : 10,
    'EVS' => c >= 5 ? 11 : 9,
    'Science' => c == 9 ? 11 : 1,
    'Social Science' => 3,
    'Computer' => 2,
    'Physical Education' => 4,
    _ => 13, // Art & Craft
  };
}

class _Holiday {
  const _Holiday(this.reason, this.from, this.to);
  final String reason;
  final (int, int) from;
  final (int, int) to;
}

/// Closures that fall on the same date every year.
const _holidays = [
  _Holiday('Ambedkar Jayanti', (4, 14), (4, 14)),
  _Holiday('Summer vacation', (5, 25), (6, 30)),
  _Holiday('Independence Day', (8, 15), (8, 15)),
  _Holiday('Gandhi Jayanti', (10, 2), (10, 2)),
];

// ---------------------------------------------------------------------------

class _Q {
  const _Q(this.type, this.text, this.marks, {this.details});
  final String type;
  final String text;
  final int marks;
  final String? details;
}

String _mcq(List<String> options, int correct) =>
    jsonEncode({'options': options, 'correct': correct});

String _tf(bool isTrue) => jsonEncode({'correct': isTrue ? 0 : 1});

String _fill(String answer) => jsonEncode({'answer': answer});

String _match(List<List<String>> pairs) => jsonEncode({'pairs': pairs});

/// A paper of 20 marks: 2 + 2 + 2 + 4 + 5 + 5.
List<_Q> _paper({
  required String mcq,
  required List<String> options,
  required int correct,
  required String tf,
  required bool tfTrue,
  required String fill,
  required String fillAnswer,
  required String matchTitle,
  required List<List<String>> pairs,
  required String short,
  required String shortAnswer,
  required String long,
  String longAnswer = '',
}) => [
  _Q('mcq', mcq, 2, details: _mcq(options, correct)),
  _Q('trueFalse', tf, 2, details: _tf(tfTrue)),
  _Q('fillBlank', fill, 2, details: _fill(fillAnswer)),
  _Q('matchFollowing', matchTitle, 4, details: _match(pairs)),
  _Q('shortAnswer', short, 5, details: _fill(shortAnswer)),
  _Q(
    'longAnswer',
    long,
    5,
    details: longAnswer.isEmpty ? null : _fill(longAnswer),
  ),
];

final _bank = <String, List<_Q>>{
  'Maths:junior': _paper(
    mcq: 'What is 7 + 5?',
    options: ['10', '11', '12', '13'],
    correct: 2,
    tf: '9 is greater than 7.',
    tfTrue: true,
    fill: '15 - 6 = ____',
    fillAnswer: '9',
    matchTitle: 'Match the numbers with their words.',
    pairs: [
      ['2', 'Two'],
      ['5', 'Five'],
      ['8', 'Eight'],
      ['10', 'Ten'],
    ],
    short: 'Write the numbers from 1 to 10.',
    shortAnswer: '1, 2, 3, 4, 5, 6, 7, 8, 9, 10',
    long:
        'Ravi has 12 marbles and gets 8 more. How many marbles does he have '
        'now? Show your working.',
    longAnswer: '12 + 8 = 20 marbles',
  ),
  'Maths:senior': _paper(
    mcq: 'The value of 3² + 4² is',
    options: ['7', '12', '25', '49'],
    correct: 2,
    tf: 'The sum of the angles of a triangle is 180°.',
    tfTrue: true,
    fill: 'The LCM of 4 and 6 is ____.',
    fillAnswer: '12',
    matchTitle: 'Match the shape with its property.',
    pairs: [
      ['Square', '4 equal sides'],
      ['Triangle', '3 sides'],
      ['Circle', 'No corners'],
      ['Rectangle', 'Opposite sides equal'],
    ],
    short: 'Solve: 2x + 5 = 15',
    shortAnswer: 'x = 5',
    long:
        'A shopkeeper buys a shirt for ₹400 and sells it for ₹460. Find the '
        'profit percent.',
    longAnswer: 'Profit = 60, profit % = 60/400 × 100 = 15%',
  ),
  'English:junior': _paper(
    mcq: 'Which word is a noun?',
    options: ['run', 'apple', 'quickly', 'blue'],
    correct: 1,
    tf: 'A cat is an animal.',
    tfTrue: true,
    fill: 'The sun rises in the ____.',
    fillAnswer: 'east',
    matchTitle: 'Match the opposites.',
    pairs: [
      ['Hot', 'Cold'],
      ['Big', 'Small'],
      ['Day', 'Night'],
      ['Up', 'Down'],
    ],
    short: "Write three words that rhyme with 'cat'.",
    shortAnswer: 'bat, hat, mat',
    long: 'Write five sentences about your school.',
  ),
  'English:senior': _paper(
    mcq: "Choose the correct past tense of 'go'.",
    options: ['goed', 'went', 'gone', 'going'],
    correct: 1,
    tf: 'An adjective describes a noun.',
    tfTrue: true,
    fill: 'She ____ my best friend. (is / are)',
    fillAnswer: 'is',
    matchTitle: 'Match the words with their synonyms.',
    pairs: [
      ['Happy', 'Joyful'],
      ['Big', 'Large'],
      ['Quick', 'Fast'],
      ['Begin', 'Start'],
    ],
    short: 'What is a metaphor? Give one example.',
    shortAnswer: 'A comparison without "like" or "as", e.g. "Time is money."',
    long: 'Write a letter to your friend inviting them to your birthday party.',
  ),
  'Hindi': _paper(
    mcq: "'सूरज' का पर्यायवाची शब्द कौन-सा है?",
    options: ['चाँद', 'रवि', 'तारा', 'बादल'],
    correct: 1,
    tf: "'गाय' एक पशु है।",
    tfTrue: true,
    fill: 'भारत की राजधानी ____ है।',
    fillAnswer: 'नई दिल्ली',
    matchTitle: 'विलोम शब्द मिलाइए।',
    pairs: [
      ['दिन', 'रात'],
      ['ऊपर', 'नीचे'],
      ['सुख', 'दुख'],
      ['अच्छा', 'बुरा'],
    ],
    short: 'अपने विद्यालय का नाम लिखिए।',
    shortAnswer: '',
    long: "'मेरा प्रिय त्योहार' पर पाँच वाक्य लिखिए।",
  ),
  'EVS': _paper(
    mcq: 'Which of these is a source of water?',
    options: ['Stone', 'River', 'Chair', 'Book'],
    correct: 1,
    tf: 'Plants need sunlight to grow.',
    tfTrue: true,
    fill: 'We breathe in ____.',
    fillAnswer: 'oxygen',
    matchTitle: 'Match the animal with its home.',
    pairs: [
      ['Bird', 'Nest'],
      ['Dog', 'Kennel'],
      ['Bee', 'Hive'],
      ['Fish', 'Water'],
    ],
    short: 'Name two things we get from plants.',
    shortAnswer: 'fruits, wood',
    long: 'Why should we keep our surroundings clean? Write four sentences.',
  ),
  'Science': _paper(
    mcq: 'Which gas do plants take in for photosynthesis?',
    options: ['Oxygen', 'Carbon dioxide', 'Nitrogen', 'Hydrogen'],
    correct: 1,
    tf: 'Water boils at 100°C at sea level.',
    tfTrue: true,
    fill: 'The force that pulls objects towards the Earth is called ____.',
    fillAnswer: 'gravity',
    matchTitle: 'Match the organ with its work.',
    pairs: [
      ['Heart', 'Pumps blood'],
      ['Lungs', 'Breathing'],
      ['Kidney', 'Filters blood'],
      ['Brain', 'Controls the body'],
    ],
    short: 'What is the difference between a mixture and a compound?',
    shortAnswer: 'A mixture can be separated physically; a compound cannot.',
    long: 'Explain the process of photosynthesis with a labelled diagram.',
  ),
  'Social Science': _paper(
    mcq: 'Who was the first Prime Minister of India?',
    options: ['M. K. Gandhi', 'Jawaharlal Nehru', 'Sardar Patel', 'S. C. Bose'],
    correct: 1,
    tf: 'The Ganga is the longest river in India.',
    tfTrue: true,
    fill: 'The capital of Uttar Pradesh is ____.',
    fillAnswer: 'Lucknow',
    matchTitle: 'Match the monument with its city.',
    pairs: [
      ['Taj Mahal', 'Agra'],
      ['Red Fort', 'Delhi'],
      ['Gateway of India', 'Mumbai'],
      ['Charminar', 'Hyderabad'],
    ],
    short: 'What is a map? Give one use of it.',
    shortAnswer: 'A drawing of a place; it helps us find directions.',
    long: 'Explain why the Constitution of India is important.',
  ),
  'Computer': _paper(
    mcq: 'Which of these is an input device?',
    options: ['Monitor', 'Keyboard', 'Printer', 'Speaker'],
    correct: 1,
    tf: 'RAM is a permanent memory.',
    tfTrue: false,
    fill: 'The brain of the computer is the ____.',
    fillAnswer: 'CPU',
    matchTitle: 'Match the device with its use.',
    pairs: [
      ['Mouse', 'Pointing device'],
      ['Printer', 'Output device'],
      ['Keyboard', 'Typing'],
      ['Monitor', 'Display'],
    ],
    short: 'What is an operating system?',
    shortAnswer: 'Software that manages the computer and its programs.',
    long: 'Explain hardware and software with two examples of each.',
  ),
  'Art & Craft': _paper(
    mcq: 'Which are the primary colours?',
    options: [
      'Red, Yellow, Blue',
      'Green, Orange, Purple',
      'Black, White, Grey',
      'Pink, Brown, Green',
    ],
    correct: 0,
    tf: 'Mixing blue and yellow gives green.',
    tfTrue: true,
    fill: 'A rainbow has ____ colours.',
    fillAnswer: 'seven',
    matchTitle: 'Match the colour with the thing.',
    pairs: [
      ['Red', 'Apple'],
      ['Yellow', 'Banana'],
      ['Green', 'Leaf'],
      ['Blue', 'Sky'],
    ],
    short: 'Name two tools used for painting.',
    shortAnswer: 'brush, palette',
    long: 'Describe a scene of your village that you would like to paint.',
  ),
  'Physical Education': _paper(
    mcq: 'How many players are there in a cricket team?',
    options: ['9', '10', '11', '12'],
    correct: 2,
    tf: 'Regular exercise keeps us healthy.',
    tfTrue: true,
    fill: 'The Olympic Games are held every ____ years.',
    fillAnswer: 'four',
    matchTitle: 'Match the game with its equipment.',
    pairs: [
      ['Cricket', 'Bat'],
      ['Football', 'Goal'],
      ['Badminton', 'Shuttlecock'],
      ['Hockey', 'Stick'],
    ],
    short: 'Name two benefits of yoga.',
    shortAnswer: 'flexibility, calm mind',
    long: 'Explain why we should warm up before playing a sport.',
  ),
};

List<_Q> _questionsFor(String subject, int c) {
  final level = c >= 8 ? 'senior' : 'junior';
  return _bank['$subject:$level'] ?? _bank[subject] ?? _bank['English:junior']!;
}

// ---------------------------------------------------------------------------

class _Builder {
  _Builder({
    required this.principalId,
    required this.principalName,
    required this.now,
    required this.lat,
    required this.lon,
  }) : today = DateTime(now.year, now.month, now.day),
       yearStart = DateTime(now.month >= 4 ? now.year : now.year - 1, 4, 1);

  final String principalId;
  final String principalName;
  final DateTime now;
  final DateTime today;
  final DateTime yearStart;
  final double lat;
  final double lon;

  final _r = Random(2026);

  final classes = <DemoRow>[];
  final users = <DemoRow>[];
  final students = <DemoRow>[];
  final otherStaff = <DemoRow>[];
  final schoolDays = <DemoRow>[];
  final schoolDayChanges = <DemoRow>[];
  final teacherAttendance = <DemoRow>[];
  final studentAttendance = <DemoRow>[];
  final staffAttendance = <DemoRow>[];
  final examPapers = <DemoRow>[];
  final examQuestions = <DemoRow>[];
  final examMarks = <DemoRow>[];
  final feeAccounts = <DemoRow>[];
  final feePayments = <DemoRow>[];
  final feeStructure = <DemoRow>[];
  final accessoryItems = <DemoRow>[];
  final accessoryIssues = <DemoRow>[];
  final bellSlots = <DemoRow>[];
  final timetableEntries = <DemoRow>[];
  final assemblyDuty = <DemoRow>[];
  final schoolTimings = <DemoRow>[];
  final staffBills = <DemoRow>[];
  final staffSettlements = <DemoRow>[];
  final daySettings = <String, String>{};
  final notices = <DemoRow>[];
  final masterQuestions = <DemoRow>[];
  final questionUnits = <DemoRow>[];
  final teacherSubjects = <DemoRow>[];
  final dayKeys = <String>[];

  /// Open school days, oldest first.
  final _openDays = <DateTime>[];

  /// Student ids and teacher ids, in creation order.
  final _studentIds = <List<String>>[];
  final _teacherIds = <String>[];

  int _ms(DateTime d) => d.millisecondsSinceEpoch;
  DateTime _at(DateTime d, int h, int m) =>
      DateTime(d.year, d.month, d.day, h, m);
  DateTime _daysAgo(int n) => today.subtract(Duration(days: n));
  T _pick<T>(List<T> l) => l[_r.nextInt(l.length)];

  String _phone() =>
      '${[6, 7, 8, 9][_r.nextInt(4)]}${100000000 + _r.nextInt(900000000)}';

  String _aadhaar() => 'XXXX XXXX ${1000 + _r.nextInt(9000)}';

  String _address() =>
      '${1 + _r.nextInt(240)}, ${_pick(_areas)}, Lucknow, Uttar Pradesh';

  void build() {
    _calendar();
    _classesAndTeachers();
    _studentsAndStaff();
    _teaching();
    _attendance();
    _exams();
    _fees();
    _accessories();
    _schoolDay();
    _bills();
    _noticeBoard();
    _questionBank();
    _teacherBanks();
  }

  // --- calendar ------------------------------------------------------------

  bool _isHoliday(DateTime d, _Holiday h) {
    final from = DateTime(d.year, h.from.$1, h.from.$2);
    final to = DateTime(d.year, h.to.$1, h.to.$2);
    return !d.isBefore(from) && !d.isAfter(to);
  }

  void _calendar() {
    final rainDay = DateTime(yearStart.year, 7, 15);
    for (
      var d = yearStart;
      d.isBefore(today);
      d = DateTime(d.year, d.month, d.day + 1)
    ) {
      if (d.weekday == DateTime.sunday) continue;
      final holiday = _holidays.where((h) => _isHoliday(d, h)).firstOrNull;
      final rain = d == rainDay;
      final open = holiday == null && !rain;
      final at = _at(d, 9, 0);
      final reason =
          holiday?.reason ?? (rain ? 'Heavy rain, school closed' : null);
      final key = dayKey(d);
      dayKeys.add(key);
      schoolDays.add({
        'day': key,
        'status': open ? 'approved' : 'rejected',
        'decided_by': principalId,
        'decided_at': _ms(at),
        'reason': reason,
        'kind': holiday != null ? 'holiday' : null,
      });
      schoolDayChanges.add({
        'day': key,
        'old_status': 'pending',
        'new_status': open ? 'approved' : 'rejected',
        'reason': reason,
        'changed_by': principalId,
        'changed_at': _ms(at),
      });
      if (open) _openDays.add(d);
    }
  }

  // --- classes, teachers ---------------------------------------------------

  void _classesAndTeachers() {
    for (var i = 0; i < _teachers.length; i++) {
      final t = _teachers[i];
      final id = '${demoIdPrefix}teacher-${(i + 1).toString().padLeft(2, '0')}';
      _teacherIds.add(id);
      final handle = t.name.toLowerCase().replaceAll(' ', '.');
      users.add({
        'id': id,
        'name': t.name,
        'email': '$handle@demo.shikshasetu.test',
        'role': 'teacher',
        'phone': _phone(),
        'employee_id': 'T-${(i + 1).toString().padLeft(3, '0')}',
        'joined_on': _ms(DateTime(2019 + i % 6, 6, 1 + i)),
        'subject': t.subject,
        'aadhaar_masked': _aadhaar(),
        'aadhaar_reason': null,
        'dob': _ms(DateTime(1976 + i * 2 % 17, 1 + i % 12, 3 + i)),
        'gender': t.gender,
        'address': _address(),
        'password_hash': '',
        'password_salt': '',
        'active': 1,
      });
    }
    for (var c = 0; c < _classNames.length; c++) {
      classes.add({
        'name': _classNames[c],
        'class_teacher_id': _teacherIds[_classTeacher[c]],
      });
    }
  }

  // --- students, other staff -----------------------------------------------

  void _studentsAndStaff() {
    for (var c = 0; c < _classNames.length; c++) {
      final ids = <String>[];
      final age = 3 + c;
      for (var n = 1; n <= _classSizes[c]; n++) {
        final id =
            '${demoIdPrefix}stu-${c.toString().padLeft(2, '0')}-'
            '${n.toString().padLeft(2, '0')}';
        ids.add(id);
        final boy = _r.nextBool();
        final surname = _pick(_surnames);
        final noAadhaar = c <= 2 || _r.nextInt(10) == 0;
        students.add({
          'id': id,
          'name': '${_pick(boy ? _boys : _girls)} $surname',
          'roll_no': n,
          'class_name': _classNames[c],
          'guardian': '${_pick(_boys)} $surname',
          'phone': _phone(),
          'aadhaar_masked': noAadhaar ? null : _aadhaar(),
          'aadhaar_reason': noAadhaar ? 'Aadhaar not made yet' : null,
          'dob': _ms(
            DateTime(
              yearStart.year - age - 1,
              4,
              1,
            ).add(Duration(days: _r.nextInt(365))),
          ),
          'gender': boy ? 'male' : 'female',
          'address': _address(),
          'registered_on': _ms(yearStart.add(Duration(days: _r.nextInt(12)))),
          'vehicle_number': _r.nextInt(4) == 0 ? _van : null,
        });
      }
      _studentIds.add(ids);
    }
    for (var i = 0; i < _otherStaff.length; i++) {
      final (name, title, gender) = _otherStaff[i];
      otherStaff.add({
        'id': '${demoIdPrefix}staff-${(i + 1).toString().padLeft(2, '0')}',
        'name': name,
        'role_title': title,
        'phone': _phone(),
        'aadhaar_masked': _aadhaar(),
        'aadhaar_reason': null,
        'dob': _ms(DateTime(1970 + i * 3, 2 + i, 5 + i)),
        'gender': gender,
        'address': _address(),
        'registered_on': _ms(DateTime(2021 + i % 4, 7, 1)),
        'active': 1,
        'vehicle_number': title == 'Bus Driver' ? 'UP32 AB ${1234 + i}' : null,
      });
    }
  }

  // --- who teaches what ----------------------------------------------------

  void _teaching() {
    var n = 0;
    String id() => '${demoIdPrefix}ts-${(++n).toString().padLeft(3, '0')}';
    final approvedAt = _ms(yearStart.add(const Duration(days: 3)));
    for (var c = 0; c < _classNames.length; c++) {
      for (final subject in _subjectsOf(c)) {
        teacherSubjects.add({
          'id': id(),
          'teacher_id': _teacherIds[_ownerOf(subject, c)],
          'class_name': _classNames[c],
          'subject': subject,
          'status': 'approved',
          'requested_by': 'principal',
          'requested_at': approvedAt,
          'decided_at': approvedAt,
        });
      }
    }
    void request(int teacher, int c, String subject, String status, int ago) {
      final at = _ms(_at(_daysAgo(ago), 11, 30));
      teacherSubjects.add({
        'id': id(),
        'teacher_id': _teacherIds[teacher],
        'class_name': _classNames[c],
        'subject': subject,
        'status': status,
        'requested_by': 'teacher',
        'requested_at': at,
        'decided_at': status == 'pending' ? null : at + 3600000,
      });
    }

    request(6, 7, 'English', 'pending', 1);
    request(2, 4, 'Computer', 'pending', 2);
    request(11, 8, 'Science', 'pending', 3);
    request(4, 6, 'Maths', 'rejected', 9);
  }

  // --- attendance ----------------------------------------------------------

  void _attendance() {
    final recent = _openDays.length > 60
        ? _openDays.sublist(_openDays.length - 60)
        : _openDays;

    // How often each student is away: most are regular, a few are not.
    for (final ids in _studentIds) {
      for (final sid in ids) {
        final away = 0.02 + _r.nextDouble() * 0.10;
        for (final d in recent) {
          final x = _r.nextDouble();
          studentAttendance.add({
            'student_id': sid,
            'day': dayKey(d),
            'status': x < away
                ? 'absent'
                : (x < away + 0.03 ? 'late' : 'present'),
          });
        }
      }
    }

    for (var i = 0; i < _otherStaff.length; i++) {
      final id = '${demoIdPrefix}staff-${(i + 1).toString().padLeft(2, '0')}';
      for (final d in recent) {
        final x = _r.nextDouble();
        staffAttendance.add({
          'staff_id': id,
          'day': dayKey(d),
          'status': x < 0.06 ? 'absent' : (x < 0.1 ? 'late' : 'present'),
        });
      }
    }

    for (final tid in _teacherIds) {
      for (final d in recent) {
        if (_r.nextDouble() < 0.06) continue; // on leave
        final inDistance = 5 + _r.nextInt(110).toDouble();
        final outDistance = 5 + _r.nextInt(110).toDouble();
        final inAt = _at(d, 7, 35 + _r.nextInt(50));
        final outAt = _at(d, 14, _r.nextInt(50));
        teacherAttendance.add({
          'teacher_id': tid,
          'day': dayKey(d),
          'check_in': _ms(inAt),
          'check_out': _ms(outAt),
          'in_lat': lat + inDistance / 111000,
          'in_lon': lon,
          'in_distance': inDistance,
          'in_selfie': null,
          'in_face_score': 0.82 + _r.nextDouble() * 0.15,
          'out_lat': lat + outDistance / 111000,
          'out_lon': lon,
          'out_distance': outDistance,
          'out_selfie': null,
          'out_face_score': 0.82 + _r.nextDouble() * 0.15,
        });
      }
    }
  }

  // --- exams ---------------------------------------------------------------

  static const _thirdPaperStatus = [
    'approved',
    'submitted',
    'draft',
    'changesRequested',
    'approved',
    'submitted',
    'approved',
    'changesRequested',
    'submitted',
    'approved',
    'draft',
  ];

  void _exams() {
    for (var c = 0; c < _classNames.length; c++) {
      final duration = c >= 8 ? 60 : 45;
      final third = c <= 2 ? 'Hindi' : (c <= 7 ? 'EVS' : 'Science');
      final papers = <(String, String, DateTime, String, String)>[
        (
          'Unit Test 1',
          'Maths',
          _at(yearStart.add(const Duration(days: 105)), 9, 0),
          'conducted',
          'unitTest',
        ),
        (
          'Half Yearly Exam',
          'English',
          _at(_daysAgo(12), 9, 0),
          'conducted',
          'halfYearly',
        ),
        (
          'Monthly Test',
          third,
          _at(today.add(Duration(days: 10 + c)), 9, 0),
          _thirdPaperStatus[c],
          'midMonthly',
        ),
      ];
      for (var k = 0; k < papers.length; k++) {
        final (title, subject, date, status, kind) = papers[k];
        final id = '${demoIdPrefix}paper-${c.toString().padLeft(2, '0')}-$k';
        final submitted = status != 'draft';
        examPapers.add({
          'id': id,
          'title': '$title – ${_classNames[c]}',
          'subject': subject,
          'class_name': _classNames[c],
          'exam_date': _ms(date),
          'duration_minutes': duration,
          'status': status,
          'created_by': _teacherIds[_ownerOf(subject, c)],
          'exam_type': kind,
          'instructions':
              'Read every question carefully. Attempt all questions.',
          'review_note': status == 'changesRequested'
              ? 'Please add one more easy question and shorten the long answer.'
              : null,
          'submitted_at': submitted
              ? _ms(
                  status == 'conducted'
                      ? date.subtract(const Duration(days: 8))
                      : _at(_daysAgo(1 + c % 5), 16, 0),
                )
              : null,
        });
        final questions = _questionsFor(subject, c);
        var total = 0;
        for (var q = 0; q < questions.length; q++) {
          total += questions[q].marks;
          examQuestions.add({
            'paper_id': id,
            'position': q + 1,
            'text': questions[q].text,
            'marks': questions[q].marks,
            'type': questions[q].type,
            'details': questions[q].details,
          });
        }
        if (status != 'conducted') continue;
        for (final sid in _studentIds[c]) {
          final scored = (total * (0.35 + _r.nextDouble() * 0.62)).round();
          examMarks.add({
            'paper_id': id,
            'student_id': sid,
            'marks_obtained': scored.clamp(0, total),
          });
        }
      }
    }
  }

  // --- fees ----------------------------------------------------------------

  static const _van = 'UP32 AB 1237';

  static int _dressOf(int c) => c <= 2 ? 1800 : (c <= 7 ? 2500 : 3000);
  static int _booksOf(int c) => c <= 2 ? 1500 : (c <= 7 ? 2800 : 3500);
  static const _vanFee = 3000;

  void _fees() {
    var n = 0;
    String account() =>
        '${demoIdPrefix}fee-${(++n).toString().padLeft(4, '0')}';

    String reference() =>
        '${1000 + _r.nextInt(9000)}${1000 + _r.nextInt(9000)}'
        '${1000 + _r.nextInt(9000)}';

    void payments(String accountId, int amount, {int parts = 1}) {
      var left = amount;
      final dates = [
        for (var i = 0; i < parts; i++) _daysAgo(5 + _r.nextInt(150)),
      ]..sort();
      for (var i = 0; i < parts; i++) {
        final part = i == parts - 1
            ? left
            : (amount / parts / 500).round() * 500;
        left -= part;
        final x = _r.nextDouble();
        final mode = x < 0.4
            ? 'cash'
            : (x < 0.75 ? 'upi' : (x < 0.85 ? 'cheque' : 'bank'));
        feePayments.add({
          'account_id': accountId,
          'amount': part,
          'paid_at': _ms(_at(dates[i], 10 + _r.nextInt(5), _r.nextInt(60))),
          'mode': mode,
          'reference': mode == 'cash' ? null : reference(),
          'proof_path': null,
        });
      }
    }

    // What each class pays, for every kind of fee.
    for (var c = 0; c < _classNames.length; c++) {
      final due = today.add(const Duration(days: 24));
      final last = due.add(const Duration(days: 10));
      for (final (head, amount) in [
        ('academic', _feeOf(c)),
        ('dress', _dressOf(c)),
        ('books', _booksOf(c)),
        ('van', _vanFee),
      ]) {
        feeStructure.add({
          'class_name': _classNames[c],
          'head': head,
          'amount': amount,
          'due_date': _ms(due),
          'last_date': _ms(last),
        });
      }
    }

    final byId = {for (final r in students) r['id']! as String: r};
    for (var c = 0; c < _classNames.length; c++) {
      for (final sid in _studentIds[c]) {
        final student = byId[sid]!;
        final heads = [
          ('academic', _feeOf(c)),
          ('dress', _dressOf(c)),
          ('books', _booksOf(c)),
          if (student['vehicle_number'] != null) ('van', _vanFee),
        ];
        for (final (head, total) in heads) {
          final id = account();
          final x = _r.nextDouble();
          final overdue = _r.nextDouble() < 0.4;
          final due = overdue
              ? _daysAgo(15 + _r.nextInt(40))
              : today.add(Duration(days: 10 + _r.nextInt(60)));
          feeAccounts.add({
            'id': id,
            'group_type': 'student',
            'person_id': sid,
            'name': student['name'],
            'subtitle': _classNames[c],
            'total': total,
            'due_date': _ms(due),
            'last_date': _ms(due.add(const Duration(days: 10))),
            'head': head,
          });
          if (x < 0.4) {
            payments(
              id,
              total,
              parts: head == 'academic' ? 1 + _r.nextInt(3) : 1,
            );
          } else if (x < 0.65 && head == 'academic') {
            final part =
                (total * (0.4 + _r.nextDouble() * 0.3) / 500).round() * 500;
            payments(id, part, parts: 1 + _r.nextInt(2));
          }
        }
      }
    }

    // Teachers and other staff can owe or pay too (an advance, a deposit).
    for (final i in [0, 7, 10]) {
      final id = account();
      feeAccounts.add({
        'id': id,
        'group_type': 'teacher',
        'person_id': _teacherIds[i],
        'name': _teachers[i].name,
        'subtitle': _teachers[i].subject,
        'total': 5000,
        'due_date': _ms(today.add(const Duration(days: 20))),
        'head': 'payment',
      });
      if (i == 7) payments(id, 5000);
      if (i == 10) payments(id, 2000);
    }
    for (var i = 0; i < 2; i++) {
      final id = account();
      feeAccounts.add({
        'id': id,
        'group_type': 'other',
        'person_id':
            '${demoIdPrefix}staff-${(i + 1).toString().padLeft(2, '0')}',
        'name': _otherStaff[i].$1,
        'subtitle': _otherStaff[i].$2,
        'total': 3000,
        'due_date': _ms(_daysAgo(7)),
        'head': 'payment',
      });
      if (i == 0) payments(id, 1000);
    }
  }

  // --- timing, assembly, periods, timetable ---------------------------------

  void _schoolDay() {
    daySettings.addAll({
      'school_start_min': '${8 * 60}',
      'school_end_min': '${13 * 60 + 50}',
      'school_working_days': '1,2,3,4,5,6',
      'assembly_start_min': '${8 * 60}',
      'assembly_end_min': '${8 * 60 + 20}',
      'assembly_place': 'Ground',
      'assembly_days': '1,2,3,4,5,6',
      'assembly_order': jsonEncode([
        'Prayer',
        'Pledge',
        'Thought of the day',
        'News headlines',
        'Announcements',
        'National anthem',
      ]),
    });
    schoolTimings.add({
      'id': '${demoIdPrefix}timing-1',
      'class_names': jsonEncode(_classNames.take(3).toList()),
      'start_min': 8 * 60 + 30,
      'end_min': 12 * 60 + 30,
      'from_date': null,
    });

    // The bell: seven periods, a short break after the third, lunch after
    // the fifth.
    const plan = <(String, String, int, int)>[
      ('period', '', 8 * 60 + 20, 9 * 60),
      ('period', '', 9 * 60, 9 * 60 + 40),
      ('period', '', 9 * 60 + 40, 10 * 60 + 20),
      ('break', 'Short break', 10 * 60 + 20, 10 * 60 + 40),
      ('period', '', 10 * 60 + 40, 11 * 60 + 20),
      ('period', '', 11 * 60 + 20, 12 * 60),
      ('break', 'Lunch', 12 * 60, 12 * 60 + 30),
      ('period', '', 12 * 60 + 30, 13 * 60 + 10),
      ('period', '', 13 * 60 + 10, 13 * 60 + 50),
    ];
    final periodSlots = <String>[];
    for (var i = 0; i < plan.length; i++) {
      final id = '${demoIdPrefix}slot-${(i + 1).toString().padLeft(2, '0')}';
      final (kind, label, start, end) = plan[i];
      if (kind == 'period') periodSlots.add(id);
      bellSlots.add({
        'id': id,
        'position': i,
        'kind': kind,
        'label': label,
        'start_min': start,
        'end_min': end,
      });
    }

    // Who leads the assembly each day.
    const duty = [(7, 4), (8, 1), (9, 3), (10, 5), (6, 6), (5, 11)];
    for (var d = 0; d < duty.length; d++) {
      assemblyDuty.add({
        'weekday': d + 1,
        'class_name': _classNames[duty[d].$1],
        'teacher_id': _teacherIds[duty[d].$2],
      });
    }

    // Each class's week: its subjects taken in turn, never putting a teacher
    // in two classes at once.
    final busy = <String>{};
    for (var c = 0; c < _classNames.length; c++) {
      final subjects = _subjectsOf(c);
      for (var day = 1; day <= 6; day++) {
        for (var k = 0; k < periodSlots.length; k++) {
          for (var t = 0; t < subjects.length; t++) {
            final subject = subjects[(k + day + c + t) % subjects.length];
            final teacher = _teacherIds[_ownerOf(subject, c)];
            final key = '$teacher|$day|${periodSlots[k]}';
            if (busy.contains(key)) continue;
            busy.add(key);
            timetableEntries.add({
              'class_name': _classNames[c],
              'weekday': day,
              'slot_id': periodSlots[k],
              'subject': subject,
              'teacher_id': teacher,
            });
            break;
          }
        }
      }
    }
  }

  // --- the driver's fuel bills ---------------------------------------------

  void _bills() {
    const driver = '${demoIdPrefix}staff-04';
    // (days ago, kind, litres, amount, status, settled with)
    const plan = <(int, String, double, int, String, int?)>[
      (2, 'diesel', 40, 3200, 'pending', null),
      (9, 'diesel', 35, 2850, 'pending', null),
      (16, 'petrol', 14, 1400, 'approved', null),
      (27, 'diesel', 38, 3000, 'approved', 1),
      (41, 'diesel', 33, 2600, 'approved', 2),
      (55, 'diesel', 9, 900, 'rejected', null),
    ];
    const settlements = <(int, String, String?)>[
      (24, 'bank', 'UTR 5530 1184'),
      (38, 'cash', null),
    ];
    final sums = <int, int>{};
    for (var i = 0; i < plan.length; i++) {
      final (ago, kind, litres, amount, status, settled) = plan[i];
      if (settled != null) sums[settled] = (sums[settled] ?? 0) + amount;
      staffBills.add({
        'id': '${demoIdPrefix}bill-${i + 1}',
        'staff_id': driver,
        'kind': kind,
        'bill_date': _ms(_at(_daysAgo(ago), 17, 0)),
        'litres': litres,
        'amount': amount,
        'photo_path': null,
        'note': null,
        'status': status,
        'decided_at': status == 'pending' ? null : _ms(_daysAgo(ago - 1)),
        'settlement_id': settled == null ? null : '${demoIdPrefix}pay-$settled',
      });
    }
    for (var i = 0; i < settlements.length; i++) {
      final (ago, mode, ref) = settlements[i];
      staffSettlements.add({
        'id': '${demoIdPrefix}pay-${i + 1}',
        'voucher_no': 'PV-${(i + 1).toString().padLeft(4, '0')}',
        'staff_id': driver,
        'amount': sums[i + 1] ?? 0,
        'paid_at': _ms(_at(_daysAgo(ago), 12, 0)),
        'mode': mode,
        'reference': ref,
        'proof_path': null,
        'paid_by': principalName,
      });
    }
  }

  // --- dress and books -----------------------------------------------------

  void _accessories() {
    var item = 0;
    var dressNo = 0;
    var booksNo = 0;
    for (var c = 0; c < _classNames.length; c++) {
      final dress = c <= 2
          ? ['Shirt', 'Shorts / Skirt', 'Cap']
          : ['Shirt', 'Pant / Skirt', 'Tie', 'Belt'];
      final books = [
        for (final subject in _subjectsOf(c))
          if (subject != 'Physical Education') subject,
      ];
      void set(String kind, List<String> names) {
        for (var i = 0; i < names.length; i++) {
          accessoryItems.add({
            'id': '${demoIdPrefix}item-${(++item).toString().padLeft(4, '0')}',
            'class_name': _classNames[c],
            'kind': kind,
            'name': names[i],
            'position': i,
          });
        }
      }

      set('dress', dress);
      set('books', books);

      for (final sid in _studentIds[c]) {
        final row = students.firstWhere((r) => r['id'] == sid);
        final guardian = row['guardian'] as String;
        final size = '${22 + 2 * _r.nextInt(6)}';
        row['dress_size'] = _r.nextInt(10) == 0 ? null : size;
        final at = _at(
          yearStart.add(Duration(days: 8 + _r.nextInt(30))),
          11,
          0,
        );
        if (row['dress_size'] != null && _r.nextDouble() < 0.7) {
          accessoryIssues.add({
            'id': '${demoIdPrefix}issue-d-$sid',
            'receipt_no': 'DR-${(++dressNo).toString().padLeft(4, '0')}',
            'student_id': sid,
            'kind': 'dress',
            'items': jsonEncode(dress),
            'size': size,
            'quantity': 1,
            'received_by': guardian,
            'signature_path': null,
            'photo_path': null,
            'issued_by': principalName,
            'issued_at': _ms(at),
          });
        }
        final x = _r.nextDouble();
        if (x < 0.75) {
          final given = x < 0.5 ? books : books.take(books.length - 1).toList();
          accessoryIssues.add({
            'id': '${demoIdPrefix}issue-b-$sid',
            'receipt_no': 'BK-${(++booksNo).toString().padLeft(4, '0')}',
            'student_id': sid,
            'kind': 'books',
            'items': jsonEncode(given),
            'size': null,
            'quantity': 1,
            'received_by': guardian,
            'signature_path': null,
            'photo_path': null,
            'issued_by': principalName,
            'issued_at': _ms(at),
          });
        }
      }
    }
  }

  // --- notices -------------------------------------------------------------

  void _noticeBoard() {
    const items = [
      (
        'Half-yearly exam time table',
        'The half-yearly examinations for all classes have been completed. '
            'Results will be shared with parents next week.',
        4,
      ),
      (
        'Parent-teacher meeting',
        'A parent-teacher meeting will be held on Saturday at 10 AM. '
            'All parents are requested to attend.',
        8,
      ),
      (
        'Diwali holidays',
        'The school will remain closed for Diwali. Classes will resume after '
            'the break. Please complete the holiday homework.',
        12,
      ),
      (
        'Fee reminder',
        'Parents are requested to clear the pending fees before the due date '
            'to avoid inconvenience.',
        16,
      ),
      (
        'Annual sports day',
        'Annual sports day will be held next month. Students interested in '
            'taking part should give their names to the class teacher.',
        24,
      ),
      (
        'Uniform check',
        'All students must come in the full school uniform with a clean '
            'handkerchief from Monday.',
        31,
      ),
      (
        'Teachers\' Day celebration',
        'Thank you to everyone who took part in the Teachers\' Day '
            'programme. The photos are on the school board.',
        32,
      ),
      (
        'New session welcome',
        'Welcome to the new session. Please make sure every student has all '
            'books and stationery.',
        150,
      ),
    ];
    for (var i = 0; i < items.length; i++) {
      final (title, body, ago) = items[i];
      notices.add({
        'id': '${demoIdPrefix}notice-${(i + 1).toString().padLeft(2, '0')}',
        'title': title,
        'body': body,
        'posted_by': principalName,
        'posted_at': _ms(_at(_daysAgo(ago), 9, 15)),
      });
    }
  }

  // --- question bank -------------------------------------------------------

  void _questionBank() {
    const sets = [
      ('Maths', 'Maths:junior', 'Class 2'),
      ('Maths', 'Maths:senior', 'Class 7'),
      ('English', 'English:junior', 'Class 2'),
      ('English', 'English:senior', 'Class 7'),
      ('Hindi', 'Hindi', 'Class 4'),
      ('EVS', 'EVS', 'Class 3'),
      ('Science', 'Science', 'Class 7'),
      ('Social Science', 'Social Science', 'Class 8'),
      ('Computer', 'Computer', 'Class 6'),
    ];
    var n = 0;
    for (final (subject, key, className) in sets) {
      for (final q in _bank[key]!) {
        masterQuestions.add({
          'id': '${demoIdPrefix}mq-${(++n).toString().padLeft(3, '0')}',
          'type': q.type,
          'text': q.text,
          'marks': q.marks,
          'details': q.details,
          'subject': subject,
          'class_name': className,
          'created_by': principalId,
          'created_at': _ms(_daysAgo(20 + n % 60)),
        });
      }
    }
  }

  // --- teachers' own banks -------------------------------------------------

  /// Each teacher gets a bank for every class and subject they teach: four
  /// units, the last one still empty, filled from the sample questions.
  void _teacherBanks() {
    const unitNames = ['Unit 1', 'Unit 2', 'Unit 3', 'Unit 4'];
    // Which of the six sample questions (by position) each unit holds.
    const shares = [
      [0, 1, 2, 3, 4, 5],
      [0, 2, 3, 4],
      [0, 1, 2, 5],
      <int>[],
    ];
    var u = 0;
    var q = 0;
    for (final ts in teacherSubjects) {
      if (ts['status'] != 'approved') continue;
      final c = _classNames.indexOf(ts['class_name']! as String);
      final questions = _questionsFor(ts['subject']! as String, c);
      for (var k = 0; k < unitNames.length; k++) {
        final unitId =
            '${demoIdPrefix}unit-${(++u).toString().padLeft(4, '0')}';
        questionUnits.add({
          'id': unitId,
          'teacher_id': ts['teacher_id'],
          'class_name': ts['class_name'],
          'subject': ts['subject'],
          'name': unitNames[k],
          'position': k,
          'created_at': _ms(_daysAgo(40 - k)),
        });
        for (final i in shares[k]) {
          masterQuestions.add({
            'id': '${demoIdPrefix}bq-${(++q).toString().padLeft(5, '0')}',
            'type': questions[i].type,
            'text': questions[i].text,
            'marks': questions[i].marks,
            'details': questions[i].details,
            'subject': ts['subject'],
            'class_name': ts['class_name'],
            'created_by': ts['teacher_id'],
            'created_at': _ms(_daysAgo(30 - k)) + q,
            'unit_id': unitId,
          });
        }
      }
    }
  }
}
