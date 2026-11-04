// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shiksha Setu';

  @override
  String get roleLabelPrincipal => 'Principal';

  @override
  String get roleLabelTeacher => 'Teacher';

  @override
  String get navDashboard => 'Home';

  @override
  String get navAttendance => 'Attendance';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginWelcome => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get actionSignIn => 'Sign In';

  @override
  String get actionSignOut => 'Sign Out';

  @override
  String get errorEmailInvalid => 'Enter a valid email';

  @override
  String get errorPasswordRequired => 'Enter your password';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get loginDemoTitle => 'Demo accounts — tap to fill';

  @override
  String greetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String roleAndDate(String role, String date) {
    return '$role · $date';
  }

  @override
  String get dayOpen => 'School is open today';

  @override
  String get dayClosed => 'School is closed today';

  @override
  String get dayPending => 'Waiting for the Principal to approve';

  @override
  String get actionApprove => 'Approve';

  @override
  String get actionKeepClosed => 'Keep school closed';

  @override
  String get actionChangeDecision => 'Change decision';

  @override
  String get sectionTodayAtGlance => 'Today at a glance';

  @override
  String get sectionMyDay => 'My day';

  @override
  String get statTeachersPresent => 'Teachers present';

  @override
  String get statStudentsPresent => 'Students present';

  @override
  String get statClassesMarked => 'Classes marked';

  @override
  String get statTeachersNotIn => 'Teachers not in';

  @override
  String get statCheckedIn => 'Checked in';

  @override
  String get statNotCheckedIn => 'Not checked in';

  @override
  String get statPresent => 'Present';

  @override
  String get statNotInYet => 'Not in yet';

  @override
  String statClassAttendance(String name) {
    return 'Student attendance: Class $name';
  }

  @override
  String get valueDone => 'Done';

  @override
  String get valuePending => 'Pending';

  @override
  String valueOutOf(int value, int total) {
    return '$value/$total';
  }

  @override
  String get attendanceTitle => 'Attendance';

  @override
  String get tabTeachers => 'Teachers';

  @override
  String get tabStudents => 'Students';

  @override
  String get tabMyAttendance => 'My Attendance';

  @override
  String get sectionMyAttendanceToday => 'My attendance today';

  @override
  String get sectionClasses => 'Classes';

  @override
  String get labelCheckIn => 'Check-in';

  @override
  String get labelCheckOut => 'Check-out';

  @override
  String get labelWorked => 'Worked';

  @override
  String get actionCheckIn => 'Check In';

  @override
  String get actionCheckOut => 'Check Out';

  @override
  String get noticeCheckInLocked =>
      'You can check in after the Principal says school is open today.';

  @override
  String get noticeCheckedOut => 'You have checked out. See you tomorrow!';

  @override
  String get chipNotIn => 'Not in';

  @override
  String get chipCheckedOut => 'Checked out';

  @override
  String get chipInSchool => 'In school';

  @override
  String get chipNotMarked => 'Not marked';

  @override
  String get chipMarkNow => 'Mark now';

  @override
  String get chipDone => 'Done';

  @override
  String timeInOut(String inTime, String outTime) {
    return 'In $inTime  ·  Out $outTime';
  }

  @override
  String classTitle(String name) {
    return 'Class $name';
  }

  @override
  String get classNotMarkedYet => 'Not marked yet';

  @override
  String classPresentOfTotal(int present, int total) {
    return '$present of $total present';
  }

  @override
  String classPresentAbsent(int present, int absent) {
    return '$present present · $absent absent';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get actionMarkAllPresent => 'Mark all present';

  @override
  String get actionSaveAttendance => 'Save Attendance';

  @override
  String get messageAttendanceSaved => 'Attendance saved';

  @override
  String get statusPresent => 'Present';

  @override
  String get statusAbsent => 'Absent';

  @override
  String get statusLate => 'Late';

  @override
  String get statusPresentShort => 'P';

  @override
  String get statusAbsentShort => 'A';

  @override
  String get statusLateShort => 'L';

  @override
  String get verifyTitle => 'Verifying';

  @override
  String get verifyLocation => 'Checking school location';

  @override
  String get verifyFace => 'Verifying face';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEmployeeId => 'Employee ID';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileJoined => 'Joined';

  @override
  String get profileSubject => 'Subject';

  @override
  String get profileClassTeacherOf => 'Class teacher of';

  @override
  String get profileAdminNote =>
      'As Principal, you can approve school days and see everyone\'s attendance.';

  @override
  String get profileLanguage => 'Language';

  @override
  String get moduleExams => 'Exams';

  @override
  String get moduleAnalytics => 'Analytics';

  @override
  String get moduleFees => 'Fees';

  @override
  String get moduleRegistration => 'Add student or staff';

  @override
  String get moduleTeachers => 'Teachers';

  @override
  String get moduleNotices => 'Notices';

  @override
  String get sectionQuickAccess => 'Quick access';

  @override
  String get examsTitle => 'Exams';

  @override
  String get tabUpcoming => 'Not held yet';

  @override
  String get tabPastPapers => 'Past papers';

  @override
  String get actionCreatePaper => 'Create paper';

  @override
  String get emptyUpcoming =>
      'No upcoming or draft papers yet.\nTap \"Create paper\" to add one.';

  @override
  String get emptyPast => 'No conducted papers yet.';

  @override
  String get paperStatusDraft => 'Draft';

  @override
  String get paperStatusScheduled => 'Scheduled';

  @override
  String get paperStatusConducted => 'Exam held';

  @override
  String paperSubjectClass(String subject, String cls) {
    return '$subject · Class $cls';
  }

  @override
  String paperMarksDuration(int marks, int minutes) {
    return '$marks marks · $minutes min';
  }

  @override
  String get sectionQuestions => 'Questions';

  @override
  String questionNumber(int n) {
    return 'Q$n';
  }

  @override
  String marksShort(int marks) {
    return '$marks marks';
  }

  @override
  String get createPaperTitle => 'New question paper';

  @override
  String get fieldPaperTitle => 'Paper title';

  @override
  String get fieldSubject => 'Subject';

  @override
  String get fieldClass => 'Class';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldDuration => 'Duration';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get fieldQuestion => 'Question';

  @override
  String get fieldMarks => 'Marks';

  @override
  String paperTotalMarks(int marks) {
    return 'Total $marks marks';
  }

  @override
  String get actionAddQuestion => 'Add question';

  @override
  String get actionSaveDraft => 'Save draft';

  @override
  String get actionSchedule => 'Schedule';

  @override
  String get actionRemove => 'Remove';

  @override
  String get errorRequired => 'Required';

  @override
  String get messagePaperSaved => 'Paper saved';

  @override
  String get feesTitle => 'Fees';

  @override
  String get tabOthers => 'Others';

  @override
  String get feesCollected => 'Collected';

  @override
  String get feesPending => 'Pending';

  @override
  String get feesTotal => 'Total';

  @override
  String get searchByName => 'Search by name';

  @override
  String get filterAll => 'All';

  @override
  String get feeStatusPaid => 'Paid';

  @override
  String get feeStatusPartial => 'Partial';

  @override
  String get feeStatusOverdue => 'Overdue';

  @override
  String get feeStatusDue => 'Due';

  @override
  String feePaidOfTotal(String paid, String total) {
    return '$paid of $total paid';
  }

  @override
  String feeDueOn(String date) {
    return 'Due on $date';
  }

  @override
  String get fieldAmount => 'Amount';

  @override
  String get errorAmountInvalid => 'Enter a valid amount';

  @override
  String get errorAmountExceeds => 'Cannot exceed the pending amount';

  @override
  String get actionRecordPayment => 'Record payment';

  @override
  String get messagePaymentRecorded => 'Payment recorded';

  @override
  String get emptyNoResults => 'No matching records.';

  @override
  String get registrationTitle => 'Add student or staff';

  @override
  String get personStudent => 'Student';

  @override
  String get personTeacher => 'Teacher';

  @override
  String get personOther => 'Other';

  @override
  String get actionRegister => 'Register';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get fieldAadhaar => 'Aadhaar number';

  @override
  String get fieldPhone => 'Mobile number';

  @override
  String get fieldGuardian => 'Guardian name';

  @override
  String get fieldRole => 'Role (e.g. Van driver)';

  @override
  String get aadhaarHelper =>
      'We check the number but save only its last 4 digits.';

  @override
  String get fieldAadhaarReason => 'Reason for no Aadhaar number';

  @override
  String get hintAadhaarReason =>
      'e.g. Aadhaar not yet made, card lost, applied and awaited';

  @override
  String get errorAadhaarInvalid => 'Enter a valid 12-digit Aadhaar number';

  @override
  String get errorPhoneInvalid => 'Enter a 10-digit mobile number';

  @override
  String get messageRegistered => 'Registration successful';

  @override
  String registeredOnLabel(String date) {
    return 'Registered $date';
  }

  @override
  String get emptyPeople => 'No one registered yet.';

  @override
  String get staffTitle => 'Teachers';

  @override
  String get emptyStaff => 'No teachers found.';

  @override
  String get staffActive => 'Active';

  @override
  String get staffInactive => 'Inactive';

  @override
  String get staffNoClass => 'No class assigned';

  @override
  String staffClassTeacher(String cls) {
    return 'Class teacher of $cls';
  }

  @override
  String sheetAssignTitle(String name) {
    return 'Assign class to $name';
  }

  @override
  String classTakenBy(String name) {
    return 'Already assigned to $name';
  }

  @override
  String get actionRemoveAssignment => 'Remove class assignment';

  @override
  String get noticesTitle => 'Notices';

  @override
  String get actionPostNotice => 'Post notice';

  @override
  String get emptyNotices => 'No notices yet.';

  @override
  String get fieldNoticeTitle => 'Title';

  @override
  String get fieldNoticeBody => 'Message';

  @override
  String get messageNoticePosted => 'Notice posted';

  @override
  String noticePostedBy(String name, String date) {
    return 'Posted by $name · $date';
  }

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get sectionAttendanceTrend => 'Attendance — last 7 days (%)';

  @override
  String get sectionSubjectAverages => 'Average marks by subject (%)';

  @override
  String get sectionFeeCollection => 'Fee collection';

  @override
  String get sectionTeacherReport => 'Teacher report';

  @override
  String avgCheckInLabel(String time) {
    return 'Average check-in $time';
  }

  @override
  String percentValue(int percent) {
    return '$percent%';
  }

  @override
  String get dialogUnsavedTitle => 'Discard changes?';

  @override
  String get dialogUnsavedBody => 'You have unsaved attendance changes.';

  @override
  String get actionKeepEditing => 'Keep editing';

  @override
  String get actionDiscard => 'Discard';

  @override
  String get moduleClasses => 'Manage classes';

  @override
  String get classesTitle => 'Manage classes';

  @override
  String get actionAddClass => 'Add class';

  @override
  String get actionEditClass => 'Edit class';

  @override
  String get fieldClassName => 'Class name';

  @override
  String get hintClassName => 'e.g. 9-A';

  @override
  String get errorClassExists => 'This class already exists';

  @override
  String classStudentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students',
      one: '1 student',
    );
    return '$_temp0';
  }

  @override
  String get classNoTeacher => 'No class teacher';

  @override
  String dialogDeleteClassTitle(String name) {
    return 'Delete class $name?';
  }

  @override
  String dialogDeleteClassBody(int count) {
    return 'This will delete the class, its $count students and their attendance. You cannot undo this.';
  }

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get feesFilters => 'Filters';

  @override
  String get feesFilterStatus => 'Status';

  @override
  String get feesFilterClass => 'Class';

  @override
  String get feesFilterDueDate => 'Due date';

  @override
  String get feesFilterSort => 'Sort by';

  @override
  String get feesSortUrgency => 'Most urgent';

  @override
  String get feesSortName => 'Name (A to Z)';

  @override
  String get feesSortPending => 'Highest pending';

  @override
  String get feesSortDue => 'Earliest due date';

  @override
  String get feesClearAll => 'Clear all';

  @override
  String get feesShowResults => 'Show results';

  @override
  String feesResultSummary(int count, String pending) {
    return '$count found · $pending pending';
  }

  @override
  String feeRollNo(int roll) {
    return 'Roll $roll';
  }

  @override
  String get dateAnyTime => 'Any date';

  @override
  String get datePickRange => 'Pick dates';

  @override
  String get dateToday => 'Today';

  @override
  String get dateThisWeek => 'This week';

  @override
  String get dateThisMonth => 'This month';

  @override
  String get paymentsFilterDate => 'Paid on';

  @override
  String paymentsSummary(int count, String amount) {
    return '$count payments · $amount';
  }

  @override
  String get paymentsNone => 'No payments match these filters.';

  @override
  String paymentsOf(String name) {
    return 'Payments: $name';
  }

  @override
  String get staffAddTeacher => 'Add teacher';

  @override
  String get staffActionAssignClass => 'Assign class';

  @override
  String get qtMcq => 'Multiple choice';

  @override
  String get qtTrueFalse => 'True / False';

  @override
  String get qtFillBlank => 'Fill in the blank';

  @override
  String get qtMatch => 'Match the following';

  @override
  String get qtShort => 'Short answer';

  @override
  String get qtLong => 'Long answer';

  @override
  String get qtMcqHint => 'A question with several options';

  @override
  String get qtTrueFalseHint => 'A statement to mark true or false';

  @override
  String get qtFillBlankHint => 'A sentence with a blank to fill';

  @override
  String get qtMatchHint => 'Join the items of two columns';

  @override
  String get qtShortHint => 'Answered in a line or two';

  @override
  String get qtLongHint => 'Answered in detail';

  @override
  String get paperChooseType => 'Choose question type';

  @override
  String get paperInstructions => 'General instructions';

  @override
  String get paperInstructionsHint => 'e.g. All questions are compulsory.';

  @override
  String get paperAddQuestion => 'Add question';

  @override
  String get paperScan => 'Scan photo';

  @override
  String get paperPaste => 'Paste text';

  @override
  String get paperFromMaster => 'Question bank';

  @override
  String get paperSetMarksAll => 'Set marks for all';

  @override
  String get paperMarksForAll => 'Marks for every question';

  @override
  String get paperApply => 'Apply';

  @override
  String get paperShuffle => 'Shuffle';

  @override
  String get paperShuffleQuestions => 'Shuffle questions';

  @override
  String get paperShuffleOptions => 'Shuffle questions and MCQ options';

  @override
  String get paperShuffleNote =>
      'Questions are mixed only within their own type. For example, MCQs stay with MCQs.';

  @override
  String get paperDuplicate => 'Duplicate';

  @override
  String get paperSaveToMaster => 'Save to question bank';

  @override
  String get paperSavedToMaster => 'Saved to the question bank';

  @override
  String get paperCheckChip => 'Check';

  @override
  String paperFoundN(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions added. Please check them.',
      one: '1 question added. Please check it.',
    );
    return '$_temp0';
  }

  @override
  String get paperPasteTitle => 'Paste questions';

  @override
  String get paperPasteHint =>
      'Paste or type your questions here. Number each question. Write options as (a) (b) (c).';

  @override
  String get paperPasteAction => 'Add questions';

  @override
  String get paperDragHint => 'Hold and drag to reorder';

  @override
  String optionLabel(String letter) {
    return 'Option $letter';
  }

  @override
  String get qAddOption => 'Add option';

  @override
  String get qCorrectAnswer => 'Correct answer';

  @override
  String get qTrue => 'True';

  @override
  String get qFalse => 'False';

  @override
  String get qBlankHint => 'Type ____ where the blank goes.';

  @override
  String get qBlankAnswer => 'Answer (for the answer key)';

  @override
  String get qColumnA => 'Column A';

  @override
  String get qColumnB => 'Column B';

  @override
  String get qAddPair => 'Add pair';

  @override
  String get qCheckMatches => 'Check that each pair is matched correctly.';

  @override
  String get qNeedBlank => 'Add ____ where the blank goes';

  @override
  String get qNeedOptions => 'Add at least two options';

  @override
  String get qNeedPairs => 'Add at least two complete pairs';

  @override
  String get actionSendForApproval => 'Send for approval';

  @override
  String get actionApproveSave => 'Approve and save';

  @override
  String get paperStatusSubmitted => 'Awaiting approval';

  @override
  String get paperStatusChanges => 'Changes requested';

  @override
  String get paperStatusApproved => 'Approved';

  @override
  String get paperTabToApprove => 'To approve';

  @override
  String get paperTabReady => 'Ready';

  @override
  String get paperTabDrafts => 'Drafts';

  @override
  String paperSetBy(String name) {
    return 'Set by $name';
  }

  @override
  String get paperAwaitingTitle => 'Waiting for your approval';

  @override
  String get paperAwaitingBody =>
      'Read the questions. You can change, delete or shuffle them, then approve.';

  @override
  String get paperYourStatusSubmitted =>
      'Sent to the Principal. It will show here once approved.';

  @override
  String get paperSentBackTitle => 'Sent back for changes';

  @override
  String get actionSendBack => 'Send back';

  @override
  String get actionEditPaper => 'Edit paper';

  @override
  String get actionDeletePaper => 'Delete paper';

  @override
  String get sendBackTitle => 'Send back for changes';

  @override
  String get sendBackHint => 'What should be changed?';

  @override
  String get paperDeleteTitle => 'Delete this paper?';

  @override
  String get paperDeleteBody => 'The paper and its questions will be removed.';

  @override
  String get messagePaperSubmitted => 'Sent to the Principal for approval';

  @override
  String get messagePaperApproved => 'Paper approved';

  @override
  String get messagePaperSentBack => 'Sent back to the teacher';

  @override
  String get messagePaperShuffled => 'Questions shuffled';

  @override
  String get paperPreviewPrint => 'Preview and print';

  @override
  String get masterTitle => 'Question bank';

  @override
  String get masterEmpty =>
      'Your question bank is empty. Save questions here to use them again in any paper.';

  @override
  String get masterAdd => 'Add question';

  @override
  String get masterEdit => 'Edit question';

  @override
  String get masterSubjectOptional => 'Subject (optional)';

  @override
  String get masterSaved => 'Saved to the question bank';

  @override
  String get masterRemoved => 'Removed from the question bank';

  @override
  String get masterPickTitle => 'Pick from question bank';

  @override
  String masterAddSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count questions',
      one: 'Add 1 question',
      zero: 'Select questions',
    );
    return '$_temp0';
  }

  @override
  String get masterNoMatch => 'Nothing in the question bank matches.';

  @override
  String get masterRemoveTitle => 'Remove from the question bank?';

  @override
  String get emptyPapersHere => 'No papers here.';

  @override
  String get categoryExamPaper => 'Exams';

  @override
  String get approvalExamQuestion =>
      'A question paper is waiting for your review.';

  @override
  String get actionReviewPaper => 'Review paper';

  @override
  String get logoTitle => 'School logo';

  @override
  String get logoHelp =>
      'The logo is printed at the top of every question paper.';

  @override
  String get logoChoose => 'Choose from gallery';

  @override
  String get logoChange => 'Change logo';

  @override
  String get logoRemove => 'Remove logo';

  @override
  String get logoNone => 'No logo yet';

  @override
  String get printSecMcq => 'Choose the correct answer';

  @override
  String get printSecTrueFalse => 'State true or false';

  @override
  String get printSecFill => 'Fill in the blanks';

  @override
  String get printSecMatch => 'Match the following';

  @override
  String get printSecShort => 'Short answer questions';

  @override
  String get printSecLong => 'Long answer questions';

  @override
  String printMarks(int marks) {
    String _temp0 = intl.Intl.pluralLogic(
      marks,
      locale: localeName,
      other: '[$marks marks]',
      one: '[1 mark]',
    );
    return '$_temp0';
  }

  @override
  String printSection(String letter) {
    return 'Section $letter';
  }

  @override
  String get printTimeAllowed => 'Time allowed';

  @override
  String get printMaxMarks => 'Maximum marks';

  @override
  String get printName => 'Name';

  @override
  String get printRollNo => 'Roll no.';

  @override
  String get printAnswerKey => 'Answer key';

  @override
  String get printEndOfPaper => '— End of paper —';

  @override
  String get printModeInk => 'Ink / laser (A4)';

  @override
  String get printModeThermal => 'Small Bluetooth printer';

  @override
  String get printIncludeKey => 'Include answer key';

  @override
  String get printCopies => 'Copies';

  @override
  String get printRoll => 'Paper roll';

  @override
  String get printMm58 => '58 mm';

  @override
  String get printMm80 => '80 mm';

  @override
  String get printPrinters => 'Paired printers';

  @override
  String get printRefresh => 'Refresh';

  @override
  String get printNoPrinters =>
      'No printer found. Pair your Bluetooth printer in the phone\'s Bluetooth settings, then tap Refresh.';

  @override
  String get printBluetoothOff => 'Turn Bluetooth on to find printers.';

  @override
  String get printNeedPermission =>
      'Allow Bluetooth access for this app in the phone\'s settings.';

  @override
  String get printUnsupported => 'Thermal printing needs an Android or iPhone.';

  @override
  String get printTipInk =>
      'Best for full papers: an A4 printer (inkjet or laser) on Wi-Fi. You choose the printer on the next screen.';

  @override
  String get printTipThermal =>
      'Good for answer keys and small slips: a 58 mm or 80 mm Bluetooth printer. A full paper uses a lot of roll.';

  @override
  String get printAction => 'Print';

  @override
  String get printShare => 'Share PDF';

  @override
  String get printSent => 'Sent to the printer';

  @override
  String get printCancelled => 'Printing was cancelled';

  @override
  String get printPickPrinter => 'Choose a printer first';

  @override
  String get printConnectFailed =>
      'Could not connect. Check that the printer is on and in range.';

  @override
  String get printWriteFailed => 'The printer stopped responding.';

  @override
  String get printFailed => 'Could not print.';

  @override
  String get printBuilding => 'Preparing the paper…';

  @override
  String get printOnlyApproved =>
      'Printing is available once the paper is approved.';

  @override
  String get cloudTitle => 'Cloud sync';

  @override
  String get cloudIntro =>
      'Your data is saved on this phone and works without internet. When internet is on, it is also backed up online.';

  @override
  String get cloudNotConfigured =>
      'Online backup is not set up in this app yet. Please contact support.';

  @override
  String cloudConnectedAs(String email) {
    return 'Connected as $email';
  }

  @override
  String get cloudProject => 'Cloud ID';

  @override
  String get cloudSchoolId => 'School id in the cloud';

  @override
  String get cloudSyncNow => 'Sync now';

  @override
  String get cloudSyncing => 'Syncing…';

  @override
  String cloudLastSync(String when) {
    return 'Last sync: $when';
  }

  @override
  String get cloudNeverSynced => 'Not synced yet';

  @override
  String get cloudUpToDate => 'Everything is already in the cloud.';

  @override
  String cloudSentSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records sent',
      one: '1 record sent',
    );
    return '$_temp0';
  }

  @override
  String cloudRemovedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records removed',
      one: '1 record removed',
    );
    return '$_temp0';
  }

  @override
  String get cloudWhatIsSent => 'What is sent';

  @override
  String get cloudWhatIsSentBody =>
      'Students, teachers, staff, classes, attendance, exams, fees, notices and settings are backed up. Passwords, photos and selfies are never sent.';

  @override
  String get cloudSyncedNotice => 'Synced to the cloud';

  @override
  String get cloudNeedSignIn =>
      'Please sign in first. The Principal\'s login is used for online backup.';

  @override
  String get cloudNotOwner =>
      'This school\'s online data belongs to another login.';

  @override
  String get cloudOffline =>
      'Cannot connect. Check your internet. Your data is safe on this phone.';

  @override
  String get cloudFailed => 'Sync did not finish. It will try again.';

  @override
  String get faceNudgeStarting => 'Opening the camera…';

  @override
  String get faceNudgeShowFace => 'Show your face to the camera';

  @override
  String get faceNudgeOnlyOne => 'Only one face, please';

  @override
  String get faceNudgeCloser => 'Move a little closer';

  @override
  String get faceNudgeBack => 'Move back a little';

  @override
  String get faceNudgeCenter => 'Keep your face inside the circle';

  @override
  String get faceNudgeStraight => 'Look straight at the camera';

  @override
  String get faceNudgeOpenEyes => 'Open your eyes';

  @override
  String get faceNudgeHold => 'Hold still…';

  @override
  String get faceNudgeBlink => 'Now blink once';

  @override
  String get faceNudgeCapturing => 'Got it';

  @override
  String get faceCaptureEnrollTitle => 'Set up Face ID';

  @override
  String get faceCaptureVerifyTitle => 'Check it\'s you';

  @override
  String faceCaptureStep(int current, int total) {
    return 'Photo $current of $total';
  }

  @override
  String get faceFlipCamera => 'Switch camera';

  @override
  String get faceCameraDenied =>
      'Allow camera access in the phone\'s settings to use Face ID.';

  @override
  String get faceCameraMissing =>
      'No front camera could be opened on this phone.';

  @override
  String get faceTitle => 'Face ID';

  @override
  String get faceIntro =>
      'Check-in uses your face and the school location. Your face is saved on this phone as numbers only. No photo is kept and nothing goes online.';

  @override
  String get faceStatusOn => 'Face ID is set up';

  @override
  String get faceStatusOff => 'Face ID is not set up';

  @override
  String get faceSetUp => 'Set up Face ID';

  @override
  String get faceReplace => 'Set up again';

  @override
  String get faceRemove => 'Remove Face ID';

  @override
  String get faceSetUpDone => 'Face ID is set up';

  @override
  String get faceRemoved => 'Face ID removed';

  @override
  String faceEnrolledOn(String date) {
    return 'Set up on $date';
  }

  @override
  String get faceErrNotFound =>
      'No clear face was found. Try again in good light, facing the camera.';

  @override
  String get faceErrUnavailable => 'Face ID could not run on this phone.';

  @override
  String get checkErrFaceMismatch =>
      'Face did not match. Try again in good light, facing the camera.';

  @override
  String get checkErrFaceNotFound =>
      'No clear face was found. Try again, facing the camera.';

  @override
  String get checkErrFaceUnavailable =>
      'Face ID could not run on this phone. Ask the Principal for help.';

  @override
  String get faceNudgeSetUpPrompt =>
      'Set up Face ID to check in with your face.';

  @override
  String faceScore(int percent) {
    return 'Face match $percent%';
  }

  @override
  String get aadhaarScan => 'Scan Aadhaar card';

  @override
  String get aadhaarScanHint =>
      'Take a clear, flat photo of the front of the card where the 12-digit number is printed. The photo is read on this phone and is not saved.';

  @override
  String get aadhaarScanFilled => 'Aadhaar number filled in from the card';

  @override
  String get aadhaarScanNotFound =>
      'No valid Aadhaar number found. Try a clearer photo of the front of the card.';

  @override
  String get aadhaarScanFailed => 'Could not read the photo. Please try again.';

  @override
  String get aadhaarScanning => 'Reading the card…';

  @override
  String get aadhaarProbTitleNoNumber => 'We couldn\'t see the number';

  @override
  String get aadhaarProbNoNumber =>
      'We could not find a 12-digit number. Hold the card flat so the number is sharp and big in the photo.';

  @override
  String get aadhaarProbTitleNoText => 'The photo is too unclear';

  @override
  String get aadhaarProbNoText =>
      'Nothing could be read. It may be blurry, dark or not a card. Retake it in good light.';

  @override
  String get aadhaarProbTitleMasked => 'This card hides the number';

  @override
  String get aadhaarProbMasked =>
      'Only the last four digits are shown (XXXX XXXX 1234). Use a card that shows all 12 digits.';

  @override
  String get aadhaarProbTitleVid => 'This is a Virtual ID';

  @override
  String get aadhaarProbVid =>
      'This is the 16-digit Virtual ID. Scan the 12-digit Aadhaar number on the card.';

  @override
  String get aadhaarProbTitleChecksum => 'One digit may be misread';

  @override
  String aadhaarProbChecksum(String number) {
    return 'We read $number, but it looks wrong. Take a clearer photo or fix it by hand.';
  }

  @override
  String get aadhaarProbTitleError => 'Could not read the photo';

  @override
  String get aadhaarProbError =>
      'Something went wrong while reading the photo. Please try again.';

  @override
  String get aadhaarTipsTitle => 'For a good photo';

  @override
  String get aadhaarTipLight => 'Good light, no glare or shadow';

  @override
  String get aadhaarTipFlat => 'Card flat, all four corners in view';

  @override
  String get aadhaarTipFront => 'The side with the 12-digit number';

  @override
  String get aadhaarRetake => 'Take another photo';

  @override
  String get aadhaarEditByHand => 'Correct it by hand';

  @override
  String get aadhaarTypeInstead => 'Type it instead';

  @override
  String get fieldDob => 'Date of birth';

  @override
  String bornOnLabel(String date) {
    return 'Born $date';
  }

  @override
  String aadhaarFilledFromCard(String items) {
    return 'Filled in from the card: $items';
  }

  @override
  String get aadhaarItemNumber => 'Aadhaar number';

  @override
  String get aadhaarItemName => 'name';

  @override
  String get aadhaarItemDob => 'date of birth';

  @override
  String get fieldGender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get fieldAddress => 'Address';

  @override
  String get aadhaarItemGender => 'gender';

  @override
  String get aadhaarItemAddress => 'address';

  @override
  String get aadhaarScanIntro =>
      'Take photos of both sides of the card. The front has the name, date of birth and number. The back has the address. Photos are read on this phone and not saved.';

  @override
  String get aadhaarSideFront => 'Front side';

  @override
  String get aadhaarSideFrontHint =>
      'Name, gender, date of birth and Aadhaar number';

  @override
  String get aadhaarSideBack => 'Back side';

  @override
  String get aadhaarSideBackHint => 'Address';

  @override
  String get aadhaarRetakeSide => 'Retake';

  @override
  String get aadhaarAddBack => 'Add the back side too, to get the address.';

  @override
  String get aadhaarRead => 'Read the card';

  @override
  String get aadhaarReading => 'Reading the card…';

  @override
  String get aadhaarFound => 'What we found';

  @override
  String get aadhaarNotFound => 'Not found';

  @override
  String get aadhaarUse => 'Fill the form';

  @override
  String get aadhaarRetakeBoth => 'Take the photos again';

  @override
  String get aadhaarBackNoAddress =>
      'No address was found on the back photo. You can type it in.';

  @override
  String get aadhaarMismatchTitle => 'The two photos are of different numbers';

  @override
  String aadhaarMismatchBody(String front, String back) {
    return 'The front shows $front but the back shows $back. They may be two different cards, so the address from the back was not used. Take the back photo of the same card again.';
  }

  @override
  String get aadhaarMismatchAddress =>
      'Not used: the back photo shows a different Aadhaar number.';

  @override
  String get registrationListAll => 'Everyone registered';

  @override
  String get drawerSectionProfiles => 'Profiles';

  @override
  String get profileStudents => 'Student profiles';

  @override
  String get profileTeachers => 'Teacher profiles';

  @override
  String get profileClassTeachers => 'Class teachers';

  @override
  String get profileNoOne => 'No one matches these filters.';

  @override
  String get profileOverview => 'Overview';

  @override
  String get profileAttendance => 'Attendance';

  @override
  String get profileFees => 'Fees';

  @override
  String get profileResults => 'Results';

  @override
  String get profilePapers => 'Papers set';

  @override
  String get profileDetails => 'Details';

  @override
  String profileJoinedOn(String date) {
    return 'Joined $date';
  }

  @override
  String get profileClassLabel => 'Class and roll no.';

  @override
  String profileClassTeacherOfClass(String cls) {
    return 'Class teacher of $cls';
  }

  @override
  String get profileDates => 'Dates';

  @override
  String profileAttended(int percent) {
    return 'Attended $percent%';
  }

  @override
  String profileDaysRecorded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days recorded',
      one: '1 day recorded',
    );
    return '$_temp0';
  }

  @override
  String profileDaysPresent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days present',
      one: '1 day present',
    );
    return '$_temp0';
  }

  @override
  String get profileNoAttendance => 'No attendance recorded for these filters.';

  @override
  String get profileNoResults => 'No exam marks recorded yet.';

  @override
  String get profileNoFees => 'No fees on record.';

  @override
  String get profileNoPapers => 'No papers set yet.';

  @override
  String get profileNoPayments => 'No payments yet.';

  @override
  String profileMarksOf(int obtained, int total) {
    return '$obtained / $total';
  }

  @override
  String profileTotalPaid(String amount) {
    return 'Paid in all: $amount';
  }

  @override
  String get profilePaymentHistory => 'Full payment history';

  @override
  String get profileNotFound => 'This person could not be found.';

  @override
  String get profileStillIn => 'Still checked in';

  @override
  String get dobErrFuture => 'Date of birth cannot be in the future.';

  @override
  String dobErrYoung(int years) {
    return 'Too young: the minimum age is $years years.';
  }

  @override
  String dobErrOld(int years) {
    return 'Too old: the maximum age is $years years.';
  }

  @override
  String get calendarTitle => 'School calendar';

  @override
  String get calendarToday => 'Today';

  @override
  String get calendarOpen => 'School was open';

  @override
  String get calendarClosed => 'School closed';

  @override
  String get calendarNoRecord => 'No record';

  @override
  String get calendarWeeklyOff => 'Weekly off';

  @override
  String get calendarThisMonth => 'This month';

  @override
  String calendarYear(String date) {
    return 'Academic year since $date';
  }

  @override
  String get calendarDaysOpen => 'Days school was open';

  @override
  String get calendarDaysClosed => 'Days closed';

  @override
  String get calendarDaysNoRecord => 'Days with no record';

  @override
  String get calendarNoRecordNote =>
      'Sundays are the weekly off and are not counted.';

  @override
  String get calendarTapHint => 'Tap a day to see its details.';

  @override
  String get calendarTapHintPrincipal =>
      'Tap a day to see details or change it. You must give a reason for every change.';

  @override
  String get calendarMarkOpen => 'Mark school open';

  @override
  String get calendarMarkClosed => 'Mark school closed';

  @override
  String get calendarClearDay => 'Clear this day';

  @override
  String get calendarReasonTitle => 'Why are you changing this day?';

  @override
  String get calendarReasonHint => 'e.g. Heavy rain, Diwali holiday, Exam day';

  @override
  String get calendarReasonRequired =>
      'Please give a reason (at least 3 letters).';

  @override
  String get calendarSave => 'Save change';

  @override
  String calendarReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get calendarNoReason => 'No reason recorded';

  @override
  String calendarMarkedBy(String name, String when) {
    return 'Marked by $name, $when';
  }

  @override
  String get calendarHistory => 'History';

  @override
  String get calendarNoHistory => 'No changes recorded for this day.';

  @override
  String get calendarSaved => 'Calendar updated';

  @override
  String get calendarNotAllowed =>
      'Only the Principal can change the calendar.';

  @override
  String get calendarFailed => 'Could not save the change.';

  @override
  String get holidaysTitle => 'Holidays';

  @override
  String get holidayAdd => 'Add holiday';

  @override
  String get holidayFilterUpcoming => 'Upcoming';

  @override
  String get holidayFilterPast => 'Past';

  @override
  String get holidayFilterAll => 'All';

  @override
  String get holidayListUpcoming => 'Upcoming holidays';

  @override
  String get holidayListPast => 'Past holidays';

  @override
  String get holidayListAll => 'All holidays';

  @override
  String holidayDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String holidaySummary(int holidays, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      holidays,
      locale: localeName,
      other: '$holidays holidays',
      one: '1 holiday',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get holidayOnNow => 'On now';

  @override
  String holidayInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'Tomorrow',
    );
    return '$_temp0';
  }

  @override
  String get holidayPast => 'Past';

  @override
  String get holidayEmpty => 'No holidays added yet.';

  @override
  String get holidayEmptyPrincipal =>
      'No holidays added yet. Tap \"Add holidays\" to enter the school\'s holiday list.';

  @override
  String get holidayEmptyFilter => 'No holidays in this list.';

  @override
  String holidayEntryTitle(int number) {
    return 'Holiday $number';
  }

  @override
  String get holidayReason => 'Reason';

  @override
  String get holidayReasonHint => 'e.g. Diwali vacation, Republic Day';

  @override
  String get holidayPickDates => 'Pick the date or dates';

  @override
  String get holidayDatesHelp => 'For one day, pick the same date twice.';

  @override
  String get holidayDatesRequired => 'Pick the date or dates';

  @override
  String get holidayAnother => 'Add another holiday';

  @override
  String holidaySaveAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save $count days',
      one: 'Save 1 day',
      zero: 'Save holidays',
    );
    return '$_temp0';
  }

  @override
  String get holidayAddIntro =>
      'Add holidays with their dates and a reason, then save them together. Everyone can see them in Holidays and the calendar.';

  @override
  String holidaySaved(int added) {
    String _temp0 = intl.Intl.pluralLogic(
      added,
      locale: localeName,
      other: '$added holiday days added',
      one: '1 holiday day added',
    );
    return '$_temp0';
  }

  @override
  String holidaySavedSkipped(int added, int skipped) {
    String _temp0 = intl.Intl.pluralLogic(
      skipped,
      locale: localeName,
      other: '$skipped days skipped, school was already marked open on them',
      one: '1 day skipped, school was already marked open on it',
    );
    return '$added days added. $_temp0.';
  }

  @override
  String holidayInvalidDates(int max) {
    return 'Check the dates: each holiday needs its dates, and none can be longer than $max days.';
  }

  @override
  String get holidayRemove => 'Remove this holiday';

  @override
  String get holidayRemoved => 'Holiday removed';

  @override
  String get calendarHoliday => 'Holiday';

  @override
  String get holidaySuggestedPick => 'Pick from India\'s holidays';

  @override
  String get holidaySuggested => 'Holidays of India';

  @override
  String get holidaySuggestedNote =>
      'Festival dates change every year. Please check the dates before saving. You can edit them later.';

  @override
  String holidaySuggestedAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count holidays',
      one: 'Add 1 holiday',
    );
    return '$_temp0';
  }

  @override
  String get scrollForMore => 'Scroll to view more';

  @override
  String get moduleAttendance => 'Attendance';

  @override
  String get moduleMarkAttendance => 'Student attendance';

  @override
  String get modulePayments => 'Payment history';

  @override
  String get notClassTeacherMessage =>
      'You are not a class teacher yet, so there is no class to mark.';

  @override
  String get drawerSectionAcademics => 'Academics';

  @override
  String get drawerSectionPeople => 'People';

  @override
  String get drawerSectionMoney => 'Money';

  @override
  String get drawerSectionSchool => 'School';

  @override
  String scrollForMoreCount(int count) {
    return 'Scroll to view more · $count in all';
  }

  @override
  String get sectionApprovals => 'Approvals';

  @override
  String get sectionOverview => 'Today at a glance';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionMore => 'More options';

  @override
  String get messageClassAdded => 'Class added';

  @override
  String get messageClassUpdated => 'Class updated';

  @override
  String get messageClassDeleted => 'Class deleted';

  @override
  String get emptyClasses =>
      'No classes yet.\nTap \"Add class\" to create one.';

  @override
  String get emptyStudents =>
      'No students in this class yet.\nRegister students from the Register module.';

  @override
  String get actionScanQuestions => 'Scan from photo';

  @override
  String get scanSourceTitle => 'Scan questions';

  @override
  String get scanLanguage => 'Language of the text';

  @override
  String get scanCamera => 'Take a photo';

  @override
  String get scanGallery => 'Choose from gallery';

  @override
  String get scanProcessing => 'Reading the text…';

  @override
  String get scanNoText => 'No text found. Try a clearer, well-lit photo.';

  @override
  String get scanFailed => 'Could not read the photo. Please try again.';

  @override
  String get scanReviewTitle => 'Review scanned questions';

  @override
  String get scanReviewHint =>
      'Scanning can make mistakes. Check each question, correct the text, and untick anything that is not a question.';

  @override
  String actionAddSelected(int count) {
    return 'Add $count questions';
  }

  @override
  String get setupTitle => 'Set up your school';

  @override
  String get setupSubtitle =>
      'Create the Principal login. You can add teachers later.';

  @override
  String get fieldSchoolName => 'School name';

  @override
  String get fieldConfirmPassword => 'Confirm password';

  @override
  String get actionCreateSchool => 'Create school';

  @override
  String errorPasswordShort(int min) {
    return 'Use at least $min characters';
  }

  @override
  String get errorPasswordMismatch => 'Passwords do not match';

  @override
  String get errorInactiveAccount =>
      'This account is inactive. Please contact the Principal.';

  @override
  String get errorWrongCurrentPassword => 'Current password is incorrect';

  @override
  String get errorEmailTaken => 'This email is already in use';

  @override
  String get fieldLoginEmail => 'Login email';

  @override
  String get fieldTempPassword => 'Temporary password';

  @override
  String get helperTempPassword =>
      'Give this to the teacher. They can change it after signing in.';

  @override
  String get fieldCurrentPassword => 'Current password';

  @override
  String get fieldNewPassword => 'New password';

  @override
  String get actionEditProfile => 'Edit profile';

  @override
  String get actionChangePassword => 'Change password';

  @override
  String get actionChangeEmail => 'Change email';

  @override
  String get actionSend => 'Send';

  @override
  String get changeEmailHint =>
      'A verification link will be sent to the new email. Your email changes after you open it.';

  @override
  String get fieldNewEmail => 'New email';

  @override
  String get messageEmailChangeSent =>
      'Verification link sent. Open it to finish changing your email.';

  @override
  String get messageProfileUpdated => 'Profile updated';

  @override
  String get messagePasswordChanged => 'Password changed';

  @override
  String get checkErrSchoolClosed =>
      'The Principal has not marked today as a school day yet.';

  @override
  String get checkErrNotConfigured =>
      'The school location is not set. Ask the Principal to set it in Profile → School settings.';

  @override
  String get checkErrServicesOff => 'Turn on location (GPS) and try again.';

  @override
  String get checkErrPermissionDenied =>
      'Location permission is needed to check in.';

  @override
  String get checkErrPermissionForever =>
      'Location permission is blocked. Allow it from the phone settings.';

  @override
  String get checkErrUnavailable =>
      'Could not read your location. Try again outdoors.';

  @override
  String get checkErrMockLocation =>
      'A fake location app is on. Turn it off and try again.';

  @override
  String checkErrOutside(int meters) {
    return 'You are $meters m from the school. Move closer to check in.';
  }

  @override
  String get checkErrSelfie => 'A selfie is required to check in.';

  @override
  String get checkInHint =>
      'We check your location and take a selfie as proof.';

  @override
  String distanceFromSchool(int meters) {
    return '$meters m from school';
  }

  @override
  String teacherReportWindow(int days) {
    return 'Last $days days (school days only)';
  }

  @override
  String get emptyTrend => 'No student attendance marked in the last 7 days.';

  @override
  String get emptyMarks => 'No exam marks entered for this class yet.';

  @override
  String get noCheckInsYet => 'No check-ins in this period';

  @override
  String get schoolSettingsTitle => 'School settings';

  @override
  String get sectionSchoolLocation => 'School location';

  @override
  String get locationNotSet => 'Not set yet';

  @override
  String locationValue(String lat, String lon) {
    return 'Lat $lat, Lon $lon';
  }

  @override
  String get locationHelp =>
      'Stand at the school gate or in the middle of the campus, then tap the button.';

  @override
  String get actionUseCurrentLocation => 'Use my current location';

  @override
  String get fieldRadius => 'Allowed distance';

  @override
  String get helperRadius => 'How close a teacher must be to check in.';

  @override
  String get unitMeters => 'metres';

  @override
  String get errorRadiusInvalid => 'Enter the distance in metres';

  @override
  String get errorLocationRequired => 'Set the school location first';

  @override
  String get messageSettingsSaved => 'Settings saved';

  @override
  String get backupTitle => 'Backup & restore';

  @override
  String get backupNever => 'No backup taken yet';

  @override
  String backupLast(String when) {
    return 'Last backup: $when';
  }

  @override
  String get actionBackupShare => 'Create backup & share';

  @override
  String get actionBackupSave => 'Save backup to this phone';

  @override
  String get sectionRestore => 'Restore';

  @override
  String get actionRestoreFromFile => 'Restore from backup file';

  @override
  String get actionRestore => 'Restore';

  @override
  String get messageBackupDone => 'Backup created';

  @override
  String get messageBackupFailed => 'Could not create the backup';

  @override
  String get messageRestoreDone => 'Restored. Please sign in again.';

  @override
  String get messageRestoreFailed => 'Restore failed. Nothing was changed.';

  @override
  String get errBackupNotBackup => 'This file is not a Shiksha Setu backup.';

  @override
  String get errBackupNewer =>
      'This backup was made with a newer app. Please update the app.';

  @override
  String get errBackupCorrupt => 'This backup file is damaged.';

  @override
  String get dialogRestoreTitle => 'Replace all data?';

  @override
  String dialogRestoreBody(String date, int students, int users) {
    return 'Backup from $date: $students students, $users accounts. All data in the app will be replaced and you will be signed out.';
  }

  @override
  String get actionEnterMarks => 'Enter marks';

  @override
  String get actionMarkConducted => 'Mark as conducted';

  @override
  String marksEntryTitle(String title) {
    return 'Marks — $title';
  }

  @override
  String outOfMarks(int total) {
    return '/ $total';
  }

  @override
  String get errorMarksTooHigh => 'Above total marks';

  @override
  String get messageMarksSaved => 'Marks saved';

  @override
  String get actionAddFee => 'Add fee';

  @override
  String get sectionPayments => 'Payments';

  @override
  String get emptyPayments => 'No payments yet.';

  @override
  String get actionShareReceipt => 'Share receipt';

  @override
  String get emptyFeePeople =>
      'Everyone here already has a fee, or no one is registered yet.';

  @override
  String get fieldPerson => 'Person';

  @override
  String get fieldDueDate => 'Due date';

  @override
  String get messageFeeAdded => 'Fee added';

  @override
  String dashSchoolAndDate(String school, String date) {
    return '$school · $date';
  }

  @override
  String get sectionNeedsAttention => 'Needs your attention';

  @override
  String get allClearTitle => 'All clear';

  @override
  String get allClearBody => 'Nothing needs your attention right now.';

  @override
  String attTeachersNotIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count teachers have not checked in',
      one: '1 teacher has not checked in',
    );
    return '$_temp0';
  }

  @override
  String attClassesNotMarked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes have no attendance yet',
      one: '1 class has no attendance yet',
    );
    return '$_temp0';
  }

  @override
  String attOverdueFees(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fee accounts overdue · $amount',
      one: '1 fee account overdue · $amount',
    );
    return '$_temp0';
  }

  @override
  String get attLocationMissing =>
      'School location is not set, so teachers cannot check in.';

  @override
  String get attNoBackup => 'No backup yet. Your data is only on this phone.';

  @override
  String get actionReview => 'Review';

  @override
  String get actionViewAll => 'View all';

  @override
  String get kpiTeachersIn => 'Teachers in';

  @override
  String get kpiStudentsPresent => 'Students present';

  @override
  String get kpiFeesCollected => 'Fees collected';

  @override
  String get kpiClassesMarked => 'Classes marked';

  @override
  String get sectionClassAttendance => 'Class attendance today';

  @override
  String feesOverdueAmount(String amount) {
    return 'Overdue $amount';
  }

  @override
  String get sectionUpcomingExams => 'Upcoming exams';

  @override
  String get emptyUpcomingExams => 'No exams scheduled.';

  @override
  String get sectionLatestNotice => 'Latest notice';

  @override
  String get emptyLatestNotice => 'No notices yet.';

  @override
  String get approvalsTitle => 'Approvals';

  @override
  String get approvalsNeedsApproval => 'Needs approval';

  @override
  String get approvalsNonePending => 'No pending approvals';

  @override
  String get actionView => 'View';

  @override
  String get actionReject => 'Reject';

  @override
  String get sectionPendingApprovals => 'Pending';

  @override
  String get sectionDecidedApprovals => 'Decided';

  @override
  String get emptyApprovals => 'Nothing to approve right now.';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get themeTitle => 'Theme color';

  @override
  String get themeHelp =>
      'Choose two colors for the app: a main color and a second color. Everyone sees them.';

  @override
  String get themeCurrent => 'Current color';

  @override
  String get themeDefault => 'Black & white';

  @override
  String get themeBlue => 'Blue';

  @override
  String get themeIndigo => 'Indigo';

  @override
  String get themePurple => 'Purple';

  @override
  String get themeTeal => 'Teal';

  @override
  String get themeGreen => 'Green';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeRed => 'Red';

  @override
  String get themeBrown => 'Brown';

  @override
  String get themePreview => 'Preview';

  @override
  String get themeMainTitle => 'Main color';

  @override
  String get themeAccentTitle => 'Accent color';

  @override
  String get themeAccentAuto => 'Same as main';

  @override
  String get themeCustom => 'Custom';

  @override
  String get themePickerTitle => 'Pick any color';

  @override
  String get themeHue => 'Shade';

  @override
  String get themeSaturation => 'Strength';

  @override
  String get themeBrightness => 'Brightness';

  @override
  String get themeApply => 'Use this color';

  @override
  String get addressLoading => 'Finding address…';

  @override
  String get addressUnavailable => 'Address not available (needs internet)';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeSubtitle => 'Who are you?';

  @override
  String get welcomePrincipal => 'I am the Principal';

  @override
  String get welcomePrincipalHint => 'Create a new school on this phone';

  @override
  String get welcomeAlreadyRegistered => 'School already registered? Sign in';

  @override
  String get registeredSignInTitle => 'Sign in to your school';

  @override
  String get registeredSignInSubtitle =>
      'Use the email and password you registered with (Principal), or the ones your Principal gave you (Teacher). Your school data will be loaded.';

  @override
  String get registeredSignInBusy =>
      'Restoring your school data. This can take a minute…';

  @override
  String get errorSchoolNotFound =>
      'This account is not linked to a school. Please contact your administrator.';

  @override
  String get actionBack => 'Back';

  @override
  String get errorPasswordWeak =>
      'This password is too common or too simple. Use at least 8 characters with letters and numbers.';

  @override
  String get errorTooManyAttempts =>
      'Too many attempts. Please try again later.';

  @override
  String get errorAuthOffline =>
      'No internet connection. Please connect to the internet and try again.';

  @override
  String get errorProfileMissing =>
      'Your account could not be loaded on this phone. Please try again with internet on.';

  @override
  String get errorAuthUnavailable =>
      'This is not available right now. Please try again.';

  @override
  String get cloudSignedOutBanner =>
      'Online backup needs the Principal\'s login. Sign out and sign in again with internet to start.';

  @override
  String get syncNotifChannel => 'Data sync';

  @override
  String get syncNotifTitle => 'Syncing data to server';

  @override
  String syncNotifProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get cloudAutoSyncTitle => 'Automatic sync';

  @override
  String get cloudAutoSyncHelp =>
      'Backs up your changes every few minutes while the app is open, and once more when you leave the app. Needs internet.';

  @override
  String get cloudAutoSyncOff => 'Off';

  @override
  String cloudAutoSyncHours(int hours) {
    return '$hours hr';
  }

  @override
  String cloudSyncProgress(int done, int total) {
    return '$done of $total';
  }

  @override
  String cloudAutoSyncMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get syncNotifDone => 'Data saved to server';

  @override
  String syncNotifDoneAt(String time) {
    return 'Last synced at $time';
  }

  @override
  String get syncFeatureSettings => 'Settings';

  @override
  String get syncFeatureStaff => 'Staff';

  @override
  String get syncFeatureClasses => 'Classes';

  @override
  String get syncFeatureStudents => 'Students';

  @override
  String get syncFeatureCalendar => 'School calendar';

  @override
  String get syncFeatureAttendance => 'Attendance';

  @override
  String get syncFeatureExams => 'Exams';

  @override
  String get syncFeatureFees => 'Fees';

  @override
  String get syncFeatureNotices => 'Notices';

  @override
  String get syncFeatureQuestionBank => 'Question bank';

  @override
  String syncNotifChecking(String feature, int done, int total) {
    return 'Checking $feature · $done of $total';
  }

  @override
  String get syncNotifUpToDate => 'Everything was already up to date';

  @override
  String syncNotifNext(String when) {
    return 'Next sync in $when';
  }

  @override
  String syncFeaturesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count features',
      one: '1 feature',
    );
    return '$_temp0';
  }

  @override
  String get syncNotifTapHint => 'Tap for details';

  @override
  String get syncDetailsTitle => 'Sync details';

  @override
  String get syncDetailsLastSync => 'Last sync';

  @override
  String get syncDetailsLastData => 'Last data sent';

  @override
  String get syncDetailsNothingSent => 'No data has been sent yet.';

  @override
  String syncDetailsAtTime(String date, String time) {
    return '$date, $time';
  }

  @override
  String syncDetailsRemoved(int count) {
    return '$count removed';
  }

  @override
  String syncStripLast(String when) {
    return 'Last synced $when';
  }

  @override
  String syncStripNext(String when) {
    return 'Next sync $when';
  }

  @override
  String get syncStripOff => 'Automatic sync is off';

  @override
  String get syncStripSyncing => 'Syncing data to server…';

  @override
  String get approvalNotifChannel => 'Approval requests';

  @override
  String get approvalNotifOneTitle => 'New request to approve';

  @override
  String approvalNotifOneBody(String teacher, String title) {
    return '$teacher sent \"$title\" for approval';
  }

  @override
  String approvalNotifManyTitle(int count) {
    return '$count new requests to approve';
  }

  @override
  String get approvalNotifManyBody => 'Open the app to review them';

  @override
  String dashTodoWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests are waiting for you',
      one: '1 request is waiting for you',
    );
    return '$_temp0';
  }

  @override
  String get dashTodoWaitingHint => 'Teachers are waiting for your answer.';

  @override
  String get dashTodoReview => 'Review now';

  @override
  String get dashTodoNone => 'Nothing is waiting for you';

  @override
  String get dashTodoNoneHint => 'New requests from teachers will appear here.';

  @override
  String get dashTodayTitle => 'Today in school';

  @override
  String get dashTeachersHere => 'Teachers in';

  @override
  String get dashStudentsHere => 'Students in';

  @override
  String get dashClassesDone => 'Classes marked';

  @override
  String get dashFeesLeft => 'Fees due';

  @override
  String get dashQuickTitle => 'Quick access';

  @override
  String get dashMore => 'More';

  @override
  String get dashTeacherWaitTitle => 'Waiting for the Principal';

  @override
  String get dashTeacherWaitBody =>
      'The Principal has not opened school for today yet. This page updates by itself.';

  @override
  String get dashTeacherClosedTitle => 'School is closed today';

  @override
  String get dashTeacherClosedBody => 'No check-in is needed today.';

  @override
  String get dashTeacherOpenTitle => 'School is open today';

  @override
  String get dashTeacherOpenBody => 'Tap Check In when you reach school.';

  @override
  String get dashTeacherInTitle => 'You are checked in';

  @override
  String dashTeacherInBody(String time) {
    return 'Checked in at $time. Tap Check Out when you leave.';
  }

  @override
  String get dashTeacherOutTitle => 'You are done for today';

  @override
  String get dashPapersTitle => 'My question papers';

  @override
  String get dashPapersNone => 'You have not made any paper yet.';

  @override
  String dashPapersWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count waiting for the Principal',
      one: '1 waiting for the Principal',
    );
    return '$_temp0';
  }

  @override
  String dashPapersSentBack(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sent back, need your changes',
      one: '1 sent back, needs your changes',
    );
    return '$_temp0';
  }

  @override
  String dashPapersDrafts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count drafts not sent',
      one: '1 draft not sent',
    );
    return '$_temp0';
  }

  @override
  String dashPapersApproved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count approved',
      one: '1 approved',
    );
    return '$_temp0';
  }

  @override
  String get dashRefreshed => 'Updated';

  @override
  String approvalsWaitingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests waiting',
      one: '1 request waiting',
    );
    return '$_temp0';
  }

  @override
  String get approvalsPullHint => 'Pull down to check for new requests';

  @override
  String get approvalsDecidedApproved => 'Approved';

  @override
  String get approvalsDecidedRejected => 'Not approved';

  @override
  String get descAttendance => 'See who came today: teachers and students';

  @override
  String get descMarkAttendance =>
      'Mark your class\'s students present, absent or late';

  @override
  String get descExams => 'Make question papers and send them for approval';

  @override
  String get descQuestionBank =>
      'Questions you saved, to use again in any paper';

  @override
  String get descStudentProfiles =>
      'Each student\'s details, attendance, fees and marks';

  @override
  String get descTeacherProfiles =>
      'Each teacher\'s details, check-ins and papers';

  @override
  String get descClasses => 'Add classes and see their students';

  @override
  String get descRegister => 'Add a new student, teacher or staff member';

  @override
  String get descTeachers => 'Class teachers, subjects, on or off';

  @override
  String get descFees => 'See fees due and collect payments';

  @override
  String get descPayments => 'Every payment received so far';

  @override
  String get descApprovals => 'Requests waiting for your answer';

  @override
  String get descAnalytics => 'Charts and reports for the school';

  @override
  String get descCalendar => 'See which days school was open or closed';

  @override
  String get descHolidays => 'The school\'s list of holidays';

  @override
  String get descNotices => 'Messages for everyone in school';

  @override
  String get drawerMoreTitle => 'More';

  @override
  String get moduleMyAttendance => 'My attendance';

  @override
  String get descMyAttendance => 'Your own check-in and check-out';

  @override
  String get myAttendanceTitle => 'My attendance (check-in)';

  @override
  String markingTitle(String name) {
    return 'Student attendance · Class $name';
  }

  @override
  String get categoryTeachingSubject => 'Subjects';

  @override
  String approvalSubjectQuestion(String name) {
    return '$name wants to teach this subject in this class.';
  }

  @override
  String get moduleMySubjects => 'My subjects';

  @override
  String get descMySubjects =>
      'Subjects and classes you teach. Ask for a new one.';

  @override
  String subjectsTitleFor(String name) {
    return 'Subjects of $name';
  }

  @override
  String get subjectAskButton => 'Ask for a subject';

  @override
  String get subjectGiveButton => 'Give a subject';

  @override
  String get subjectSheetAskTitle => 'Ask the Principal for a subject';

  @override
  String subjectSheetGiveTitle(String name) {
    return 'Give a subject to $name';
  }

  @override
  String get subjectSheetHint => 'Choose the class, then the subject.';

  @override
  String get subjectSend => 'Send request';

  @override
  String get subjectGive => 'Give subject';

  @override
  String get subjectStatusApproved => 'Allowed';

  @override
  String get subjectStatusPending => 'Waiting for the Principal';

  @override
  String get subjectStatusRejected => 'Not approved';

  @override
  String get subjectRequestSent => 'Request sent to the Principal';

  @override
  String get subjectGiven => 'Subject given';

  @override
  String get subjectEmptyTeacher =>
      'You have no subject yet. Tap the button below to ask the Principal.';

  @override
  String get subjectEmptyPrincipal =>
      'No subject given yet. Tap the button below to give one.';

  @override
  String subjectRegistered(String subject) {
    return 'Registered subject: $subject (all classes)';
  }

  @override
  String get subjectRemoveTitle => 'Remove this subject?';

  @override
  String subjectRemoveBody(String subject, String cls) {
    return '$subject · $cls will be removed.';
  }

  @override
  String get subjectNoneForPaper =>
      'You have no subject yet. Ask the Principal for one before making a paper.';

  @override
  String get subjectChooseClassFirst => 'Choose the class first';

  @override
  String get subjectNoneInClass => 'No subject allowed in this class';

  @override
  String get staffActionSubjects => 'Subjects and classes';

  @override
  String get staffActionSubjectsHint => 'What this teacher teaches, and where';

  @override
  String get paperDetailsTitle => 'Paper details';

  @override
  String get paperMoreOptions => 'More options';

  @override
  String get paperMoreOptionsHint => 'Instructions for students (optional)';

  @override
  String get paperQuickAdd => 'Or add many questions at once';

  @override
  String paperQuestionsCount(int count, int marks) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0 · $marks marks';
  }

  @override
  String get paperTools => 'Tools';

  @override
  String get tabWaiting => 'Waiting';

  @override
  String get tabReady => 'Ready';

  @override
  String get tabDrafts => 'Drafts';

  @override
  String get tabDone => 'Done';

  @override
  String get dialogSignOutTitle => 'Sign out?';

  @override
  String get dialogSignOutBody => 'You will need to sign in again.';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get noticeAnnounceTitle => 'Run it on everyone\'s Dashboard';

  @override
  String get noticeAnnounceHint => 'It moves along the top until you stop it.';

  @override
  String get announceStop => 'Stop announcement';

  @override
  String get dashSchoolToday => 'School today';

  @override
  String get dashStateOpen => 'Open';

  @override
  String get dashStateClosed => 'Closed';

  @override
  String get dashStateWaiting => 'Waiting';

  @override
  String get dashTeachersAbsent => 'Teachers absent';

  @override
  String get dashStudentsAbsent => 'Students absent';

  @override
  String get dashFeesCollected => 'Fees collected';

  @override
  String get dashOverdueFees => 'Overdue fee accounts';

  @override
  String get dashUpcomingExams => 'Upcoming exams';

  @override
  String get dashRequestsTitle => 'Teacher requests';

  @override
  String get dashRequestsNone => 'No request is waiting for your answer.';

  @override
  String dashRequestsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests need your answer.',
      one: '1 request needs your answer.',
    );
    return '$_temp0 Tap to open Approvals.';
  }

  @override
  String get dashRequestsClear => 'None pending';

  @override
  String dashRequestsCount(int count) {
    return '$count pending';
  }

  @override
  String greetingNight(String name) {
    return 'Good night, $name';
  }

  @override
  String get actionSync => 'Sync';

  @override
  String get actionSyncHint =>
      'Saves your data to the cloud and checks for new requests';

  @override
  String get dashSyncing =>
      'Syncing: saving your data and checking for new requests…';

  @override
  String get syncStripDetails => 'Details';

  @override
  String get syncTable_app_settings => 'School settings';

  @override
  String get syncTable_users => 'Teacher and Principal profiles';

  @override
  String get syncTable_other_staff => 'Other staff';

  @override
  String get syncTable_teacher_subjects => 'Teacher subjects';

  @override
  String get syncTable_classes => 'Classes';

  @override
  String get syncTable_students => 'Students';

  @override
  String get syncTable_school_days => 'School days';

  @override
  String get syncTable_school_day_changes => 'School day edits';

  @override
  String get syncTable_teacher_attendance => 'Teacher attendance';

  @override
  String get syncTable_student_attendance => 'Student attendance';

  @override
  String get syncTable_exam_papers => 'Question papers';

  @override
  String get syncTable_exam_questions => 'Paper questions';

  @override
  String get syncTable_exam_marks => 'Exam marks';

  @override
  String get syncTable_fee_accounts => 'Fee accounts';

  @override
  String get syncTable_fee_payments => 'Fee payments';

  @override
  String get syncTable_notices => 'Notices';

  @override
  String get syncTable_master_questions => 'Question bank';

  @override
  String syncStripSent(int count) {
    return 'Sent $count';
  }

  @override
  String syncStripReceived(int count) {
    return 'Received $count';
  }

  @override
  String get syncStripNothingYet => 'Nothing sent or received yet';

  @override
  String syncStripLastData(String when) {
    return 'Last data $when';
  }

  @override
  String get syncDetailsStatus => 'Status';

  @override
  String get syncDetailsNextSync => 'Next sync';

  @override
  String syncDetailsChecksEvery(int seconds) {
    return 'Checks for new data every $seconds seconds';
  }

  @override
  String get syncDetailsSyncingNow => 'Syncing now…';

  @override
  String get syncDetailsCloudUpload => 'Saved to the cloud';

  @override
  String get syncDetailsLastCheck => 'Last check for new data';

  @override
  String get syncDetailsSentTitle => 'Sent from this phone';

  @override
  String get syncDetailsReceivedTitle => 'Received on this phone';

  @override
  String get syncDetailsNothingReceived => 'Nothing new has been received yet.';

  @override
  String syncDetailsRecordsSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
    );
    return '$_temp0';
  }

  @override
  String syncDetailsRecordsRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records removed',
      one: '1 record removed',
    );
    return '$_temp0';
  }

  @override
  String get syncDetailsOffline =>
      'Could not reach the server on the last check.';

  @override
  String get syncDetailsNeverChecked => 'Not checked yet';

  @override
  String get staffTapForMore =>
      'Tap to do more: assign class, subjects and more';

  @override
  String get registerWho => 'Who are you registering?';

  @override
  String aadhaarMissingReason(String reason) {
    return 'No Aadhaar: $reason';
  }

  @override
  String get syncKindAdded => 'New';

  @override
  String get syncKindChanged => 'Changed';

  @override
  String get syncKindRemoved => 'Removed';

  @override
  String get syncDetailsEarlierUnknown => 'The earlier value was not kept';

  @override
  String syncDetailsMoreNotListed(int count) {
    return '$count more records not listed';
  }

  @override
  String get syncValueEmpty => '(empty)';

  @override
  String get syncDetailsWas => 'was';

  @override
  String get syncDetailsNow => 'now';

  @override
  String get dashTeachersTitle => 'Teachers';

  @override
  String get dashStudentsTitle => 'Students';

  @override
  String dashTotalCount(int count) {
    return 'Total $count';
  }

  @override
  String get attReportTitle => 'Attendance report';

  @override
  String get attReportCardTitle => 'Attendance status';

  @override
  String get attReportCardHint =>
      'Students, teachers and others · tap to see the table';

  @override
  String get attGroupStudents => 'Students';

  @override
  String get attGroupTeachers => 'Teachers';

  @override
  String get attGroupOthers => 'Others';

  @override
  String get attMarkNotMarked => 'Not marked';

  @override
  String get attMarkNotTracked => 'Not recorded';

  @override
  String get attColName => 'Name';

  @override
  String get attColClassRole => 'Class / role';

  @override
  String get attColStatus => 'Status';

  @override
  String get attColTime => 'Check-in';

  @override
  String get attFilterDetail => 'Class / subject / role';

  @override
  String get attSearchName => 'Search by name';

  @override
  String get attClearFilters => 'Clear filters';

  @override
  String attShowing(int shown, int total) {
    return 'Showing $shown of $total';
  }

  @override
  String get attReportEmpty => 'No one matches these filters.';

  @override
  String get attReportOthersNote =>
      'Attendance of other staff is not recorded in the app.';

  @override
  String get attReportToday => 'Today';

  @override
  String get attReportPickDay => 'Pick a day';

  @override
  String get attReminderTitle => 'You have not checked in yet';

  @override
  String get attReminderBody =>
      'Check in now so that today\'s attendance is recorded.';

  @override
  String get demoDataTitle => 'Demo data';

  @override
  String get demoDataBody =>
      'Fill the school with made-up data to try every feature: classes Nursery to 8, students, male and female teachers, other staff, attendance, exams, fees, notices and more. Your own data is not changed, and \"Remove\" takes out only the demo data. You will be asked to sign in again.';

  @override
  String get demoDataLoad => 'Load';

  @override
  String get demoDataRemove => 'Remove';

  @override
  String get demoDataLoaded => 'Demo data added. Please sign in again.';

  @override
  String get demoDataRemoved => 'Demo data removed. Please sign in again.';

  @override
  String get demoDataFailed =>
      'Could not change the demo data. Please try again.';

  @override
  String get featureFees => 'Fees';

  @override
  String get featureAccessories => 'Accessories';

  @override
  String get featurePerformance => 'Performance';

  @override
  String get featureAttendance => 'Attendance';

  @override
  String get featureClasses => 'Classes';

  @override
  String get featureTeacherPayment => 'Teacher payment';

  @override
  String get featureQuestionBank => 'Question bank';

  @override
  String get featureExamPapers => 'Exam papers';

  @override
  String get featureStaffPayment => 'Payment';

  @override
  String get featureBills => 'Bills';

  @override
  String get featureSubjects => 'Subjects';

  @override
  String get addStudentTitle => 'Add student';

  @override
  String get addTeacherTitle => 'Add teacher';

  @override
  String get addStaffTitle => 'Add staff';

  @override
  String get editStudentTitle => 'Edit student';

  @override
  String get messageSaved => 'Saved';

  @override
  String get searchStudentsHint => 'Search name or roll no.';

  @override
  String get searchTeachersHint => 'Search name or subject';

  @override
  String get searchStaffHint => 'Search name or role';

  @override
  String get filterAllClasses => 'All classes';

  @override
  String summaryVan(String van) {
    return 'Van $van';
  }

  @override
  String summaryClassTeacher(String name) {
    return 'Class teacher, $name';
  }

  @override
  String get memberOpen => 'Open';

  @override
  String get memberEdit => 'Edit';

  @override
  String get memberMakeInactive => 'Make inactive';

  @override
  String get memberMakeActive => 'Make active';

  @override
  String get memberInactiveTag => 'Inactive';

  @override
  String memberShowInactive(int count) {
    return 'Show inactive ($count)';
  }

  @override
  String memberMadeInactive(String name) {
    return '$name is now inactive';
  }

  @override
  String memberMadeActive(String name) {
    return '$name is active again';
  }

  @override
  String get actionUndo => 'Undo';

  @override
  String get dashStudentsIn => 'Students in';

  @override
  String get dashTeachersIn => 'Teachers in';

  @override
  String get dashOthersIn => 'Others in';

  @override
  String get dashNotMarkedYet => 'Not marked yet';

  @override
  String dashInOf(int present, int total) {
    return '$present of $total';
  }

  @override
  String get navStudents => 'Students';

  @override
  String get navTeachers => 'Teachers';

  @override
  String get navOthers => 'Others';

  @override
  String get syncTable_staff_attendance => 'Other staff attendance';

  @override
  String get attTitleStudents => 'Student attendance';

  @override
  String get attTitleTeachers => 'Teacher attendance';

  @override
  String get attTitleOthers => 'Staff attendance';

  @override
  String attTabAll(int count) {
    return 'All $count';
  }

  @override
  String attTabMark(String label, int count) {
    return '$label $count';
  }

  @override
  String get attMeaningTeachers =>
      'Present means checked in with location and face. Absent means no check-in on this day.';

  @override
  String get attMeaningStudents =>
      'Present, absent and late are marked by the class teacher. A class shows Not marked until it is done.';

  @override
  String get attMeaningOthers =>
      'You mark staff attendance yourself. Not marked means this day has not been done yet.';

  @override
  String get attFilterClass => 'Class';

  @override
  String get attFilterRole => 'Role';

  @override
  String get attMarkStaff => 'Mark attendance';

  @override
  String get attStaffMarkTitle => 'Mark staff attendance';

  @override
  String attTeachersCheckedIn(int present, int total) {
    return '$present of $total teachers have checked in';
  }

  @override
  String get syncTable_fee_structure => 'Fee setup';

  @override
  String get proofAddPhoto => 'Add photo';

  @override
  String get proofTakePhoto => 'Take photo';

  @override
  String get proofFromGallery => 'Choose from gallery';

  @override
  String get proofRemove => 'Remove';

  @override
  String get proofSignHere => 'Sign here';

  @override
  String get proofClear => 'Clear';

  @override
  String get proofView => 'View proof';

  @override
  String get proofNone => 'No proof added';

  @override
  String get proofPhotoTitle => 'Photo proof';

  @override
  String get proofSignatureTitle => 'Signature';

  @override
  String get proofSignedTag => 'Signed';

  @override
  String get proofPhotoTag => 'Photo';

  @override
  String get proofMissing => 'The file is not on this phone any more.';

  @override
  String get feeHeadAcademic => 'Academic fee';

  @override
  String get feeHeadDress => 'Dress';

  @override
  String get feeHeadBooks => 'Books';

  @override
  String get feeHeadVan => 'Van';

  @override
  String get feeHeadPayment => 'Payment';

  @override
  String get payModeCash => 'Cash';

  @override
  String get payModeUpi => 'UPI';

  @override
  String get payModeCheque => 'Cheque';

  @override
  String get payModeBank => 'Bank';

  @override
  String feeDueLast(String due, String last) {
    return 'Due $due · Last date $last';
  }

  @override
  String get feeNoPaymentYet => 'No payment yet';

  @override
  String get feeChangeDates => 'Change dates';

  @override
  String feeDatesNote(String note) {
    return 'Own dates: $note';
  }

  @override
  String get recordPaymentTitle => 'Record payment';

  @override
  String get fieldPaidOn => 'Paid on';

  @override
  String get fieldHowPaid => 'How paid';

  @override
  String get fieldReferenceUpi => 'UPI transaction id';

  @override
  String get fieldReferenceCheque => 'Cheque number';

  @override
  String get fieldReferenceBank => 'Bank reference (UTR)';

  @override
  String get fieldReferenceCash => 'Receipt book no. (optional)';

  @override
  String get fieldProofPhoto => 'Proof (photo or screenshot)';

  @override
  String get errorReferenceRequired => 'Enter the reference.';

  @override
  String get errorProofRequired =>
      'Add a photo as proof for this kind of payment.';

  @override
  String messagePaymentSavedReceipt(String no) {
    return 'Payment saved. Receipt $no';
  }

  @override
  String get paymentProofYes => 'Proof added';

  @override
  String get paymentProofNo => 'No proof';

  @override
  String get feeAccountNotFound => 'This fee is no longer there.';

  @override
  String get feeLedgerPaymentsTitle => 'Payments';

  @override
  String get fieldReason => 'Reason';

  @override
  String get feeSetupTitle => 'Fee setup';

  @override
  String get feeSetupDue => 'Due date';

  @override
  String get feeSetupLast => 'Last date';

  @override
  String get feeSetupAmount => 'Amount';

  @override
  String feeSetupApplies(String name) {
    return 'These apply to all students of $name.';
  }

  @override
  String get feeSetupNotSet => 'Not set up yet';

  @override
  String get feeSetupEdit => 'Edit';

  @override
  String get feeSetupSetUp => 'Set up';

  @override
  String get feeSetupGive => 'Give to students';

  @override
  String feeSetupGiven(int count) {
    return '$count students now have this fee';
  }

  @override
  String get feeSetupNoneToGive => 'Everyone already has this fee';

  @override
  String get feeSetupMeaning =>
      'Due date is the day the fee becomes payable. After the last date it shows as overdue. A student who needs different dates is changed from their own fee screen.';

  @override
  String get feeSetupVanNote => 'Only for students who travel by van.';

  @override
  String get feeSetupNoClasses => 'Add classes first.';

  @override
  String get syncTable_accessory_items => 'Dress and book lists';

  @override
  String get syncTable_accessory_issues => 'Dress and books given';

  @override
  String get fieldVan => 'Van (if the student travels by van)';

  @override
  String get fieldNoVan => 'No van';

  @override
  String get accKindDress => 'Dress';

  @override
  String get accKindBooks => 'Books';

  @override
  String accSummaryDone(int done, int total) {
    return '$done of $total given';
  }

  @override
  String accSummaryNot(int count) {
    return '$count not given';
  }

  @override
  String get accSetDress => 'Dress set';

  @override
  String get accSetBooks => 'Book list';

  @override
  String get accSetEmpty => 'Not set up yet. Tap Edit set.';

  @override
  String get accEditSet => 'Edit set';

  @override
  String get accSetHintDress => 'One piece per line, for example: Shirt';

  @override
  String get accSetHintBooks => 'One book per line';

  @override
  String accSizesButton(int done, int total) {
    return 'Dress sizes $done/$total';
  }

  @override
  String accSizeLabel(String size) {
    return 'Size $size';
  }

  @override
  String get accSizeNotNoted => 'Size not noted';

  @override
  String get accNoteSize => 'Note size';

  @override
  String get accIssue => 'Issue';

  @override
  String get accGive => 'Give';

  @override
  String accGivenOf(int done, int total) {
    return '$done of $total given';
  }

  @override
  String get accComplete => 'Complete';

  @override
  String get accIssuedTag => 'Issued';

  @override
  String get accSizesTitle => 'Dress sizes';

  @override
  String accSizesNoted(int done, int total) {
    return '$done of $total noted';
  }

  @override
  String get accSizesOrder => 'Order summary';

  @override
  String accSizesNotNoted(int count) {
    return 'Not noted ×$count';
  }

  @override
  String get accSizesField => 'Size';

  @override
  String get accSizesSave => 'Save sizes';

  @override
  String get accSizesSaved => 'Sizes saved';

  @override
  String get accIssueTitleDress => 'Issue dress';

  @override
  String get accIssueTitleBooks => 'Give books';

  @override
  String get accItemsGiven => 'Items given';

  @override
  String get accSets => 'Sets';

  @override
  String get accReceivedBy => 'Received by';

  @override
  String get accSignTitle => 'Receiver\'s signature';

  @override
  String get accPhotoOptional => 'Photo (optional)';

  @override
  String accIssuedBy(String name) {
    return 'Issued by $name';
  }

  @override
  String get accIssueAndSave => 'Issue and save receipt';

  @override
  String accIssuedSaved(String no) {
    return 'Saved. Receipt $no';
  }

  @override
  String get accProblemNoItems => 'Tick at least one item.';

  @override
  String get accProblemReceiver => 'Enter who received it.';

  @override
  String get accProblemSignature => 'The receiver must sign.';

  @override
  String get accProblemSize => 'Enter the size.';

  @override
  String get accNoItemsSetup => 'Set up this class\'s list first (Edit set).';

  @override
  String get accLogEmpty => 'Nothing has been given yet.';

  @override
  String get accLogViewSignature => 'View signature';

  @override
  String get accLogViewPhoto => 'View photo';

  @override
  String accLogReceived(String name, String date) {
    return 'Received by $name · $date';
  }

  @override
  String get accLogGiveRest => 'Give remaining';

  @override
  String accNotGivenYet(String items) {
    return 'Not given yet: $items';
  }

  @override
  String get profileAccessories => 'Accessories';

  @override
  String get accNoClasses => 'Add classes first.';

  @override
  String get approvalsSearchHint => 'Search by name, class or title';

  @override
  String approvalsTabWaiting(int count) {
    return 'Waiting $count';
  }

  @override
  String approvalsTabAnswered(int count) {
    return 'Answered $count';
  }

  @override
  String approvalsChipCount(String label, int count) {
    return '$label $count';
  }

  @override
  String get fieldVanNumber => 'Van number';

  @override
  String get hintVanNumber => 'For example UP32 AB 1234';

  @override
  String dashWaitingTitle(int count) {
    return '$count waiting for you';
  }

  @override
  String get dashWaitingNone => 'Nothing is waiting for you';

  @override
  String get dashWaitingOpen => 'Open';

  @override
  String get dashSectionPeople => 'People';

  @override
  String get homeTileTiming => 'School timing';

  @override
  String get homeTileAssembly => 'Assembly';

  @override
  String get homeTilePeriods => 'Period schedule';

  @override
  String get homeTileCalendar => 'Calendar';

  @override
  String get homeTileSettings => 'Settings';

  @override
  String homeGreetingLine(String date, String greeting) {
    return '$date · $greeting';
  }

  @override
  String get syncTable_school_timings => 'Class timings';

  @override
  String get syncTable_bell_slots => 'Period timings';

  @override
  String get syncTable_assembly_duty => 'Assembly duty';

  @override
  String get syncTable_timetable_entries => 'Class timetable';

  @override
  String get timingTitle => 'School timing';

  @override
  String get timingStarts => 'School starts';

  @override
  String get timingEnds => 'School ends';

  @override
  String get timingNotSet => 'Not set';

  @override
  String get timingWorkingDays => 'Working days';

  @override
  String get timingClassRules => 'Different timing for some classes';

  @override
  String get timingAddAnother => '+ Add another timing';

  @override
  String get timingSeasonal => 'Seasonal timing';

  @override
  String get timingSeasonalHint =>
      'Summer timing from a date, winter timing from a date.';

  @override
  String get timingAdd => '+ Add';

  @override
  String get timingNote =>
      'Shown on Home, in the period schedule and at the teacher\'s check-in. Whether a late check-in is flagged after the start time is not decided.';

  @override
  String get timingRuleTitle => 'Timing';

  @override
  String get timingRuleClasses =>
      'For these classes (none picked means every class)';

  @override
  String get timingRuleFrom => 'Starts from';

  @override
  String get timingRuleFromNone => 'Every day';

  @override
  String get timingRuleRemove => 'Remove';

  @override
  String timingRuleFromDate(String range, String date) {
    return '$range from $date';
  }

  @override
  String get assemblyTitle => 'School assembly';

  @override
  String get assemblyTime => 'Time';

  @override
  String get assemblyPlace => 'Place';

  @override
  String get assemblyDays => 'Days';

  @override
  String get assemblyOrder => 'Running order';

  @override
  String get assemblyOrderHint => 'One item per line, for example: Prayer';

  @override
  String get assemblyDutyTitle => 'Who is on duty';

  @override
  String assemblyInCharge(String name) {
    return 'In charge: $name';
  }

  @override
  String get assemblyDutyClass => 'Class';

  @override
  String get assemblyDutyTeacher => 'Teacher in charge';

  @override
  String get assemblyDutyClear => 'Clear';

  @override
  String get periodsTitle => 'Period timings';

  @override
  String get periodsAdd => '+ Period';

  @override
  String get periodsHint =>
      'The bell schedule for the whole school. Classes fill in subjects next.';

  @override
  String get periodsAssembly => 'Assembly';

  @override
  String get periodsFixed => 'Fixed';

  @override
  String periodN(int n) {
    return 'Period $n';
  }

  @override
  String get periodBreakTag => 'Break';

  @override
  String get periodEdit => 'Edit';

  @override
  String get periodKindPeriod => 'Period';

  @override
  String get periodKindBreak => 'Break';

  @override
  String get periodLabel => 'Name (for a break, e.g. Lunch)';

  @override
  String periodMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get periodsTimetableButton => 'Class timetable';

  @override
  String get periodRemove => 'Remove';

  @override
  String periodTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get periodEndBeforeStart => 'The end must be after the start.';

  @override
  String get timetableTitle => 'Timetable';

  @override
  String get timetableCopy => 'Copy to…';

  @override
  String get timetableChange => 'Change';

  @override
  String get timetableNotSet => 'Not set';

  @override
  String get timetableClear => 'Clear';

  @override
  String timetableConflict(
    String teacher,
    String className,
    String slot,
    String day,
  ) {
    return '$teacher is already teaching $className in $slot on $day. Choose another teacher or period.';
  }

  @override
  String get timetableNoOptions =>
      'No teacher is allotted to this class yet. Allot subjects from the teacher\'s Subjects.';

  @override
  String timetableCopied(int copied, int skipped) {
    return '$copied periods copied, $skipped left out (teacher busy)';
  }

  @override
  String timetableCopyTo(String day) {
    return 'Copy $day to';
  }

  @override
  String get timetableNoSlots => 'Set the period timings first.';

  @override
  String timetablePickTitle(String slot, String day) {
    return '$slot · $day';
  }

  @override
  String get actionDone => 'Done';

  @override
  String get categoryTagExam => 'Exam';

  @override
  String get categoryTagSubject => 'Subject';

  @override
  String get categoryTagBill => 'Bill';

  @override
  String approvalsSubtitle(int waiting, int total) {
    return '$waiting waiting · $total total';
  }

  @override
  String get approvalAllow => 'Allow';

  @override
  String get approvalDecline => 'Decline';

  @override
  String get approvalTabWaiting => 'Waiting';

  @override
  String get approvalTabApproved => 'Approved';

  @override
  String get approvalTabRejected => 'Rejected';

  @override
  String get aadhaarScanCardTitle => 'Scan Aadhaar card';

  @override
  String get aadhaarScanCardHint => 'Fills name, birth date, gender, address';

  @override
  String get saveStudent => 'Save student';

  @override
  String get saveTeacher => 'Save teacher';

  @override
  String get saveStaff => 'Save staff';

  @override
  String get actionAssignFee => '+ Assign fee';

  @override
  String profileTileFeesDue(String amount) {
    return '$amount due';
  }

  @override
  String get profileTileFeesClear => 'All paid';

  @override
  String profileTileAvg(int percent) {
    return 'Avg $percent%';
  }

  @override
  String profileTileAttendance(int percent) {
    return '$percent% this term';
  }

  @override
  String get profileTileNone => 'Nothing yet';

  @override
  String profileGuardianLine(String name, String phone) {
    return 'Guardian: $name · $phone';
  }

  @override
  String get syncTable_staff_bills => 'Fuel bills';

  @override
  String get syncTable_staff_settlements => 'Staff payments';

  @override
  String get categoryStaffBill => 'Bills';

  @override
  String approvalBillLine(String name, String detail, String date) {
    return '$name · $detail · $date';
  }

  @override
  String get billsTitle => 'Bills';

  @override
  String get billsAdd => '+ Bill';

  @override
  String get billsTabAll => 'All';

  @override
  String get billsTabPending => 'Pending';

  @override
  String get billsTabApproved => 'Approved';

  @override
  String get billsTabPaid => 'Paid';

  @override
  String billRowTitle(String kind, String amount) {
    return '$kind · $amount';
  }

  @override
  String billRowSub(String date, String litres, String proof) {
    return '$date · $litres L · $proof';
  }

  @override
  String billRowSubNoLitres(String date, String proof) {
    return '$date · $proof';
  }

  @override
  String get billPhasePending => 'Pending approval';

  @override
  String get billPhaseApproved => 'Approved';

  @override
  String get billPhaseRejected => 'Rejected';

  @override
  String get billPhasePaid => 'Paid';

  @override
  String get billPhotoYes => 'photo';

  @override
  String get billPhotoNo => 'no photo';

  @override
  String get billsRule =>
      'Only an approved bill can be paid. Pending and rejected bills are locked.';

  @override
  String get billsEmpty => 'No bills yet.';

  @override
  String get fuelPetrol => 'Petrol';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get addBillTitle => 'Add bill';

  @override
  String get fieldBillDate => 'Date';

  @override
  String get fieldLitres => 'Litres';

  @override
  String get fieldBillAmount => 'Amount';

  @override
  String get fieldBillPhoto => 'Photo of the bill';

  @override
  String get fieldBillNote => 'Note (optional)';

  @override
  String get billSendForApproval => 'Send for approval';

  @override
  String get billSent => 'Bill sent for approval';

  @override
  String get errBillAmount => 'Enter the amount.';

  @override
  String get errBillPhoto => 'Add a photo of the bill.';

  @override
  String get billChooseStaff => 'Whose bill is it?';

  @override
  String get staffPaymentTitle => 'Payment';

  @override
  String get staffPayableNow => 'Payable now (approved bills)';

  @override
  String get staffEligible => 'Eligible · approved';

  @override
  String staffSettle(String amount) {
    return 'Settle $amount';
  }

  @override
  String get staffNotEligible => 'Not eligible yet';

  @override
  String get staffLockedWaiting => 'Waiting for your approval';

  @override
  String get staffLocked => 'Locked';

  @override
  String get staffGoApprovals => 'Approvals';

  @override
  String get staffPayHistory => 'Payment history';

  @override
  String get staffNothingPayable => 'Nothing is ready to pay.';

  @override
  String staffPayableLine(String amount) {
    return '$amount payable';
  }

  @override
  String staffBillsWaiting(int count) {
    return '$count awaiting approval';
  }

  @override
  String get staffNoBillsYet => 'No bills yet';

  @override
  String get settleTitle => 'Settle payment';

  @override
  String get settleAmountPaid => 'Amount paid';

  @override
  String get settleProof => 'Proof of settlement';

  @override
  String settlePaidBy(String name) {
    return 'Paid by $name';
  }

  @override
  String get settleConfirm => 'Confirm and save voucher';

  @override
  String settleSaved(String no) {
    return 'Paid. Voucher $no';
  }

  @override
  String get settleNothing => 'Choose at least one bill.';

  @override
  String get settleNotApproved => 'Some of these bills are no longer approved.';

  @override
  String get settlementsTitle => 'Payment history';

  @override
  String get settlementsEmpty => 'No payments yet.';

  @override
  String settlementLine(String mode, String date) {
    return '$mode · $date';
  }

  @override
  String settlementRef(String ref) {
    return 'Ref $ref';
  }

  @override
  String settlementBills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'For $count bills',
      one: 'For 1 bill',
    );
    return '$_temp0';
  }

  @override
  String get settlementViewProof => 'View proof';

  @override
  String staffRoleLine(String phone) {
    return 'Phone $phone';
  }

  @override
  String get staffTilePayment => 'Payment';

  @override
  String get staffTileBills => 'Bills';

  @override
  String get teacherSubjectsListTitle => 'Subjects';

  @override
  String teacherSubjectsLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subjects',
      one: '1 subject',
      zero: 'No subjects yet',
    );
    return '$_temp0';
  }

  @override
  String get navMyClass => 'My class';

  @override
  String get navExams => 'Exams';

  @override
  String get teacherTodayPeriods => 'Today\'s periods';

  @override
  String get teacherNoPeriods => 'No periods set for today.';

  @override
  String get teacherAddQuestion => '+ Question';

  @override
  String teacherAssemblyDuty(String day) {
    return 'Assembly duty: $day';
  }

  @override
  String teacherAssemblyDutyLine(String className, String time) {
    return '$className · $time';
  }

  @override
  String get teacherMarkNow => 'Mark now';

  @override
  String teacherClassNotMarked(String className) {
    return '$className attendance not marked';
  }

  @override
  String teacherClassStudents(int count) {
    return '$count students';
  }

  @override
  String teacherClassMarked(String className) {
    return '$className attendance done';
  }

  @override
  String teacherClassPresentOf(int present, int total) {
    return '$present of $total present';
  }

  @override
  String myClassTitle(String name) {
    return 'My class · $name';
  }

  @override
  String get myClassNone => 'No class is given to you yet. Ask the Principal.';

  @override
  String get myClassMark => 'Mark attendance';

  @override
  String get myClassView => 'View today\'s attendance';

  @override
  String get syncTable_question_units => 'Question bank units';

  @override
  String get bankTitle => 'My question bank';

  @override
  String get bankAddQuestion => '+ Question';

  @override
  String bankSummary(int count, int units) {
    return '$count questions in $units units';
  }

  @override
  String get bankUnitEmpty => 'No questions yet';

  @override
  String get bankNoScopes =>
      'You have no subject yet. Ask the Principal to give you one.';

  @override
  String get bankNoUnits => 'No units yet. Add a unit, then its questions.';

  @override
  String get bankAddTitle => 'Add questions';

  @override
  String get bankAddPhoto => 'Take a photo of the questions';

  @override
  String get bankAddPhotoHint => 'From your book, worksheet or board.';

  @override
  String get bankFastest => 'Fastest';

  @override
  String get bankAddGallery => 'Choose a photo from the phone';

  @override
  String get bankAddGalleryHint => 'A picture you already took.';

  @override
  String get bankAddType => 'Type one question';

  @override
  String get bankAddTypeHint => 'Write it yourself.';

  @override
  String get bankClassSubject => 'Class · Subject';

  @override
  String get bankUnitLabel => 'Unit';

  @override
  String get bankNewUnit => '+ New unit';

  @override
  String get bankNewUnitTitle => 'New unit';

  @override
  String get bankNewUnitHint => 'e.g. Unit 2 · Verbs';

  @override
  String get bankAddOneTitle => 'Add question';

  @override
  String get bankSaveAnother => 'Save and add another';

  @override
  String get bankSaved => 'Question saved';

  @override
  String get bankDeleted => 'Question deleted';

  @override
  String get bankPickUnit => 'Choose a unit first.';

  @override
  String get photoTitle => 'Photo questions';

  @override
  String photoStep(int n) {
    return 'Step $n of 4';
  }

  @override
  String get photoWhereGo => 'Where should these go?';

  @override
  String get photoTips => 'Tips for a clear photo';

  @override
  String get photoTip1 => 'Good light, no shadow';

  @override
  String get photoTip2 => 'Page flat, all four corners in view';

  @override
  String get photoTip3 => 'One page at a time';

  @override
  String photoPages(int count) {
    return 'Pages taken: $count';
  }

  @override
  String photoPageN(int n) {
    return 'Page $n';
  }

  @override
  String get photoAddPage => 'Add another page';

  @override
  String get photoRead => 'Read questions';

  @override
  String get photoReading => 'Reading the photos…';

  @override
  String get photoNothing => 'No questions could be read. Try a clearer photo.';

  @override
  String photoFound(int count, int pages, String name) {
    return '$count questions found in $pages pages · $name';
  }

  @override
  String get photoCheckEach => 'Check each one. Tap a question to fix it.';

  @override
  String photoFilterAll(int count) {
    return 'All $count';
  }

  @override
  String photoFilterNeed(int count) {
    return 'Need answer $count';
  }

  @override
  String photoFilterCheck(int count) {
    return 'Check $count';
  }

  @override
  String get flagReady => 'Ready';

  @override
  String get flagAnswerMissing => 'Answer missing';

  @override
  String get flagCheckPairs => 'Check pairs';

  @override
  String get flagLeftOut => 'Left out';

  @override
  String get photoHeadingNote => 'Looks like a heading, not a question';

  @override
  String photoSaveTo(String name) {
    return 'Save to $name';
  }

  @override
  String photoSaveN(int count) {
    return 'Save $count';
  }

  @override
  String get photoFixTitle => 'Fix question';

  @override
  String photoFixOf(int n, int total) {
    return '$n of $total';
  }

  @override
  String get photoPrevious => 'Previous';

  @override
  String get photoNext => 'Next';

  @override
  String get photoSavedTitle => 'Saved';

  @override
  String photoSavedCount(int count) {
    return '$count questions added';
  }

  @override
  String photoBefore(String name) {
    return '$name before';
  }

  @override
  String photoNow(String name) {
    return '$name now';
  }

  @override
  String get photoTakeAnother => 'Take another photo';

  @override
  String get photoMakePaper => 'Make a paper from my bank';

  @override
  String get kindWeekly => 'Weekly test';

  @override
  String get kindMidMonthly => 'Mid-monthly test';

  @override
  String get kindUnitTest => 'Unit test';

  @override
  String get kindHalfYearly => 'Half-yearly exam';

  @override
  String get kindYearlyFinal => 'Yearly final exam';

  @override
  String get makeTitle => 'Make paper';

  @override
  String makeStep(int n) {
    return 'Step $n of 5';
  }

  @override
  String get makeExamType => 'Exam type';

  @override
  String get makeTotalMarks => 'Total marks';

  @override
  String get makeTime => 'Time (minutes)';

  @override
  String get makeDate => 'Exam date';

  @override
  String get makeNextUnits => 'Next: pick units';

  @override
  String get makePickUnits => 'Which units does this test cover?';

  @override
  String makeUnitCount(int count) {
    return '$count questions';
  }

  @override
  String get makeNoQuestions => 'No questions in your bank';

  @override
  String makeUnitsSummary(int units, int count) {
    return '$units units · $count questions to choose from';
  }

  @override
  String get makeNextTypes => 'Next: question types';

  @override
  String makePlanned(int planned, int total) {
    return '$planned of $total marks planned';
  }

  @override
  String get makeTypesHave => 'Types you have in these units';

  @override
  String makeAvailable(int count) {
    return '$count available';
  }

  @override
  String get makeTakeFrom => 'Take from:';

  @override
  String get makeQuestions => 'Questions';

  @override
  String get makeMarksEach => 'Marks each';

  @override
  String get makeNotUsed => 'not used';

  @override
  String makeShort(int want, int have) {
    return 'Ask for $want and the bank has only $have.';
  }

  @override
  String get makeMakeSet => 'Make the set';

  @override
  String get makeReviewTitle => 'Review set';

  @override
  String makeMarksOf(int have, int want) {
    return '$have / $want marks';
  }

  @override
  String get makeReplace => 'Replace';

  @override
  String get makeNewSet => 'Make a new set';

  @override
  String get makeNext => 'Next';

  @override
  String get makeReplaceTitle => 'Replace question';

  @override
  String get makeReplacing => 'Replacing';

  @override
  String get makeOtherOfType => 'Other questions of this type from your bank';

  @override
  String get makeUse => 'Use';

  @override
  String get makeReplaceHint =>
      'Questions already in this paper are hidden. Marks stay as planned.';

  @override
  String get makeNoOthers => 'No other questions of this type.';

  @override
  String get makeSendTitle => 'Send for approval';

  @override
  String makeSummaryLine(String name, int marks, int minutes) {
    return '$name · $marks marks · $minutes min';
  }

  @override
  String makeMadeFrom(int count) {
    return 'Made from my question bank · $count questions replaced by hand';
  }

  @override
  String get makeSaveDraft => 'Save draft';

  @override
  String get makeSend => 'Send to Principal';

  @override
  String makeMismatch(int have, int want) {
    return 'The set has $have marks but the paper needs $want.';
  }

  @override
  String get makeSent => 'Sent to the Principal.';

  @override
  String get makeDraftSaved => 'Saved as a draft.';

  @override
  String get makeNeedTotal => 'Enter total marks and time first.';

  @override
  String get makeNeedUnits => 'Tick at least one unit that has questions.';

  @override
  String get makeNeedTypes => 'Choose how many questions of at least one type.';

  @override
  String get newPaperTitle => 'New paper';

  @override
  String get newPaperFromBank => 'Make from my question bank';

  @override
  String get newPaperFromBankHint =>
      'Pick units and types. A set is made for you.';

  @override
  String get newPaperWrite => 'Write questions myself';

  @override
  String get newPaperWriteHint => 'Type, scan or pick one by one.';

  @override
  String get tabSent => 'Sent';

  @override
  String get tabApproved => 'Approved';

  @override
  String get examsNewPaper => '+ New paper';

  @override
  String get examsMyBank => 'My question bank';

  @override
  String get profileCheckInHistory => 'Check-in history';

  @override
  String get profileCalendarHolidays => 'Calendar and holidays';

  @override
  String get loginNewSchool => 'New school? Set up as Principal';

  @override
  String get loginRestoreSchool => 'School already registered? Restore it';

  @override
  String get loginOr => 'or';

  @override
  String get resetTitle => 'Start a new school?';

  @override
  String get resetBody =>
      'This phone still holds the data of an earlier school. Starting a new school erases it from this phone. Nothing in the cloud is touched.';

  @override
  String get resetConfirm => 'Erase and start new';

  @override
  String get monTitle => 'Data monitor';

  @override
  String get monCheck => 'Check';

  @override
  String get monAgainst => 'Against';

  @override
  String get monSrcCloud => 'Cloud';

  @override
  String get monSrcFile => 'File';

  @override
  String get monSrcDb => 'Local DB';

  @override
  String monRows(int count) {
    return '$count rows';
  }

  @override
  String monAsOf(String time) {
    return 'as of $time';
  }

  @override
  String get monCheckCloud => 'Check cloud';

  @override
  String get monCheckCloudHint =>
      'Reads a count for each table from the cloud.';

  @override
  String get monNotRead => 'Not read yet';

  @override
  String get monProblemMissing => 'No data file yet';

  @override
  String get monProblemNotSignedIn => 'Not signed in to the cloud';

  @override
  String get monProblemOffline => 'Cannot reach the cloud';

  @override
  String get monProblemOther => 'Could not be read';

  @override
  String get monTable => 'Table';

  @override
  String get monAllMatch => 'All tables match';

  @override
  String monSomeDiffer(int count) {
    return '$count tables differ';
  }

  @override
  String monOnlyIn(String name) {
    return 'Only in $name';
  }

  @override
  String get monChanged => 'Different values';

  @override
  String monSame(int count) {
    return '$count rows are the same';
  }

  @override
  String get monMatches => 'Both match completely.';

  @override
  String monShowing(int count) {
    return 'Showing the first $count';
  }

  @override
  String get monReading => 'Reading…';

  @override
  String monFileWritten(String time) {
    return 'Data file written $time';
  }

  @override
  String get monFileFailed => 'Data file could not be written';

  @override
  String monCompareWith(String name) {
    return 'Compared with $name';
  }

  @override
  String get monCheckNow => 'Check now';

  @override
  String get monPhone => 'Phone';

  @override
  String get monCloudCost => 'Reads a count of each table from the cloud.';

  @override
  String monMatchLine(String name, String other) {
    return '$name has the same rows as $other';
  }

  @override
  String monDiffLine(int count, String other) {
    return '$count tables differ from $other';
  }

  @override
  String monShowDifferences(int count) {
    return 'Differences ($count)';
  }

  @override
  String monShowAll(int count) {
    return 'All rows ($count)';
  }

  @override
  String get monStatusSame => 'Same';

  @override
  String get monStatusDifferent => 'Different';

  @override
  String get monEmptyValue => '(empty)';

  @override
  String monCountsLine(
    int same,
    String a,
    int onlyA,
    String b,
    int onlyB,
    int diff,
  ) {
    return 'Same $same · Only $a $onlyA · Only $b $onlyB · Different $diff';
  }

  @override
  String get monSource => 'Source';

  @override
  String monReadBoth(String a, String b) {
    return 'Read $a and $b again';
  }

  @override
  String monRefreshLabel(String a, String b) {
    return 'Refresh: $a + $b';
  }

  @override
  String get monRefreshHint =>
      'Refresh reads only the two places chosen above.';

  @override
  String monExternalWritten(String time) {
    return 'Copy in Downloads/ShikshaSetu written $time';
  }

  @override
  String get monExternalFailed =>
      'Copy in Downloads/ShikshaSetu could not be written';

  @override
  String get genderMaleShort => 'M';

  @override
  String get genderFemaleShort => 'F';

  @override
  String get genderOtherShort => 'Other';

  @override
  String backupAutoLast(String time) {
    return 'Automatic copy: $time';
  }

  @override
  String get backupAutoNone => 'Automatic copy not made yet';

  @override
  String get backupAutoFailed => 'Automatic copy could not be written';

  @override
  String get actionBackupShareZip => 'Share backup';

  @override
  String get backupShareHint =>
      'Send the latest data to Drive, WhatsApp or email.';

  @override
  String get restoreHint =>
      'Pick shiksha_setu_latest from Downloads/ShikshaSetu.';

  @override
  String get rpTitle => 'Check before restoring';

  @override
  String rpBackupFrom(String time) {
    return 'Backup made $time';
  }

  @override
  String get rpNoChange =>
      'The backup has exactly the same data as the app. Nothing would change.';

  @override
  String rpWillChange(int added, int changed, int removed) {
    return 'Restoring will add $added, change $changed and remove $removed rows.';
  }

  @override
  String rpLoseWarning(int removed) {
    return '$removed rows are in the app but not in this backup. They would be lost.';
  }

  @override
  String get rpLegend => 'Now = the app today. Backup = the file you picked.';

  @override
  String get rpNow => 'Now';

  @override
  String get rpBackup => 'Backup';

  @override
  String rpAdd(int count) {
    return '+$count added';
  }

  @override
  String rpRemove(int count) {
    return '−$count lost';
  }

  @override
  String rpChange(int count) {
    return '~$count changed';
  }

  @override
  String get rpRestoreButton => 'Restore this backup';

  @override
  String get rpRestoreLosing => 'Restore anyway';

  @override
  String get rpNothingToRestore => 'Nothing to restore';

  @override
  String get actionBackupDownload => 'Download';

  @override
  String get messageBackupDownloaded => 'Backup saved';

  @override
  String rpNewerBanner(String app, String backup) {
    return 'The app has newer changes (last changed $app) than this backup (made $backup). Restoring would override them with older data.';
  }

  @override
  String get rpRestoreOverriding => 'Restore anyway';

  @override
  String get rpOverrideTitle => 'Override your data?';

  @override
  String rpOverrideBody(int changed, int removed) {
    return 'This will replace $changed rows in the app with the backup\'s version and remove $removed rows that are not in the backup.\n\nYour current data is kept first as Downloads/ShikshaSetu/shiksha_setu_before_restore.json (it replaces the one from an earlier restore).';
  }

  @override
  String get rpOverrideConfirm => 'Override and restore';

  @override
  String get rhTitle => 'Last restore';

  @override
  String rhLine(String time, String backup) {
    return 'Restored $time from the backup of $backup';
  }

  @override
  String rhCounts(int added, int changed, int removed) {
    return '$added added · $changed replaced · $removed lost';
  }

  @override
  String get rhSaved =>
      'Your earlier data: Downloads/ShikshaSetu/shiksha_setu_before_restore.json';

  @override
  String get rhNotSaved => 'Your earlier data could not be copied to Downloads';

  @override
  String get rhForced => 'The app had newer changes than this backup';

  @override
  String get rpOldTitle => 'This is an old backup';

  @override
  String rpOldBody(int changed, int removed) {
    return 'The app already has newer data than this backup.\n\nStill override it with the older data? $changed rows will be replaced by their older version and $removed rows will be removed.\n\nYour current data is kept first as Downloads/ShikshaSetu/shiksha_setu_before_restore.json (it replaces the one from an earlier restore).';
  }

  @override
  String get homeSchoolPlans => 'School plans';

  @override
  String get homeSchoolPlansHint =>
      'Timing, assembly, periods, calendar and holidays';

  @override
  String safePillSafe(String time) {
    return 'Safe $time';
  }

  @override
  String get safePillSaving => 'Saving…';

  @override
  String get safePillFailed => 'Not saved';

  @override
  String get safePillOff => 'Cloud off';

  @override
  String needsYouTitle(int count) {
    return 'Needs you · $count';
  }

  @override
  String get needsYouNone => 'All caught up';

  @override
  String get needsYouNoneHint => 'Nothing is waiting for you.';

  @override
  String get homeTodayInSchool => 'Today in school';

  @override
  String get quickNotice => 'Notice';

  @override
  String homePlansMore(int count) {
    return '+$count more';
  }

  @override
  String get planTimingHint => 'When school starts and ends';

  @override
  String get planAssemblyHint => 'Time, place and who is on duty';

  @override
  String get planPeriodsHint => 'Bell schedule and class timetables';

  @override
  String get planCalendarHint => 'School days and holidays';

  @override
  String get planHolidaysHint => 'Add or change holidays';

  @override
  String get quickNoticeHint => 'Post an announcement for everyone';

  @override
  String get wsAsk => 'What do you need?';

  @override
  String get wsAddStudentHint => 'Click to add a new student';

  @override
  String get wsAddTeacherHint => 'Click to add a new teacher';

  @override
  String get wsAddStaffHint => 'Click to add a driver, helper or other staff';

  @override
  String get wsListStudents => 'All students';

  @override
  String get wsListTeachers => 'All teachers';

  @override
  String get wsListStaff => 'All staff';

  @override
  String wsListHint(int count) {
    return '$count registered · search, see and edit';
  }

  @override
  String get wsFeesHint => 'Set fees, collect payments, see dues';

  @override
  String get wsAccessoriesHint => 'Dress and books given to students';

  @override
  String get wsPerformanceHint => 'Marks, results and how classes are doing';

  @override
  String get wsStudentAttendanceHint => 'Who came today, by class';

  @override
  String get wsClassesHint => 'Classes, sections and class teachers';

  @override
  String get wsTeacherPaymentHint => 'Pay teachers and see payments';

  @override
  String get wsQuestionBankHint => 'Questions kept for papers';

  @override
  String get wsExamPapersHint => 'Papers made and sent for approval';

  @override
  String get wsTeacherAttendanceHint => 'Check-ins and who is in school';

  @override
  String get wsSubjectsHint => 'Who teaches which subject';

  @override
  String get wsStaffAttendanceHint => 'Who came today';

  @override
  String get wsStaffPaymentHint => 'Pay staff and settle approved bills';

  @override
  String get wsBillsHint => 'Petrol and diesel bills for approval';

  @override
  String get accAddTitle => 'Add';

  @override
  String get accAddHint => 'Add a dress piece or a book to a class';

  @override
  String get accManageTitle => 'See, edit, delete';

  @override
  String get accManageHint => 'The dress and book list of each class';

  @override
  String get accGiveTitle => 'Give to students';

  @override
  String get accGiveHint => 'Hand over dress or books, class by class';

  @override
  String get accSizesHint => 'Note each student\'s size';

  @override
  String get accRecordsTitle => 'Records';

  @override
  String get accRecordsHint => 'Who got what, with receipts';

  @override
  String get accItemName => 'Name of the item';

  @override
  String get accItemAdded => 'Added';

  @override
  String get accItemRemoved => 'Removed';

  @override
  String get accEditItem => 'Edit item';

  @override
  String get accDeleteItemTitle => 'Delete this item?';

  @override
  String get accNothingHere => 'Nothing here yet.';

  @override
  String get accNoRecords => 'Nothing has been given yet.';

  @override
  String get accPickClass => 'Choose a class';

  @override
  String get actionSignInWithGoogle => 'Sign in with Google';

  @override
  String get errorNotRegistered =>
      'This Google account is not registered with the school. Ask the Principal to add you.';

  @override
  String get registerSubtitle =>
      'Register as the Principal. You will set up the school next.';

  @override
  String get loginRegister => 'New here? Register';

  @override
  String get schoolSetupTitle => 'Name your school';

  @override
  String get schoolSetupSubtitle =>
      'This name is shown across the app. You can add teachers later.';

  @override
  String get loginAdminNote =>
      'Accounts are created by your school\'s administrator. If you can\'t sign in, please contact your Principal.';

  @override
  String get srvOffline =>
      'Can\'t reach the school\'s server. Check your internet and try again.';

  @override
  String get srvInvalidCredentials =>
      'Wrong email or password, or this account is switched off.';

  @override
  String get srvSessionExpired => 'Your session ended. Please sign in again.';

  @override
  String get srvForbidden => 'You are not allowed to do this.';

  @override
  String get srvNotFound =>
      'This could not be found. It may have been removed.';

  @override
  String get srvInvalid => 'Please check what you entered.';

  @override
  String get srvRejected => 'This was not allowed.';

  @override
  String get srvTooManyRequests =>
      'Too many tries. Please wait a little and try again.';

  @override
  String get srvUnavailable =>
      'Something went wrong on the server. Please try again.';

  @override
  String get actionRetry => 'Try again';

  @override
  String get comingSoon =>
      'This part is being connected to the school\'s server.';

  @override
  String get navStaff => 'Staff';

  @override
  String get navRequests => 'Requests';

  @override
  String get navPayments => 'Payments';

  @override
  String get navAnalytics => 'Graphs';

  @override
  String get navSchool => 'School';

  @override
  String get navNotices => 'Notices';

  @override
  String get navFuelBills => 'Fuel bills';

  @override
  String get navVicePrincipal => 'Vice Principal';

  @override
  String get navMore => 'More';

  @override
  String get roleLabelVicePrincipal => 'Vice Principal';

  @override
  String get roleLabelStaff => 'Staff';

  @override
  String get profileChangeName => 'Change name';

  @override
  String get schoolTitle => 'School';

  @override
  String get schoolNameNotSet => 'School name not set';

  @override
  String get schoolSeasonInUse => 'Timing in use';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get seasonWinter => 'Winter';

  @override
  String schoolTimingOf(String season) {
    return '$season timing';
  }

  @override
  String schoolHours(String opens, String closes) {
    return '$opens to $closes';
  }

  @override
  String get schoolTimingNotSet => 'Not set yet';

  @override
  String schoolPeriodCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count periods',
      one: '1 period',
      zero: 'No periods',
    );
    return '$_temp0';
  }

  @override
  String get schoolInUse => 'In use';

  @override
  String get schoolHolidays => 'Holidays';

  @override
  String get fieldOpens => 'School opens';

  @override
  String get fieldCloses => 'School closes';

  @override
  String get fieldStarts => 'Starts';

  @override
  String get fieldEnds => 'Ends';

  @override
  String get schoolPeriods => 'Periods';

  @override
  String get schoolAddPeriod => 'Add period';

  @override
  String get schoolNoPeriods => 'No periods yet.';

  @override
  String schoolPeriodName(int n) {
    return 'Period $n name (optional)';
  }

  @override
  String get holidayEdit => 'Change holiday';

  @override
  String get fieldHolidayName => 'Holiday name';

  @override
  String get fieldFirstDay => 'First day';

  @override
  String get fieldLastDay => 'Last day';

  @override
  String get holidaysEmpty => 'No holidays from this month on.';

  @override
  String get noticePost => 'Post a notice';

  @override
  String get noticeKindNotice => 'Notice';

  @override
  String get noticeAnnouncement => 'Announcement';

  @override
  String get noticeWithdraw => 'Take down';

  @override
  String get noticeWithdrawTitle => 'Take this notice down?';

  @override
  String get noticeWithdrawBody => 'Everyone will stop seeing it.';

  @override
  String get stuTitle => 'Students';

  @override
  String get stuTabStudents => 'Students';

  @override
  String get stuTabClasses => 'Classes';

  @override
  String get stuSearch => 'Search by name';

  @override
  String get stuAllClasses => 'All classes';

  @override
  String get stuAdd => 'Add student';

  @override
  String get stuEdit => 'Edit student';

  @override
  String get stuRemove => 'Remove student';

  @override
  String get stuRestore => 'Restore student';

  @override
  String stuRemoveAsk(String name) {
    return 'Remove $name? Their records and fees stay.';
  }

  @override
  String get stuRemoved => 'Removed';

  @override
  String get stuEmpty => 'No students found.';

  @override
  String stuRoll(String roll) {
    return 'Roll $roll';
  }

  @override
  String get stuRollField => 'Roll number (leave empty for the next one)';

  @override
  String get stuGuardianField => 'Guardian name';

  @override
  String get stuUsesVan => 'Uses the school van';

  @override
  String get stuVanYes => 'Uses the van';

  @override
  String get stuVanNo => 'Does not use the van';

  @override
  String get stuClassesEmpty =>
      'No classes yet. Tap \"Add class\" to create one.';

  @override
  String get stuClassLevel => 'Level';

  @override
  String get stuClassSection => 'Section (leave empty if there is only one)';

  @override
  String stuClassRemoveAsk(String name) {
    return 'Remove $name?';
  }

  @override
  String get stuLevelNursery => 'Nursery';

  @override
  String get stuLevelLkg => 'LKG';

  @override
  String get stuLevelUkg => 'UKG';

  @override
  String get feeTab => 'Fees';

  @override
  String get feeSetupTab => 'Fee setup';

  @override
  String get itemsTab => 'Dress & books';

  @override
  String get feeOnlyDue => 'Only with dues';

  @override
  String get feeAccountsEmpty => 'No fee accounts found.';

  @override
  String feeBalanceOf(String amount) {
    return 'Balance $amount';
  }

  @override
  String get feeDue => 'Due';

  @override
  String get feePaid => 'Paid';

  @override
  String get feeBalance => 'Balance';

  @override
  String get feeNotSet => 'Not set';

  @override
  String get feeSetAmount => 'Set amount';

  @override
  String get feeReceive => 'Receive payment';

  @override
  String get feeHeadTuition => 'Tuition';

  @override
  String feeReceipt(String no) {
    return 'Receipt $no';
  }

  @override
  String get feeNote => 'Note (optional)';

  @override
  String get feePayments => 'Payments';

  @override
  String get feeNoPayments => 'No payments yet.';

  @override
  String get feeSell => 'Sell dress or books';

  @override
  String get feeNoClasses => 'Add a class first.';

  @override
  String get itemAdd => 'Add item';

  @override
  String get itemEdit => 'Edit item';

  @override
  String get itemName => 'Item name';

  @override
  String get itemPrice => 'Price';

  @override
  String get itemClass => 'Class';

  @override
  String get itemAllClasses => 'All classes';

  @override
  String get itemKind => 'Kind';

  @override
  String get itemKindDress => 'Dress';

  @override
  String get itemKindBooks => 'Books';

  @override
  String get itemsEmpty => 'Nothing for sale yet. Tap \"Add item\".';

  @override
  String get itemQuantity => 'Quantity';

  @override
  String get itemSellAction => 'Sell';

  @override
  String get itemsForSale => 'Nothing is for sale for this class.';

  @override
  String get memTeachers => 'Teachers';

  @override
  String get memStaff => 'Staff';

  @override
  String get memVicePrincipals => 'Vice Principals';

  @override
  String get memTeacherAdd => 'Add teacher';

  @override
  String get memStaffAdd => 'Add staff member';

  @override
  String get memVpAdd => 'Appoint Vice Principal';

  @override
  String get memTeacherEdit => 'Edit teacher';

  @override
  String get memStaffEdit => 'Edit staff member';

  @override
  String get memVpEdit => 'Edit Vice Principal';

  @override
  String get memTeachersEmpty => 'No teachers found.';

  @override
  String get memStaffEmpty => 'No staff found.';

  @override
  String get memVpEmpty => 'No Vice Principal yet.';

  @override
  String get memJobTitle => 'Job title (e.g. Van driver)';

  @override
  String get memShowRemoved => 'Include removed';

  @override
  String get memRemove => 'Remove';

  @override
  String get memRestore => 'Restore';

  @override
  String memRemoveAsk(String name) {
    return 'Remove $name? They can no longer sign in.';
  }

  @override
  String get memResetPassword => 'Set a new password';

  @override
  String get memPasswordChanged => 'Password changed';

  @override
  String get memEmailHint => 'They sign in with this email';

  @override
  String get navLessons => 'My lessons';

  @override
  String get tchAllotments => 'Classes';

  @override
  String get tchLessonBoard => 'Daily lessons';

  @override
  String get tchAllot => 'Allot a class';

  @override
  String get tchAllotmentsEmpty => 'No class is allotted yet.';

  @override
  String get tchTeacher => 'Teacher';

  @override
  String get tchSubject => 'Subject';

  @override
  String tchRemoveAllotmentAsk(String subject, String name) {
    return 'Take $subject of $name back from this teacher?';
  }

  @override
  String get tchRecorded => 'Recorded';

  @override
  String get tchPending => 'Not recorded yet';

  @override
  String get tchBoardEmpty =>
      'No class is allotted, so there is nothing to record.';

  @override
  String get tchRecordLesson => 'Record today\'s lesson';

  @override
  String get tchEditLesson => 'Change the lesson';

  @override
  String get tchTopic => 'What was taught';

  @override
  String get tchLessonsEmpty => 'No lessons recorded yet.';

  @override
  String get tchMyClasses => 'My classes';

  @override
  String get tchRecentLessons => 'Recent lessons';

  @override
  String tchClassSubject(String name, String subject) {
    return '$name · $subject';
  }

  @override
  String get tchDayPick => 'Day';

  @override
  String get fltVans => 'Vans';

  @override
  String get fltFuelBills => 'Fuel bills';

  @override
  String get fltVanAdd => 'Add van';

  @override
  String get fltVanEdit => 'Edit van';

  @override
  String get fltVanName => 'Van name or number';

  @override
  String get fltDriver => 'Driver';

  @override
  String get fltNoDriver => 'No driver';

  @override
  String get fltVansEmpty => 'No vans yet.';

  @override
  String get fltBillsEmpty => 'No fuel bills.';

  @override
  String get fltBillAdd => 'Add fuel bill';

  @override
  String get fltFuelType => 'Fuel';

  @override
  String get fltPetrol => 'Petrol';

  @override
  String get fltDiesel => 'Diesel';

  @override
  String get fltLitres => 'Litres';

  @override
  String get fltRate => 'Rate per litre';

  @override
  String get fltOdometer => 'Odometer (km)';

  @override
  String get fltBilledOn => 'Bill date';

  @override
  String get fltVan => 'Van';

  @override
  String get fltStatusPending => 'Pending';

  @override
  String get fltStatusApproved => 'Approved';

  @override
  String get fltStatusRejected => 'Rejected';

  @override
  String get fltAllStatuses => 'All';

  @override
  String get fltWithdraw => 'Withdraw';

  @override
  String get fltApprove => 'Approve';

  @override
  String get fltReject => 'Reject';

  @override
  String get fltRejectReason => 'Reason';

  @override
  String fltMileage(String km, String kpl) {
    return '$km km · $kpl km/l';
  }

  @override
  String fltBillLine(String litres, String rate) {
    return '$litres L at $rate';
  }

  @override
  String fltSubmittedBy(String name) {
    return 'By $name';
  }

  @override
  String fltRejectedWhy(String reason) {
    return 'Rejected: $reason';
  }

  @override
  String get fltNoVanForDriver => 'You have not been given a van yet.';

  @override
  String get attStudentsTab => 'Students';

  @override
  String get attReportTab => 'Report';

  @override
  String get attMineTab => 'My attendance';

  @override
  String get attPeopleTab => 'Teachers & staff';

  @override
  String get attPresent => 'Present';

  @override
  String get attLate => 'Late';

  @override
  String get attAbsent => 'Absent';

  @override
  String get attLeave => 'On leave';

  @override
  String get attHoliday => 'Holiday';

  @override
  String get attNotInYet => 'Not in yet';

  @override
  String get attMarkAll => 'Mark all present';

  @override
  String get attSave => 'Save attendance';

  @override
  String get attSaved => 'Attendance saved';

  @override
  String get attPickClass => 'Choose a class';

  @override
  String get attRosterEmpty => 'No students in this class.';

  @override
  String get attCheckIn => 'Check in';

  @override
  String get attCheckOut => 'Check out';

  @override
  String attCheckedInAt(String time) {
    return 'In $time';
  }

  @override
  String attCheckedOutAt(String time) {
    return 'Out $time';
  }

  @override
  String get attMineEmpty => 'No attendance recorded yet.';

  @override
  String get attBoardEmpty => 'No one to show.';

  @override
  String get attHolidayToday => 'This day is a holiday.';

  @override
  String get attAllRoles => 'Everyone';

  @override
  String get attRoleTeachers => 'Teachers';

  @override
  String get attRoleStaff => 'Staff';

  @override
  String get attCorrect => 'Correct the times';

  @override
  String get attCheckInTime => 'Check-in time';

  @override
  String get attCheckOutTime => 'Check-out time (optional)';

  @override
  String attTally(int present, int late, int absent) {
    return '$present present · $late late · $absent absent';
  }

  @override
  String get attRange => 'Period';

  @override
  String get attReportNeedsRange => 'Choose a period to see the report.';

  @override
  String get attDay => 'Day';

  @override
  String get reqTitle => 'Requests';

  @override
  String get reqEmpty => 'No requests.';

  @override
  String get reqRaiseLeave => 'Ask for leave';

  @override
  String get reqRaiseMeeting => 'Ask for a meeting';

  @override
  String get reqKindLeave => 'Leave';

  @override
  String get reqKindMeeting => 'Meeting';

  @override
  String get reqAllKinds => 'All';

  @override
  String get reqStatusPending => 'Pending';

  @override
  String get reqStatusApproved => 'Approved';

  @override
  String get reqStatusRejected => 'Rejected';

  @override
  String get reqStatusWithdrawn => 'Withdrawn';

  @override
  String get reqFrom => 'From';

  @override
  String get reqTo => 'To';

  @override
  String get reqReason => 'Reason';

  @override
  String get reqSubject => 'Subject';

  @override
  String get reqDetails => 'Details (optional)';

  @override
  String get reqPreferredOn => 'Preferred day (optional)';

  @override
  String get reqSend => 'Send';

  @override
  String get reqWithdraw => 'Withdraw';

  @override
  String get reqApprove => 'Approve';

  @override
  String get reqReject => 'Reject';

  @override
  String get reqRejectReason => 'Reason for rejecting';

  @override
  String get reqMeetingOn => 'Meeting day';

  @override
  String get reqMeetingAt => 'Meeting time';

  @override
  String reqBy(String name) {
    return 'From $name';
  }

  @override
  String reqDecidedBy(String name, String date) {
    return '$name on $date';
  }

  @override
  String reqMeetingFixed(String date, String time) {
    return 'Meeting on $date at $time';
  }

  @override
  String reqNote(String note) {
    return 'Note: $note';
  }

  @override
  String get exmTitle => 'Exams';

  @override
  String get exmTabExams => 'Exams';

  @override
  String get exmTabBank => 'Question bank';

  @override
  String get exmSchedule => 'Schedule exam';

  @override
  String get exmEdit => 'Change exam';

  @override
  String get exmEmpty => 'No exams found.';

  @override
  String get exmType => 'Kind of exam';

  @override
  String get exmTypeUnitTest => 'Unit test';

  @override
  String get exmTypeMidTerm => 'Mid-term';

  @override
  String get exmTypeAnnual => 'Annual';

  @override
  String get exmSubject => 'Subject';

  @override
  String get exmHeldOn => 'Exam day';

  @override
  String get exmMaxMarks => 'Total marks';

  @override
  String get exmAwaiting => 'Papers awaiting approval';

  @override
  String get exmRemoveAsk => 'Remove this exam?';

  @override
  String exmTeacher(String name) {
    return 'Teacher: $name';
  }

  @override
  String exmMarksOf(int marks, String max) {
    return '$marks of $max';
  }

  @override
  String get exmEnterMarks => 'Enter marks';

  @override
  String get exmMarksSave => 'Save marks';

  @override
  String get exmAbsent => 'Absent';

  @override
  String get exmMarksField => 'Marks';

  @override
  String get exmMarksTooHigh => 'More than the total marks';

  @override
  String get exmResults => 'Results';

  @override
  String exmResultsStats(String entered, int absent) {
    return '$entered entered · $absent absent';
  }

  @override
  String exmAverage(String value) {
    return 'Average $value%';
  }

  @override
  String exmHighLow(String high, String low) {
    return 'Highest $high · Lowest $low';
  }

  @override
  String get exmNotEntered => 'Not entered';

  @override
  String get exmPaper => 'Question paper';

  @override
  String get exmPaperNone => 'No paper yet.';

  @override
  String get exmPaperCompose => 'Choose questions';

  @override
  String get exmPaperSend => 'Send for approval';

  @override
  String get exmPaperApprove => 'Approve paper';

  @override
  String get exmPaperReject => 'Send back';

  @override
  String get exmPaperStatusDraft => 'Draft';

  @override
  String get exmPaperStatusSent => 'Waiting for approval';

  @override
  String get exmPaperStatusApproved => 'Approved';

  @override
  String get exmPaperStatusRejected => 'Sent back';

  @override
  String exmPaperTotal(int marks) {
    return 'Total $marks marks';
  }

  @override
  String exmPaperNote(String note) {
    return 'Note: $note';
  }

  @override
  String get exmPaperBankEmpty =>
      'No questions yet for this class and subject. Add them in the question bank.';

  @override
  String exmPaperUse(int count) {
    return 'Use $count questions';
  }

  @override
  String get exmReason => 'Reason';

  @override
  String get qbUnitAdd => 'Add unit';

  @override
  String get qbUnitEdit => 'Change unit';

  @override
  String get qbUnitName => 'Unit name';

  @override
  String get qbUnitsEmpty => 'No units yet.';

  @override
  String get qbQuestionAdd => 'Add question';

  @override
  String get qbQuestionEdit => 'Change question';

  @override
  String get qbQuestionText => 'Question';

  @override
  String get qbQuestionMarks => 'Marks';

  @override
  String get qbQuestionType => 'Kind of question';

  @override
  String get qbTypeMcq => 'Multiple choice';

  @override
  String get qbTypeShort => 'Short answer';

  @override
  String get qbTypeLong => 'Long answer';

  @override
  String get qbQuestionsEmpty => 'No questions in this unit yet.';

  @override
  String qbUnitBy(String teacher, String cls, String subject) {
    return '$teacher · $cls · $subject';
  }

  @override
  String get exmStudentResults => 'Exam results';

  @override
  String exmStudentTotal(String obtained, String outOf, String pct) {
    return 'Total $obtained of $outOf ($pct%)';
  }

  @override
  String get exmStudentEmpty => 'No exams yet.';

  @override
  String get payTitle => 'Payments';

  @override
  String get payTabTeachers => 'Teachers';

  @override
  String get payTabStaff => 'Staff';

  @override
  String get payTabMine => 'My account';

  @override
  String get payEmpty => 'No one to show.';

  @override
  String get paySalary => 'Salary';

  @override
  String get payFuelBill => 'Fuel bill';

  @override
  String paySalaryNow(String amount) {
    return 'Salary $amount a month';
  }

  @override
  String get paySalaryNone => 'Salary not set';

  @override
  String get paySetSalary => 'Set salary';

  @override
  String get paySalaryFrom => 'From month';

  @override
  String get paySalaryHistory => 'Salary history';

  @override
  String payFrom(String month) {
    return 'from $month';
  }

  @override
  String payBalance(String amount) {
    return 'To pay $amount';
  }

  @override
  String payTotals(String due, String paid) {
    return 'Due $due · Paid $paid';
  }

  @override
  String payLineDue(String label, String due, String paid) {
    return '$label: due $due, paid $paid';
  }

  @override
  String get payPay => 'Pay';

  @override
  String get payMode => 'How paid';

  @override
  String get payHistory => 'Payments made';

  @override
  String get payHistoryEmpty => 'No payments yet.';

  @override
  String payReceipt(String no) {
    return 'Receipt $no';
  }

  @override
  String get payNothingDue => 'Nothing is due.';

  @override
  String payFuelOn(String van, String date) {
    return '$van · $date';
  }

  @override
  String get anaTitle => 'Analytics';

  @override
  String get anaStudentAttendance => 'Student attendance';

  @override
  String get anaFees => 'Fees';

  @override
  String get anaExams => 'Exam results';

  @override
  String get anaStaffAttendance => 'Teacher & staff attendance';

  @override
  String get anaPayments => 'Payments to staff';

  @override
  String get anaFuel => 'Fuel';

  @override
  String get anaLessons => 'Daily lessons';

  @override
  String get anaSeriesAttendance => 'Attendance %';

  @override
  String get anaSeriesFeesCollected => 'Fees collected each month';

  @override
  String get anaSeriesFeesBalance => 'Fees still to come, by class';

  @override
  String get anaSeriesExamAverage => 'Average % in each exam';

  @override
  String get anaSeriesStaffPresent => 'Came in';

  @override
  String get anaSeriesStaffAbsent => 'Absent or on leave';

  @override
  String get anaSeriesPaidOut => 'Paid out each month';

  @override
  String get anaSeriesFuelAmount => 'Fuel spent';

  @override
  String get anaSeriesFuelMileage => 'Kilometres per litre';

  @override
  String get anaSeriesLessons => 'Lessons recorded %';

  @override
  String get anaSumCollected => 'Collected';

  @override
  String get anaSumBalance => 'Still to come';

  @override
  String get anaSumOwed => 'Still owed to staff';

  @override
  String get anaSumPaid => 'Paid out';

  @override
  String get anaEmpty => 'Nothing to draw for this period.';

  @override
  String get anaPeriod => 'Period';

  @override
  String get perTitle => 'What this person may do';

  @override
  String get perReason => 'Why are you giving this?';

  @override
  String get perGive => 'Allow';

  @override
  String perTakeBackAsk(String label) {
    return 'Take back “$label”?';
  }

  @override
  String get perTakeBack => 'Take back';

  @override
  String perReasonShown(String reason) {
    return 'Reason: $reason';
  }

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeAreas => 'Your areas';

  @override
  String get homeLatestNotice => 'Latest notice';

  @override
  String get homeNoNotice => 'No notices yet.';

  @override
  String get betaNotice =>
      'Beta version: you may see changes or errors while we improve the app.';

  @override
  String get betaBadge => 'BETA';

  @override
  String get navExamTimetable => 'Exam Timetable';

  @override
  String get ttbSettings => 'Timetable settings';

  @override
  String get ttbPickClass => 'Choose a class to make its timetable.';

  @override
  String get ttbNoSubjects =>
      'No subject of this class has a teacher yet. Allot teachers first.';

  @override
  String get ttbSkipHint => 'Leave a subject without a date to skip it.';

  @override
  String get ttbDate => 'Date';

  @override
  String get ttbStart => 'Start time';

  @override
  String get ttbMarks => 'Marks';

  @override
  String get ttbDuration => 'Minutes';

  @override
  String get ttbSave => 'Save timetable';

  @override
  String get ttbSaved => 'Timetable saved.';

  @override
  String get ttbNote => 'Please note';

  @override
  String get ttbSavedHeading => 'Saved timetable';

  @override
  String get ttbNoneSaved => 'Nothing is scheduled yet for this class.';

  @override
  String get ttbSetMarks => 'Default marks';

  @override
  String get ttbSetDuration => 'Default duration (minutes)';

  @override
  String get ttbSetStart => 'Default start time';

  @override
  String get ttbSetShowTime => 'Show start time and duration';

  @override
  String get ttbSetSameDay => 'Two papers on one day';

  @override
  String get ttbRuleAllow => 'Allow';

  @override
  String get ttbRuleWarn => 'Warn';

  @override
  String get ttbRuleBlock => 'Block';

  @override
  String get ttbSetGap => 'Free days needed between papers';

  @override
  String get ttbSetOffDays => 'Weekly holidays';

  @override
  String get ttbSetOffDates => 'Holiday dates';

  @override
  String get ttbAddDate => 'Add a date';

  @override
  String get ttbSetNames => 'Exam names';

  @override
  String get ttbSettingsSaved => 'Settings saved.';

  @override
  String get ttbHoliday => 'Holiday';
}
