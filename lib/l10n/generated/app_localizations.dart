import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Shiksha Setu'**
  String get appName;

  /// No description provided for @roleLabelPrincipal.
  ///
  /// In en, this message translates to:
  /// **'Principal'**
  String get roleLabelPrincipal;

  /// No description provided for @roleLabelTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get roleLabelTeacher;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navDashboard;

  /// No description provided for @navAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get navAttendance;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get actionSignIn;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get actionSignOut;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get errorPasswordRequired;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errorInvalidCredentials;

  /// No description provided for @loginDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo accounts — tap to fill'**
  String get loginDemoTitle;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String greetingMorning(String name);

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String greetingAfternoon(String name);

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String greetingEvening(String name);

  /// No description provided for @roleAndDate.
  ///
  /// In en, this message translates to:
  /// **'{role} · {date}'**
  String roleAndDate(String role, String date);

  /// No description provided for @dayOpen.
  ///
  /// In en, this message translates to:
  /// **'School is open today'**
  String get dayOpen;

  /// No description provided for @dayClosed.
  ///
  /// In en, this message translates to:
  /// **'School is closed today'**
  String get dayClosed;

  /// No description provided for @dayPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the Principal to approve'**
  String get dayPending;

  /// No description provided for @actionApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get actionApprove;

  /// No description provided for @actionKeepClosed.
  ///
  /// In en, this message translates to:
  /// **'Keep school closed'**
  String get actionKeepClosed;

  /// No description provided for @actionChangeDecision.
  ///
  /// In en, this message translates to:
  /// **'Change decision'**
  String get actionChangeDecision;

  /// No description provided for @sectionTodayAtGlance.
  ///
  /// In en, this message translates to:
  /// **'Today at a glance'**
  String get sectionTodayAtGlance;

  /// No description provided for @sectionMyDay.
  ///
  /// In en, this message translates to:
  /// **'My day'**
  String get sectionMyDay;

  /// No description provided for @statTeachersPresent.
  ///
  /// In en, this message translates to:
  /// **'Teachers present'**
  String get statTeachersPresent;

  /// No description provided for @statStudentsPresent.
  ///
  /// In en, this message translates to:
  /// **'Students present'**
  String get statStudentsPresent;

  /// No description provided for @statClassesMarked.
  ///
  /// In en, this message translates to:
  /// **'Classes marked'**
  String get statClassesMarked;

  /// No description provided for @statTeachersNotIn.
  ///
  /// In en, this message translates to:
  /// **'Teachers not in'**
  String get statTeachersNotIn;

  /// No description provided for @statCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get statCheckedIn;

  /// No description provided for @statNotCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Not checked in'**
  String get statNotCheckedIn;

  /// No description provided for @statPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get statPresent;

  /// No description provided for @statNotInYet.
  ///
  /// In en, this message translates to:
  /// **'Not in yet'**
  String get statNotInYet;

  /// No description provided for @statClassAttendance.
  ///
  /// In en, this message translates to:
  /// **'Student attendance: Class {name}'**
  String statClassAttendance(String name);

  /// No description provided for @valueDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get valueDone;

  /// No description provided for @valuePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get valuePending;

  /// No description provided for @valueOutOf.
  ///
  /// In en, this message translates to:
  /// **'{value}/{total}'**
  String valueOutOf(int value, int total);

  /// No description provided for @attendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTitle;

  /// No description provided for @tabTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get tabTeachers;

  /// No description provided for @tabStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get tabStudents;

  /// No description provided for @tabMyAttendance.
  ///
  /// In en, this message translates to:
  /// **'My Attendance'**
  String get tabMyAttendance;

  /// No description provided for @sectionMyAttendanceToday.
  ///
  /// In en, this message translates to:
  /// **'My attendance today'**
  String get sectionMyAttendanceToday;

  /// No description provided for @sectionClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get sectionClasses;

  /// No description provided for @labelCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get labelCheckIn;

  /// No description provided for @labelCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get labelCheckOut;

  /// No description provided for @labelWorked.
  ///
  /// In en, this message translates to:
  /// **'Worked'**
  String get labelWorked;

  /// No description provided for @actionCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get actionCheckIn;

  /// No description provided for @actionCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get actionCheckOut;

  /// No description provided for @noticeCheckInLocked.
  ///
  /// In en, this message translates to:
  /// **'You can check in after the Principal says school is open today.'**
  String get noticeCheckInLocked;

  /// No description provided for @noticeCheckedOut.
  ///
  /// In en, this message translates to:
  /// **'You have checked out. See you tomorrow!'**
  String get noticeCheckedOut;

  /// No description provided for @chipNotIn.
  ///
  /// In en, this message translates to:
  /// **'Not in'**
  String get chipNotIn;

  /// No description provided for @chipCheckedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked out'**
  String get chipCheckedOut;

  /// No description provided for @chipInSchool.
  ///
  /// In en, this message translates to:
  /// **'In school'**
  String get chipInSchool;

  /// No description provided for @chipNotMarked.
  ///
  /// In en, this message translates to:
  /// **'Not marked'**
  String get chipNotMarked;

  /// No description provided for @chipMarkNow.
  ///
  /// In en, this message translates to:
  /// **'Mark now'**
  String get chipMarkNow;

  /// No description provided for @chipDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get chipDone;

  /// No description provided for @timeInOut.
  ///
  /// In en, this message translates to:
  /// **'In {inTime}  ·  Out {outTime}'**
  String timeInOut(String inTime, String outTime);

  /// No description provided for @classTitle.
  ///
  /// In en, this message translates to:
  /// **'Class {name}'**
  String classTitle(String name);

  /// No description provided for @classNotMarkedYet.
  ///
  /// In en, this message translates to:
  /// **'Not marked yet'**
  String get classNotMarkedYet;

  /// No description provided for @classPresentOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{present} of {total} present'**
  String classPresentOfTotal(int present, int total);

  /// No description provided for @classPresentAbsent.
  ///
  /// In en, this message translates to:
  /// **'{present} present · {absent} absent'**
  String classPresentAbsent(int present, int absent);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @actionMarkAllPresent.
  ///
  /// In en, this message translates to:
  /// **'Mark all present'**
  String get actionMarkAllPresent;

  /// No description provided for @actionSaveAttendance.
  ///
  /// In en, this message translates to:
  /// **'Save Attendance'**
  String get actionSaveAttendance;

  /// No description provided for @messageAttendanceSaved.
  ///
  /// In en, this message translates to:
  /// **'Attendance saved'**
  String get messageAttendanceSaved;

  /// No description provided for @statusPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get statusPresent;

  /// No description provided for @statusAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get statusAbsent;

  /// No description provided for @statusLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get statusLate;

  /// No description provided for @statusPresentShort.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get statusPresentShort;

  /// No description provided for @statusAbsentShort.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get statusAbsentShort;

  /// No description provided for @statusLateShort.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get statusLateShort;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verifying'**
  String get verifyTitle;

  /// No description provided for @verifyLocation.
  ///
  /// In en, this message translates to:
  /// **'Checking school location'**
  String get verifyLocation;

  /// No description provided for @verifyFace.
  ///
  /// In en, this message translates to:
  /// **'Verifying face'**
  String get verifyFace;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEmployeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get profileEmployeeId;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get profileJoined;

  /// No description provided for @profileSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get profileSubject;

  /// No description provided for @profileClassTeacherOf.
  ///
  /// In en, this message translates to:
  /// **'Class teacher of'**
  String get profileClassTeacherOf;

  /// No description provided for @profileAdminNote.
  ///
  /// In en, this message translates to:
  /// **'As Principal, you can approve school days and see everyone\'s attendance.'**
  String get profileAdminNote;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @moduleExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get moduleExams;

  /// No description provided for @moduleAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get moduleAnalytics;

  /// No description provided for @moduleFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get moduleFees;

  /// No description provided for @moduleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Add student or staff'**
  String get moduleRegistration;

  /// No description provided for @moduleTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get moduleTeachers;

  /// No description provided for @moduleNotices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get moduleNotices;

  /// No description provided for @sectionQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get sectionQuickAccess;

  /// No description provided for @examsTitle.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get examsTitle;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Not held yet'**
  String get tabUpcoming;

  /// No description provided for @tabPastPapers.
  ///
  /// In en, this message translates to:
  /// **'Past papers'**
  String get tabPastPapers;

  /// No description provided for @actionCreatePaper.
  ///
  /// In en, this message translates to:
  /// **'Create paper'**
  String get actionCreatePaper;

  /// No description provided for @emptyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming or draft papers yet.\nTap \"Create paper\" to add one.'**
  String get emptyUpcoming;

  /// No description provided for @emptyPast.
  ///
  /// In en, this message translates to:
  /// **'No conducted papers yet.'**
  String get emptyPast;

  /// No description provided for @paperStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get paperStatusDraft;

  /// No description provided for @paperStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get paperStatusScheduled;

  /// No description provided for @paperStatusConducted.
  ///
  /// In en, this message translates to:
  /// **'Exam held'**
  String get paperStatusConducted;

  /// No description provided for @paperSubjectClass.
  ///
  /// In en, this message translates to:
  /// **'{subject} · Class {cls}'**
  String paperSubjectClass(String subject, String cls);

  /// No description provided for @paperMarksDuration.
  ///
  /// In en, this message translates to:
  /// **'{marks} marks · {minutes} min'**
  String paperMarksDuration(int marks, int minutes);

  /// No description provided for @sectionQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get sectionQuestions;

  /// No description provided for @questionNumber.
  ///
  /// In en, this message translates to:
  /// **'Q{n}'**
  String questionNumber(int n);

  /// No description provided for @marksShort.
  ///
  /// In en, this message translates to:
  /// **'{marks} marks'**
  String marksShort(int marks);

  /// No description provided for @createPaperTitle.
  ///
  /// In en, this message translates to:
  /// **'New question paper'**
  String get createPaperTitle;

  /// No description provided for @fieldPaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Paper title'**
  String get fieldPaperTitle;

  /// No description provided for @fieldSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get fieldSubject;

  /// No description provided for @fieldClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get fieldClass;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get fieldDuration;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @fieldQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get fieldQuestion;

  /// No description provided for @fieldMarks.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get fieldMarks;

  /// No description provided for @paperTotalMarks.
  ///
  /// In en, this message translates to:
  /// **'Total {marks} marks'**
  String paperTotalMarks(int marks);

  /// No description provided for @actionAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get actionAddQuestion;

  /// No description provided for @actionSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get actionSaveDraft;

  /// No description provided for @actionSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get actionSchedule;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get errorRequired;

  /// No description provided for @messagePaperSaved.
  ///
  /// In en, this message translates to:
  /// **'Paper saved'**
  String get messagePaperSaved;

  /// No description provided for @feesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get feesTitle;

  /// No description provided for @tabOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get tabOthers;

  /// No description provided for @feesCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get feesCollected;

  /// No description provided for @feesPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get feesPending;

  /// No description provided for @feesTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get feesTotal;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchByName;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @feeStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get feeStatusPaid;

  /// No description provided for @feeStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get feeStatusPartial;

  /// No description provided for @feeStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get feeStatusOverdue;

  /// No description provided for @feeStatusDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get feeStatusDue;

  /// No description provided for @feePaidOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{paid} of {total} paid'**
  String feePaidOfTotal(String paid, String total);

  /// No description provided for @feeDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due on {date}'**
  String feeDueOn(String date);

  /// No description provided for @fieldAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fieldAmount;

  /// No description provided for @errorAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get errorAmountInvalid;

  /// No description provided for @errorAmountExceeds.
  ///
  /// In en, this message translates to:
  /// **'Cannot exceed the pending amount'**
  String get errorAmountExceeds;

  /// No description provided for @actionRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get actionRecordPayment;

  /// No description provided for @messagePaymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded'**
  String get messagePaymentRecorded;

  /// No description provided for @emptyNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching records.'**
  String get emptyNoResults;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Add student or staff'**
  String get registrationTitle;

  /// No description provided for @personStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get personStudent;

  /// No description provided for @personTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get personTeacher;

  /// No description provided for @personOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get personOther;

  /// No description provided for @actionRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get actionRegister;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @fieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fieldFullName;

  /// No description provided for @fieldAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number'**
  String get fieldAadhaar;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get fieldPhone;

  /// No description provided for @fieldGuardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian name'**
  String get fieldGuardian;

  /// No description provided for @fieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role (e.g. Van driver)'**
  String get fieldRole;

  /// No description provided for @aadhaarHelper.
  ///
  /// In en, this message translates to:
  /// **'We check the number but save only its last 4 digits.'**
  String get aadhaarHelper;

  /// No description provided for @fieldAadhaarReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for no Aadhaar number'**
  String get fieldAadhaarReason;

  /// No description provided for @hintAadhaarReason.
  ///
  /// In en, this message translates to:
  /// **'e.g. Aadhaar not yet made, card lost, applied and awaited'**
  String get hintAadhaarReason;

  /// No description provided for @errorAadhaarInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 12-digit Aadhaar number'**
  String get errorAadhaarInvalid;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number'**
  String get errorPhoneInvalid;

  /// No description provided for @messageRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get messageRegistered;

  /// No description provided for @registeredOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered {date}'**
  String registeredOnLabel(String date);

  /// No description provided for @emptyPeople.
  ///
  /// In en, this message translates to:
  /// **'No one registered yet.'**
  String get emptyPeople;

  /// No description provided for @staffTitle.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get staffTitle;

  /// No description provided for @emptyStaff.
  ///
  /// In en, this message translates to:
  /// **'No teachers found.'**
  String get emptyStaff;

  /// No description provided for @staffActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get staffActive;

  /// No description provided for @staffInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get staffInactive;

  /// No description provided for @staffNoClass.
  ///
  /// In en, this message translates to:
  /// **'No class assigned'**
  String get staffNoClass;

  /// No description provided for @staffClassTeacher.
  ///
  /// In en, this message translates to:
  /// **'Class teacher of {cls}'**
  String staffClassTeacher(String cls);

  /// No description provided for @sheetAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign class to {name}'**
  String sheetAssignTitle(String name);

  /// No description provided for @classTakenBy.
  ///
  /// In en, this message translates to:
  /// **'Already assigned to {name}'**
  String classTakenBy(String name);

  /// No description provided for @actionRemoveAssignment.
  ///
  /// In en, this message translates to:
  /// **'Remove class assignment'**
  String get actionRemoveAssignment;

  /// No description provided for @noticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get noticesTitle;

  /// No description provided for @actionPostNotice.
  ///
  /// In en, this message translates to:
  /// **'Post notice'**
  String get actionPostNotice;

  /// No description provided for @emptyNotices.
  ///
  /// In en, this message translates to:
  /// **'No notices yet.'**
  String get emptyNotices;

  /// No description provided for @fieldNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldNoticeTitle;

  /// No description provided for @fieldNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get fieldNoticeBody;

  /// No description provided for @messageNoticePosted.
  ///
  /// In en, this message translates to:
  /// **'Notice posted'**
  String get messageNoticePosted;

  /// No description provided for @noticePostedBy.
  ///
  /// In en, this message translates to:
  /// **'Posted by {name} · {date}'**
  String noticePostedBy(String name, String date);

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @sectionAttendanceTrend.
  ///
  /// In en, this message translates to:
  /// **'Attendance — last 7 days (%)'**
  String get sectionAttendanceTrend;

  /// No description provided for @sectionSubjectAverages.
  ///
  /// In en, this message translates to:
  /// **'Average marks by subject (%)'**
  String get sectionSubjectAverages;

  /// No description provided for @sectionFeeCollection.
  ///
  /// In en, this message translates to:
  /// **'Fee collection'**
  String get sectionFeeCollection;

  /// No description provided for @sectionTeacherReport.
  ///
  /// In en, this message translates to:
  /// **'Teacher report'**
  String get sectionTeacherReport;

  /// No description provided for @avgCheckInLabel.
  ///
  /// In en, this message translates to:
  /// **'Average check-in {time}'**
  String avgCheckInLabel(String time);

  /// No description provided for @percentValue.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String percentValue(int percent);

  /// No description provided for @dialogUnsavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get dialogUnsavedTitle;

  /// No description provided for @dialogUnsavedBody.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved attendance changes.'**
  String get dialogUnsavedBody;

  /// No description provided for @actionKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get actionKeepEditing;

  /// No description provided for @actionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get actionDiscard;

  /// No description provided for @moduleClasses.
  ///
  /// In en, this message translates to:
  /// **'Manage classes'**
  String get moduleClasses;

  /// No description provided for @classesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage classes'**
  String get classesTitle;

  /// No description provided for @actionAddClass.
  ///
  /// In en, this message translates to:
  /// **'Add class'**
  String get actionAddClass;

  /// No description provided for @actionEditClass.
  ///
  /// In en, this message translates to:
  /// **'Edit class'**
  String get actionEditClass;

  /// No description provided for @fieldClassName.
  ///
  /// In en, this message translates to:
  /// **'Class name'**
  String get fieldClassName;

  /// No description provided for @hintClassName.
  ///
  /// In en, this message translates to:
  /// **'e.g. 9-A'**
  String get hintClassName;

  /// No description provided for @errorClassExists.
  ///
  /// In en, this message translates to:
  /// **'This class already exists'**
  String get errorClassExists;

  /// No description provided for @classStudentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 student} other{{count} students}}'**
  String classStudentCount(int count);

  /// No description provided for @classNoTeacher.
  ///
  /// In en, this message translates to:
  /// **'No class teacher'**
  String get classNoTeacher;

  /// No description provided for @dialogDeleteClassTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete class {name}?'**
  String dialogDeleteClassTitle(String name);

  /// No description provided for @dialogDeleteClassBody.
  ///
  /// In en, this message translates to:
  /// **'This will delete the class, its {count} students and their attendance. You cannot undo this.'**
  String dialogDeleteClassBody(int count);

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @feesFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get feesFilters;

  /// No description provided for @feesFilterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get feesFilterStatus;

  /// No description provided for @feesFilterClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get feesFilterClass;

  /// No description provided for @feesFilterDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get feesFilterDueDate;

  /// No description provided for @feesFilterSort.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get feesFilterSort;

  /// No description provided for @feesSortUrgency.
  ///
  /// In en, this message translates to:
  /// **'Most urgent'**
  String get feesSortUrgency;

  /// No description provided for @feesSortName.
  ///
  /// In en, this message translates to:
  /// **'Name (A to Z)'**
  String get feesSortName;

  /// No description provided for @feesSortPending.
  ///
  /// In en, this message translates to:
  /// **'Highest pending'**
  String get feesSortPending;

  /// No description provided for @feesSortDue.
  ///
  /// In en, this message translates to:
  /// **'Earliest due date'**
  String get feesSortDue;

  /// No description provided for @feesClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get feesClearAll;

  /// No description provided for @feesShowResults.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get feesShowResults;

  /// No description provided for @feesResultSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} found · {pending} pending'**
  String feesResultSummary(int count, String pending);

  /// No description provided for @feeRollNo.
  ///
  /// In en, this message translates to:
  /// **'Roll {roll}'**
  String feeRollNo(int roll);

  /// No description provided for @dateAnyTime.
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get dateAnyTime;

  /// No description provided for @datePickRange.
  ///
  /// In en, this message translates to:
  /// **'Pick dates'**
  String get datePickRange;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get dateThisWeek;

  /// No description provided for @dateThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get dateThisMonth;

  /// No description provided for @paymentsFilterDate.
  ///
  /// In en, this message translates to:
  /// **'Paid on'**
  String get paymentsFilterDate;

  /// No description provided for @paymentsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} payments · {amount}'**
  String paymentsSummary(int count, String amount);

  /// No description provided for @paymentsNone.
  ///
  /// In en, this message translates to:
  /// **'No payments match these filters.'**
  String get paymentsNone;

  /// No description provided for @paymentsOf.
  ///
  /// In en, this message translates to:
  /// **'Payments: {name}'**
  String paymentsOf(String name);

  /// No description provided for @staffAddTeacher.
  ///
  /// In en, this message translates to:
  /// **'Add teacher'**
  String get staffAddTeacher;

  /// No description provided for @staffActionAssignClass.
  ///
  /// In en, this message translates to:
  /// **'Assign class'**
  String get staffActionAssignClass;

  /// No description provided for @qtMcq.
  ///
  /// In en, this message translates to:
  /// **'Multiple choice'**
  String get qtMcq;

  /// No description provided for @qtTrueFalse.
  ///
  /// In en, this message translates to:
  /// **'True / False'**
  String get qtTrueFalse;

  /// No description provided for @qtFillBlank.
  ///
  /// In en, this message translates to:
  /// **'Fill in the blank'**
  String get qtFillBlank;

  /// No description provided for @qtMatch.
  ///
  /// In en, this message translates to:
  /// **'Match the following'**
  String get qtMatch;

  /// No description provided for @qtShort.
  ///
  /// In en, this message translates to:
  /// **'Short answer'**
  String get qtShort;

  /// No description provided for @qtLong.
  ///
  /// In en, this message translates to:
  /// **'Long answer'**
  String get qtLong;

  /// No description provided for @qtMcqHint.
  ///
  /// In en, this message translates to:
  /// **'A question with several options'**
  String get qtMcqHint;

  /// No description provided for @qtTrueFalseHint.
  ///
  /// In en, this message translates to:
  /// **'A statement to mark true or false'**
  String get qtTrueFalseHint;

  /// No description provided for @qtFillBlankHint.
  ///
  /// In en, this message translates to:
  /// **'A sentence with a blank to fill'**
  String get qtFillBlankHint;

  /// No description provided for @qtMatchHint.
  ///
  /// In en, this message translates to:
  /// **'Join the items of two columns'**
  String get qtMatchHint;

  /// No description provided for @qtShortHint.
  ///
  /// In en, this message translates to:
  /// **'Answered in a line or two'**
  String get qtShortHint;

  /// No description provided for @qtLongHint.
  ///
  /// In en, this message translates to:
  /// **'Answered in detail'**
  String get qtLongHint;

  /// No description provided for @paperChooseType.
  ///
  /// In en, this message translates to:
  /// **'Choose question type'**
  String get paperChooseType;

  /// No description provided for @paperInstructions.
  ///
  /// In en, this message translates to:
  /// **'General instructions'**
  String get paperInstructions;

  /// No description provided for @paperInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. All questions are compulsory.'**
  String get paperInstructionsHint;

  /// No description provided for @paperAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get paperAddQuestion;

  /// No description provided for @paperScan.
  ///
  /// In en, this message translates to:
  /// **'Scan photo'**
  String get paperScan;

  /// No description provided for @paperPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste text'**
  String get paperPaste;

  /// No description provided for @paperFromMaster.
  ///
  /// In en, this message translates to:
  /// **'Question bank'**
  String get paperFromMaster;

  /// No description provided for @paperSetMarksAll.
  ///
  /// In en, this message translates to:
  /// **'Set marks for all'**
  String get paperSetMarksAll;

  /// No description provided for @paperMarksForAll.
  ///
  /// In en, this message translates to:
  /// **'Marks for every question'**
  String get paperMarksForAll;

  /// No description provided for @paperApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get paperApply;

  /// No description provided for @paperShuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get paperShuffle;

  /// No description provided for @paperShuffleQuestions.
  ///
  /// In en, this message translates to:
  /// **'Shuffle questions'**
  String get paperShuffleQuestions;

  /// No description provided for @paperShuffleOptions.
  ///
  /// In en, this message translates to:
  /// **'Shuffle questions and MCQ options'**
  String get paperShuffleOptions;

  /// No description provided for @paperShuffleNote.
  ///
  /// In en, this message translates to:
  /// **'Questions are mixed only within their own type. For example, MCQs stay with MCQs.'**
  String get paperShuffleNote;

  /// No description provided for @paperDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get paperDuplicate;

  /// No description provided for @paperSaveToMaster.
  ///
  /// In en, this message translates to:
  /// **'Save to question bank'**
  String get paperSaveToMaster;

  /// No description provided for @paperSavedToMaster.
  ///
  /// In en, this message translates to:
  /// **'Saved to the question bank'**
  String get paperSavedToMaster;

  /// No description provided for @paperCheckChip.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get paperCheckChip;

  /// No description provided for @paperFoundN.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question added. Please check it.} other{{count} questions added. Please check them.}}'**
  String paperFoundN(int count);

  /// No description provided for @paperPasteTitle.
  ///
  /// In en, this message translates to:
  /// **'Paste questions'**
  String get paperPasteTitle;

  /// No description provided for @paperPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste or type your questions here. Number each question. Write options as (a) (b) (c).'**
  String get paperPasteHint;

  /// No description provided for @paperPasteAction.
  ///
  /// In en, this message translates to:
  /// **'Add questions'**
  String get paperPasteAction;

  /// No description provided for @paperDragHint.
  ///
  /// In en, this message translates to:
  /// **'Hold and drag to reorder'**
  String get paperDragHint;

  /// No description provided for @optionLabel.
  ///
  /// In en, this message translates to:
  /// **'Option {letter}'**
  String optionLabel(String letter);

  /// No description provided for @qAddOption.
  ///
  /// In en, this message translates to:
  /// **'Add option'**
  String get qAddOption;

  /// No description provided for @qCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get qCorrectAnswer;

  /// No description provided for @qTrue.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get qTrue;

  /// No description provided for @qFalse.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get qFalse;

  /// No description provided for @qBlankHint.
  ///
  /// In en, this message translates to:
  /// **'Type ____ where the blank goes.'**
  String get qBlankHint;

  /// No description provided for @qBlankAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer (for the answer key)'**
  String get qBlankAnswer;

  /// No description provided for @qColumnA.
  ///
  /// In en, this message translates to:
  /// **'Column A'**
  String get qColumnA;

  /// No description provided for @qColumnB.
  ///
  /// In en, this message translates to:
  /// **'Column B'**
  String get qColumnB;

  /// No description provided for @qAddPair.
  ///
  /// In en, this message translates to:
  /// **'Add pair'**
  String get qAddPair;

  /// No description provided for @qCheckMatches.
  ///
  /// In en, this message translates to:
  /// **'Check that each pair is matched correctly.'**
  String get qCheckMatches;

  /// No description provided for @qNeedBlank.
  ///
  /// In en, this message translates to:
  /// **'Add ____ where the blank goes'**
  String get qNeedBlank;

  /// No description provided for @qNeedOptions.
  ///
  /// In en, this message translates to:
  /// **'Add at least two options'**
  String get qNeedOptions;

  /// No description provided for @qNeedPairs.
  ///
  /// In en, this message translates to:
  /// **'Add at least two complete pairs'**
  String get qNeedPairs;

  /// No description provided for @actionSendForApproval.
  ///
  /// In en, this message translates to:
  /// **'Send for approval'**
  String get actionSendForApproval;

  /// No description provided for @actionApproveSave.
  ///
  /// In en, this message translates to:
  /// **'Approve and save'**
  String get actionApproveSave;

  /// No description provided for @paperStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get paperStatusSubmitted;

  /// No description provided for @paperStatusChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes requested'**
  String get paperStatusChanges;

  /// No description provided for @paperStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get paperStatusApproved;

  /// No description provided for @paperTabToApprove.
  ///
  /// In en, this message translates to:
  /// **'To approve'**
  String get paperTabToApprove;

  /// No description provided for @paperTabReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get paperTabReady;

  /// No description provided for @paperTabDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get paperTabDrafts;

  /// No description provided for @paperSetBy.
  ///
  /// In en, this message translates to:
  /// **'Set by {name}'**
  String paperSetBy(String name);

  /// No description provided for @paperAwaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your approval'**
  String get paperAwaitingTitle;

  /// No description provided for @paperAwaitingBody.
  ///
  /// In en, this message translates to:
  /// **'Read the questions. You can change, delete or shuffle them, then approve.'**
  String get paperAwaitingBody;

  /// No description provided for @paperYourStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Sent to the Principal. It will show here once approved.'**
  String get paperYourStatusSubmitted;

  /// No description provided for @paperSentBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Sent back for changes'**
  String get paperSentBackTitle;

  /// No description provided for @actionSendBack.
  ///
  /// In en, this message translates to:
  /// **'Send back'**
  String get actionSendBack;

  /// No description provided for @actionEditPaper.
  ///
  /// In en, this message translates to:
  /// **'Edit paper'**
  String get actionEditPaper;

  /// No description provided for @actionDeletePaper.
  ///
  /// In en, this message translates to:
  /// **'Delete paper'**
  String get actionDeletePaper;

  /// No description provided for @sendBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send back for changes'**
  String get sendBackTitle;

  /// No description provided for @sendBackHint.
  ///
  /// In en, this message translates to:
  /// **'What should be changed?'**
  String get sendBackHint;

  /// No description provided for @paperDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this paper?'**
  String get paperDeleteTitle;

  /// No description provided for @paperDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The paper and its questions will be removed.'**
  String get paperDeleteBody;

  /// No description provided for @messagePaperSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Sent to the Principal for approval'**
  String get messagePaperSubmitted;

  /// No description provided for @messagePaperApproved.
  ///
  /// In en, this message translates to:
  /// **'Paper approved'**
  String get messagePaperApproved;

  /// No description provided for @messagePaperSentBack.
  ///
  /// In en, this message translates to:
  /// **'Sent back to the teacher'**
  String get messagePaperSentBack;

  /// No description provided for @messagePaperShuffled.
  ///
  /// In en, this message translates to:
  /// **'Questions shuffled'**
  String get messagePaperShuffled;

  /// No description provided for @paperPreviewPrint.
  ///
  /// In en, this message translates to:
  /// **'Preview and print'**
  String get paperPreviewPrint;

  /// No description provided for @masterTitle.
  ///
  /// In en, this message translates to:
  /// **'Question bank'**
  String get masterTitle;

  /// No description provided for @masterEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your question bank is empty. Save questions here to use them again in any paper.'**
  String get masterEmpty;

  /// No description provided for @masterAdd.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get masterAdd;

  /// No description provided for @masterEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit question'**
  String get masterEdit;

  /// No description provided for @masterSubjectOptional.
  ///
  /// In en, this message translates to:
  /// **'Subject (optional)'**
  String get masterSubjectOptional;

  /// No description provided for @masterSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to the question bank'**
  String get masterSaved;

  /// No description provided for @masterRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from the question bank'**
  String get masterRemoved;

  /// No description provided for @masterPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick from question bank'**
  String get masterPickTitle;

  /// No description provided for @masterAddSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Select questions} =1{Add 1 question} other{Add {count} questions}}'**
  String masterAddSelected(int count);

  /// No description provided for @masterNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Nothing in the question bank matches.'**
  String get masterNoMatch;

  /// No description provided for @masterRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from the question bank?'**
  String get masterRemoveTitle;

  /// No description provided for @emptyPapersHere.
  ///
  /// In en, this message translates to:
  /// **'No papers here.'**
  String get emptyPapersHere;

  /// No description provided for @categoryExamPaper.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get categoryExamPaper;

  /// No description provided for @approvalExamQuestion.
  ///
  /// In en, this message translates to:
  /// **'A question paper is waiting for your review.'**
  String get approvalExamQuestion;

  /// No description provided for @actionReviewPaper.
  ///
  /// In en, this message translates to:
  /// **'Review paper'**
  String get actionReviewPaper;

  /// No description provided for @logoTitle.
  ///
  /// In en, this message translates to:
  /// **'School logo'**
  String get logoTitle;

  /// No description provided for @logoHelp.
  ///
  /// In en, this message translates to:
  /// **'The logo is printed at the top of every question paper.'**
  String get logoHelp;

  /// No description provided for @logoChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get logoChoose;

  /// No description provided for @logoChange.
  ///
  /// In en, this message translates to:
  /// **'Change logo'**
  String get logoChange;

  /// No description provided for @logoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove logo'**
  String get logoRemove;

  /// No description provided for @logoNone.
  ///
  /// In en, this message translates to:
  /// **'No logo yet'**
  String get logoNone;

  /// No description provided for @printSecMcq.
  ///
  /// In en, this message translates to:
  /// **'Choose the correct answer'**
  String get printSecMcq;

  /// No description provided for @printSecTrueFalse.
  ///
  /// In en, this message translates to:
  /// **'State true or false'**
  String get printSecTrueFalse;

  /// No description provided for @printSecFill.
  ///
  /// In en, this message translates to:
  /// **'Fill in the blanks'**
  String get printSecFill;

  /// No description provided for @printSecMatch.
  ///
  /// In en, this message translates to:
  /// **'Match the following'**
  String get printSecMatch;

  /// No description provided for @printSecShort.
  ///
  /// In en, this message translates to:
  /// **'Short answer questions'**
  String get printSecShort;

  /// No description provided for @printSecLong.
  ///
  /// In en, this message translates to:
  /// **'Long answer questions'**
  String get printSecLong;

  /// No description provided for @printMarks.
  ///
  /// In en, this message translates to:
  /// **'{marks, plural, =1{[1 mark]} other{[{marks} marks]}}'**
  String printMarks(int marks);

  /// No description provided for @printSection.
  ///
  /// In en, this message translates to:
  /// **'Section {letter}'**
  String printSection(String letter);

  /// No description provided for @printTimeAllowed.
  ///
  /// In en, this message translates to:
  /// **'Time allowed'**
  String get printTimeAllowed;

  /// No description provided for @printMaxMarks.
  ///
  /// In en, this message translates to:
  /// **'Maximum marks'**
  String get printMaxMarks;

  /// No description provided for @printName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get printName;

  /// No description provided for @printRollNo.
  ///
  /// In en, this message translates to:
  /// **'Roll no.'**
  String get printRollNo;

  /// No description provided for @printAnswerKey.
  ///
  /// In en, this message translates to:
  /// **'Answer key'**
  String get printAnswerKey;

  /// No description provided for @printEndOfPaper.
  ///
  /// In en, this message translates to:
  /// **'— End of paper —'**
  String get printEndOfPaper;

  /// No description provided for @printModeInk.
  ///
  /// In en, this message translates to:
  /// **'Ink / laser (A4)'**
  String get printModeInk;

  /// No description provided for @printModeThermal.
  ///
  /// In en, this message translates to:
  /// **'Small Bluetooth printer'**
  String get printModeThermal;

  /// No description provided for @printIncludeKey.
  ///
  /// In en, this message translates to:
  /// **'Include answer key'**
  String get printIncludeKey;

  /// No description provided for @printCopies.
  ///
  /// In en, this message translates to:
  /// **'Copies'**
  String get printCopies;

  /// No description provided for @printRoll.
  ///
  /// In en, this message translates to:
  /// **'Paper roll'**
  String get printRoll;

  /// No description provided for @printMm58.
  ///
  /// In en, this message translates to:
  /// **'58 mm'**
  String get printMm58;

  /// No description provided for @printMm80.
  ///
  /// In en, this message translates to:
  /// **'80 mm'**
  String get printMm80;

  /// No description provided for @printPrinters.
  ///
  /// In en, this message translates to:
  /// **'Paired printers'**
  String get printPrinters;

  /// No description provided for @printRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get printRefresh;

  /// No description provided for @printNoPrinters.
  ///
  /// In en, this message translates to:
  /// **'No printer found. Pair your Bluetooth printer in the phone\'s Bluetooth settings, then tap Refresh.'**
  String get printNoPrinters;

  /// No description provided for @printBluetoothOff.
  ///
  /// In en, this message translates to:
  /// **'Turn Bluetooth on to find printers.'**
  String get printBluetoothOff;

  /// No description provided for @printNeedPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow Bluetooth access for this app in the phone\'s settings.'**
  String get printNeedPermission;

  /// No description provided for @printUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Thermal printing needs an Android or iPhone.'**
  String get printUnsupported;

  /// No description provided for @printTipInk.
  ///
  /// In en, this message translates to:
  /// **'Best for full papers: an A4 printer (inkjet or laser) on Wi-Fi. You choose the printer on the next screen.'**
  String get printTipInk;

  /// No description provided for @printTipThermal.
  ///
  /// In en, this message translates to:
  /// **'Good for answer keys and small slips: a 58 mm or 80 mm Bluetooth printer. A full paper uses a lot of roll.'**
  String get printTipThermal;

  /// No description provided for @printAction.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printAction;

  /// No description provided for @printShare.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get printShare;

  /// No description provided for @printSent.
  ///
  /// In en, this message translates to:
  /// **'Sent to the printer'**
  String get printSent;

  /// No description provided for @printCancelled.
  ///
  /// In en, this message translates to:
  /// **'Printing was cancelled'**
  String get printCancelled;

  /// No description provided for @printPickPrinter.
  ///
  /// In en, this message translates to:
  /// **'Choose a printer first'**
  String get printPickPrinter;

  /// No description provided for @printConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect. Check that the printer is on and in range.'**
  String get printConnectFailed;

  /// No description provided for @printWriteFailed.
  ///
  /// In en, this message translates to:
  /// **'The printer stopped responding.'**
  String get printWriteFailed;

  /// No description provided for @printFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not print.'**
  String get printFailed;

  /// No description provided for @printBuilding.
  ///
  /// In en, this message translates to:
  /// **'Preparing the paper…'**
  String get printBuilding;

  /// No description provided for @printOnlyApproved.
  ///
  /// In en, this message translates to:
  /// **'Printing is available once the paper is approved.'**
  String get printOnlyApproved;

  /// No description provided for @cloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get cloudTitle;

  /// No description provided for @cloudIntro.
  ///
  /// In en, this message translates to:
  /// **'Your data is saved on this phone and works without internet. When internet is on, it is also backed up online.'**
  String get cloudIntro;

  /// No description provided for @cloudNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Online backup is not set up in this app yet. Please contact support.'**
  String get cloudNotConfigured;

  /// No description provided for @cloudConnectedAs.
  ///
  /// In en, this message translates to:
  /// **'Connected as {email}'**
  String cloudConnectedAs(String email);

  /// No description provided for @cloudProject.
  ///
  /// In en, this message translates to:
  /// **'Cloud ID'**
  String get cloudProject;

  /// No description provided for @cloudSchoolId.
  ///
  /// In en, this message translates to:
  /// **'School id in the cloud'**
  String get cloudSchoolId;

  /// No description provided for @cloudSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get cloudSyncNow;

  /// No description provided for @cloudSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get cloudSyncing;

  /// No description provided for @cloudLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync: {when}'**
  String cloudLastSync(String when);

  /// No description provided for @cloudNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get cloudNeverSynced;

  /// No description provided for @cloudUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Everything is already in the cloud.'**
  String get cloudUpToDate;

  /// No description provided for @cloudSentSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record sent} other{{count} records sent}}'**
  String cloudSentSummary(int count);

  /// No description provided for @cloudRemovedSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record removed} other{{count} records removed}}'**
  String cloudRemovedSummary(int count);

  /// No description provided for @cloudWhatIsSent.
  ///
  /// In en, this message translates to:
  /// **'What is sent'**
  String get cloudWhatIsSent;

  /// No description provided for @cloudWhatIsSentBody.
  ///
  /// In en, this message translates to:
  /// **'Students, teachers, staff, classes, attendance, exams, fees, notices and settings are backed up. Passwords, photos and selfies are never sent.'**
  String get cloudWhatIsSentBody;

  /// No description provided for @cloudSyncedNotice.
  ///
  /// In en, this message translates to:
  /// **'Synced to the cloud'**
  String get cloudSyncedNotice;

  /// No description provided for @cloudNeedSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first. The Principal\'s login is used for online backup.'**
  String get cloudNeedSignIn;

  /// No description provided for @cloudNotOwner.
  ///
  /// In en, this message translates to:
  /// **'This school\'s online data belongs to another login.'**
  String get cloudNotOwner;

  /// No description provided for @cloudOffline.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect. Check your internet. Your data is safe on this phone.'**
  String get cloudOffline;

  /// No description provided for @cloudFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync did not finish. It will try again.'**
  String get cloudFailed;

  /// No description provided for @faceNudgeStarting.
  ///
  /// In en, this message translates to:
  /// **'Opening the camera…'**
  String get faceNudgeStarting;

  /// No description provided for @faceNudgeShowFace.
  ///
  /// In en, this message translates to:
  /// **'Show your face to the camera'**
  String get faceNudgeShowFace;

  /// No description provided for @faceNudgeOnlyOne.
  ///
  /// In en, this message translates to:
  /// **'Only one face, please'**
  String get faceNudgeOnlyOne;

  /// No description provided for @faceNudgeCloser.
  ///
  /// In en, this message translates to:
  /// **'Move a little closer'**
  String get faceNudgeCloser;

  /// No description provided for @faceNudgeBack.
  ///
  /// In en, this message translates to:
  /// **'Move back a little'**
  String get faceNudgeBack;

  /// No description provided for @faceNudgeCenter.
  ///
  /// In en, this message translates to:
  /// **'Keep your face inside the circle'**
  String get faceNudgeCenter;

  /// No description provided for @faceNudgeStraight.
  ///
  /// In en, this message translates to:
  /// **'Look straight at the camera'**
  String get faceNudgeStraight;

  /// No description provided for @faceNudgeOpenEyes.
  ///
  /// In en, this message translates to:
  /// **'Open your eyes'**
  String get faceNudgeOpenEyes;

  /// No description provided for @faceNudgeHold.
  ///
  /// In en, this message translates to:
  /// **'Hold still…'**
  String get faceNudgeHold;

  /// No description provided for @faceNudgeBlink.
  ///
  /// In en, this message translates to:
  /// **'Now blink once'**
  String get faceNudgeBlink;

  /// No description provided for @faceNudgeCapturing.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get faceNudgeCapturing;

  /// No description provided for @faceCaptureEnrollTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up Face ID'**
  String get faceCaptureEnrollTitle;

  /// No description provided for @faceCaptureVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Check it\'s you'**
  String get faceCaptureVerifyTitle;

  /// No description provided for @faceCaptureStep.
  ///
  /// In en, this message translates to:
  /// **'Photo {current} of {total}'**
  String faceCaptureStep(int current, int total);

  /// No description provided for @faceFlipCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get faceFlipCamera;

  /// No description provided for @faceCameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access in the phone\'s settings to use Face ID.'**
  String get faceCameraDenied;

  /// No description provided for @faceCameraMissing.
  ///
  /// In en, this message translates to:
  /// **'No front camera could be opened on this phone.'**
  String get faceCameraMissing;

  /// No description provided for @faceTitle.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceTitle;

  /// No description provided for @faceIntro.
  ///
  /// In en, this message translates to:
  /// **'Check-in uses your face and the school location. Your face is saved on this phone as numbers only. No photo is kept and nothing goes online.'**
  String get faceIntro;

  /// No description provided for @faceStatusOn.
  ///
  /// In en, this message translates to:
  /// **'Face ID is set up'**
  String get faceStatusOn;

  /// No description provided for @faceStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Face ID is not set up'**
  String get faceStatusOff;

  /// No description provided for @faceSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set up Face ID'**
  String get faceSetUp;

  /// No description provided for @faceReplace.
  ///
  /// In en, this message translates to:
  /// **'Set up again'**
  String get faceReplace;

  /// No description provided for @faceRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove Face ID'**
  String get faceRemove;

  /// No description provided for @faceSetUpDone.
  ///
  /// In en, this message translates to:
  /// **'Face ID is set up'**
  String get faceSetUpDone;

  /// No description provided for @faceRemoved.
  ///
  /// In en, this message translates to:
  /// **'Face ID removed'**
  String get faceRemoved;

  /// No description provided for @faceEnrolledOn.
  ///
  /// In en, this message translates to:
  /// **'Set up on {date}'**
  String faceEnrolledOn(String date);

  /// No description provided for @faceErrNotFound.
  ///
  /// In en, this message translates to:
  /// **'No clear face was found. Try again in good light, facing the camera.'**
  String get faceErrNotFound;

  /// No description provided for @faceErrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Face ID could not run on this phone.'**
  String get faceErrUnavailable;

  /// No description provided for @checkErrFaceMismatch.
  ///
  /// In en, this message translates to:
  /// **'Face did not match. Try again in good light, facing the camera.'**
  String get checkErrFaceMismatch;

  /// No description provided for @checkErrFaceNotFound.
  ///
  /// In en, this message translates to:
  /// **'No clear face was found. Try again, facing the camera.'**
  String get checkErrFaceNotFound;

  /// No description provided for @checkErrFaceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Face ID could not run on this phone. Ask the Principal for help.'**
  String get checkErrFaceUnavailable;

  /// No description provided for @faceNudgeSetUpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Set up Face ID to check in with your face.'**
  String get faceNudgeSetUpPrompt;

  /// No description provided for @faceScore.
  ///
  /// In en, this message translates to:
  /// **'Face match {percent}%'**
  String faceScore(int percent);

  /// No description provided for @aadhaarScan.
  ///
  /// In en, this message translates to:
  /// **'Scan Aadhaar card'**
  String get aadhaarScan;

  /// No description provided for @aadhaarScanHint.
  ///
  /// In en, this message translates to:
  /// **'Take a clear, flat photo of the front of the card where the 12-digit number is printed. The photo is read on this phone and is not saved.'**
  String get aadhaarScanHint;

  /// No description provided for @aadhaarScanFilled.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number filled in from the card'**
  String get aadhaarScanFilled;

  /// No description provided for @aadhaarScanNotFound.
  ///
  /// In en, this message translates to:
  /// **'No valid Aadhaar number found. Try a clearer photo of the front of the card.'**
  String get aadhaarScanNotFound;

  /// No description provided for @aadhaarScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read the photo. Please try again.'**
  String get aadhaarScanFailed;

  /// No description provided for @aadhaarScanning.
  ///
  /// In en, this message translates to:
  /// **'Reading the card…'**
  String get aadhaarScanning;

  /// No description provided for @aadhaarProbTitleNoNumber.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t see the number'**
  String get aadhaarProbTitleNoNumber;

  /// No description provided for @aadhaarProbNoNumber.
  ///
  /// In en, this message translates to:
  /// **'We could not find a 12-digit number. Hold the card flat so the number is sharp and big in the photo.'**
  String get aadhaarProbNoNumber;

  /// No description provided for @aadhaarProbTitleNoText.
  ///
  /// In en, this message translates to:
  /// **'The photo is too unclear'**
  String get aadhaarProbTitleNoText;

  /// No description provided for @aadhaarProbNoText.
  ///
  /// In en, this message translates to:
  /// **'Nothing could be read. It may be blurry, dark or not a card. Retake it in good light.'**
  String get aadhaarProbNoText;

  /// No description provided for @aadhaarProbTitleMasked.
  ///
  /// In en, this message translates to:
  /// **'This card hides the number'**
  String get aadhaarProbTitleMasked;

  /// No description provided for @aadhaarProbMasked.
  ///
  /// In en, this message translates to:
  /// **'Only the last four digits are shown (XXXX XXXX 1234). Use a card that shows all 12 digits.'**
  String get aadhaarProbMasked;

  /// No description provided for @aadhaarProbTitleVid.
  ///
  /// In en, this message translates to:
  /// **'This is a Virtual ID'**
  String get aadhaarProbTitleVid;

  /// No description provided for @aadhaarProbVid.
  ///
  /// In en, this message translates to:
  /// **'This is the 16-digit Virtual ID. Scan the 12-digit Aadhaar number on the card.'**
  String get aadhaarProbVid;

  /// No description provided for @aadhaarProbTitleChecksum.
  ///
  /// In en, this message translates to:
  /// **'One digit may be misread'**
  String get aadhaarProbTitleChecksum;

  /// No description provided for @aadhaarProbChecksum.
  ///
  /// In en, this message translates to:
  /// **'We read {number}, but it looks wrong. Take a clearer photo or fix it by hand.'**
  String aadhaarProbChecksum(String number);

  /// No description provided for @aadhaarProbTitleError.
  ///
  /// In en, this message translates to:
  /// **'Could not read the photo'**
  String get aadhaarProbTitleError;

  /// No description provided for @aadhaarProbError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while reading the photo. Please try again.'**
  String get aadhaarProbError;

  /// No description provided for @aadhaarTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'For a good photo'**
  String get aadhaarTipsTitle;

  /// No description provided for @aadhaarTipLight.
  ///
  /// In en, this message translates to:
  /// **'Good light, no glare or shadow'**
  String get aadhaarTipLight;

  /// No description provided for @aadhaarTipFlat.
  ///
  /// In en, this message translates to:
  /// **'Card flat, all four corners in view'**
  String get aadhaarTipFlat;

  /// No description provided for @aadhaarTipFront.
  ///
  /// In en, this message translates to:
  /// **'The side with the 12-digit number'**
  String get aadhaarTipFront;

  /// No description provided for @aadhaarRetake.
  ///
  /// In en, this message translates to:
  /// **'Take another photo'**
  String get aadhaarRetake;

  /// No description provided for @aadhaarEditByHand.
  ///
  /// In en, this message translates to:
  /// **'Correct it by hand'**
  String get aadhaarEditByHand;

  /// No description provided for @aadhaarTypeInstead.
  ///
  /// In en, this message translates to:
  /// **'Type it instead'**
  String get aadhaarTypeInstead;

  /// No description provided for @fieldDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get fieldDob;

  /// No description provided for @bornOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Born {date}'**
  String bornOnLabel(String date);

  /// No description provided for @aadhaarFilledFromCard.
  ///
  /// In en, this message translates to:
  /// **'Filled in from the card: {items}'**
  String aadhaarFilledFromCard(String items);

  /// No description provided for @aadhaarItemNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number'**
  String get aadhaarItemNumber;

  /// No description provided for @aadhaarItemName.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get aadhaarItemName;

  /// No description provided for @aadhaarItemDob.
  ///
  /// In en, this message translates to:
  /// **'date of birth'**
  String get aadhaarItemDob;

  /// No description provided for @fieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get fieldGender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fieldAddress;

  /// No description provided for @aadhaarItemGender.
  ///
  /// In en, this message translates to:
  /// **'gender'**
  String get aadhaarItemGender;

  /// No description provided for @aadhaarItemAddress.
  ///
  /// In en, this message translates to:
  /// **'address'**
  String get aadhaarItemAddress;

  /// No description provided for @aadhaarScanIntro.
  ///
  /// In en, this message translates to:
  /// **'Take photos of both sides of the card. The front has the name, date of birth and number. The back has the address. Photos are read on this phone and not saved.'**
  String get aadhaarScanIntro;

  /// No description provided for @aadhaarSideFront.
  ///
  /// In en, this message translates to:
  /// **'Front side'**
  String get aadhaarSideFront;

  /// No description provided for @aadhaarSideFrontHint.
  ///
  /// In en, this message translates to:
  /// **'Name, gender, date of birth and Aadhaar number'**
  String get aadhaarSideFrontHint;

  /// No description provided for @aadhaarSideBack.
  ///
  /// In en, this message translates to:
  /// **'Back side'**
  String get aadhaarSideBack;

  /// No description provided for @aadhaarSideBackHint.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get aadhaarSideBackHint;

  /// No description provided for @aadhaarRetakeSide.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get aadhaarRetakeSide;

  /// No description provided for @aadhaarAddBack.
  ///
  /// In en, this message translates to:
  /// **'Add the back side too, to get the address.'**
  String get aadhaarAddBack;

  /// No description provided for @aadhaarRead.
  ///
  /// In en, this message translates to:
  /// **'Read the card'**
  String get aadhaarRead;

  /// No description provided for @aadhaarReading.
  ///
  /// In en, this message translates to:
  /// **'Reading the card…'**
  String get aadhaarReading;

  /// No description provided for @aadhaarFound.
  ///
  /// In en, this message translates to:
  /// **'What we found'**
  String get aadhaarFound;

  /// No description provided for @aadhaarNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get aadhaarNotFound;

  /// No description provided for @aadhaarUse.
  ///
  /// In en, this message translates to:
  /// **'Fill the form'**
  String get aadhaarUse;

  /// No description provided for @aadhaarRetakeBoth.
  ///
  /// In en, this message translates to:
  /// **'Take the photos again'**
  String get aadhaarRetakeBoth;

  /// No description provided for @aadhaarBackNoAddress.
  ///
  /// In en, this message translates to:
  /// **'No address was found on the back photo. You can type it in.'**
  String get aadhaarBackNoAddress;

  /// No description provided for @aadhaarMismatchTitle.
  ///
  /// In en, this message translates to:
  /// **'The two photos are of different numbers'**
  String get aadhaarMismatchTitle;

  /// No description provided for @aadhaarMismatchBody.
  ///
  /// In en, this message translates to:
  /// **'The front shows {front} but the back shows {back}. They may be two different cards, so the address from the back was not used. Take the back photo of the same card again.'**
  String aadhaarMismatchBody(String front, String back);

  /// No description provided for @aadhaarMismatchAddress.
  ///
  /// In en, this message translates to:
  /// **'Not used: the back photo shows a different Aadhaar number.'**
  String get aadhaarMismatchAddress;

  /// No description provided for @registrationListAll.
  ///
  /// In en, this message translates to:
  /// **'Everyone registered'**
  String get registrationListAll;

  /// No description provided for @drawerSectionProfiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get drawerSectionProfiles;

  /// No description provided for @profileStudents.
  ///
  /// In en, this message translates to:
  /// **'Student profiles'**
  String get profileStudents;

  /// No description provided for @profileTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teacher profiles'**
  String get profileTeachers;

  /// No description provided for @profileClassTeachers.
  ///
  /// In en, this message translates to:
  /// **'Class teachers'**
  String get profileClassTeachers;

  /// No description provided for @profileNoOne.
  ///
  /// In en, this message translates to:
  /// **'No one matches these filters.'**
  String get profileNoOne;

  /// No description provided for @profileOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get profileOverview;

  /// No description provided for @profileAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get profileAttendance;

  /// No description provided for @profileFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get profileFees;

  /// No description provided for @profileResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get profileResults;

  /// No description provided for @profilePapers.
  ///
  /// In en, this message translates to:
  /// **'Papers set'**
  String get profilePapers;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get profileDetails;

  /// No description provided for @profileJoinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String profileJoinedOn(String date);

  /// No description provided for @profileClassLabel.
  ///
  /// In en, this message translates to:
  /// **'Class and roll no.'**
  String get profileClassLabel;

  /// No description provided for @profileClassTeacherOfClass.
  ///
  /// In en, this message translates to:
  /// **'Class teacher of {cls}'**
  String profileClassTeacherOfClass(String cls);

  /// No description provided for @profileDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get profileDates;

  /// No description provided for @profileAttended.
  ///
  /// In en, this message translates to:
  /// **'Attended {percent}%'**
  String profileAttended(int percent);

  /// No description provided for @profileDaysRecorded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day recorded} other{{count} days recorded}}'**
  String profileDaysRecorded(int count);

  /// No description provided for @profileDaysPresent.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day present} other{{count} days present}}'**
  String profileDaysPresent(int count);

  /// No description provided for @profileNoAttendance.
  ///
  /// In en, this message translates to:
  /// **'No attendance recorded for these filters.'**
  String get profileNoAttendance;

  /// No description provided for @profileNoResults.
  ///
  /// In en, this message translates to:
  /// **'No exam marks recorded yet.'**
  String get profileNoResults;

  /// No description provided for @profileNoFees.
  ///
  /// In en, this message translates to:
  /// **'No fees on record.'**
  String get profileNoFees;

  /// No description provided for @profileNoPapers.
  ///
  /// In en, this message translates to:
  /// **'No papers set yet.'**
  String get profileNoPapers;

  /// No description provided for @profileNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get profileNoPayments;

  /// No description provided for @profileMarksOf.
  ///
  /// In en, this message translates to:
  /// **'{obtained} / {total}'**
  String profileMarksOf(int obtained, int total);

  /// No description provided for @profileTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid in all: {amount}'**
  String profileTotalPaid(String amount);

  /// No description provided for @profilePaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Full payment history'**
  String get profilePaymentHistory;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'This person could not be found.'**
  String get profileNotFound;

  /// No description provided for @profileStillIn.
  ///
  /// In en, this message translates to:
  /// **'Still checked in'**
  String get profileStillIn;

  /// No description provided for @dobErrFuture.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future.'**
  String get dobErrFuture;

  /// No description provided for @dobErrYoung.
  ///
  /// In en, this message translates to:
  /// **'Too young: the minimum age is {years} years.'**
  String dobErrYoung(int years);

  /// No description provided for @dobErrOld.
  ///
  /// In en, this message translates to:
  /// **'Too old: the maximum age is {years} years.'**
  String dobErrOld(int years);

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'School calendar'**
  String get calendarTitle;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarOpen.
  ///
  /// In en, this message translates to:
  /// **'School was open'**
  String get calendarOpen;

  /// No description provided for @calendarClosed.
  ///
  /// In en, this message translates to:
  /// **'School closed'**
  String get calendarClosed;

  /// No description provided for @calendarNoRecord.
  ///
  /// In en, this message translates to:
  /// **'No record'**
  String get calendarNoRecord;

  /// No description provided for @calendarWeeklyOff.
  ///
  /// In en, this message translates to:
  /// **'Weekly off'**
  String get calendarWeeklyOff;

  /// No description provided for @calendarThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get calendarThisMonth;

  /// No description provided for @calendarYear.
  ///
  /// In en, this message translates to:
  /// **'Academic year since {date}'**
  String calendarYear(String date);

  /// No description provided for @calendarDaysOpen.
  ///
  /// In en, this message translates to:
  /// **'Days school was open'**
  String get calendarDaysOpen;

  /// No description provided for @calendarDaysClosed.
  ///
  /// In en, this message translates to:
  /// **'Days closed'**
  String get calendarDaysClosed;

  /// No description provided for @calendarDaysNoRecord.
  ///
  /// In en, this message translates to:
  /// **'Days with no record'**
  String get calendarDaysNoRecord;

  /// No description provided for @calendarNoRecordNote.
  ///
  /// In en, this message translates to:
  /// **'Sundays are the weekly off and are not counted.'**
  String get calendarNoRecordNote;

  /// No description provided for @calendarTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to see its details.'**
  String get calendarTapHint;

  /// No description provided for @calendarTapHintPrincipal.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to see details or change it. You must give a reason for every change.'**
  String get calendarTapHintPrincipal;

  /// No description provided for @calendarMarkOpen.
  ///
  /// In en, this message translates to:
  /// **'Mark school open'**
  String get calendarMarkOpen;

  /// No description provided for @calendarMarkClosed.
  ///
  /// In en, this message translates to:
  /// **'Mark school closed'**
  String get calendarMarkClosed;

  /// No description provided for @calendarClearDay.
  ///
  /// In en, this message translates to:
  /// **'Clear this day'**
  String get calendarClearDay;

  /// No description provided for @calendarReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you changing this day?'**
  String get calendarReasonTitle;

  /// No description provided for @calendarReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Heavy rain, Diwali holiday, Exam day'**
  String get calendarReasonHint;

  /// No description provided for @calendarReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please give a reason (at least 3 letters).'**
  String get calendarReasonRequired;

  /// No description provided for @calendarSave.
  ///
  /// In en, this message translates to:
  /// **'Save change'**
  String get calendarSave;

  /// No description provided for @calendarReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String calendarReason(String reason);

  /// No description provided for @calendarNoReason.
  ///
  /// In en, this message translates to:
  /// **'No reason recorded'**
  String get calendarNoReason;

  /// No description provided for @calendarMarkedBy.
  ///
  /// In en, this message translates to:
  /// **'Marked by {name}, {when}'**
  String calendarMarkedBy(String name, String when);

  /// No description provided for @calendarHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get calendarHistory;

  /// No description provided for @calendarNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No changes recorded for this day.'**
  String get calendarNoHistory;

  /// No description provided for @calendarSaved.
  ///
  /// In en, this message translates to:
  /// **'Calendar updated'**
  String get calendarSaved;

  /// No description provided for @calendarNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Only the Principal can change the calendar.'**
  String get calendarNotAllowed;

  /// No description provided for @calendarFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the change.'**
  String get calendarFailed;

  /// No description provided for @holidaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get holidaysTitle;

  /// No description provided for @holidayAdd.
  ///
  /// In en, this message translates to:
  /// **'Add holiday'**
  String get holidayAdd;

  /// No description provided for @holidayFilterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get holidayFilterUpcoming;

  /// No description provided for @holidayFilterPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get holidayFilterPast;

  /// No description provided for @holidayFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get holidayFilterAll;

  /// No description provided for @holidayListUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming holidays'**
  String get holidayListUpcoming;

  /// No description provided for @holidayListPast.
  ///
  /// In en, this message translates to:
  /// **'Past holidays'**
  String get holidayListPast;

  /// No description provided for @holidayListAll.
  ///
  /// In en, this message translates to:
  /// **'All holidays'**
  String get holidayListAll;

  /// No description provided for @holidayDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String holidayDays(int count);

  /// No description provided for @holidaySummary.
  ///
  /// In en, this message translates to:
  /// **'{holidays, plural, =1{1 holiday} other{{holidays} holidays}} · {days, plural, =1{1 day} other{{days} days}}'**
  String holidaySummary(int holidays, int days);

  /// No description provided for @holidayOnNow.
  ///
  /// In en, this message translates to:
  /// **'On now'**
  String get holidayOnNow;

  /// No description provided for @holidayInDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Tomorrow} other{In {count} days}}'**
  String holidayInDays(int count);

  /// No description provided for @holidayPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get holidayPast;

  /// No description provided for @holidayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No holidays added yet.'**
  String get holidayEmpty;

  /// No description provided for @holidayEmptyPrincipal.
  ///
  /// In en, this message translates to:
  /// **'No holidays added yet. Tap \"Add holidays\" to enter the school\'s holiday list.'**
  String get holidayEmptyPrincipal;

  /// No description provided for @holidayEmptyFilter.
  ///
  /// In en, this message translates to:
  /// **'No holidays in this list.'**
  String get holidayEmptyFilter;

  /// No description provided for @holidayEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Holiday {number}'**
  String holidayEntryTitle(int number);

  /// No description provided for @holidayReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get holidayReason;

  /// No description provided for @holidayReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Diwali vacation, Republic Day'**
  String get holidayReasonHint;

  /// No description provided for @holidayPickDates.
  ///
  /// In en, this message translates to:
  /// **'Pick the date or dates'**
  String get holidayPickDates;

  /// No description provided for @holidayDatesHelp.
  ///
  /// In en, this message translates to:
  /// **'For one day, pick the same date twice.'**
  String get holidayDatesHelp;

  /// No description provided for @holidayDatesRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick the date or dates'**
  String get holidayDatesRequired;

  /// No description provided for @holidayAnother.
  ///
  /// In en, this message translates to:
  /// **'Add another holiday'**
  String get holidayAnother;

  /// No description provided for @holidaySaveAll.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Save holidays} =1{Save 1 day} other{Save {count} days}}'**
  String holidaySaveAll(int count);

  /// No description provided for @holidayAddIntro.
  ///
  /// In en, this message translates to:
  /// **'Add holidays with their dates and a reason, then save them together. Everyone can see them in Holidays and the calendar.'**
  String get holidayAddIntro;

  /// No description provided for @holidaySaved.
  ///
  /// In en, this message translates to:
  /// **'{added, plural, =1{1 holiday day added} other{{added} holiday days added}}'**
  String holidaySaved(int added);

  /// No description provided for @holidaySavedSkipped.
  ///
  /// In en, this message translates to:
  /// **'{added} days added. {skipped, plural, =1{1 day skipped, school was already marked open on it} other{{skipped} days skipped, school was already marked open on them}}.'**
  String holidaySavedSkipped(int added, int skipped);

  /// No description provided for @holidayInvalidDates.
  ///
  /// In en, this message translates to:
  /// **'Check the dates: each holiday needs its dates, and none can be longer than {max} days.'**
  String holidayInvalidDates(int max);

  /// No description provided for @holidayRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove this holiday'**
  String get holidayRemove;

  /// No description provided for @holidayRemoved.
  ///
  /// In en, this message translates to:
  /// **'Holiday removed'**
  String get holidayRemoved;

  /// No description provided for @calendarHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get calendarHoliday;

  /// No description provided for @holidaySuggestedPick.
  ///
  /// In en, this message translates to:
  /// **'Pick from India\'s holidays'**
  String get holidaySuggestedPick;

  /// No description provided for @holidaySuggested.
  ///
  /// In en, this message translates to:
  /// **'Holidays of India'**
  String get holidaySuggested;

  /// No description provided for @holidaySuggestedNote.
  ///
  /// In en, this message translates to:
  /// **'Festival dates change every year. Please check the dates before saving. You can edit them later.'**
  String get holidaySuggestedNote;

  /// No description provided for @holidaySuggestedAdd.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add 1 holiday} other{Add {count} holidays}}'**
  String holidaySuggestedAdd(int count);

  /// No description provided for @scrollForMore.
  ///
  /// In en, this message translates to:
  /// **'Scroll to view more'**
  String get scrollForMore;

  /// No description provided for @moduleAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get moduleAttendance;

  /// No description provided for @moduleMarkAttendance.
  ///
  /// In en, this message translates to:
  /// **'Student attendance'**
  String get moduleMarkAttendance;

  /// No description provided for @modulePayments.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get modulePayments;

  /// No description provided for @notClassTeacherMessage.
  ///
  /// In en, this message translates to:
  /// **'You are not a class teacher yet, so there is no class to mark.'**
  String get notClassTeacherMessage;

  /// No description provided for @drawerSectionAcademics.
  ///
  /// In en, this message translates to:
  /// **'Academics'**
  String get drawerSectionAcademics;

  /// No description provided for @drawerSectionPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get drawerSectionPeople;

  /// No description provided for @drawerSectionMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get drawerSectionMoney;

  /// No description provided for @drawerSectionSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get drawerSectionSchool;

  /// No description provided for @scrollForMoreCount.
  ///
  /// In en, this message translates to:
  /// **'Scroll to view more · {count} in all'**
  String scrollForMoreCount(int count);

  /// No description provided for @sectionApprovals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get sectionApprovals;

  /// No description provided for @sectionOverview.
  ///
  /// In en, this message translates to:
  /// **'Today at a glance'**
  String get sectionOverview;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get actionMore;

  /// No description provided for @messageClassAdded.
  ///
  /// In en, this message translates to:
  /// **'Class added'**
  String get messageClassAdded;

  /// No description provided for @messageClassUpdated.
  ///
  /// In en, this message translates to:
  /// **'Class updated'**
  String get messageClassUpdated;

  /// No description provided for @messageClassDeleted.
  ///
  /// In en, this message translates to:
  /// **'Class deleted'**
  String get messageClassDeleted;

  /// No description provided for @emptyClasses.
  ///
  /// In en, this message translates to:
  /// **'No classes yet.\nTap \"Add class\" to create one.'**
  String get emptyClasses;

  /// No description provided for @emptyStudents.
  ///
  /// In en, this message translates to:
  /// **'No students in this class yet.\nRegister students from the Register module.'**
  String get emptyStudents;

  /// No description provided for @actionScanQuestions.
  ///
  /// In en, this message translates to:
  /// **'Scan from photo'**
  String get actionScanQuestions;

  /// No description provided for @scanSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan questions'**
  String get scanSourceTitle;

  /// No description provided for @scanLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language of the text'**
  String get scanLanguage;

  /// No description provided for @scanCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get scanCamera;

  /// No description provided for @scanGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get scanGallery;

  /// No description provided for @scanProcessing.
  ///
  /// In en, this message translates to:
  /// **'Reading the text…'**
  String get scanProcessing;

  /// No description provided for @scanNoText.
  ///
  /// In en, this message translates to:
  /// **'No text found. Try a clearer, well-lit photo.'**
  String get scanNoText;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read the photo. Please try again.'**
  String get scanFailed;

  /// No description provided for @scanReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review scanned questions'**
  String get scanReviewTitle;

  /// No description provided for @scanReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Scanning can make mistakes. Check each question, correct the text, and untick anything that is not a question.'**
  String get scanReviewHint;

  /// No description provided for @actionAddSelected.
  ///
  /// In en, this message translates to:
  /// **'Add {count} questions'**
  String actionAddSelected(int count);

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your school'**
  String get setupTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create the Principal login. You can add teachers later.'**
  String get setupSubtitle;

  /// No description provided for @fieldSchoolName.
  ///
  /// In en, this message translates to:
  /// **'School name'**
  String get fieldSchoolName;

  /// No description provided for @fieldConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get fieldConfirmPassword;

  /// No description provided for @actionCreateSchool.
  ///
  /// In en, this message translates to:
  /// **'Create school'**
  String get actionCreateSchool;

  /// No description provided for @errorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least {min} characters'**
  String errorPasswordShort(int min);

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordMismatch;

  /// No description provided for @errorInactiveAccount.
  ///
  /// In en, this message translates to:
  /// **'This account is inactive. Please contact the Principal.'**
  String get errorInactiveAccount;

  /// No description provided for @errorWrongCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get errorWrongCurrentPassword;

  /// No description provided for @errorEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get errorEmailTaken;

  /// No description provided for @fieldLoginEmail.
  ///
  /// In en, this message translates to:
  /// **'Login email'**
  String get fieldLoginEmail;

  /// No description provided for @fieldTempPassword.
  ///
  /// In en, this message translates to:
  /// **'Temporary password'**
  String get fieldTempPassword;

  /// No description provided for @helperTempPassword.
  ///
  /// In en, this message translates to:
  /// **'Give this to the teacher. They can change it after signing in.'**
  String get helperTempPassword;

  /// No description provided for @fieldCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get fieldCurrentPassword;

  /// No description provided for @fieldNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get fieldNewPassword;

  /// No description provided for @actionEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get actionEditProfile;

  /// No description provided for @actionChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get actionChangePassword;

  /// No description provided for @actionChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get actionChangeEmail;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @changeEmailHint.
  ///
  /// In en, this message translates to:
  /// **'A verification link will be sent to the new email. Your email changes after you open it.'**
  String get changeEmailHint;

  /// No description provided for @fieldNewEmail.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get fieldNewEmail;

  /// No description provided for @messageEmailChangeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification link sent. Open it to finish changing your email.'**
  String get messageEmailChangeSent;

  /// No description provided for @messageProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get messageProfileUpdated;

  /// No description provided for @messagePasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get messagePasswordChanged;

  /// No description provided for @checkErrSchoolClosed.
  ///
  /// In en, this message translates to:
  /// **'The Principal has not marked today as a school day yet.'**
  String get checkErrSchoolClosed;

  /// No description provided for @checkErrNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'The school location is not set. Ask the Principal to set it in Profile → School settings.'**
  String get checkErrNotConfigured;

  /// No description provided for @checkErrServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Turn on location (GPS) and try again.'**
  String get checkErrServicesOff;

  /// No description provided for @checkErrPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is needed to check in.'**
  String get checkErrPermissionDenied;

  /// No description provided for @checkErrPermissionForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked. Allow it from the phone settings.'**
  String get checkErrPermissionForever;

  /// No description provided for @checkErrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not read your location. Try again outdoors.'**
  String get checkErrUnavailable;

  /// No description provided for @checkErrMockLocation.
  ///
  /// In en, this message translates to:
  /// **'A fake location app is on. Turn it off and try again.'**
  String get checkErrMockLocation;

  /// No description provided for @checkErrOutside.
  ///
  /// In en, this message translates to:
  /// **'You are {meters} m from the school. Move closer to check in.'**
  String checkErrOutside(int meters);

  /// No description provided for @checkErrSelfie.
  ///
  /// In en, this message translates to:
  /// **'A selfie is required to check in.'**
  String get checkErrSelfie;

  /// No description provided for @checkInHint.
  ///
  /// In en, this message translates to:
  /// **'We check your location and take a selfie as proof.'**
  String get checkInHint;

  /// No description provided for @distanceFromSchool.
  ///
  /// In en, this message translates to:
  /// **'{meters} m from school'**
  String distanceFromSchool(int meters);

  /// No description provided for @teacherReportWindow.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days (school days only)'**
  String teacherReportWindow(int days);

  /// No description provided for @emptyTrend.
  ///
  /// In en, this message translates to:
  /// **'No student attendance marked in the last 7 days.'**
  String get emptyTrend;

  /// No description provided for @emptyMarks.
  ///
  /// In en, this message translates to:
  /// **'No exam marks entered for this class yet.'**
  String get emptyMarks;

  /// No description provided for @noCheckInsYet.
  ///
  /// In en, this message translates to:
  /// **'No check-ins in this period'**
  String get noCheckInsYet;

  /// No description provided for @schoolSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'School settings'**
  String get schoolSettingsTitle;

  /// No description provided for @sectionSchoolLocation.
  ///
  /// In en, this message translates to:
  /// **'School location'**
  String get sectionSchoolLocation;

  /// No description provided for @locationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get locationNotSet;

  /// No description provided for @locationValue.
  ///
  /// In en, this message translates to:
  /// **'Lat {lat}, Lon {lon}'**
  String locationValue(String lat, String lon);

  /// No description provided for @locationHelp.
  ///
  /// In en, this message translates to:
  /// **'Stand at the school gate or in the middle of the campus, then tap the button.'**
  String get locationHelp;

  /// No description provided for @actionUseCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get actionUseCurrentLocation;

  /// No description provided for @fieldRadius.
  ///
  /// In en, this message translates to:
  /// **'Allowed distance'**
  String get fieldRadius;

  /// No description provided for @helperRadius.
  ///
  /// In en, this message translates to:
  /// **'How close a teacher must be to check in.'**
  String get helperRadius;

  /// No description provided for @unitMeters.
  ///
  /// In en, this message translates to:
  /// **'metres'**
  String get unitMeters;

  /// No description provided for @errorRadiusInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the distance in metres'**
  String get errorRadiusInvalid;

  /// No description provided for @errorLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Set the school location first'**
  String get errorLocationRequired;

  /// No description provided for @messageSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get messageSettingsSaved;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupTitle;

  /// No description provided for @backupNever.
  ///
  /// In en, this message translates to:
  /// **'No backup taken yet'**
  String get backupNever;

  /// No description provided for @backupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {when}'**
  String backupLast(String when);

  /// No description provided for @actionBackupShare.
  ///
  /// In en, this message translates to:
  /// **'Create backup & share'**
  String get actionBackupShare;

  /// No description provided for @actionBackupSave.
  ///
  /// In en, this message translates to:
  /// **'Save backup to this phone'**
  String get actionBackupSave;

  /// No description provided for @sectionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get sectionRestore;

  /// No description provided for @actionRestoreFromFile.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup file'**
  String get actionRestoreFromFile;

  /// No description provided for @actionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

  /// No description provided for @messageBackupDone.
  ///
  /// In en, this message translates to:
  /// **'Backup created'**
  String get messageBackupDone;

  /// No description provided for @messageBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the backup'**
  String get messageBackupFailed;

  /// No description provided for @messageRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Restored. Please sign in again.'**
  String get messageRestoreDone;

  /// No description provided for @messageRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed. Nothing was changed.'**
  String get messageRestoreFailed;

  /// No description provided for @errBackupNotBackup.
  ///
  /// In en, this message translates to:
  /// **'This file is not a Shiksha Setu backup.'**
  String get errBackupNotBackup;

  /// No description provided for @errBackupNewer.
  ///
  /// In en, this message translates to:
  /// **'This backup was made with a newer app. Please update the app.'**
  String get errBackupNewer;

  /// No description provided for @errBackupCorrupt.
  ///
  /// In en, this message translates to:
  /// **'This backup file is damaged.'**
  String get errBackupCorrupt;

  /// No description provided for @dialogRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get dialogRestoreTitle;

  /// No description provided for @dialogRestoreBody.
  ///
  /// In en, this message translates to:
  /// **'Backup from {date}: {students} students, {users} accounts. All data in the app will be replaced and you will be signed out.'**
  String dialogRestoreBody(String date, int students, int users);

  /// No description provided for @actionEnterMarks.
  ///
  /// In en, this message translates to:
  /// **'Enter marks'**
  String get actionEnterMarks;

  /// No description provided for @actionMarkConducted.
  ///
  /// In en, this message translates to:
  /// **'Mark as conducted'**
  String get actionMarkConducted;

  /// No description provided for @marksEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Marks — {title}'**
  String marksEntryTitle(String title);

  /// No description provided for @outOfMarks.
  ///
  /// In en, this message translates to:
  /// **'/ {total}'**
  String outOfMarks(int total);

  /// No description provided for @errorMarksTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Above total marks'**
  String get errorMarksTooHigh;

  /// No description provided for @messageMarksSaved.
  ///
  /// In en, this message translates to:
  /// **'Marks saved'**
  String get messageMarksSaved;

  /// No description provided for @actionAddFee.
  ///
  /// In en, this message translates to:
  /// **'Add fee'**
  String get actionAddFee;

  /// No description provided for @sectionPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get sectionPayments;

  /// No description provided for @emptyPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get emptyPayments;

  /// No description provided for @actionShareReceipt.
  ///
  /// In en, this message translates to:
  /// **'Share receipt'**
  String get actionShareReceipt;

  /// No description provided for @emptyFeePeople.
  ///
  /// In en, this message translates to:
  /// **'Everyone here already has a fee, or no one is registered yet.'**
  String get emptyFeePeople;

  /// No description provided for @fieldPerson.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get fieldPerson;

  /// No description provided for @fieldDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get fieldDueDate;

  /// No description provided for @messageFeeAdded.
  ///
  /// In en, this message translates to:
  /// **'Fee added'**
  String get messageFeeAdded;

  /// No description provided for @dashSchoolAndDate.
  ///
  /// In en, this message translates to:
  /// **'{school} · {date}'**
  String dashSchoolAndDate(String school, String date);

  /// No description provided for @sectionNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs your attention'**
  String get sectionNeedsAttention;

  /// No description provided for @allClearTitle.
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get allClearTitle;

  /// No description provided for @allClearBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs your attention right now.'**
  String get allClearBody;

  /// No description provided for @attTeachersNotIn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 teacher has not checked in} other{{count} teachers have not checked in}}'**
  String attTeachersNotIn(int count);

  /// No description provided for @attClassesNotMarked.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 class has no attendance yet} other{{count} classes have no attendance yet}}'**
  String attClassesNotMarked(int count);

  /// No description provided for @attOverdueFees.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 fee account overdue · {amount}} other{{count} fee accounts overdue · {amount}}}'**
  String attOverdueFees(int count, String amount);

  /// No description provided for @attLocationMissing.
  ///
  /// In en, this message translates to:
  /// **'School location is not set, so teachers cannot check in.'**
  String get attLocationMissing;

  /// No description provided for @attNoBackup.
  ///
  /// In en, this message translates to:
  /// **'No backup yet. Your data is only on this phone.'**
  String get attNoBackup;

  /// No description provided for @actionReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get actionReview;

  /// No description provided for @actionViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get actionViewAll;

  /// No description provided for @kpiTeachersIn.
  ///
  /// In en, this message translates to:
  /// **'Teachers in'**
  String get kpiTeachersIn;

  /// No description provided for @kpiStudentsPresent.
  ///
  /// In en, this message translates to:
  /// **'Students present'**
  String get kpiStudentsPresent;

  /// No description provided for @kpiFeesCollected.
  ///
  /// In en, this message translates to:
  /// **'Fees collected'**
  String get kpiFeesCollected;

  /// No description provided for @kpiClassesMarked.
  ///
  /// In en, this message translates to:
  /// **'Classes marked'**
  String get kpiClassesMarked;

  /// No description provided for @sectionClassAttendance.
  ///
  /// In en, this message translates to:
  /// **'Class attendance today'**
  String get sectionClassAttendance;

  /// No description provided for @feesOverdueAmount.
  ///
  /// In en, this message translates to:
  /// **'Overdue {amount}'**
  String feesOverdueAmount(String amount);

  /// No description provided for @sectionUpcomingExams.
  ///
  /// In en, this message translates to:
  /// **'Upcoming exams'**
  String get sectionUpcomingExams;

  /// No description provided for @emptyUpcomingExams.
  ///
  /// In en, this message translates to:
  /// **'No exams scheduled.'**
  String get emptyUpcomingExams;

  /// No description provided for @sectionLatestNotice.
  ///
  /// In en, this message translates to:
  /// **'Latest notice'**
  String get sectionLatestNotice;

  /// No description provided for @emptyLatestNotice.
  ///
  /// In en, this message translates to:
  /// **'No notices yet.'**
  String get emptyLatestNotice;

  /// No description provided for @approvalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get approvalsTitle;

  /// No description provided for @approvalsNeedsApproval.
  ///
  /// In en, this message translates to:
  /// **'Needs approval'**
  String get approvalsNeedsApproval;

  /// No description provided for @approvalsNonePending.
  ///
  /// In en, this message translates to:
  /// **'No pending approvals'**
  String get approvalsNonePending;

  /// No description provided for @actionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get actionView;

  /// No description provided for @actionReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get actionReject;

  /// No description provided for @sectionPendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get sectionPendingApprovals;

  /// No description provided for @sectionDecidedApprovals.
  ///
  /// In en, this message translates to:
  /// **'Decided'**
  String get sectionDecidedApprovals;

  /// No description provided for @emptyApprovals.
  ///
  /// In en, this message translates to:
  /// **'Nothing to approve right now.'**
  String get emptyApprovals;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get themeTitle;

  /// No description provided for @themeHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose two colors for the app: a main color and a second color. Everyone sees them.'**
  String get themeHelp;

  /// No description provided for @themeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current color'**
  String get themeCurrent;

  /// No description provided for @themeDefault.
  ///
  /// In en, this message translates to:
  /// **'Black & white'**
  String get themeDefault;

  /// No description provided for @themeBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeBlue;

  /// No description provided for @themeIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get themeIndigo;

  /// No description provided for @themePurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get themePurple;

  /// No description provided for @themeTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get themeTeal;

  /// No description provided for @themeGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get themeGreen;

  /// No description provided for @themeOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get themeOrange;

  /// No description provided for @themeRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get themeRed;

  /// No description provided for @themeBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get themeBrown;

  /// No description provided for @themePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get themePreview;

  /// No description provided for @themeMainTitle.
  ///
  /// In en, this message translates to:
  /// **'Main color'**
  String get themeMainTitle;

  /// No description provided for @themeAccentTitle.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get themeAccentTitle;

  /// No description provided for @themeAccentAuto.
  ///
  /// In en, this message translates to:
  /// **'Same as main'**
  String get themeAccentAuto;

  /// No description provided for @themeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get themeCustom;

  /// No description provided for @themePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick any color'**
  String get themePickerTitle;

  /// No description provided for @themeHue.
  ///
  /// In en, this message translates to:
  /// **'Shade'**
  String get themeHue;

  /// No description provided for @themeSaturation.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get themeSaturation;

  /// No description provided for @themeBrightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get themeBrightness;

  /// No description provided for @themeApply.
  ///
  /// In en, this message translates to:
  /// **'Use this color'**
  String get themeApply;

  /// No description provided for @addressLoading.
  ///
  /// In en, this message translates to:
  /// **'Finding address…'**
  String get addressLoading;

  /// No description provided for @addressUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Address not available (needs internet)'**
  String get addressUnavailable;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get welcomeSubtitle;

  /// No description provided for @welcomePrincipal.
  ///
  /// In en, this message translates to:
  /// **'I am the Principal'**
  String get welcomePrincipal;

  /// No description provided for @welcomePrincipalHint.
  ///
  /// In en, this message translates to:
  /// **'Create a new school on this phone'**
  String get welcomePrincipalHint;

  /// No description provided for @welcomeAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'School already registered? Sign in'**
  String get welcomeAlreadyRegistered;

  /// No description provided for @registeredSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your school'**
  String get registeredSignInTitle;

  /// No description provided for @registeredSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the email and password you registered with (Principal), or the ones your Principal gave you (Teacher). Your school data will be loaded.'**
  String get registeredSignInSubtitle;

  /// No description provided for @registeredSignInBusy.
  ///
  /// In en, this message translates to:
  /// **'Restoring your school data. This can take a minute…'**
  String get registeredSignInBusy;

  /// No description provided for @errorSchoolNotFound.
  ///
  /// In en, this message translates to:
  /// **'This account is not linked to a school. Please contact your administrator.'**
  String get errorSchoolNotFound;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @errorPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'This password is too common or too simple. Use at least 8 characters with letters and numbers.'**
  String get errorPasswordWeak;

  /// No description provided for @errorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get errorTooManyAttempts;

  /// No description provided for @errorAuthOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please connect to the internet and try again.'**
  String get errorAuthOffline;

  /// No description provided for @errorProfileMissing.
  ///
  /// In en, this message translates to:
  /// **'Your account could not be loaded on this phone. Please try again with internet on.'**
  String get errorProfileMissing;

  /// No description provided for @errorAuthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This is not available right now. Please try again.'**
  String get errorAuthUnavailable;

  /// No description provided for @cloudSignedOutBanner.
  ///
  /// In en, this message translates to:
  /// **'Online backup needs the Principal\'s login. Sign out and sign in again with internet to start.'**
  String get cloudSignedOutBanner;

  /// No description provided for @syncNotifChannel.
  ///
  /// In en, this message translates to:
  /// **'Data sync'**
  String get syncNotifChannel;

  /// No description provided for @syncNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Syncing data to server'**
  String get syncNotifTitle;

  /// No description provided for @syncNotifProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String syncNotifProgress(int done, int total);

  /// No description provided for @cloudAutoSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic sync'**
  String get cloudAutoSyncTitle;

  /// No description provided for @cloudAutoSyncHelp.
  ///
  /// In en, this message translates to:
  /// **'Backs up your changes every few minutes while the app is open, and once more when you leave the app. Needs internet.'**
  String get cloudAutoSyncHelp;

  /// No description provided for @cloudAutoSyncOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get cloudAutoSyncOff;

  /// No description provided for @cloudAutoSyncHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr'**
  String cloudAutoSyncHours(int hours);

  /// No description provided for @cloudSyncProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String cloudSyncProgress(int done, int total);

  /// No description provided for @cloudAutoSyncMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String cloudAutoSyncMinutes(int minutes);

  /// No description provided for @syncNotifDone.
  ///
  /// In en, this message translates to:
  /// **'Data saved to server'**
  String get syncNotifDone;

  /// No description provided for @syncNotifDoneAt.
  ///
  /// In en, this message translates to:
  /// **'Last synced at {time}'**
  String syncNotifDoneAt(String time);

  /// No description provided for @syncFeatureSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get syncFeatureSettings;

  /// No description provided for @syncFeatureStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get syncFeatureStaff;

  /// No description provided for @syncFeatureClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get syncFeatureClasses;

  /// No description provided for @syncFeatureStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get syncFeatureStudents;

  /// No description provided for @syncFeatureCalendar.
  ///
  /// In en, this message translates to:
  /// **'School calendar'**
  String get syncFeatureCalendar;

  /// No description provided for @syncFeatureAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get syncFeatureAttendance;

  /// No description provided for @syncFeatureExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get syncFeatureExams;

  /// No description provided for @syncFeatureFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get syncFeatureFees;

  /// No description provided for @syncFeatureNotices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get syncFeatureNotices;

  /// No description provided for @syncFeatureQuestionBank.
  ///
  /// In en, this message translates to:
  /// **'Question bank'**
  String get syncFeatureQuestionBank;

  /// No description provided for @syncNotifChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking {feature} · {done} of {total}'**
  String syncNotifChecking(String feature, int done, int total);

  /// No description provided for @syncNotifUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Everything was already up to date'**
  String get syncNotifUpToDate;

  /// No description provided for @syncNotifNext.
  ///
  /// In en, this message translates to:
  /// **'Next sync in {when}'**
  String syncNotifNext(String when);

  /// No description provided for @syncFeaturesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 feature} other{{count} features}}'**
  String syncFeaturesCount(int count);

  /// No description provided for @syncNotifTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap for details'**
  String get syncNotifTapHint;

  /// No description provided for @syncDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync details'**
  String get syncDetailsTitle;

  /// No description provided for @syncDetailsLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get syncDetailsLastSync;

  /// No description provided for @syncDetailsLastData.
  ///
  /// In en, this message translates to:
  /// **'Last data sent'**
  String get syncDetailsLastData;

  /// No description provided for @syncDetailsNothingSent.
  ///
  /// In en, this message translates to:
  /// **'No data has been sent yet.'**
  String get syncDetailsNothingSent;

  /// No description provided for @syncDetailsAtTime.
  ///
  /// In en, this message translates to:
  /// **'{date}, {time}'**
  String syncDetailsAtTime(String date, String time);

  /// No description provided for @syncDetailsRemoved.
  ///
  /// In en, this message translates to:
  /// **'{count} removed'**
  String syncDetailsRemoved(int count);

  /// No description provided for @syncStripLast.
  ///
  /// In en, this message translates to:
  /// **'Last synced {when}'**
  String syncStripLast(String when);

  /// No description provided for @syncStripNext.
  ///
  /// In en, this message translates to:
  /// **'Next sync {when}'**
  String syncStripNext(String when);

  /// No description provided for @syncStripOff.
  ///
  /// In en, this message translates to:
  /// **'Automatic sync is off'**
  String get syncStripOff;

  /// No description provided for @syncStripSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing data to server…'**
  String get syncStripSyncing;

  /// No description provided for @approvalNotifChannel.
  ///
  /// In en, this message translates to:
  /// **'Approval requests'**
  String get approvalNotifChannel;

  /// No description provided for @approvalNotifOneTitle.
  ///
  /// In en, this message translates to:
  /// **'New request to approve'**
  String get approvalNotifOneTitle;

  /// No description provided for @approvalNotifOneBody.
  ///
  /// In en, this message translates to:
  /// **'{teacher} sent \"{title}\" for approval'**
  String approvalNotifOneBody(String teacher, String title);

  /// No description provided for @approvalNotifManyTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} new requests to approve'**
  String approvalNotifManyTitle(int count);

  /// No description provided for @approvalNotifManyBody.
  ///
  /// In en, this message translates to:
  /// **'Open the app to review them'**
  String get approvalNotifManyBody;

  /// No description provided for @dashTodoWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 request is waiting for you} other{{count} requests are waiting for you}}'**
  String dashTodoWaiting(int count);

  /// No description provided for @dashTodoWaitingHint.
  ///
  /// In en, this message translates to:
  /// **'Teachers are waiting for your answer.'**
  String get dashTodoWaitingHint;

  /// No description provided for @dashTodoReview.
  ///
  /// In en, this message translates to:
  /// **'Review now'**
  String get dashTodoReview;

  /// No description provided for @dashTodoNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing is waiting for you'**
  String get dashTodoNone;

  /// No description provided for @dashTodoNoneHint.
  ///
  /// In en, this message translates to:
  /// **'New requests from teachers will appear here.'**
  String get dashTodoNoneHint;

  /// No description provided for @dashTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today in school'**
  String get dashTodayTitle;

  /// No description provided for @dashTeachersHere.
  ///
  /// In en, this message translates to:
  /// **'Teachers in'**
  String get dashTeachersHere;

  /// No description provided for @dashStudentsHere.
  ///
  /// In en, this message translates to:
  /// **'Students in'**
  String get dashStudentsHere;

  /// No description provided for @dashClassesDone.
  ///
  /// In en, this message translates to:
  /// **'Classes marked'**
  String get dashClassesDone;

  /// No description provided for @dashFeesLeft.
  ///
  /// In en, this message translates to:
  /// **'Fees due'**
  String get dashFeesLeft;

  /// No description provided for @dashQuickTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get dashQuickTitle;

  /// No description provided for @dashMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get dashMore;

  /// No description provided for @dashTeacherWaitTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the Principal'**
  String get dashTeacherWaitTitle;

  /// No description provided for @dashTeacherWaitBody.
  ///
  /// In en, this message translates to:
  /// **'The Principal has not opened school for today yet. This page updates by itself.'**
  String get dashTeacherWaitBody;

  /// No description provided for @dashTeacherClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'School is closed today'**
  String get dashTeacherClosedTitle;

  /// No description provided for @dashTeacherClosedBody.
  ///
  /// In en, this message translates to:
  /// **'No check-in is needed today.'**
  String get dashTeacherClosedBody;

  /// No description provided for @dashTeacherOpenTitle.
  ///
  /// In en, this message translates to:
  /// **'School is open today'**
  String get dashTeacherOpenTitle;

  /// No description provided for @dashTeacherOpenBody.
  ///
  /// In en, this message translates to:
  /// **'Tap Check In when you reach school.'**
  String get dashTeacherOpenBody;

  /// No description provided for @dashTeacherInTitle.
  ///
  /// In en, this message translates to:
  /// **'You are checked in'**
  String get dashTeacherInTitle;

  /// No description provided for @dashTeacherInBody.
  ///
  /// In en, this message translates to:
  /// **'Checked in at {time}. Tap Check Out when you leave.'**
  String dashTeacherInBody(String time);

  /// No description provided for @dashTeacherOutTitle.
  ///
  /// In en, this message translates to:
  /// **'You are done for today'**
  String get dashTeacherOutTitle;

  /// No description provided for @dashPapersTitle.
  ///
  /// In en, this message translates to:
  /// **'My question papers'**
  String get dashPapersTitle;

  /// No description provided for @dashPapersNone.
  ///
  /// In en, this message translates to:
  /// **'You have not made any paper yet.'**
  String get dashPapersNone;

  /// No description provided for @dashPapersWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 waiting for the Principal} other{{count} waiting for the Principal}}'**
  String dashPapersWaiting(int count);

  /// No description provided for @dashPapersSentBack.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sent back, needs your changes} other{{count} sent back, need your changes}}'**
  String dashPapersSentBack(int count);

  /// No description provided for @dashPapersDrafts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 draft not sent} other{{count} drafts not sent}}'**
  String dashPapersDrafts(int count);

  /// No description provided for @dashPapersApproved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 approved} other{{count} approved}}'**
  String dashPapersApproved(int count);

  /// No description provided for @dashRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get dashRefreshed;

  /// No description provided for @approvalsWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 request waiting} other{{count} requests waiting}}'**
  String approvalsWaitingTitle(int count);

  /// No description provided for @approvalsPullHint.
  ///
  /// In en, this message translates to:
  /// **'Pull down to check for new requests'**
  String get approvalsPullHint;

  /// No description provided for @approvalsDecidedApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvalsDecidedApproved;

  /// No description provided for @approvalsDecidedRejected.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get approvalsDecidedRejected;

  /// No description provided for @descAttendance.
  ///
  /// In en, this message translates to:
  /// **'See who came today: teachers and students'**
  String get descAttendance;

  /// No description provided for @descMarkAttendance.
  ///
  /// In en, this message translates to:
  /// **'Mark your class\'s students present, absent or late'**
  String get descMarkAttendance;

  /// No description provided for @descExams.
  ///
  /// In en, this message translates to:
  /// **'Make question papers and send them for approval'**
  String get descExams;

  /// No description provided for @descQuestionBank.
  ///
  /// In en, this message translates to:
  /// **'Questions you saved, to use again in any paper'**
  String get descQuestionBank;

  /// No description provided for @descStudentProfiles.
  ///
  /// In en, this message translates to:
  /// **'Each student\'s details, attendance, fees and marks'**
  String get descStudentProfiles;

  /// No description provided for @descTeacherProfiles.
  ///
  /// In en, this message translates to:
  /// **'Each teacher\'s details, check-ins and papers'**
  String get descTeacherProfiles;

  /// No description provided for @descClasses.
  ///
  /// In en, this message translates to:
  /// **'Add classes and see their students'**
  String get descClasses;

  /// No description provided for @descRegister.
  ///
  /// In en, this message translates to:
  /// **'Add a new student, teacher or staff member'**
  String get descRegister;

  /// No description provided for @descTeachers.
  ///
  /// In en, this message translates to:
  /// **'Class teachers, subjects, on or off'**
  String get descTeachers;

  /// No description provided for @descFees.
  ///
  /// In en, this message translates to:
  /// **'See fees due and collect payments'**
  String get descFees;

  /// No description provided for @descPayments.
  ///
  /// In en, this message translates to:
  /// **'Every payment received so far'**
  String get descPayments;

  /// No description provided for @descApprovals.
  ///
  /// In en, this message translates to:
  /// **'Requests waiting for your answer'**
  String get descApprovals;

  /// No description provided for @descAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Charts and reports for the school'**
  String get descAnalytics;

  /// No description provided for @descCalendar.
  ///
  /// In en, this message translates to:
  /// **'See which days school was open or closed'**
  String get descCalendar;

  /// No description provided for @descHolidays.
  ///
  /// In en, this message translates to:
  /// **'The school\'s list of holidays'**
  String get descHolidays;

  /// No description provided for @descNotices.
  ///
  /// In en, this message translates to:
  /// **'Messages for everyone in school'**
  String get descNotices;

  /// No description provided for @drawerMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get drawerMoreTitle;

  /// No description provided for @moduleMyAttendance.
  ///
  /// In en, this message translates to:
  /// **'My attendance'**
  String get moduleMyAttendance;

  /// No description provided for @descMyAttendance.
  ///
  /// In en, this message translates to:
  /// **'Your own check-in and check-out'**
  String get descMyAttendance;

  /// No description provided for @myAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'My attendance (check-in)'**
  String get myAttendanceTitle;

  /// No description provided for @markingTitle.
  ///
  /// In en, this message translates to:
  /// **'Student attendance · Class {name}'**
  String markingTitle(String name);

  /// No description provided for @categoryTeachingSubject.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get categoryTeachingSubject;

  /// No description provided for @approvalSubjectQuestion.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to teach this subject in this class.'**
  String approvalSubjectQuestion(String name);

  /// No description provided for @moduleMySubjects.
  ///
  /// In en, this message translates to:
  /// **'My subjects'**
  String get moduleMySubjects;

  /// No description provided for @descMySubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects and classes you teach. Ask for a new one.'**
  String get descMySubjects;

  /// No description provided for @subjectsTitleFor.
  ///
  /// In en, this message translates to:
  /// **'Subjects of {name}'**
  String subjectsTitleFor(String name);

  /// No description provided for @subjectAskButton.
  ///
  /// In en, this message translates to:
  /// **'Ask for a subject'**
  String get subjectAskButton;

  /// No description provided for @subjectGiveButton.
  ///
  /// In en, this message translates to:
  /// **'Give a subject'**
  String get subjectGiveButton;

  /// No description provided for @subjectSheetAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask the Principal for a subject'**
  String get subjectSheetAskTitle;

  /// No description provided for @subjectSheetGiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Give a subject to {name}'**
  String subjectSheetGiveTitle(String name);

  /// No description provided for @subjectSheetHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the class, then the subject.'**
  String get subjectSheetHint;

  /// No description provided for @subjectSend.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get subjectSend;

  /// No description provided for @subjectGive.
  ///
  /// In en, this message translates to:
  /// **'Give subject'**
  String get subjectGive;

  /// No description provided for @subjectStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get subjectStatusApproved;

  /// No description provided for @subjectStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the Principal'**
  String get subjectStatusPending;

  /// No description provided for @subjectStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get subjectStatusRejected;

  /// No description provided for @subjectRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent to the Principal'**
  String get subjectRequestSent;

  /// No description provided for @subjectGiven.
  ///
  /// In en, this message translates to:
  /// **'Subject given'**
  String get subjectGiven;

  /// No description provided for @subjectEmptyTeacher.
  ///
  /// In en, this message translates to:
  /// **'You have no subject yet. Tap the button below to ask the Principal.'**
  String get subjectEmptyTeacher;

  /// No description provided for @subjectEmptyPrincipal.
  ///
  /// In en, this message translates to:
  /// **'No subject given yet. Tap the button below to give one.'**
  String get subjectEmptyPrincipal;

  /// No description provided for @subjectRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered subject: {subject} (all classes)'**
  String subjectRegistered(String subject);

  /// No description provided for @subjectRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this subject?'**
  String get subjectRemoveTitle;

  /// No description provided for @subjectRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'{subject} · {cls} will be removed.'**
  String subjectRemoveBody(String subject, String cls);

  /// No description provided for @subjectNoneForPaper.
  ///
  /// In en, this message translates to:
  /// **'You have no subject yet. Ask the Principal for one before making a paper.'**
  String get subjectNoneForPaper;

  /// No description provided for @subjectChooseClassFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose the class first'**
  String get subjectChooseClassFirst;

  /// No description provided for @subjectNoneInClass.
  ///
  /// In en, this message translates to:
  /// **'No subject allowed in this class'**
  String get subjectNoneInClass;

  /// No description provided for @staffActionSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects and classes'**
  String get staffActionSubjects;

  /// No description provided for @staffActionSubjectsHint.
  ///
  /// In en, this message translates to:
  /// **'What this teacher teaches, and where'**
  String get staffActionSubjectsHint;

  /// No description provided for @paperDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Paper details'**
  String get paperDetailsTitle;

  /// No description provided for @paperMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get paperMoreOptions;

  /// No description provided for @paperMoreOptionsHint.
  ///
  /// In en, this message translates to:
  /// **'Instructions for students (optional)'**
  String get paperMoreOptionsHint;

  /// No description provided for @paperQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Or add many questions at once'**
  String get paperQuickAdd;

  /// No description provided for @paperQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question} other{{count} questions}} · {marks} marks'**
  String paperQuestionsCount(int count, int marks);

  /// No description provided for @paperTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get paperTools;

  /// No description provided for @tabWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get tabWaiting;

  /// No description provided for @tabReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get tabReady;

  /// No description provided for @tabDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get tabDrafts;

  /// No description provided for @tabDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tabDone;

  /// No description provided for @dialogSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get dialogSignOutTitle;

  /// No description provided for @dialogSignOutBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again.'**
  String get dialogSignOutBody;

  /// No description provided for @actionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// No description provided for @noticeAnnounceTitle.
  ///
  /// In en, this message translates to:
  /// **'Run it on everyone\'s Dashboard'**
  String get noticeAnnounceTitle;

  /// No description provided for @noticeAnnounceHint.
  ///
  /// In en, this message translates to:
  /// **'It moves along the top until you stop it.'**
  String get noticeAnnounceHint;

  /// No description provided for @announceStop.
  ///
  /// In en, this message translates to:
  /// **'Stop announcement'**
  String get announceStop;

  /// No description provided for @dashSchoolToday.
  ///
  /// In en, this message translates to:
  /// **'School today'**
  String get dashSchoolToday;

  /// No description provided for @dashStateOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get dashStateOpen;

  /// No description provided for @dashStateClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get dashStateClosed;

  /// No description provided for @dashStateWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get dashStateWaiting;

  /// No description provided for @dashTeachersAbsent.
  ///
  /// In en, this message translates to:
  /// **'Teachers absent'**
  String get dashTeachersAbsent;

  /// No description provided for @dashStudentsAbsent.
  ///
  /// In en, this message translates to:
  /// **'Students absent'**
  String get dashStudentsAbsent;

  /// No description provided for @dashFeesCollected.
  ///
  /// In en, this message translates to:
  /// **'Fees collected'**
  String get dashFeesCollected;

  /// No description provided for @dashOverdueFees.
  ///
  /// In en, this message translates to:
  /// **'Overdue fee accounts'**
  String get dashOverdueFees;

  /// No description provided for @dashUpcomingExams.
  ///
  /// In en, this message translates to:
  /// **'Upcoming exams'**
  String get dashUpcomingExams;

  /// No description provided for @dashRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher requests'**
  String get dashRequestsTitle;

  /// No description provided for @dashRequestsNone.
  ///
  /// In en, this message translates to:
  /// **'No request is waiting for your answer.'**
  String get dashRequestsNone;

  /// No description provided for @dashRequestsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 request needs your answer.} other{{count} requests need your answer.}} Tap to open Approvals.'**
  String dashRequestsWaiting(int count);

  /// No description provided for @dashRequestsClear.
  ///
  /// In en, this message translates to:
  /// **'None pending'**
  String get dashRequestsClear;

  /// No description provided for @dashRequestsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String dashRequestsCount(int count);

  /// No description provided for @greetingNight.
  ///
  /// In en, this message translates to:
  /// **'Good night, {name}'**
  String greetingNight(String name);

  /// No description provided for @actionSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get actionSync;

  /// No description provided for @actionSyncHint.
  ///
  /// In en, this message translates to:
  /// **'Saves your data to the cloud and checks for new requests'**
  String get actionSyncHint;

  /// No description provided for @dashSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing: saving your data and checking for new requests…'**
  String get dashSyncing;

  /// No description provided for @syncStripDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get syncStripDetails;

  /// No description provided for @syncTable_app_settings.
  ///
  /// In en, this message translates to:
  /// **'School settings'**
  String get syncTable_app_settings;

  /// No description provided for @syncTable_users.
  ///
  /// In en, this message translates to:
  /// **'Teacher and Principal profiles'**
  String get syncTable_users;

  /// No description provided for @syncTable_other_staff.
  ///
  /// In en, this message translates to:
  /// **'Other staff'**
  String get syncTable_other_staff;

  /// No description provided for @syncTable_teacher_subjects.
  ///
  /// In en, this message translates to:
  /// **'Teacher subjects'**
  String get syncTable_teacher_subjects;

  /// No description provided for @syncTable_classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get syncTable_classes;

  /// No description provided for @syncTable_students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get syncTable_students;

  /// No description provided for @syncTable_school_days.
  ///
  /// In en, this message translates to:
  /// **'School days'**
  String get syncTable_school_days;

  /// No description provided for @syncTable_school_day_changes.
  ///
  /// In en, this message translates to:
  /// **'School day edits'**
  String get syncTable_school_day_changes;

  /// No description provided for @syncTable_teacher_attendance.
  ///
  /// In en, this message translates to:
  /// **'Teacher attendance'**
  String get syncTable_teacher_attendance;

  /// No description provided for @syncTable_student_attendance.
  ///
  /// In en, this message translates to:
  /// **'Student attendance'**
  String get syncTable_student_attendance;

  /// No description provided for @syncTable_exam_papers.
  ///
  /// In en, this message translates to:
  /// **'Question papers'**
  String get syncTable_exam_papers;

  /// No description provided for @syncTable_exam_questions.
  ///
  /// In en, this message translates to:
  /// **'Paper questions'**
  String get syncTable_exam_questions;

  /// No description provided for @syncTable_exam_marks.
  ///
  /// In en, this message translates to:
  /// **'Exam marks'**
  String get syncTable_exam_marks;

  /// No description provided for @syncTable_fee_accounts.
  ///
  /// In en, this message translates to:
  /// **'Fee accounts'**
  String get syncTable_fee_accounts;

  /// No description provided for @syncTable_fee_payments.
  ///
  /// In en, this message translates to:
  /// **'Fee payments'**
  String get syncTable_fee_payments;

  /// No description provided for @syncTable_notices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get syncTable_notices;

  /// No description provided for @syncTable_master_questions.
  ///
  /// In en, this message translates to:
  /// **'Question bank'**
  String get syncTable_master_questions;

  /// No description provided for @syncStripSent.
  ///
  /// In en, this message translates to:
  /// **'Sent {count}'**
  String syncStripSent(int count);

  /// No description provided for @syncStripReceived.
  ///
  /// In en, this message translates to:
  /// **'Received {count}'**
  String syncStripReceived(int count);

  /// No description provided for @syncStripNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing sent or received yet'**
  String get syncStripNothingYet;

  /// No description provided for @syncStripLastData.
  ///
  /// In en, this message translates to:
  /// **'Last data {when}'**
  String syncStripLastData(String when);

  /// No description provided for @syncDetailsStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get syncDetailsStatus;

  /// No description provided for @syncDetailsNextSync.
  ///
  /// In en, this message translates to:
  /// **'Next sync'**
  String get syncDetailsNextSync;

  /// No description provided for @syncDetailsChecksEvery.
  ///
  /// In en, this message translates to:
  /// **'Checks for new data every {seconds} seconds'**
  String syncDetailsChecksEvery(int seconds);

  /// No description provided for @syncDetailsSyncingNow.
  ///
  /// In en, this message translates to:
  /// **'Syncing now…'**
  String get syncDetailsSyncingNow;

  /// No description provided for @syncDetailsCloudUpload.
  ///
  /// In en, this message translates to:
  /// **'Saved to the cloud'**
  String get syncDetailsCloudUpload;

  /// No description provided for @syncDetailsLastCheck.
  ///
  /// In en, this message translates to:
  /// **'Last check for new data'**
  String get syncDetailsLastCheck;

  /// No description provided for @syncDetailsSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Sent from this phone'**
  String get syncDetailsSentTitle;

  /// No description provided for @syncDetailsReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Received on this phone'**
  String get syncDetailsReceivedTitle;

  /// No description provided for @syncDetailsNothingReceived.
  ///
  /// In en, this message translates to:
  /// **'Nothing new has been received yet.'**
  String get syncDetailsNothingReceived;

  /// No description provided for @syncDetailsRecordsSent.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record} other{{count} records}}'**
  String syncDetailsRecordsSent(int count);

  /// No description provided for @syncDetailsRecordsRemoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record removed} other{{count} records removed}}'**
  String syncDetailsRecordsRemoved(int count);

  /// No description provided for @syncDetailsOffline.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server on the last check.'**
  String get syncDetailsOffline;

  /// No description provided for @syncDetailsNeverChecked.
  ///
  /// In en, this message translates to:
  /// **'Not checked yet'**
  String get syncDetailsNeverChecked;

  /// No description provided for @staffTapForMore.
  ///
  /// In en, this message translates to:
  /// **'Tap to do more: assign class, subjects and more'**
  String get staffTapForMore;

  /// No description provided for @registerWho.
  ///
  /// In en, this message translates to:
  /// **'Who are you registering?'**
  String get registerWho;

  /// No description provided for @aadhaarMissingReason.
  ///
  /// In en, this message translates to:
  /// **'No Aadhaar: {reason}'**
  String aadhaarMissingReason(String reason);

  /// No description provided for @syncKindAdded.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get syncKindAdded;

  /// No description provided for @syncKindChanged.
  ///
  /// In en, this message translates to:
  /// **'Changed'**
  String get syncKindChanged;

  /// No description provided for @syncKindRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get syncKindRemoved;

  /// No description provided for @syncDetailsEarlierUnknown.
  ///
  /// In en, this message translates to:
  /// **'The earlier value was not kept'**
  String get syncDetailsEarlierUnknown;

  /// No description provided for @syncDetailsMoreNotListed.
  ///
  /// In en, this message translates to:
  /// **'{count} more records not listed'**
  String syncDetailsMoreNotListed(int count);

  /// No description provided for @syncValueEmpty.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get syncValueEmpty;

  /// No description provided for @syncDetailsWas.
  ///
  /// In en, this message translates to:
  /// **'was'**
  String get syncDetailsWas;

  /// No description provided for @syncDetailsNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get syncDetailsNow;

  /// No description provided for @dashTeachersTitle.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get dashTeachersTitle;

  /// No description provided for @dashStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get dashStudentsTitle;

  /// No description provided for @dashTotalCount.
  ///
  /// In en, this message translates to:
  /// **'Total {count}'**
  String dashTotalCount(int count);

  /// No description provided for @attReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance report'**
  String get attReportTitle;

  /// No description provided for @attReportCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance status'**
  String get attReportCardTitle;

  /// No description provided for @attReportCardHint.
  ///
  /// In en, this message translates to:
  /// **'Students, teachers and others · tap to see the table'**
  String get attReportCardHint;

  /// No description provided for @attGroupStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get attGroupStudents;

  /// No description provided for @attGroupTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get attGroupTeachers;

  /// No description provided for @attGroupOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get attGroupOthers;

  /// No description provided for @attMarkNotMarked.
  ///
  /// In en, this message translates to:
  /// **'Not marked'**
  String get attMarkNotMarked;

  /// No description provided for @attMarkNotTracked.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get attMarkNotTracked;

  /// No description provided for @attColName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get attColName;

  /// No description provided for @attColClassRole.
  ///
  /// In en, this message translates to:
  /// **'Class / role'**
  String get attColClassRole;

  /// No description provided for @attColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get attColStatus;

  /// No description provided for @attColTime.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get attColTime;

  /// No description provided for @attFilterDetail.
  ///
  /// In en, this message translates to:
  /// **'Class / subject / role'**
  String get attFilterDetail;

  /// No description provided for @attSearchName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get attSearchName;

  /// No description provided for @attClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get attClearFilters;

  /// No description provided for @attShowing.
  ///
  /// In en, this message translates to:
  /// **'Showing {shown} of {total}'**
  String attShowing(int shown, int total);

  /// No description provided for @attReportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No one matches these filters.'**
  String get attReportEmpty;

  /// No description provided for @attReportOthersNote.
  ///
  /// In en, this message translates to:
  /// **'Attendance of other staff is not recorded in the app.'**
  String get attReportOthersNote;

  /// No description provided for @attReportToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get attReportToday;

  /// No description provided for @attReportPickDay.
  ///
  /// In en, this message translates to:
  /// **'Pick a day'**
  String get attReportPickDay;

  /// No description provided for @attReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'You have not checked in yet'**
  String get attReminderTitle;

  /// No description provided for @attReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Check in now so that today\'s attendance is recorded.'**
  String get attReminderBody;

  /// No description provided for @demoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get demoDataTitle;

  /// No description provided for @demoDataBody.
  ///
  /// In en, this message translates to:
  /// **'Fill the school with made-up data to try every feature: classes Nursery to 8, students, male and female teachers, other staff, attendance, exams, fees, notices and more. Your own data is not changed, and \"Remove\" takes out only the demo data. You will be asked to sign in again.'**
  String get demoDataBody;

  /// No description provided for @demoDataLoad.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get demoDataLoad;

  /// No description provided for @demoDataRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get demoDataRemove;

  /// No description provided for @demoDataLoaded.
  ///
  /// In en, this message translates to:
  /// **'Demo data added. Please sign in again.'**
  String get demoDataLoaded;

  /// No description provided for @demoDataRemoved.
  ///
  /// In en, this message translates to:
  /// **'Demo data removed. Please sign in again.'**
  String get demoDataRemoved;

  /// No description provided for @demoDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not change the demo data. Please try again.'**
  String get demoDataFailed;

  /// No description provided for @featureFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get featureFees;

  /// No description provided for @featureAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get featureAccessories;

  /// No description provided for @featurePerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get featurePerformance;

  /// No description provided for @featureAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get featureAttendance;

  /// No description provided for @featureClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get featureClasses;

  /// No description provided for @featureTeacherPayment.
  ///
  /// In en, this message translates to:
  /// **'Teacher payment'**
  String get featureTeacherPayment;

  /// No description provided for @featureQuestionBank.
  ///
  /// In en, this message translates to:
  /// **'Question bank'**
  String get featureQuestionBank;

  /// No description provided for @featureExamPapers.
  ///
  /// In en, this message translates to:
  /// **'Exam papers'**
  String get featureExamPapers;

  /// No description provided for @featureStaffPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get featureStaffPayment;

  /// No description provided for @featureBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get featureBills;

  /// No description provided for @featureSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get featureSubjects;

  /// No description provided for @addStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add student'**
  String get addStudentTitle;

  /// No description provided for @addTeacherTitle.
  ///
  /// In en, this message translates to:
  /// **'Add teacher'**
  String get addTeacherTitle;

  /// No description provided for @addStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get addStaffTitle;

  /// No description provided for @editStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit student'**
  String get editStudentTitle;

  /// No description provided for @messageSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get messageSaved;

  /// No description provided for @searchStudentsHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or roll no.'**
  String get searchStudentsHint;

  /// No description provided for @searchTeachersHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or subject'**
  String get searchTeachersHint;

  /// No description provided for @searchStaffHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or role'**
  String get searchStaffHint;

  /// No description provided for @filterAllClasses.
  ///
  /// In en, this message translates to:
  /// **'All classes'**
  String get filterAllClasses;

  /// No description provided for @summaryVan.
  ///
  /// In en, this message translates to:
  /// **'Van {van}'**
  String summaryVan(String van);

  /// No description provided for @summaryClassTeacher.
  ///
  /// In en, this message translates to:
  /// **'Class teacher, {name}'**
  String summaryClassTeacher(String name);

  /// No description provided for @memberOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get memberOpen;

  /// No description provided for @memberEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get memberEdit;

  /// No description provided for @memberMakeInactive.
  ///
  /// In en, this message translates to:
  /// **'Make inactive'**
  String get memberMakeInactive;

  /// No description provided for @memberMakeActive.
  ///
  /// In en, this message translates to:
  /// **'Make active'**
  String get memberMakeActive;

  /// No description provided for @memberInactiveTag.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get memberInactiveTag;

  /// No description provided for @memberShowInactive.
  ///
  /// In en, this message translates to:
  /// **'Show inactive ({count})'**
  String memberShowInactive(int count);

  /// No description provided for @memberMadeInactive.
  ///
  /// In en, this message translates to:
  /// **'{name} is now inactive'**
  String memberMadeInactive(String name);

  /// No description provided for @memberMadeActive.
  ///
  /// In en, this message translates to:
  /// **'{name} is active again'**
  String memberMadeActive(String name);

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @dashStudentsIn.
  ///
  /// In en, this message translates to:
  /// **'Students in'**
  String get dashStudentsIn;

  /// No description provided for @dashTeachersIn.
  ///
  /// In en, this message translates to:
  /// **'Teachers in'**
  String get dashTeachersIn;

  /// No description provided for @dashOthersIn.
  ///
  /// In en, this message translates to:
  /// **'Others in'**
  String get dashOthersIn;

  /// No description provided for @dashNotMarkedYet.
  ///
  /// In en, this message translates to:
  /// **'Not marked yet'**
  String get dashNotMarkedYet;

  /// No description provided for @dashInOf.
  ///
  /// In en, this message translates to:
  /// **'{present} of {total}'**
  String dashInOf(int present, int total);

  /// No description provided for @navStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get navStudents;

  /// No description provided for @navTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get navTeachers;

  /// No description provided for @navOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get navOthers;

  /// No description provided for @syncTable_staff_attendance.
  ///
  /// In en, this message translates to:
  /// **'Other staff attendance'**
  String get syncTable_staff_attendance;

  /// No description provided for @attTitleStudents.
  ///
  /// In en, this message translates to:
  /// **'Student attendance'**
  String get attTitleStudents;

  /// No description provided for @attTitleTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teacher attendance'**
  String get attTitleTeachers;

  /// No description provided for @attTitleOthers.
  ///
  /// In en, this message translates to:
  /// **'Staff attendance'**
  String get attTitleOthers;

  /// No description provided for @attTabAll.
  ///
  /// In en, this message translates to:
  /// **'All {count}'**
  String attTabAll(int count);

  /// No description provided for @attTabMark.
  ///
  /// In en, this message translates to:
  /// **'{label} {count}'**
  String attTabMark(String label, int count);

  /// No description provided for @attMeaningTeachers.
  ///
  /// In en, this message translates to:
  /// **'Present means checked in with location and face. Absent means no check-in on this day.'**
  String get attMeaningTeachers;

  /// No description provided for @attMeaningStudents.
  ///
  /// In en, this message translates to:
  /// **'Present, absent and late are marked by the class teacher. A class shows Not marked until it is done.'**
  String get attMeaningStudents;

  /// No description provided for @attMeaningOthers.
  ///
  /// In en, this message translates to:
  /// **'You mark staff attendance yourself. Not marked means this day has not been done yet.'**
  String get attMeaningOthers;

  /// No description provided for @attFilterClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get attFilterClass;

  /// No description provided for @attFilterRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get attFilterRole;

  /// No description provided for @attMarkStaff.
  ///
  /// In en, this message translates to:
  /// **'Mark attendance'**
  String get attMarkStaff;

  /// No description provided for @attStaffMarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark staff attendance'**
  String get attStaffMarkTitle;

  /// No description provided for @attTeachersCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'{present} of {total} teachers have checked in'**
  String attTeachersCheckedIn(int present, int total);

  /// No description provided for @syncTable_fee_structure.
  ///
  /// In en, this message translates to:
  /// **'Fee setup'**
  String get syncTable_fee_structure;

  /// No description provided for @proofAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get proofAddPhoto;

  /// No description provided for @proofTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get proofTakePhoto;

  /// No description provided for @proofFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get proofFromGallery;

  /// No description provided for @proofRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get proofRemove;

  /// No description provided for @proofSignHere.
  ///
  /// In en, this message translates to:
  /// **'Sign here'**
  String get proofSignHere;

  /// No description provided for @proofClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get proofClear;

  /// No description provided for @proofView.
  ///
  /// In en, this message translates to:
  /// **'View proof'**
  String get proofView;

  /// No description provided for @proofNone.
  ///
  /// In en, this message translates to:
  /// **'No proof added'**
  String get proofNone;

  /// No description provided for @proofPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo proof'**
  String get proofPhotoTitle;

  /// No description provided for @proofSignatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get proofSignatureTitle;

  /// No description provided for @proofSignedTag.
  ///
  /// In en, this message translates to:
  /// **'Signed'**
  String get proofSignedTag;

  /// No description provided for @proofPhotoTag.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get proofPhotoTag;

  /// No description provided for @proofMissing.
  ///
  /// In en, this message translates to:
  /// **'The file is not on this phone any more.'**
  String get proofMissing;

  /// No description provided for @feeHeadAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic fee'**
  String get feeHeadAcademic;

  /// No description provided for @feeHeadDress.
  ///
  /// In en, this message translates to:
  /// **'Dress'**
  String get feeHeadDress;

  /// No description provided for @feeHeadBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get feeHeadBooks;

  /// No description provided for @feeHeadVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get feeHeadVan;

  /// No description provided for @feeHeadPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get feeHeadPayment;

  /// No description provided for @payModeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get payModeCash;

  /// No description provided for @payModeUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get payModeUpi;

  /// No description provided for @payModeCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get payModeCheque;

  /// No description provided for @payModeBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get payModeBank;

  /// No description provided for @feeDueLast.
  ///
  /// In en, this message translates to:
  /// **'Due {due} · Last date {last}'**
  String feeDueLast(String due, String last);

  /// No description provided for @feeNoPaymentYet.
  ///
  /// In en, this message translates to:
  /// **'No payment yet'**
  String get feeNoPaymentYet;

  /// No description provided for @feeChangeDates.
  ///
  /// In en, this message translates to:
  /// **'Change dates'**
  String get feeChangeDates;

  /// No description provided for @feeDatesNote.
  ///
  /// In en, this message translates to:
  /// **'Own dates: {note}'**
  String feeDatesNote(String note);

  /// No description provided for @recordPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get recordPaymentTitle;

  /// No description provided for @fieldPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on'**
  String get fieldPaidOn;

  /// No description provided for @fieldHowPaid.
  ///
  /// In en, this message translates to:
  /// **'How paid'**
  String get fieldHowPaid;

  /// No description provided for @fieldReferenceUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI transaction id'**
  String get fieldReferenceUpi;

  /// No description provided for @fieldReferenceCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque number'**
  String get fieldReferenceCheque;

  /// No description provided for @fieldReferenceBank.
  ///
  /// In en, this message translates to:
  /// **'Bank reference (UTR)'**
  String get fieldReferenceBank;

  /// No description provided for @fieldReferenceCash.
  ///
  /// In en, this message translates to:
  /// **'Receipt book no. (optional)'**
  String get fieldReferenceCash;

  /// No description provided for @fieldProofPhoto.
  ///
  /// In en, this message translates to:
  /// **'Proof (photo or screenshot)'**
  String get fieldProofPhoto;

  /// No description provided for @errorReferenceRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the reference.'**
  String get errorReferenceRequired;

  /// No description provided for @errorProofRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a photo as proof for this kind of payment.'**
  String get errorProofRequired;

  /// No description provided for @messagePaymentSavedReceipt.
  ///
  /// In en, this message translates to:
  /// **'Payment saved. Receipt {no}'**
  String messagePaymentSavedReceipt(String no);

  /// No description provided for @paymentProofYes.
  ///
  /// In en, this message translates to:
  /// **'Proof added'**
  String get paymentProofYes;

  /// No description provided for @paymentProofNo.
  ///
  /// In en, this message translates to:
  /// **'No proof'**
  String get paymentProofNo;

  /// No description provided for @feeAccountNotFound.
  ///
  /// In en, this message translates to:
  /// **'This fee is no longer there.'**
  String get feeAccountNotFound;

  /// No description provided for @feeLedgerPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get feeLedgerPaymentsTitle;

  /// No description provided for @fieldReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get fieldReason;

  /// No description provided for @feeSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Fee setup'**
  String get feeSetupTitle;

  /// No description provided for @feeSetupDue.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get feeSetupDue;

  /// No description provided for @feeSetupLast.
  ///
  /// In en, this message translates to:
  /// **'Last date'**
  String get feeSetupLast;

  /// No description provided for @feeSetupAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get feeSetupAmount;

  /// No description provided for @feeSetupApplies.
  ///
  /// In en, this message translates to:
  /// **'These apply to all students of {name}.'**
  String feeSetupApplies(String name);

  /// No description provided for @feeSetupNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set up yet'**
  String get feeSetupNotSet;

  /// No description provided for @feeSetupEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get feeSetupEdit;

  /// No description provided for @feeSetupSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get feeSetupSetUp;

  /// No description provided for @feeSetupGive.
  ///
  /// In en, this message translates to:
  /// **'Give to students'**
  String get feeSetupGive;

  /// No description provided for @feeSetupGiven.
  ///
  /// In en, this message translates to:
  /// **'{count} students now have this fee'**
  String feeSetupGiven(int count);

  /// No description provided for @feeSetupNoneToGive.
  ///
  /// In en, this message translates to:
  /// **'Everyone already has this fee'**
  String get feeSetupNoneToGive;

  /// No description provided for @feeSetupMeaning.
  ///
  /// In en, this message translates to:
  /// **'Due date is the day the fee becomes payable. After the last date it shows as overdue. A student who needs different dates is changed from their own fee screen.'**
  String get feeSetupMeaning;

  /// No description provided for @feeSetupVanNote.
  ///
  /// In en, this message translates to:
  /// **'Only for students who travel by van.'**
  String get feeSetupVanNote;

  /// No description provided for @feeSetupNoClasses.
  ///
  /// In en, this message translates to:
  /// **'Add classes first.'**
  String get feeSetupNoClasses;

  /// No description provided for @syncTable_accessory_items.
  ///
  /// In en, this message translates to:
  /// **'Dress and book lists'**
  String get syncTable_accessory_items;

  /// No description provided for @syncTable_accessory_issues.
  ///
  /// In en, this message translates to:
  /// **'Dress and books given'**
  String get syncTable_accessory_issues;

  /// No description provided for @fieldVan.
  ///
  /// In en, this message translates to:
  /// **'Van (if the student travels by van)'**
  String get fieldVan;

  /// No description provided for @fieldNoVan.
  ///
  /// In en, this message translates to:
  /// **'No van'**
  String get fieldNoVan;

  /// No description provided for @accKindDress.
  ///
  /// In en, this message translates to:
  /// **'Dress'**
  String get accKindDress;

  /// No description provided for @accKindBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get accKindBooks;

  /// No description provided for @accSummaryDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} given'**
  String accSummaryDone(int done, int total);

  /// No description provided for @accSummaryNot.
  ///
  /// In en, this message translates to:
  /// **'{count} not given'**
  String accSummaryNot(int count);

  /// No description provided for @accSetDress.
  ///
  /// In en, this message translates to:
  /// **'Dress set'**
  String get accSetDress;

  /// No description provided for @accSetBooks.
  ///
  /// In en, this message translates to:
  /// **'Book list'**
  String get accSetBooks;

  /// No description provided for @accSetEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not set up yet. Tap Edit set.'**
  String get accSetEmpty;

  /// No description provided for @accEditSet.
  ///
  /// In en, this message translates to:
  /// **'Edit set'**
  String get accEditSet;

  /// No description provided for @accSetHintDress.
  ///
  /// In en, this message translates to:
  /// **'One piece per line, for example: Shirt'**
  String get accSetHintDress;

  /// No description provided for @accSetHintBooks.
  ///
  /// In en, this message translates to:
  /// **'One book per line'**
  String get accSetHintBooks;

  /// No description provided for @accSizesButton.
  ///
  /// In en, this message translates to:
  /// **'Dress sizes {done}/{total}'**
  String accSizesButton(int done, int total);

  /// No description provided for @accSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size {size}'**
  String accSizeLabel(String size);

  /// No description provided for @accSizeNotNoted.
  ///
  /// In en, this message translates to:
  /// **'Size not noted'**
  String get accSizeNotNoted;

  /// No description provided for @accNoteSize.
  ///
  /// In en, this message translates to:
  /// **'Note size'**
  String get accNoteSize;

  /// No description provided for @accIssue.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get accIssue;

  /// No description provided for @accGive.
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get accGive;

  /// No description provided for @accGivenOf.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} given'**
  String accGivenOf(int done, int total);

  /// No description provided for @accComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get accComplete;

  /// No description provided for @accIssuedTag.
  ///
  /// In en, this message translates to:
  /// **'Issued'**
  String get accIssuedTag;

  /// No description provided for @accSizesTitle.
  ///
  /// In en, this message translates to:
  /// **'Dress sizes'**
  String get accSizesTitle;

  /// No description provided for @accSizesNoted.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} noted'**
  String accSizesNoted(int done, int total);

  /// No description provided for @accSizesOrder.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get accSizesOrder;

  /// No description provided for @accSizesNotNoted.
  ///
  /// In en, this message translates to:
  /// **'Not noted ×{count}'**
  String accSizesNotNoted(int count);

  /// No description provided for @accSizesField.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get accSizesField;

  /// No description provided for @accSizesSave.
  ///
  /// In en, this message translates to:
  /// **'Save sizes'**
  String get accSizesSave;

  /// No description provided for @accSizesSaved.
  ///
  /// In en, this message translates to:
  /// **'Sizes saved'**
  String get accSizesSaved;

  /// No description provided for @accIssueTitleDress.
  ///
  /// In en, this message translates to:
  /// **'Issue dress'**
  String get accIssueTitleDress;

  /// No description provided for @accIssueTitleBooks.
  ///
  /// In en, this message translates to:
  /// **'Give books'**
  String get accIssueTitleBooks;

  /// No description provided for @accItemsGiven.
  ///
  /// In en, this message translates to:
  /// **'Items given'**
  String get accItemsGiven;

  /// No description provided for @accSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get accSets;

  /// No description provided for @accReceivedBy.
  ///
  /// In en, this message translates to:
  /// **'Received by'**
  String get accReceivedBy;

  /// No description provided for @accSignTitle.
  ///
  /// In en, this message translates to:
  /// **'Receiver\'s signature'**
  String get accSignTitle;

  /// No description provided for @accPhotoOptional.
  ///
  /// In en, this message translates to:
  /// **'Photo (optional)'**
  String get accPhotoOptional;

  /// No description provided for @accIssuedBy.
  ///
  /// In en, this message translates to:
  /// **'Issued by {name}'**
  String accIssuedBy(String name);

  /// No description provided for @accIssueAndSave.
  ///
  /// In en, this message translates to:
  /// **'Issue and save receipt'**
  String get accIssueAndSave;

  /// No description provided for @accIssuedSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved. Receipt {no}'**
  String accIssuedSaved(String no);

  /// No description provided for @accProblemNoItems.
  ///
  /// In en, this message translates to:
  /// **'Tick at least one item.'**
  String get accProblemNoItems;

  /// No description provided for @accProblemReceiver.
  ///
  /// In en, this message translates to:
  /// **'Enter who received it.'**
  String get accProblemReceiver;

  /// No description provided for @accProblemSignature.
  ///
  /// In en, this message translates to:
  /// **'The receiver must sign.'**
  String get accProblemSignature;

  /// No description provided for @accProblemSize.
  ///
  /// In en, this message translates to:
  /// **'Enter the size.'**
  String get accProblemSize;

  /// No description provided for @accNoItemsSetup.
  ///
  /// In en, this message translates to:
  /// **'Set up this class\'s list first (Edit set).'**
  String get accNoItemsSetup;

  /// No description provided for @accLogEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing has been given yet.'**
  String get accLogEmpty;

  /// No description provided for @accLogViewSignature.
  ///
  /// In en, this message translates to:
  /// **'View signature'**
  String get accLogViewSignature;

  /// No description provided for @accLogViewPhoto.
  ///
  /// In en, this message translates to:
  /// **'View photo'**
  String get accLogViewPhoto;

  /// No description provided for @accLogReceived.
  ///
  /// In en, this message translates to:
  /// **'Received by {name} · {date}'**
  String accLogReceived(String name, String date);

  /// No description provided for @accLogGiveRest.
  ///
  /// In en, this message translates to:
  /// **'Give remaining'**
  String get accLogGiveRest;

  /// No description provided for @accNotGivenYet.
  ///
  /// In en, this message translates to:
  /// **'Not given yet: {items}'**
  String accNotGivenYet(String items);

  /// No description provided for @profileAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get profileAccessories;

  /// No description provided for @accNoClasses.
  ///
  /// In en, this message translates to:
  /// **'Add classes first.'**
  String get accNoClasses;

  /// No description provided for @approvalsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, class or title'**
  String get approvalsSearchHint;

  /// No description provided for @approvalsTabWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting {count}'**
  String approvalsTabWaiting(int count);

  /// No description provided for @approvalsTabAnswered.
  ///
  /// In en, this message translates to:
  /// **'Answered {count}'**
  String approvalsTabAnswered(int count);

  /// No description provided for @approvalsChipCount.
  ///
  /// In en, this message translates to:
  /// **'{label} {count}'**
  String approvalsChipCount(String label, int count);

  /// No description provided for @fieldVanNumber.
  ///
  /// In en, this message translates to:
  /// **'Van number'**
  String get fieldVanNumber;

  /// No description provided for @hintVanNumber.
  ///
  /// In en, this message translates to:
  /// **'For example UP32 AB 1234'**
  String get hintVanNumber;

  /// No description provided for @dashWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} waiting for you'**
  String dashWaitingTitle(int count);

  /// No description provided for @dashWaitingNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing is waiting for you'**
  String get dashWaitingNone;

  /// No description provided for @dashWaitingOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get dashWaitingOpen;

  /// No description provided for @dashSectionPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get dashSectionPeople;

  /// No description provided for @homeTileTiming.
  ///
  /// In en, this message translates to:
  /// **'School timing'**
  String get homeTileTiming;

  /// No description provided for @homeTileAssembly.
  ///
  /// In en, this message translates to:
  /// **'Assembly'**
  String get homeTileAssembly;

  /// No description provided for @homeTilePeriods.
  ///
  /// In en, this message translates to:
  /// **'Period schedule'**
  String get homeTilePeriods;

  /// No description provided for @homeTileCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get homeTileCalendar;

  /// No description provided for @homeTileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeTileSettings;

  /// No description provided for @homeGreetingLine.
  ///
  /// In en, this message translates to:
  /// **'{date} · {greeting}'**
  String homeGreetingLine(String date, String greeting);

  /// No description provided for @syncTable_school_timings.
  ///
  /// In en, this message translates to:
  /// **'Class timings'**
  String get syncTable_school_timings;

  /// No description provided for @syncTable_bell_slots.
  ///
  /// In en, this message translates to:
  /// **'Period timings'**
  String get syncTable_bell_slots;

  /// No description provided for @syncTable_assembly_duty.
  ///
  /// In en, this message translates to:
  /// **'Assembly duty'**
  String get syncTable_assembly_duty;

  /// No description provided for @syncTable_timetable_entries.
  ///
  /// In en, this message translates to:
  /// **'Class timetable'**
  String get syncTable_timetable_entries;

  /// No description provided for @timingTitle.
  ///
  /// In en, this message translates to:
  /// **'School timing'**
  String get timingTitle;

  /// No description provided for @timingStarts.
  ///
  /// In en, this message translates to:
  /// **'School starts'**
  String get timingStarts;

  /// No description provided for @timingEnds.
  ///
  /// In en, this message translates to:
  /// **'School ends'**
  String get timingEnds;

  /// No description provided for @timingNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get timingNotSet;

  /// No description provided for @timingWorkingDays.
  ///
  /// In en, this message translates to:
  /// **'Working days'**
  String get timingWorkingDays;

  /// No description provided for @timingClassRules.
  ///
  /// In en, this message translates to:
  /// **'Different timing for some classes'**
  String get timingClassRules;

  /// No description provided for @timingAddAnother.
  ///
  /// In en, this message translates to:
  /// **'+ Add another timing'**
  String get timingAddAnother;

  /// No description provided for @timingSeasonal.
  ///
  /// In en, this message translates to:
  /// **'Seasonal timing'**
  String get timingSeasonal;

  /// No description provided for @timingSeasonalHint.
  ///
  /// In en, this message translates to:
  /// **'Summer timing from a date, winter timing from a date.'**
  String get timingSeasonalHint;

  /// No description provided for @timingAdd.
  ///
  /// In en, this message translates to:
  /// **'+ Add'**
  String get timingAdd;

  /// No description provided for @timingNote.
  ///
  /// In en, this message translates to:
  /// **'Shown on Home, in the period schedule and at the teacher\'s check-in. Whether a late check-in is flagged after the start time is not decided.'**
  String get timingNote;

  /// No description provided for @timingRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timingRuleTitle;

  /// No description provided for @timingRuleClasses.
  ///
  /// In en, this message translates to:
  /// **'For these classes (none picked means every class)'**
  String get timingRuleClasses;

  /// No description provided for @timingRuleFrom.
  ///
  /// In en, this message translates to:
  /// **'Starts from'**
  String get timingRuleFrom;

  /// No description provided for @timingRuleFromNone.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get timingRuleFromNone;

  /// No description provided for @timingRuleRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get timingRuleRemove;

  /// No description provided for @timingRuleFromDate.
  ///
  /// In en, this message translates to:
  /// **'{range} from {date}'**
  String timingRuleFromDate(String range, String date);

  /// No description provided for @assemblyTitle.
  ///
  /// In en, this message translates to:
  /// **'School assembly'**
  String get assemblyTitle;

  /// No description provided for @assemblyTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get assemblyTime;

  /// No description provided for @assemblyPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get assemblyPlace;

  /// No description provided for @assemblyDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get assemblyDays;

  /// No description provided for @assemblyOrder.
  ///
  /// In en, this message translates to:
  /// **'Running order'**
  String get assemblyOrder;

  /// No description provided for @assemblyOrderHint.
  ///
  /// In en, this message translates to:
  /// **'One item per line, for example: Prayer'**
  String get assemblyOrderHint;

  /// No description provided for @assemblyDutyTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is on duty'**
  String get assemblyDutyTitle;

  /// No description provided for @assemblyInCharge.
  ///
  /// In en, this message translates to:
  /// **'In charge: {name}'**
  String assemblyInCharge(String name);

  /// No description provided for @assemblyDutyClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get assemblyDutyClass;

  /// No description provided for @assemblyDutyTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher in charge'**
  String get assemblyDutyTeacher;

  /// No description provided for @assemblyDutyClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get assemblyDutyClear;

  /// No description provided for @periodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Period timings'**
  String get periodsTitle;

  /// No description provided for @periodsAdd.
  ///
  /// In en, this message translates to:
  /// **'+ Period'**
  String get periodsAdd;

  /// No description provided for @periodsHint.
  ///
  /// In en, this message translates to:
  /// **'The bell schedule for the whole school. Classes fill in subjects next.'**
  String get periodsHint;

  /// No description provided for @periodsAssembly.
  ///
  /// In en, this message translates to:
  /// **'Assembly'**
  String get periodsAssembly;

  /// No description provided for @periodsFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get periodsFixed;

  /// No description provided for @periodN.
  ///
  /// In en, this message translates to:
  /// **'Period {n}'**
  String periodN(int n);

  /// No description provided for @periodBreakTag.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get periodBreakTag;

  /// No description provided for @periodEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get periodEdit;

  /// No description provided for @periodKindPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get periodKindPeriod;

  /// No description provided for @periodKindBreak.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get periodKindBreak;

  /// No description provided for @periodLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (for a break, e.g. Lunch)'**
  String get periodLabel;

  /// No description provided for @periodMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String periodMinutes(int minutes);

  /// No description provided for @periodsTimetableButton.
  ///
  /// In en, this message translates to:
  /// **'Class timetable'**
  String get periodsTimetableButton;

  /// No description provided for @periodRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get periodRemove;

  /// No description provided for @periodTimeRange.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String periodTimeRange(String start, String end);

  /// No description provided for @periodEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The end must be after the start.'**
  String get periodEndBeforeStart;

  /// No description provided for @timetableTitle.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get timetableTitle;

  /// No description provided for @timetableCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy to…'**
  String get timetableCopy;

  /// No description provided for @timetableChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get timetableChange;

  /// No description provided for @timetableNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get timetableNotSet;

  /// No description provided for @timetableClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get timetableClear;

  /// No description provided for @timetableConflict.
  ///
  /// In en, this message translates to:
  /// **'{teacher} is already teaching {className} in {slot} on {day}. Choose another teacher or period.'**
  String timetableConflict(
    String teacher,
    String className,
    String slot,
    String day,
  );

  /// No description provided for @timetableNoOptions.
  ///
  /// In en, this message translates to:
  /// **'No teacher is allotted to this class yet. Allot subjects from the teacher\'s Subjects.'**
  String get timetableNoOptions;

  /// No description provided for @timetableCopied.
  ///
  /// In en, this message translates to:
  /// **'{copied} periods copied, {skipped} left out (teacher busy)'**
  String timetableCopied(int copied, int skipped);

  /// No description provided for @timetableCopyTo.
  ///
  /// In en, this message translates to:
  /// **'Copy {day} to'**
  String timetableCopyTo(String day);

  /// No description provided for @timetableNoSlots.
  ///
  /// In en, this message translates to:
  /// **'Set the period timings first.'**
  String get timetableNoSlots;

  /// No description provided for @timetablePickTitle.
  ///
  /// In en, this message translates to:
  /// **'{slot} · {day}'**
  String timetablePickTitle(String slot, String day);

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @categoryTagExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get categoryTagExam;

  /// No description provided for @categoryTagSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get categoryTagSubject;

  /// No description provided for @categoryTagBill.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get categoryTagBill;

  /// No description provided for @approvalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{waiting} waiting · {total} total'**
  String approvalsSubtitle(int waiting, int total);

  /// No description provided for @approvalAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get approvalAllow;

  /// No description provided for @approvalDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get approvalDecline;

  /// No description provided for @approvalTabWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get approvalTabWaiting;

  /// No description provided for @approvalTabApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvalTabApproved;

  /// No description provided for @approvalTabRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get approvalTabRejected;

  /// No description provided for @aadhaarScanCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Aadhaar card'**
  String get aadhaarScanCardTitle;

  /// No description provided for @aadhaarScanCardHint.
  ///
  /// In en, this message translates to:
  /// **'Fills name, birth date, gender, address'**
  String get aadhaarScanCardHint;

  /// No description provided for @saveStudent.
  ///
  /// In en, this message translates to:
  /// **'Save student'**
  String get saveStudent;

  /// No description provided for @saveTeacher.
  ///
  /// In en, this message translates to:
  /// **'Save teacher'**
  String get saveTeacher;

  /// No description provided for @saveStaff.
  ///
  /// In en, this message translates to:
  /// **'Save staff'**
  String get saveStaff;

  /// No description provided for @actionAssignFee.
  ///
  /// In en, this message translates to:
  /// **'+ Assign fee'**
  String get actionAssignFee;

  /// No description provided for @profileTileFeesDue.
  ///
  /// In en, this message translates to:
  /// **'{amount} due'**
  String profileTileFeesDue(String amount);

  /// No description provided for @profileTileFeesClear.
  ///
  /// In en, this message translates to:
  /// **'All paid'**
  String get profileTileFeesClear;

  /// No description provided for @profileTileAvg.
  ///
  /// In en, this message translates to:
  /// **'Avg {percent}%'**
  String profileTileAvg(int percent);

  /// No description provided for @profileTileAttendance.
  ///
  /// In en, this message translates to:
  /// **'{percent}% this term'**
  String profileTileAttendance(int percent);

  /// No description provided for @profileTileNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet'**
  String get profileTileNone;

  /// No description provided for @profileGuardianLine.
  ///
  /// In en, this message translates to:
  /// **'Guardian: {name} · {phone}'**
  String profileGuardianLine(String name, String phone);

  /// No description provided for @syncTable_staff_bills.
  ///
  /// In en, this message translates to:
  /// **'Fuel bills'**
  String get syncTable_staff_bills;

  /// No description provided for @syncTable_staff_settlements.
  ///
  /// In en, this message translates to:
  /// **'Staff payments'**
  String get syncTable_staff_settlements;

  /// No description provided for @categoryStaffBill.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get categoryStaffBill;

  /// No description provided for @approvalBillLine.
  ///
  /// In en, this message translates to:
  /// **'{name} · {detail} · {date}'**
  String approvalBillLine(String name, String detail, String date);

  /// No description provided for @billsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get billsTitle;

  /// No description provided for @billsAdd.
  ///
  /// In en, this message translates to:
  /// **'+ Bill'**
  String get billsAdd;

  /// No description provided for @billsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get billsTabAll;

  /// No description provided for @billsTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get billsTabPending;

  /// No description provided for @billsTabApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get billsTabApproved;

  /// No description provided for @billsTabPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billsTabPaid;

  /// No description provided for @billRowTitle.
  ///
  /// In en, this message translates to:
  /// **'{kind} · {amount}'**
  String billRowTitle(String kind, String amount);

  /// No description provided for @billRowSub.
  ///
  /// In en, this message translates to:
  /// **'{date} · {litres} L · {proof}'**
  String billRowSub(String date, String litres, String proof);

  /// No description provided for @billRowSubNoLitres.
  ///
  /// In en, this message translates to:
  /// **'{date} · {proof}'**
  String billRowSubNoLitres(String date, String proof);

  /// No description provided for @billPhasePending.
  ///
  /// In en, this message translates to:
  /// **'Pending approval'**
  String get billPhasePending;

  /// No description provided for @billPhaseApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get billPhaseApproved;

  /// No description provided for @billPhaseRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get billPhaseRejected;

  /// No description provided for @billPhasePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billPhasePaid;

  /// No description provided for @billPhotoYes.
  ///
  /// In en, this message translates to:
  /// **'photo'**
  String get billPhotoYes;

  /// No description provided for @billPhotoNo.
  ///
  /// In en, this message translates to:
  /// **'no photo'**
  String get billPhotoNo;

  /// No description provided for @billsRule.
  ///
  /// In en, this message translates to:
  /// **'Only an approved bill can be paid. Pending and rejected bills are locked.'**
  String get billsRule;

  /// No description provided for @billsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bills yet.'**
  String get billsEmpty;

  /// No description provided for @fuelPetrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get fuelPetrol;

  /// No description provided for @fuelDiesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get fuelDiesel;

  /// No description provided for @addBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Add bill'**
  String get addBillTitle;

  /// No description provided for @fieldBillDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldBillDate;

  /// No description provided for @fieldLitres.
  ///
  /// In en, this message translates to:
  /// **'Litres'**
  String get fieldLitres;

  /// No description provided for @fieldBillAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fieldBillAmount;

  /// No description provided for @fieldBillPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo of the bill'**
  String get fieldBillPhoto;

  /// No description provided for @fieldBillNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get fieldBillNote;

  /// No description provided for @billSendForApproval.
  ///
  /// In en, this message translates to:
  /// **'Send for approval'**
  String get billSendForApproval;

  /// No description provided for @billSent.
  ///
  /// In en, this message translates to:
  /// **'Bill sent for approval'**
  String get billSent;

  /// No description provided for @errBillAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount.'**
  String get errBillAmount;

  /// No description provided for @errBillPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of the bill.'**
  String get errBillPhoto;

  /// No description provided for @billChooseStaff.
  ///
  /// In en, this message translates to:
  /// **'Whose bill is it?'**
  String get billChooseStaff;

  /// No description provided for @staffPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get staffPaymentTitle;

  /// No description provided for @staffPayableNow.
  ///
  /// In en, this message translates to:
  /// **'Payable now (approved bills)'**
  String get staffPayableNow;

  /// No description provided for @staffEligible.
  ///
  /// In en, this message translates to:
  /// **'Eligible · approved'**
  String get staffEligible;

  /// No description provided for @staffSettle.
  ///
  /// In en, this message translates to:
  /// **'Settle {amount}'**
  String staffSettle(String amount);

  /// No description provided for @staffNotEligible.
  ///
  /// In en, this message translates to:
  /// **'Not eligible yet'**
  String get staffNotEligible;

  /// No description provided for @staffLockedWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your approval'**
  String get staffLockedWaiting;

  /// No description provided for @staffLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get staffLocked;

  /// No description provided for @staffGoApprovals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get staffGoApprovals;

  /// No description provided for @staffPayHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get staffPayHistory;

  /// No description provided for @staffNothingPayable.
  ///
  /// In en, this message translates to:
  /// **'Nothing is ready to pay.'**
  String get staffNothingPayable;

  /// No description provided for @staffPayableLine.
  ///
  /// In en, this message translates to:
  /// **'{amount} payable'**
  String staffPayableLine(String amount);

  /// No description provided for @staffBillsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count} awaiting approval'**
  String staffBillsWaiting(int count);

  /// No description provided for @staffNoBillsYet.
  ///
  /// In en, this message translates to:
  /// **'No bills yet'**
  String get staffNoBillsYet;

  /// No description provided for @settleTitle.
  ///
  /// In en, this message translates to:
  /// **'Settle payment'**
  String get settleTitle;

  /// No description provided for @settleAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get settleAmountPaid;

  /// No description provided for @settleProof.
  ///
  /// In en, this message translates to:
  /// **'Proof of settlement'**
  String get settleProof;

  /// No description provided for @settlePaidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by {name}'**
  String settlePaidBy(String name);

  /// No description provided for @settleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm and save voucher'**
  String get settleConfirm;

  /// No description provided for @settleSaved.
  ///
  /// In en, this message translates to:
  /// **'Paid. Voucher {no}'**
  String settleSaved(String no);

  /// No description provided for @settleNothing.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one bill.'**
  String get settleNothing;

  /// No description provided for @settleNotApproved.
  ///
  /// In en, this message translates to:
  /// **'Some of these bills are no longer approved.'**
  String get settleNotApproved;

  /// No description provided for @settlementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get settlementsTitle;

  /// No description provided for @settlementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get settlementsEmpty;

  /// No description provided for @settlementLine.
  ///
  /// In en, this message translates to:
  /// **'{mode} · {date}'**
  String settlementLine(String mode, String date);

  /// No description provided for @settlementRef.
  ///
  /// In en, this message translates to:
  /// **'Ref {ref}'**
  String settlementRef(String ref);

  /// No description provided for @settlementBills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{For 1 bill} other{For {count} bills}}'**
  String settlementBills(int count);

  /// No description provided for @settlementViewProof.
  ///
  /// In en, this message translates to:
  /// **'View proof'**
  String get settlementViewProof;

  /// No description provided for @staffRoleLine.
  ///
  /// In en, this message translates to:
  /// **'Phone {phone}'**
  String staffRoleLine(String phone);

  /// No description provided for @staffTilePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get staffTilePayment;

  /// No description provided for @staffTileBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get staffTileBills;

  /// No description provided for @teacherSubjectsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get teacherSubjectsListTitle;

  /// No description provided for @teacherSubjectsLine.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No subjects yet} =1{1 subject} other{{count} subjects}}'**
  String teacherSubjectsLine(int count);

  /// No description provided for @navMyClass.
  ///
  /// In en, this message translates to:
  /// **'My class'**
  String get navMyClass;

  /// No description provided for @navExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get navExams;

  /// No description provided for @teacherTodayPeriods.
  ///
  /// In en, this message translates to:
  /// **'Today\'s periods'**
  String get teacherTodayPeriods;

  /// No description provided for @teacherNoPeriods.
  ///
  /// In en, this message translates to:
  /// **'No periods set for today.'**
  String get teacherNoPeriods;

  /// No description provided for @teacherAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'+ Question'**
  String get teacherAddQuestion;

  /// No description provided for @teacherAssemblyDuty.
  ///
  /// In en, this message translates to:
  /// **'Assembly duty: {day}'**
  String teacherAssemblyDuty(String day);

  /// No description provided for @teacherAssemblyDutyLine.
  ///
  /// In en, this message translates to:
  /// **'{className} · {time}'**
  String teacherAssemblyDutyLine(String className, String time);

  /// No description provided for @teacherMarkNow.
  ///
  /// In en, this message translates to:
  /// **'Mark now'**
  String get teacherMarkNow;

  /// No description provided for @teacherClassNotMarked.
  ///
  /// In en, this message translates to:
  /// **'{className} attendance not marked'**
  String teacherClassNotMarked(String className);

  /// No description provided for @teacherClassStudents.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String teacherClassStudents(int count);

  /// No description provided for @teacherClassMarked.
  ///
  /// In en, this message translates to:
  /// **'{className} attendance done'**
  String teacherClassMarked(String className);

  /// No description provided for @teacherClassPresentOf.
  ///
  /// In en, this message translates to:
  /// **'{present} of {total} present'**
  String teacherClassPresentOf(int present, int total);

  /// No description provided for @myClassTitle.
  ///
  /// In en, this message translates to:
  /// **'My class · {name}'**
  String myClassTitle(String name);

  /// No description provided for @myClassNone.
  ///
  /// In en, this message translates to:
  /// **'No class is given to you yet. Ask the Principal.'**
  String get myClassNone;

  /// No description provided for @myClassMark.
  ///
  /// In en, this message translates to:
  /// **'Mark attendance'**
  String get myClassMark;

  /// No description provided for @myClassView.
  ///
  /// In en, this message translates to:
  /// **'View today\'s attendance'**
  String get myClassView;

  /// No description provided for @syncTable_question_units.
  ///
  /// In en, this message translates to:
  /// **'Question bank units'**
  String get syncTable_question_units;

  /// No description provided for @bankTitle.
  ///
  /// In en, this message translates to:
  /// **'My question bank'**
  String get bankTitle;

  /// No description provided for @bankAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'+ Question'**
  String get bankAddQuestion;

  /// No description provided for @bankSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} questions in {units} units'**
  String bankSummary(int count, int units);

  /// No description provided for @bankUnitEmpty.
  ///
  /// In en, this message translates to:
  /// **'No questions yet'**
  String get bankUnitEmpty;

  /// No description provided for @bankNoScopes.
  ///
  /// In en, this message translates to:
  /// **'You have no subject yet. Ask the Principal to give you one.'**
  String get bankNoScopes;

  /// No description provided for @bankNoUnits.
  ///
  /// In en, this message translates to:
  /// **'No units yet. Add a unit, then its questions.'**
  String get bankNoUnits;

  /// No description provided for @bankAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add questions'**
  String get bankAddTitle;

  /// No description provided for @bankAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the questions'**
  String get bankAddPhoto;

  /// No description provided for @bankAddPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'From your book, worksheet or board.'**
  String get bankAddPhotoHint;

  /// No description provided for @bankFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get bankFastest;

  /// No description provided for @bankAddGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo from the phone'**
  String get bankAddGallery;

  /// No description provided for @bankAddGalleryHint.
  ///
  /// In en, this message translates to:
  /// **'A picture you already took.'**
  String get bankAddGalleryHint;

  /// No description provided for @bankAddType.
  ///
  /// In en, this message translates to:
  /// **'Type one question'**
  String get bankAddType;

  /// No description provided for @bankAddTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Write it yourself.'**
  String get bankAddTypeHint;

  /// No description provided for @bankClassSubject.
  ///
  /// In en, this message translates to:
  /// **'Class · Subject'**
  String get bankClassSubject;

  /// No description provided for @bankUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get bankUnitLabel;

  /// No description provided for @bankNewUnit.
  ///
  /// In en, this message translates to:
  /// **'+ New unit'**
  String get bankNewUnit;

  /// No description provided for @bankNewUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'New unit'**
  String get bankNewUnitTitle;

  /// No description provided for @bankNewUnitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Unit 2 · Verbs'**
  String get bankNewUnitHint;

  /// No description provided for @bankAddOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get bankAddOneTitle;

  /// No description provided for @bankSaveAnother.
  ///
  /// In en, this message translates to:
  /// **'Save and add another'**
  String get bankSaveAnother;

  /// No description provided for @bankSaved.
  ///
  /// In en, this message translates to:
  /// **'Question saved'**
  String get bankSaved;

  /// No description provided for @bankDeleted.
  ///
  /// In en, this message translates to:
  /// **'Question deleted'**
  String get bankDeleted;

  /// No description provided for @bankPickUnit.
  ///
  /// In en, this message translates to:
  /// **'Choose a unit first.'**
  String get bankPickUnit;

  /// No description provided for @photoTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo questions'**
  String get photoTitle;

  /// No description provided for @photoStep.
  ///
  /// In en, this message translates to:
  /// **'Step {n} of 4'**
  String photoStep(int n);

  /// No description provided for @photoWhereGo.
  ///
  /// In en, this message translates to:
  /// **'Where should these go?'**
  String get photoWhereGo;

  /// No description provided for @photoTips.
  ///
  /// In en, this message translates to:
  /// **'Tips for a clear photo'**
  String get photoTips;

  /// No description provided for @photoTip1.
  ///
  /// In en, this message translates to:
  /// **'Good light, no shadow'**
  String get photoTip1;

  /// No description provided for @photoTip2.
  ///
  /// In en, this message translates to:
  /// **'Page flat, all four corners in view'**
  String get photoTip2;

  /// No description provided for @photoTip3.
  ///
  /// In en, this message translates to:
  /// **'One page at a time'**
  String get photoTip3;

  /// No description provided for @photoPages.
  ///
  /// In en, this message translates to:
  /// **'Pages taken: {count}'**
  String photoPages(int count);

  /// No description provided for @photoPageN.
  ///
  /// In en, this message translates to:
  /// **'Page {n}'**
  String photoPageN(int n);

  /// No description provided for @photoAddPage.
  ///
  /// In en, this message translates to:
  /// **'Add another page'**
  String get photoAddPage;

  /// No description provided for @photoRead.
  ///
  /// In en, this message translates to:
  /// **'Read questions'**
  String get photoRead;

  /// No description provided for @photoReading.
  ///
  /// In en, this message translates to:
  /// **'Reading the photos…'**
  String get photoReading;

  /// No description provided for @photoNothing.
  ///
  /// In en, this message translates to:
  /// **'No questions could be read. Try a clearer photo.'**
  String get photoNothing;

  /// No description provided for @photoFound.
  ///
  /// In en, this message translates to:
  /// **'{count} questions found in {pages} pages · {name}'**
  String photoFound(int count, int pages, String name);

  /// No description provided for @photoCheckEach.
  ///
  /// In en, this message translates to:
  /// **'Check each one. Tap a question to fix it.'**
  String get photoCheckEach;

  /// No description provided for @photoFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All {count}'**
  String photoFilterAll(int count);

  /// No description provided for @photoFilterNeed.
  ///
  /// In en, this message translates to:
  /// **'Need answer {count}'**
  String photoFilterNeed(int count);

  /// No description provided for @photoFilterCheck.
  ///
  /// In en, this message translates to:
  /// **'Check {count}'**
  String photoFilterCheck(int count);

  /// No description provided for @flagReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get flagReady;

  /// No description provided for @flagAnswerMissing.
  ///
  /// In en, this message translates to:
  /// **'Answer missing'**
  String get flagAnswerMissing;

  /// No description provided for @flagCheckPairs.
  ///
  /// In en, this message translates to:
  /// **'Check pairs'**
  String get flagCheckPairs;

  /// No description provided for @flagLeftOut.
  ///
  /// In en, this message translates to:
  /// **'Left out'**
  String get flagLeftOut;

  /// No description provided for @photoHeadingNote.
  ///
  /// In en, this message translates to:
  /// **'Looks like a heading, not a question'**
  String get photoHeadingNote;

  /// No description provided for @photoSaveTo.
  ///
  /// In en, this message translates to:
  /// **'Save to {name}'**
  String photoSaveTo(String name);

  /// No description provided for @photoSaveN.
  ///
  /// In en, this message translates to:
  /// **'Save {count}'**
  String photoSaveN(int count);

  /// No description provided for @photoFixTitle.
  ///
  /// In en, this message translates to:
  /// **'Fix question'**
  String get photoFixTitle;

  /// No description provided for @photoFixOf.
  ///
  /// In en, this message translates to:
  /// **'{n} of {total}'**
  String photoFixOf(int n, int total);

  /// No description provided for @photoPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get photoPrevious;

  /// No description provided for @photoNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get photoNext;

  /// No description provided for @photoSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get photoSavedTitle;

  /// No description provided for @photoSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions added'**
  String photoSavedCount(int count);

  /// No description provided for @photoBefore.
  ///
  /// In en, this message translates to:
  /// **'{name} before'**
  String photoBefore(String name);

  /// No description provided for @photoNow.
  ///
  /// In en, this message translates to:
  /// **'{name} now'**
  String photoNow(String name);

  /// No description provided for @photoTakeAnother.
  ///
  /// In en, this message translates to:
  /// **'Take another photo'**
  String get photoTakeAnother;

  /// No description provided for @photoMakePaper.
  ///
  /// In en, this message translates to:
  /// **'Make a paper from my bank'**
  String get photoMakePaper;

  /// No description provided for @kindWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly test'**
  String get kindWeekly;

  /// No description provided for @kindMidMonthly.
  ///
  /// In en, this message translates to:
  /// **'Mid-monthly test'**
  String get kindMidMonthly;

  /// No description provided for @kindUnitTest.
  ///
  /// In en, this message translates to:
  /// **'Unit test'**
  String get kindUnitTest;

  /// No description provided for @kindHalfYearly.
  ///
  /// In en, this message translates to:
  /// **'Half-yearly exam'**
  String get kindHalfYearly;

  /// No description provided for @kindYearlyFinal.
  ///
  /// In en, this message translates to:
  /// **'Yearly final exam'**
  String get kindYearlyFinal;

  /// No description provided for @makeTitle.
  ///
  /// In en, this message translates to:
  /// **'Make paper'**
  String get makeTitle;

  /// No description provided for @makeStep.
  ///
  /// In en, this message translates to:
  /// **'Step {n} of 5'**
  String makeStep(int n);

  /// No description provided for @makeExamType.
  ///
  /// In en, this message translates to:
  /// **'Exam type'**
  String get makeExamType;

  /// No description provided for @makeTotalMarks.
  ///
  /// In en, this message translates to:
  /// **'Total marks'**
  String get makeTotalMarks;

  /// No description provided for @makeTime.
  ///
  /// In en, this message translates to:
  /// **'Time (minutes)'**
  String get makeTime;

  /// No description provided for @makeDate.
  ///
  /// In en, this message translates to:
  /// **'Exam date'**
  String get makeDate;

  /// No description provided for @makeNextUnits.
  ///
  /// In en, this message translates to:
  /// **'Next: pick units'**
  String get makeNextUnits;

  /// No description provided for @makePickUnits.
  ///
  /// In en, this message translates to:
  /// **'Which units does this test cover?'**
  String get makePickUnits;

  /// No description provided for @makeUnitCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String makeUnitCount(int count);

  /// No description provided for @makeNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions in your bank'**
  String get makeNoQuestions;

  /// No description provided for @makeUnitsSummary.
  ///
  /// In en, this message translates to:
  /// **'{units} units · {count} questions to choose from'**
  String makeUnitsSummary(int units, int count);

  /// No description provided for @makeNextTypes.
  ///
  /// In en, this message translates to:
  /// **'Next: question types'**
  String get makeNextTypes;

  /// No description provided for @makePlanned.
  ///
  /// In en, this message translates to:
  /// **'{planned} of {total} marks planned'**
  String makePlanned(int planned, int total);

  /// No description provided for @makeTypesHave.
  ///
  /// In en, this message translates to:
  /// **'Types you have in these units'**
  String get makeTypesHave;

  /// No description provided for @makeAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} available'**
  String makeAvailable(int count);

  /// No description provided for @makeTakeFrom.
  ///
  /// In en, this message translates to:
  /// **'Take from:'**
  String get makeTakeFrom;

  /// No description provided for @makeQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get makeQuestions;

  /// No description provided for @makeMarksEach.
  ///
  /// In en, this message translates to:
  /// **'Marks each'**
  String get makeMarksEach;

  /// No description provided for @makeNotUsed.
  ///
  /// In en, this message translates to:
  /// **'not used'**
  String get makeNotUsed;

  /// No description provided for @makeShort.
  ///
  /// In en, this message translates to:
  /// **'Ask for {want} and the bank has only {have}.'**
  String makeShort(int want, int have);

  /// No description provided for @makeMakeSet.
  ///
  /// In en, this message translates to:
  /// **'Make the set'**
  String get makeMakeSet;

  /// No description provided for @makeReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review set'**
  String get makeReviewTitle;

  /// No description provided for @makeMarksOf.
  ///
  /// In en, this message translates to:
  /// **'{have} / {want} marks'**
  String makeMarksOf(int have, int want);

  /// No description provided for @makeReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get makeReplace;

  /// No description provided for @makeNewSet.
  ///
  /// In en, this message translates to:
  /// **'Make a new set'**
  String get makeNewSet;

  /// No description provided for @makeNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get makeNext;

  /// No description provided for @makeReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace question'**
  String get makeReplaceTitle;

  /// No description provided for @makeReplacing.
  ///
  /// In en, this message translates to:
  /// **'Replacing'**
  String get makeReplacing;

  /// No description provided for @makeOtherOfType.
  ///
  /// In en, this message translates to:
  /// **'Other questions of this type from your bank'**
  String get makeOtherOfType;

  /// No description provided for @makeUse.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get makeUse;

  /// No description provided for @makeReplaceHint.
  ///
  /// In en, this message translates to:
  /// **'Questions already in this paper are hidden. Marks stay as planned.'**
  String get makeReplaceHint;

  /// No description provided for @makeNoOthers.
  ///
  /// In en, this message translates to:
  /// **'No other questions of this type.'**
  String get makeNoOthers;

  /// No description provided for @makeSendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send for approval'**
  String get makeSendTitle;

  /// No description provided for @makeSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'{name} · {marks} marks · {minutes} min'**
  String makeSummaryLine(String name, int marks, int minutes);

  /// No description provided for @makeMadeFrom.
  ///
  /// In en, this message translates to:
  /// **'Made from my question bank · {count} questions replaced by hand'**
  String makeMadeFrom(int count);

  /// No description provided for @makeSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get makeSaveDraft;

  /// No description provided for @makeSend.
  ///
  /// In en, this message translates to:
  /// **'Send to Principal'**
  String get makeSend;

  /// No description provided for @makeMismatch.
  ///
  /// In en, this message translates to:
  /// **'The set has {have} marks but the paper needs {want}.'**
  String makeMismatch(int have, int want);

  /// No description provided for @makeSent.
  ///
  /// In en, this message translates to:
  /// **'Sent to the Principal.'**
  String get makeSent;

  /// No description provided for @makeDraftSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved as a draft.'**
  String get makeDraftSaved;

  /// No description provided for @makeNeedTotal.
  ///
  /// In en, this message translates to:
  /// **'Enter total marks and time first.'**
  String get makeNeedTotal;

  /// No description provided for @makeNeedUnits.
  ///
  /// In en, this message translates to:
  /// **'Tick at least one unit that has questions.'**
  String get makeNeedUnits;

  /// No description provided for @makeNeedTypes.
  ///
  /// In en, this message translates to:
  /// **'Choose how many questions of at least one type.'**
  String get makeNeedTypes;

  /// No description provided for @newPaperTitle.
  ///
  /// In en, this message translates to:
  /// **'New paper'**
  String get newPaperTitle;

  /// No description provided for @newPaperFromBank.
  ///
  /// In en, this message translates to:
  /// **'Make from my question bank'**
  String get newPaperFromBank;

  /// No description provided for @newPaperFromBankHint.
  ///
  /// In en, this message translates to:
  /// **'Pick units and types. A set is made for you.'**
  String get newPaperFromBankHint;

  /// No description provided for @newPaperWrite.
  ///
  /// In en, this message translates to:
  /// **'Write questions myself'**
  String get newPaperWrite;

  /// No description provided for @newPaperWriteHint.
  ///
  /// In en, this message translates to:
  /// **'Type, scan or pick one by one.'**
  String get newPaperWriteHint;

  /// No description provided for @tabSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get tabSent;

  /// No description provided for @tabApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get tabApproved;

  /// No description provided for @examsNewPaper.
  ///
  /// In en, this message translates to:
  /// **'+ New paper'**
  String get examsNewPaper;

  /// No description provided for @examsMyBank.
  ///
  /// In en, this message translates to:
  /// **'My question bank'**
  String get examsMyBank;

  /// No description provided for @profileCheckInHistory.
  ///
  /// In en, this message translates to:
  /// **'Check-in history'**
  String get profileCheckInHistory;

  /// No description provided for @profileCalendarHolidays.
  ///
  /// In en, this message translates to:
  /// **'Calendar and holidays'**
  String get profileCalendarHolidays;

  /// No description provided for @loginNewSchool.
  ///
  /// In en, this message translates to:
  /// **'New school? Set up as Principal'**
  String get loginNewSchool;

  /// No description provided for @loginRestoreSchool.
  ///
  /// In en, this message translates to:
  /// **'School already registered? Restore it'**
  String get loginRestoreSchool;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOr;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new school?'**
  String get resetTitle;

  /// No description provided for @resetBody.
  ///
  /// In en, this message translates to:
  /// **'This phone still holds the data of an earlier school. Starting a new school erases it from this phone. Nothing in the cloud is touched.'**
  String get resetBody;

  /// No description provided for @resetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Erase and start new'**
  String get resetConfirm;

  /// No description provided for @monTitle.
  ///
  /// In en, this message translates to:
  /// **'Data monitor'**
  String get monTitle;

  /// No description provided for @monCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get monCheck;

  /// No description provided for @monAgainst.
  ///
  /// In en, this message translates to:
  /// **'Against'**
  String get monAgainst;

  /// No description provided for @monSrcCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get monSrcCloud;

  /// No description provided for @monSrcFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get monSrcFile;

  /// No description provided for @monSrcDb.
  ///
  /// In en, this message translates to:
  /// **'Local DB'**
  String get monSrcDb;

  /// No description provided for @monRows.
  ///
  /// In en, this message translates to:
  /// **'{count} rows'**
  String monRows(int count);

  /// No description provided for @monAsOf.
  ///
  /// In en, this message translates to:
  /// **'as of {time}'**
  String monAsOf(String time);

  /// No description provided for @monCheckCloud.
  ///
  /// In en, this message translates to:
  /// **'Check cloud'**
  String get monCheckCloud;

  /// No description provided for @monCheckCloudHint.
  ///
  /// In en, this message translates to:
  /// **'Reads a count for each table from the cloud.'**
  String get monCheckCloudHint;

  /// No description provided for @monNotRead.
  ///
  /// In en, this message translates to:
  /// **'Not read yet'**
  String get monNotRead;

  /// No description provided for @monProblemMissing.
  ///
  /// In en, this message translates to:
  /// **'No data file yet'**
  String get monProblemMissing;

  /// No description provided for @monProblemNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in to the cloud'**
  String get monProblemNotSignedIn;

  /// No description provided for @monProblemOffline.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the cloud'**
  String get monProblemOffline;

  /// No description provided for @monProblemOther.
  ///
  /// In en, this message translates to:
  /// **'Could not be read'**
  String get monProblemOther;

  /// No description provided for @monTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get monTable;

  /// No description provided for @monAllMatch.
  ///
  /// In en, this message translates to:
  /// **'All tables match'**
  String get monAllMatch;

  /// No description provided for @monSomeDiffer.
  ///
  /// In en, this message translates to:
  /// **'{count} tables differ'**
  String monSomeDiffer(int count);

  /// No description provided for @monOnlyIn.
  ///
  /// In en, this message translates to:
  /// **'Only in {name}'**
  String monOnlyIn(String name);

  /// No description provided for @monChanged.
  ///
  /// In en, this message translates to:
  /// **'Different values'**
  String get monChanged;

  /// No description provided for @monSame.
  ///
  /// In en, this message translates to:
  /// **'{count} rows are the same'**
  String monSame(int count);

  /// No description provided for @monMatches.
  ///
  /// In en, this message translates to:
  /// **'Both match completely.'**
  String get monMatches;

  /// No description provided for @monShowing.
  ///
  /// In en, this message translates to:
  /// **'Showing the first {count}'**
  String monShowing(int count);

  /// No description provided for @monReading.
  ///
  /// In en, this message translates to:
  /// **'Reading…'**
  String get monReading;

  /// No description provided for @monFileWritten.
  ///
  /// In en, this message translates to:
  /// **'Data file written {time}'**
  String monFileWritten(String time);

  /// No description provided for @monFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Data file could not be written'**
  String get monFileFailed;

  /// No description provided for @monCompareWith.
  ///
  /// In en, this message translates to:
  /// **'Compared with {name}'**
  String monCompareWith(String name);

  /// No description provided for @monCheckNow.
  ///
  /// In en, this message translates to:
  /// **'Check now'**
  String get monCheckNow;

  /// No description provided for @monPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get monPhone;

  /// No description provided for @monCloudCost.
  ///
  /// In en, this message translates to:
  /// **'Reads a count of each table from the cloud.'**
  String get monCloudCost;

  /// No description provided for @monMatchLine.
  ///
  /// In en, this message translates to:
  /// **'{name} has the same rows as {other}'**
  String monMatchLine(String name, String other);

  /// No description provided for @monDiffLine.
  ///
  /// In en, this message translates to:
  /// **'{count} tables differ from {other}'**
  String monDiffLine(int count, String other);

  /// No description provided for @monShowDifferences.
  ///
  /// In en, this message translates to:
  /// **'Differences ({count})'**
  String monShowDifferences(int count);

  /// No description provided for @monShowAll.
  ///
  /// In en, this message translates to:
  /// **'All rows ({count})'**
  String monShowAll(int count);

  /// No description provided for @monStatusSame.
  ///
  /// In en, this message translates to:
  /// **'Same'**
  String get monStatusSame;

  /// No description provided for @monStatusDifferent.
  ///
  /// In en, this message translates to:
  /// **'Different'**
  String get monStatusDifferent;

  /// No description provided for @monEmptyValue.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get monEmptyValue;

  /// No description provided for @monCountsLine.
  ///
  /// In en, this message translates to:
  /// **'Same {same} · Only {a} {onlyA} · Only {b} {onlyB} · Different {diff}'**
  String monCountsLine(
    int same,
    String a,
    int onlyA,
    String b,
    int onlyB,
    int diff,
  );

  /// No description provided for @monSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get monSource;

  /// No description provided for @monReadBoth.
  ///
  /// In en, this message translates to:
  /// **'Read {a} and {b} again'**
  String monReadBoth(String a, String b);

  /// No description provided for @monRefreshLabel.
  ///
  /// In en, this message translates to:
  /// **'Refresh: {a} + {b}'**
  String monRefreshLabel(String a, String b);

  /// No description provided for @monRefreshHint.
  ///
  /// In en, this message translates to:
  /// **'Refresh reads only the two places chosen above.'**
  String get monRefreshHint;

  /// No description provided for @monExternalWritten.
  ///
  /// In en, this message translates to:
  /// **'Copy in Downloads/ShikshaSetu written {time}'**
  String monExternalWritten(String time);

  /// No description provided for @monExternalFailed.
  ///
  /// In en, this message translates to:
  /// **'Copy in Downloads/ShikshaSetu could not be written'**
  String get monExternalFailed;

  /// No description provided for @genderMaleShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get genderMaleShort;

  /// No description provided for @genderFemaleShort.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get genderFemaleShort;

  /// No description provided for @genderOtherShort.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOtherShort;

  /// No description provided for @backupAutoLast.
  ///
  /// In en, this message translates to:
  /// **'Automatic copy: {time}'**
  String backupAutoLast(String time);

  /// No description provided for @backupAutoNone.
  ///
  /// In en, this message translates to:
  /// **'Automatic copy not made yet'**
  String get backupAutoNone;

  /// No description provided for @backupAutoFailed.
  ///
  /// In en, this message translates to:
  /// **'Automatic copy could not be written'**
  String get backupAutoFailed;

  /// No description provided for @actionBackupShareZip.
  ///
  /// In en, this message translates to:
  /// **'Share backup'**
  String get actionBackupShareZip;

  /// No description provided for @backupShareHint.
  ///
  /// In en, this message translates to:
  /// **'Send the latest data to Drive, WhatsApp or email.'**
  String get backupShareHint;

  /// No description provided for @restoreHint.
  ///
  /// In en, this message translates to:
  /// **'Pick shiksha_setu_latest from Downloads/ShikshaSetu.'**
  String get restoreHint;

  /// No description provided for @rpTitle.
  ///
  /// In en, this message translates to:
  /// **'Check before restoring'**
  String get rpTitle;

  /// No description provided for @rpBackupFrom.
  ///
  /// In en, this message translates to:
  /// **'Backup made {time}'**
  String rpBackupFrom(String time);

  /// No description provided for @rpNoChange.
  ///
  /// In en, this message translates to:
  /// **'The backup has exactly the same data as the app. Nothing would change.'**
  String get rpNoChange;

  /// No description provided for @rpWillChange.
  ///
  /// In en, this message translates to:
  /// **'Restoring will add {added}, change {changed} and remove {removed} rows.'**
  String rpWillChange(int added, int changed, int removed);

  /// No description provided for @rpLoseWarning.
  ///
  /// In en, this message translates to:
  /// **'{removed} rows are in the app but not in this backup. They would be lost.'**
  String rpLoseWarning(int removed);

  /// No description provided for @rpLegend.
  ///
  /// In en, this message translates to:
  /// **'Now = the app today. Backup = the file you picked.'**
  String get rpLegend;

  /// No description provided for @rpNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get rpNow;

  /// No description provided for @rpBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get rpBackup;

  /// No description provided for @rpAdd.
  ///
  /// In en, this message translates to:
  /// **'+{count} added'**
  String rpAdd(int count);

  /// No description provided for @rpRemove.
  ///
  /// In en, this message translates to:
  /// **'−{count} lost'**
  String rpRemove(int count);

  /// No description provided for @rpChange.
  ///
  /// In en, this message translates to:
  /// **'~{count} changed'**
  String rpChange(int count);

  /// No description provided for @rpRestoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup'**
  String get rpRestoreButton;

  /// No description provided for @rpRestoreLosing.
  ///
  /// In en, this message translates to:
  /// **'Restore anyway'**
  String get rpRestoreLosing;

  /// No description provided for @rpNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'Nothing to restore'**
  String get rpNothingToRestore;

  /// No description provided for @actionBackupDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get actionBackupDownload;

  /// No description provided for @messageBackupDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get messageBackupDownloaded;

  /// No description provided for @rpNewerBanner.
  ///
  /// In en, this message translates to:
  /// **'The app has newer changes (last changed {app}) than this backup (made {backup}). Restoring would override them with older data.'**
  String rpNewerBanner(String app, String backup);

  /// No description provided for @rpRestoreOverriding.
  ///
  /// In en, this message translates to:
  /// **'Restore anyway'**
  String get rpRestoreOverriding;

  /// No description provided for @rpOverrideTitle.
  ///
  /// In en, this message translates to:
  /// **'Override your data?'**
  String get rpOverrideTitle;

  /// No description provided for @rpOverrideBody.
  ///
  /// In en, this message translates to:
  /// **'This will replace {changed} rows in the app with the backup\'s version and remove {removed} rows that are not in the backup.\n\nYour current data is kept first as Downloads/ShikshaSetu/shiksha_setu_before_restore.json (it replaces the one from an earlier restore).'**
  String rpOverrideBody(int changed, int removed);

  /// No description provided for @rpOverrideConfirm.
  ///
  /// In en, this message translates to:
  /// **'Override and restore'**
  String get rpOverrideConfirm;

  /// No description provided for @rhTitle.
  ///
  /// In en, this message translates to:
  /// **'Last restore'**
  String get rhTitle;

  /// No description provided for @rhLine.
  ///
  /// In en, this message translates to:
  /// **'Restored {time} from the backup of {backup}'**
  String rhLine(String time, String backup);

  /// No description provided for @rhCounts.
  ///
  /// In en, this message translates to:
  /// **'{added} added · {changed} replaced · {removed} lost'**
  String rhCounts(int added, int changed, int removed);

  /// No description provided for @rhSaved.
  ///
  /// In en, this message translates to:
  /// **'Your earlier data: Downloads/ShikshaSetu/shiksha_setu_before_restore.json'**
  String get rhSaved;

  /// No description provided for @rhNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Your earlier data could not be copied to Downloads'**
  String get rhNotSaved;

  /// No description provided for @rhForced.
  ///
  /// In en, this message translates to:
  /// **'The app had newer changes than this backup'**
  String get rhForced;

  /// No description provided for @rpOldTitle.
  ///
  /// In en, this message translates to:
  /// **'This is an old backup'**
  String get rpOldTitle;

  /// No description provided for @rpOldBody.
  ///
  /// In en, this message translates to:
  /// **'The app already has newer data than this backup.\n\nStill override it with the older data? {changed} rows will be replaced by their older version and {removed} rows will be removed.\n\nYour current data is kept first as Downloads/ShikshaSetu/shiksha_setu_before_restore.json (it replaces the one from an earlier restore).'**
  String rpOldBody(int changed, int removed);

  /// No description provided for @homeSchoolPlans.
  ///
  /// In en, this message translates to:
  /// **'School plans'**
  String get homeSchoolPlans;

  /// No description provided for @homeSchoolPlansHint.
  ///
  /// In en, this message translates to:
  /// **'Timing, assembly, periods, calendar and holidays'**
  String get homeSchoolPlansHint;

  /// No description provided for @safePillSafe.
  ///
  /// In en, this message translates to:
  /// **'Safe {time}'**
  String safePillSafe(String time);

  /// No description provided for @safePillSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get safePillSaving;

  /// No description provided for @safePillFailed.
  ///
  /// In en, this message translates to:
  /// **'Not saved'**
  String get safePillFailed;

  /// No description provided for @safePillOff.
  ///
  /// In en, this message translates to:
  /// **'Cloud off'**
  String get safePillOff;

  /// No description provided for @needsYouTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs you · {count}'**
  String needsYouTitle(int count);

  /// No description provided for @needsYouNone.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get needsYouNone;

  /// No description provided for @needsYouNoneHint.
  ///
  /// In en, this message translates to:
  /// **'Nothing is waiting for you.'**
  String get needsYouNoneHint;

  /// No description provided for @homeTodayInSchool.
  ///
  /// In en, this message translates to:
  /// **'Today in school'**
  String get homeTodayInSchool;

  /// No description provided for @quickNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get quickNotice;

  /// No description provided for @homePlansMore.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String homePlansMore(int count);

  /// No description provided for @planTimingHint.
  ///
  /// In en, this message translates to:
  /// **'When school starts and ends'**
  String get planTimingHint;

  /// No description provided for @planAssemblyHint.
  ///
  /// In en, this message translates to:
  /// **'Time, place and who is on duty'**
  String get planAssemblyHint;

  /// No description provided for @planPeriodsHint.
  ///
  /// In en, this message translates to:
  /// **'Bell schedule and class timetables'**
  String get planPeriodsHint;

  /// No description provided for @planCalendarHint.
  ///
  /// In en, this message translates to:
  /// **'School days and holidays'**
  String get planCalendarHint;

  /// No description provided for @planHolidaysHint.
  ///
  /// In en, this message translates to:
  /// **'Add or change holidays'**
  String get planHolidaysHint;

  /// No description provided for @quickNoticeHint.
  ///
  /// In en, this message translates to:
  /// **'Post an announcement for everyone'**
  String get quickNoticeHint;

  /// No description provided for @wsAsk.
  ///
  /// In en, this message translates to:
  /// **'What do you need?'**
  String get wsAsk;

  /// No description provided for @wsAddStudentHint.
  ///
  /// In en, this message translates to:
  /// **'Click to add a new student'**
  String get wsAddStudentHint;

  /// No description provided for @wsAddTeacherHint.
  ///
  /// In en, this message translates to:
  /// **'Click to add a new teacher'**
  String get wsAddTeacherHint;

  /// No description provided for @wsAddStaffHint.
  ///
  /// In en, this message translates to:
  /// **'Click to add a driver, helper or other staff'**
  String get wsAddStaffHint;

  /// No description provided for @wsListStudents.
  ///
  /// In en, this message translates to:
  /// **'All students'**
  String get wsListStudents;

  /// No description provided for @wsListTeachers.
  ///
  /// In en, this message translates to:
  /// **'All teachers'**
  String get wsListTeachers;

  /// No description provided for @wsListStaff.
  ///
  /// In en, this message translates to:
  /// **'All staff'**
  String get wsListStaff;

  /// No description provided for @wsListHint.
  ///
  /// In en, this message translates to:
  /// **'{count} registered · search, see and edit'**
  String wsListHint(int count);

  /// No description provided for @wsFeesHint.
  ///
  /// In en, this message translates to:
  /// **'Set fees, collect payments, see dues'**
  String get wsFeesHint;

  /// No description provided for @wsAccessoriesHint.
  ///
  /// In en, this message translates to:
  /// **'Dress and books given to students'**
  String get wsAccessoriesHint;

  /// No description provided for @wsPerformanceHint.
  ///
  /// In en, this message translates to:
  /// **'Marks, results and how classes are doing'**
  String get wsPerformanceHint;

  /// No description provided for @wsStudentAttendanceHint.
  ///
  /// In en, this message translates to:
  /// **'Who came today, by class'**
  String get wsStudentAttendanceHint;

  /// No description provided for @wsClassesHint.
  ///
  /// In en, this message translates to:
  /// **'Classes, sections and class teachers'**
  String get wsClassesHint;

  /// No description provided for @wsTeacherPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Pay teachers and see payments'**
  String get wsTeacherPaymentHint;

  /// No description provided for @wsQuestionBankHint.
  ///
  /// In en, this message translates to:
  /// **'Questions kept for papers'**
  String get wsQuestionBankHint;

  /// No description provided for @wsExamPapersHint.
  ///
  /// In en, this message translates to:
  /// **'Papers made and sent for approval'**
  String get wsExamPapersHint;

  /// No description provided for @wsTeacherAttendanceHint.
  ///
  /// In en, this message translates to:
  /// **'Check-ins and who is in school'**
  String get wsTeacherAttendanceHint;

  /// No description provided for @wsSubjectsHint.
  ///
  /// In en, this message translates to:
  /// **'Who teaches which subject'**
  String get wsSubjectsHint;

  /// No description provided for @wsStaffAttendanceHint.
  ///
  /// In en, this message translates to:
  /// **'Who came today'**
  String get wsStaffAttendanceHint;

  /// No description provided for @wsStaffPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Pay staff and settle approved bills'**
  String get wsStaffPaymentHint;

  /// No description provided for @wsBillsHint.
  ///
  /// In en, this message translates to:
  /// **'Petrol and diesel bills for approval'**
  String get wsBillsHint;

  /// No description provided for @accAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get accAddTitle;

  /// No description provided for @accAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add a dress piece or a book to a class'**
  String get accAddHint;

  /// No description provided for @accManageTitle.
  ///
  /// In en, this message translates to:
  /// **'See, edit, delete'**
  String get accManageTitle;

  /// No description provided for @accManageHint.
  ///
  /// In en, this message translates to:
  /// **'The dress and book list of each class'**
  String get accManageHint;

  /// No description provided for @accGiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Give to students'**
  String get accGiveTitle;

  /// No description provided for @accGiveHint.
  ///
  /// In en, this message translates to:
  /// **'Hand over dress or books, class by class'**
  String get accGiveHint;

  /// No description provided for @accSizesHint.
  ///
  /// In en, this message translates to:
  /// **'Note each student\'s size'**
  String get accSizesHint;

  /// No description provided for @accRecordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get accRecordsTitle;

  /// No description provided for @accRecordsHint.
  ///
  /// In en, this message translates to:
  /// **'Who got what, with receipts'**
  String get accRecordsHint;

  /// No description provided for @accItemName.
  ///
  /// In en, this message translates to:
  /// **'Name of the item'**
  String get accItemName;

  /// No description provided for @accItemAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get accItemAdded;

  /// No description provided for @accItemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get accItemRemoved;

  /// No description provided for @accEditItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get accEditItem;

  /// No description provided for @accDeleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get accDeleteItemTitle;

  /// No description provided for @accNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get accNothingHere;

  /// No description provided for @accNoRecords.
  ///
  /// In en, this message translates to:
  /// **'Nothing has been given yet.'**
  String get accNoRecords;

  /// No description provided for @accPickClass.
  ///
  /// In en, this message translates to:
  /// **'Choose a class'**
  String get accPickClass;

  /// No description provided for @actionSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get actionSignInWithGoogle;

  /// No description provided for @errorNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This Google account is not registered with the school. Ask the Principal to add you.'**
  String get errorNotRegistered;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register as the Principal. You will set up the school next.'**
  String get registerSubtitle;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'New here? Register'**
  String get loginRegister;

  /// No description provided for @schoolSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Name your school'**
  String get schoolSetupTitle;

  /// No description provided for @schoolSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This name is shown across the app. You can add teachers later.'**
  String get schoolSetupSubtitle;

  /// No description provided for @loginAdminNote.
  ///
  /// In en, this message translates to:
  /// **'Accounts are created by your school\'s administrator. If you can\'t sign in, please contact your Principal.'**
  String get loginAdminNote;

  /// No description provided for @srvOffline.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the school\'s server. Check your internet and try again.'**
  String get srvOffline;

  /// No description provided for @srvInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password, or this account is switched off.'**
  String get srvInvalidCredentials;

  /// No description provided for @srvSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Please sign in again.'**
  String get srvSessionExpired;

  /// No description provided for @srvForbidden.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to do this.'**
  String get srvForbidden;

  /// No description provided for @srvNotFound.
  ///
  /// In en, this message translates to:
  /// **'This could not be found. It may have been removed.'**
  String get srvNotFound;

  /// No description provided for @srvInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please check what you entered.'**
  String get srvInvalid;

  /// No description provided for @srvRejected.
  ///
  /// In en, this message translates to:
  /// **'This was not allowed.'**
  String get srvRejected;

  /// No description provided for @srvTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Please wait a little and try again.'**
  String get srvTooManyRequests;

  /// No description provided for @srvUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on the server. Please try again.'**
  String get srvUnavailable;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This part is being connected to the school\'s server.'**
  String get comingSoon;

  /// No description provided for @navStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get navStaff;

  /// No description provided for @navRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navRequests;

  /// No description provided for @navPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get navPayments;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Graphs'**
  String get navAnalytics;

  /// No description provided for @navSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get navSchool;

  /// No description provided for @navNotices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get navNotices;

  /// No description provided for @navFuelBills.
  ///
  /// In en, this message translates to:
  /// **'Fuel bills'**
  String get navFuelBills;

  /// No description provided for @navVicePrincipal.
  ///
  /// In en, this message translates to:
  /// **'Vice Principal'**
  String get navVicePrincipal;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @roleLabelVicePrincipal.
  ///
  /// In en, this message translates to:
  /// **'Vice Principal'**
  String get roleLabelVicePrincipal;

  /// No description provided for @roleLabelStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get roleLabelStaff;

  /// No description provided for @profileChangeName.
  ///
  /// In en, this message translates to:
  /// **'Change name'**
  String get profileChangeName;

  /// No description provided for @schoolTitle.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolTitle;

  /// No description provided for @schoolNameNotSet.
  ///
  /// In en, this message translates to:
  /// **'School name not set'**
  String get schoolNameNotSet;

  /// No description provided for @schoolSeasonInUse.
  ///
  /// In en, this message translates to:
  /// **'Timing in use'**
  String get schoolSeasonInUse;

  /// No description provided for @seasonSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get seasonSummer;

  /// No description provided for @seasonWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get seasonWinter;

  /// No description provided for @schoolTimingOf.
  ///
  /// In en, this message translates to:
  /// **'{season} timing'**
  String schoolTimingOf(String season);

  /// No description provided for @schoolHours.
  ///
  /// In en, this message translates to:
  /// **'{opens} to {closes}'**
  String schoolHours(String opens, String closes);

  /// No description provided for @schoolTimingNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get schoolTimingNotSet;

  /// No description provided for @schoolPeriodCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No periods} =1{1 period} other{{count} periods}}'**
  String schoolPeriodCount(int count);

  /// No description provided for @schoolInUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get schoolInUse;

  /// No description provided for @schoolHolidays.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get schoolHolidays;

  /// No description provided for @fieldOpens.
  ///
  /// In en, this message translates to:
  /// **'School opens'**
  String get fieldOpens;

  /// No description provided for @fieldCloses.
  ///
  /// In en, this message translates to:
  /// **'School closes'**
  String get fieldCloses;

  /// No description provided for @fieldStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get fieldStarts;

  /// No description provided for @fieldEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get fieldEnds;

  /// No description provided for @schoolPeriods.
  ///
  /// In en, this message translates to:
  /// **'Periods'**
  String get schoolPeriods;

  /// No description provided for @schoolAddPeriod.
  ///
  /// In en, this message translates to:
  /// **'Add period'**
  String get schoolAddPeriod;

  /// No description provided for @schoolNoPeriods.
  ///
  /// In en, this message translates to:
  /// **'No periods yet.'**
  String get schoolNoPeriods;

  /// No description provided for @schoolPeriodName.
  ///
  /// In en, this message translates to:
  /// **'Period {n} name (optional)'**
  String schoolPeriodName(int n);

  /// No description provided for @holidayEdit.
  ///
  /// In en, this message translates to:
  /// **'Change holiday'**
  String get holidayEdit;

  /// No description provided for @fieldHolidayName.
  ///
  /// In en, this message translates to:
  /// **'Holiday name'**
  String get fieldHolidayName;

  /// No description provided for @fieldFirstDay.
  ///
  /// In en, this message translates to:
  /// **'First day'**
  String get fieldFirstDay;

  /// No description provided for @fieldLastDay.
  ///
  /// In en, this message translates to:
  /// **'Last day'**
  String get fieldLastDay;

  /// No description provided for @holidaysEmpty.
  ///
  /// In en, this message translates to:
  /// **'No holidays from this month on.'**
  String get holidaysEmpty;

  /// No description provided for @noticePost.
  ///
  /// In en, this message translates to:
  /// **'Post a notice'**
  String get noticePost;

  /// No description provided for @noticeKindNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get noticeKindNotice;

  /// No description provided for @noticeAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get noticeAnnouncement;

  /// No description provided for @noticeWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Take down'**
  String get noticeWithdraw;

  /// No description provided for @noticeWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Take this notice down?'**
  String get noticeWithdrawTitle;

  /// No description provided for @noticeWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'Everyone will stop seeing it.'**
  String get noticeWithdrawBody;

  /// No description provided for @stuTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get stuTitle;

  /// No description provided for @stuTabStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get stuTabStudents;

  /// No description provided for @stuTabClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get stuTabClasses;

  /// No description provided for @stuSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get stuSearch;

  /// No description provided for @stuAllClasses.
  ///
  /// In en, this message translates to:
  /// **'All classes'**
  String get stuAllClasses;

  /// No description provided for @stuAdd.
  ///
  /// In en, this message translates to:
  /// **'Add student'**
  String get stuAdd;

  /// No description provided for @stuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit student'**
  String get stuEdit;

  /// No description provided for @stuRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove student'**
  String get stuRemove;

  /// No description provided for @stuRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore student'**
  String get stuRestore;

  /// No description provided for @stuRemoveAsk.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}? Their records and fees stay.'**
  String stuRemoveAsk(String name);

  /// No description provided for @stuRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get stuRemoved;

  /// No description provided for @stuEmpty.
  ///
  /// In en, this message translates to:
  /// **'No students found.'**
  String get stuEmpty;

  /// No description provided for @stuRoll.
  ///
  /// In en, this message translates to:
  /// **'Roll {roll}'**
  String stuRoll(String roll);

  /// No description provided for @stuRollField.
  ///
  /// In en, this message translates to:
  /// **'Roll number (leave empty for the next one)'**
  String get stuRollField;

  /// No description provided for @stuGuardianField.
  ///
  /// In en, this message translates to:
  /// **'Guardian name'**
  String get stuGuardianField;

  /// No description provided for @stuUsesVan.
  ///
  /// In en, this message translates to:
  /// **'Uses the school van'**
  String get stuUsesVan;

  /// No description provided for @stuVanYes.
  ///
  /// In en, this message translates to:
  /// **'Uses the van'**
  String get stuVanYes;

  /// No description provided for @stuVanNo.
  ///
  /// In en, this message translates to:
  /// **'Does not use the van'**
  String get stuVanNo;

  /// No description provided for @stuClassesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No classes yet. Tap \"Add class\" to create one.'**
  String get stuClassesEmpty;

  /// No description provided for @stuClassLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get stuClassLevel;

  /// No description provided for @stuClassSection.
  ///
  /// In en, this message translates to:
  /// **'Section (leave empty if there is only one)'**
  String get stuClassSection;

  /// No description provided for @stuClassRemoveAsk.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String stuClassRemoveAsk(String name);

  /// No description provided for @stuLevelNursery.
  ///
  /// In en, this message translates to:
  /// **'Nursery'**
  String get stuLevelNursery;

  /// No description provided for @stuLevelLkg.
  ///
  /// In en, this message translates to:
  /// **'LKG'**
  String get stuLevelLkg;

  /// No description provided for @stuLevelUkg.
  ///
  /// In en, this message translates to:
  /// **'UKG'**
  String get stuLevelUkg;

  /// No description provided for @feeTab.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get feeTab;

  /// No description provided for @feeSetupTab.
  ///
  /// In en, this message translates to:
  /// **'Fee setup'**
  String get feeSetupTab;

  /// No description provided for @itemsTab.
  ///
  /// In en, this message translates to:
  /// **'Dress & books'**
  String get itemsTab;

  /// No description provided for @feeOnlyDue.
  ///
  /// In en, this message translates to:
  /// **'Only with dues'**
  String get feeOnlyDue;

  /// No description provided for @feeAccountsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fee accounts found.'**
  String get feeAccountsEmpty;

  /// No description provided for @feeBalanceOf.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String feeBalanceOf(String amount);

  /// No description provided for @feeDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get feeDue;

  /// No description provided for @feePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get feePaid;

  /// No description provided for @feeBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get feeBalance;

  /// No description provided for @feeNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get feeNotSet;

  /// No description provided for @feeSetAmount.
  ///
  /// In en, this message translates to:
  /// **'Set amount'**
  String get feeSetAmount;

  /// No description provided for @feeReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive payment'**
  String get feeReceive;

  /// No description provided for @feeHeadTuition.
  ///
  /// In en, this message translates to:
  /// **'Tuition'**
  String get feeHeadTuition;

  /// No description provided for @feeReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt {no}'**
  String feeReceipt(String no);

  /// No description provided for @feeNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get feeNote;

  /// No description provided for @feePayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get feePayments;

  /// No description provided for @feeNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get feeNoPayments;

  /// No description provided for @feeSell.
  ///
  /// In en, this message translates to:
  /// **'Sell dress or books'**
  String get feeSell;

  /// No description provided for @feeNoClasses.
  ///
  /// In en, this message translates to:
  /// **'Add a class first.'**
  String get feeNoClasses;

  /// No description provided for @itemAdd.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get itemAdd;

  /// No description provided for @itemEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get itemEdit;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// No description provided for @itemPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get itemPrice;

  /// No description provided for @itemClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get itemClass;

  /// No description provided for @itemAllClasses.
  ///
  /// In en, this message translates to:
  /// **'All classes'**
  String get itemAllClasses;

  /// No description provided for @itemKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get itemKind;

  /// No description provided for @itemKindDress.
  ///
  /// In en, this message translates to:
  /// **'Dress'**
  String get itemKindDress;

  /// No description provided for @itemKindBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get itemKindBooks;

  /// No description provided for @itemsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing for sale yet. Tap \"Add item\".'**
  String get itemsEmpty;

  /// No description provided for @itemQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get itemQuantity;

  /// No description provided for @itemSellAction.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get itemSellAction;

  /// No description provided for @itemsForSale.
  ///
  /// In en, this message translates to:
  /// **'Nothing is for sale for this class.'**
  String get itemsForSale;

  /// No description provided for @memTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get memTeachers;

  /// No description provided for @memStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get memStaff;

  /// No description provided for @memVicePrincipals.
  ///
  /// In en, this message translates to:
  /// **'Vice Principals'**
  String get memVicePrincipals;

  /// No description provided for @memTeacherAdd.
  ///
  /// In en, this message translates to:
  /// **'Add teacher'**
  String get memTeacherAdd;

  /// No description provided for @memStaffAdd.
  ///
  /// In en, this message translates to:
  /// **'Add staff member'**
  String get memStaffAdd;

  /// No description provided for @memVpAdd.
  ///
  /// In en, this message translates to:
  /// **'Appoint Vice Principal'**
  String get memVpAdd;

  /// No description provided for @memTeacherEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit teacher'**
  String get memTeacherEdit;

  /// No description provided for @memStaffEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit staff member'**
  String get memStaffEdit;

  /// No description provided for @memVpEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Vice Principal'**
  String get memVpEdit;

  /// No description provided for @memTeachersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No teachers found.'**
  String get memTeachersEmpty;

  /// No description provided for @memStaffEmpty.
  ///
  /// In en, this message translates to:
  /// **'No staff found.'**
  String get memStaffEmpty;

  /// No description provided for @memVpEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Vice Principal yet.'**
  String get memVpEmpty;

  /// No description provided for @memJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job title (e.g. Van driver)'**
  String get memJobTitle;

  /// No description provided for @memShowRemoved.
  ///
  /// In en, this message translates to:
  /// **'Include removed'**
  String get memShowRemoved;

  /// No description provided for @memRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get memRemove;

  /// No description provided for @memRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get memRestore;

  /// No description provided for @memRemoveAsk.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}? They can no longer sign in.'**
  String memRemoveAsk(String name);

  /// No description provided for @memResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get memResetPassword;

  /// No description provided for @memPasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get memPasswordChanged;

  /// No description provided for @memEmailHint.
  ///
  /// In en, this message translates to:
  /// **'They sign in with this email'**
  String get memEmailHint;

  /// No description provided for @navLessons.
  ///
  /// In en, this message translates to:
  /// **'My lessons'**
  String get navLessons;

  /// No description provided for @tchAllotments.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get tchAllotments;

  /// No description provided for @tchLessonBoard.
  ///
  /// In en, this message translates to:
  /// **'Daily lessons'**
  String get tchLessonBoard;

  /// No description provided for @tchAllot.
  ///
  /// In en, this message translates to:
  /// **'Allot a class'**
  String get tchAllot;

  /// No description provided for @tchAllotmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No class is allotted yet.'**
  String get tchAllotmentsEmpty;

  /// No description provided for @tchTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get tchTeacher;

  /// No description provided for @tchSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get tchSubject;

  /// No description provided for @tchRemoveAllotmentAsk.
  ///
  /// In en, this message translates to:
  /// **'Take {subject} of {name} back from this teacher?'**
  String tchRemoveAllotmentAsk(String subject, String name);

  /// No description provided for @tchRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get tchRecorded;

  /// No description provided for @tchPending.
  ///
  /// In en, this message translates to:
  /// **'Not recorded yet'**
  String get tchPending;

  /// No description provided for @tchBoardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No class is allotted, so there is nothing to record.'**
  String get tchBoardEmpty;

  /// No description provided for @tchRecordLesson.
  ///
  /// In en, this message translates to:
  /// **'Record today\'s lesson'**
  String get tchRecordLesson;

  /// No description provided for @tchEditLesson.
  ///
  /// In en, this message translates to:
  /// **'Change the lesson'**
  String get tchEditLesson;

  /// No description provided for @tchTopic.
  ///
  /// In en, this message translates to:
  /// **'What was taught'**
  String get tchTopic;

  /// No description provided for @tchLessonsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No lessons recorded yet.'**
  String get tchLessonsEmpty;

  /// No description provided for @tchMyClasses.
  ///
  /// In en, this message translates to:
  /// **'My classes'**
  String get tchMyClasses;

  /// No description provided for @tchRecentLessons.
  ///
  /// In en, this message translates to:
  /// **'Recent lessons'**
  String get tchRecentLessons;

  /// No description provided for @tchClassSubject.
  ///
  /// In en, this message translates to:
  /// **'{name} · {subject}'**
  String tchClassSubject(String name, String subject);

  /// No description provided for @tchDayPick.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get tchDayPick;

  /// No description provided for @fltVans.
  ///
  /// In en, this message translates to:
  /// **'Vans'**
  String get fltVans;

  /// No description provided for @fltFuelBills.
  ///
  /// In en, this message translates to:
  /// **'Fuel bills'**
  String get fltFuelBills;

  /// No description provided for @fltVanAdd.
  ///
  /// In en, this message translates to:
  /// **'Add van'**
  String get fltVanAdd;

  /// No description provided for @fltVanEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit van'**
  String get fltVanEdit;

  /// No description provided for @fltVanName.
  ///
  /// In en, this message translates to:
  /// **'Van name or number'**
  String get fltVanName;

  /// No description provided for @fltDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get fltDriver;

  /// No description provided for @fltNoDriver.
  ///
  /// In en, this message translates to:
  /// **'No driver'**
  String get fltNoDriver;

  /// No description provided for @fltVansEmpty.
  ///
  /// In en, this message translates to:
  /// **'No vans yet.'**
  String get fltVansEmpty;

  /// No description provided for @fltBillsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fuel bills.'**
  String get fltBillsEmpty;

  /// No description provided for @fltBillAdd.
  ///
  /// In en, this message translates to:
  /// **'Add fuel bill'**
  String get fltBillAdd;

  /// No description provided for @fltFuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fltFuelType;

  /// No description provided for @fltPetrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get fltPetrol;

  /// No description provided for @fltDiesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get fltDiesel;

  /// No description provided for @fltLitres.
  ///
  /// In en, this message translates to:
  /// **'Litres'**
  String get fltLitres;

  /// No description provided for @fltRate.
  ///
  /// In en, this message translates to:
  /// **'Rate per litre'**
  String get fltRate;

  /// No description provided for @fltOdometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer (km)'**
  String get fltOdometer;

  /// No description provided for @fltBilledOn.
  ///
  /// In en, this message translates to:
  /// **'Bill date'**
  String get fltBilledOn;

  /// No description provided for @fltVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get fltVan;

  /// No description provided for @fltStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get fltStatusPending;

  /// No description provided for @fltStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get fltStatusApproved;

  /// No description provided for @fltStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get fltStatusRejected;

  /// No description provided for @fltAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get fltAllStatuses;

  /// No description provided for @fltWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get fltWithdraw;

  /// No description provided for @fltApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get fltApprove;

  /// No description provided for @fltReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get fltReject;

  /// No description provided for @fltRejectReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get fltRejectReason;

  /// No description provided for @fltMileage.
  ///
  /// In en, this message translates to:
  /// **'{km} km · {kpl} km/l'**
  String fltMileage(String km, String kpl);

  /// No description provided for @fltBillLine.
  ///
  /// In en, this message translates to:
  /// **'{litres} L at {rate}'**
  String fltBillLine(String litres, String rate);

  /// No description provided for @fltSubmittedBy.
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String fltSubmittedBy(String name);

  /// No description provided for @fltRejectedWhy.
  ///
  /// In en, this message translates to:
  /// **'Rejected: {reason}'**
  String fltRejectedWhy(String reason);

  /// No description provided for @fltNoVanForDriver.
  ///
  /// In en, this message translates to:
  /// **'You have not been given a van yet.'**
  String get fltNoVanForDriver;

  /// No description provided for @attStudentsTab.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get attStudentsTab;

  /// No description provided for @attReportTab.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get attReportTab;

  /// No description provided for @attMineTab.
  ///
  /// In en, this message translates to:
  /// **'My attendance'**
  String get attMineTab;

  /// No description provided for @attPeopleTab.
  ///
  /// In en, this message translates to:
  /// **'Teachers & staff'**
  String get attPeopleTab;

  /// No description provided for @attPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get attPresent;

  /// No description provided for @attLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get attLate;

  /// No description provided for @attAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attAbsent;

  /// No description provided for @attLeave.
  ///
  /// In en, this message translates to:
  /// **'On leave'**
  String get attLeave;

  /// No description provided for @attHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get attHoliday;

  /// No description provided for @attNotInYet.
  ///
  /// In en, this message translates to:
  /// **'Not in yet'**
  String get attNotInYet;

  /// No description provided for @attMarkAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all present'**
  String get attMarkAll;

  /// No description provided for @attSave.
  ///
  /// In en, this message translates to:
  /// **'Save attendance'**
  String get attSave;

  /// No description provided for @attSaved.
  ///
  /// In en, this message translates to:
  /// **'Attendance saved'**
  String get attSaved;

  /// No description provided for @attPickClass.
  ///
  /// In en, this message translates to:
  /// **'Choose a class'**
  String get attPickClass;

  /// No description provided for @attRosterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No students in this class.'**
  String get attRosterEmpty;

  /// No description provided for @attCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get attCheckIn;

  /// No description provided for @attCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check out'**
  String get attCheckOut;

  /// No description provided for @attCheckedInAt.
  ///
  /// In en, this message translates to:
  /// **'In {time}'**
  String attCheckedInAt(String time);

  /// No description provided for @attCheckedOutAt.
  ///
  /// In en, this message translates to:
  /// **'Out {time}'**
  String attCheckedOutAt(String time);

  /// No description provided for @attMineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No attendance recorded yet.'**
  String get attMineEmpty;

  /// No description provided for @attBoardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No one to show.'**
  String get attBoardEmpty;

  /// No description provided for @attHolidayToday.
  ///
  /// In en, this message translates to:
  /// **'This day is a holiday.'**
  String get attHolidayToday;

  /// No description provided for @attAllRoles.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get attAllRoles;

  /// No description provided for @attRoleTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get attRoleTeachers;

  /// No description provided for @attRoleStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get attRoleStaff;

  /// No description provided for @attCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct the times'**
  String get attCorrect;

  /// No description provided for @attCheckInTime.
  ///
  /// In en, this message translates to:
  /// **'Check-in time'**
  String get attCheckInTime;

  /// No description provided for @attCheckOutTime.
  ///
  /// In en, this message translates to:
  /// **'Check-out time (optional)'**
  String get attCheckOutTime;

  /// No description provided for @attTally.
  ///
  /// In en, this message translates to:
  /// **'{present} present · {late} late · {absent} absent'**
  String attTally(int present, int late, int absent);

  /// No description provided for @attRange.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get attRange;

  /// No description provided for @attReportNeedsRange.
  ///
  /// In en, this message translates to:
  /// **'Choose a period to see the report.'**
  String get attReportNeedsRange;

  /// No description provided for @attDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get attDay;

  /// No description provided for @reqTitle.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get reqTitle;

  /// No description provided for @reqEmpty.
  ///
  /// In en, this message translates to:
  /// **'No requests.'**
  String get reqEmpty;

  /// No description provided for @reqRaiseLeave.
  ///
  /// In en, this message translates to:
  /// **'Ask for leave'**
  String get reqRaiseLeave;

  /// No description provided for @reqRaiseMeeting.
  ///
  /// In en, this message translates to:
  /// **'Ask for a meeting'**
  String get reqRaiseMeeting;

  /// No description provided for @reqKindLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get reqKindLeave;

  /// No description provided for @reqKindMeeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting'**
  String get reqKindMeeting;

  /// No description provided for @reqAllKinds.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reqAllKinds;

  /// No description provided for @reqStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reqStatusPending;

  /// No description provided for @reqStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get reqStatusApproved;

  /// No description provided for @reqStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get reqStatusRejected;

  /// No description provided for @reqStatusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get reqStatusWithdrawn;

  /// No description provided for @reqFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get reqFrom;

  /// No description provided for @reqTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get reqTo;

  /// No description provided for @reqReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reqReason;

  /// No description provided for @reqSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get reqSubject;

  /// No description provided for @reqDetails.
  ///
  /// In en, this message translates to:
  /// **'Details (optional)'**
  String get reqDetails;

  /// No description provided for @reqPreferredOn.
  ///
  /// In en, this message translates to:
  /// **'Preferred day (optional)'**
  String get reqPreferredOn;

  /// No description provided for @reqSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get reqSend;

  /// No description provided for @reqWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get reqWithdraw;

  /// No description provided for @reqApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get reqApprove;

  /// No description provided for @reqReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reqReject;

  /// No description provided for @reqRejectReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for rejecting'**
  String get reqRejectReason;

  /// No description provided for @reqMeetingOn.
  ///
  /// In en, this message translates to:
  /// **'Meeting day'**
  String get reqMeetingOn;

  /// No description provided for @reqMeetingAt.
  ///
  /// In en, this message translates to:
  /// **'Meeting time'**
  String get reqMeetingAt;

  /// No description provided for @reqBy.
  ///
  /// In en, this message translates to:
  /// **'From {name}'**
  String reqBy(String name);

  /// No description provided for @reqDecidedBy.
  ///
  /// In en, this message translates to:
  /// **'{name} on {date}'**
  String reqDecidedBy(String name, String date);

  /// No description provided for @reqMeetingFixed.
  ///
  /// In en, this message translates to:
  /// **'Meeting on {date} at {time}'**
  String reqMeetingFixed(String date, String time);

  /// No description provided for @reqNote.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String reqNote(String note);

  /// No description provided for @exmTitle.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get exmTitle;

  /// No description provided for @exmTabExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get exmTabExams;

  /// No description provided for @exmTabBank.
  ///
  /// In en, this message translates to:
  /// **'Question bank'**
  String get exmTabBank;

  /// No description provided for @exmSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule exam'**
  String get exmSchedule;

  /// No description provided for @exmEdit.
  ///
  /// In en, this message translates to:
  /// **'Change exam'**
  String get exmEdit;

  /// No description provided for @exmEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exams found.'**
  String get exmEmpty;

  /// No description provided for @exmType.
  ///
  /// In en, this message translates to:
  /// **'Kind of exam'**
  String get exmType;

  /// No description provided for @exmTypeUnitTest.
  ///
  /// In en, this message translates to:
  /// **'Unit test'**
  String get exmTypeUnitTest;

  /// No description provided for @exmTypeMidTerm.
  ///
  /// In en, this message translates to:
  /// **'Mid-term'**
  String get exmTypeMidTerm;

  /// No description provided for @exmTypeAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get exmTypeAnnual;

  /// No description provided for @exmSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get exmSubject;

  /// No description provided for @exmHeldOn.
  ///
  /// In en, this message translates to:
  /// **'Exam day'**
  String get exmHeldOn;

  /// No description provided for @exmMaxMarks.
  ///
  /// In en, this message translates to:
  /// **'Total marks'**
  String get exmMaxMarks;

  /// No description provided for @exmAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Papers awaiting approval'**
  String get exmAwaiting;

  /// No description provided for @exmRemoveAsk.
  ///
  /// In en, this message translates to:
  /// **'Remove this exam?'**
  String get exmRemoveAsk;

  /// No description provided for @exmTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher: {name}'**
  String exmTeacher(String name);

  /// No description provided for @exmMarksOf.
  ///
  /// In en, this message translates to:
  /// **'{marks} of {max}'**
  String exmMarksOf(int marks, String max);

  /// No description provided for @exmEnterMarks.
  ///
  /// In en, this message translates to:
  /// **'Enter marks'**
  String get exmEnterMarks;

  /// No description provided for @exmMarksSave.
  ///
  /// In en, this message translates to:
  /// **'Save marks'**
  String get exmMarksSave;

  /// No description provided for @exmAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get exmAbsent;

  /// No description provided for @exmMarksField.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get exmMarksField;

  /// No description provided for @exmMarksTooHigh.
  ///
  /// In en, this message translates to:
  /// **'More than the total marks'**
  String get exmMarksTooHigh;

  /// No description provided for @exmResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get exmResults;

  /// No description provided for @exmResultsStats.
  ///
  /// In en, this message translates to:
  /// **'{entered} entered · {absent} absent'**
  String exmResultsStats(String entered, int absent);

  /// No description provided for @exmAverage.
  ///
  /// In en, this message translates to:
  /// **'Average {value}%'**
  String exmAverage(String value);

  /// No description provided for @exmHighLow.
  ///
  /// In en, this message translates to:
  /// **'Highest {high} · Lowest {low}'**
  String exmHighLow(String high, String low);

  /// No description provided for @exmNotEntered.
  ///
  /// In en, this message translates to:
  /// **'Not entered'**
  String get exmNotEntered;

  /// No description provided for @exmPaper.
  ///
  /// In en, this message translates to:
  /// **'Question paper'**
  String get exmPaper;

  /// No description provided for @exmPaperNone.
  ///
  /// In en, this message translates to:
  /// **'No paper yet.'**
  String get exmPaperNone;

  /// No description provided for @exmPaperCompose.
  ///
  /// In en, this message translates to:
  /// **'Choose questions'**
  String get exmPaperCompose;

  /// No description provided for @exmPaperSend.
  ///
  /// In en, this message translates to:
  /// **'Send for approval'**
  String get exmPaperSend;

  /// No description provided for @exmPaperApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve paper'**
  String get exmPaperApprove;

  /// No description provided for @exmPaperReject.
  ///
  /// In en, this message translates to:
  /// **'Send back'**
  String get exmPaperReject;

  /// No description provided for @exmPaperStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get exmPaperStatusDraft;

  /// No description provided for @exmPaperStatusSent.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get exmPaperStatusSent;

  /// No description provided for @exmPaperStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get exmPaperStatusApproved;

  /// No description provided for @exmPaperStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Sent back'**
  String get exmPaperStatusRejected;

  /// No description provided for @exmPaperTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {marks} marks'**
  String exmPaperTotal(int marks);

  /// No description provided for @exmPaperNote.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String exmPaperNote(String note);

  /// No description provided for @exmPaperBankEmpty.
  ///
  /// In en, this message translates to:
  /// **'No questions yet for this class and subject. Add them in the question bank.'**
  String get exmPaperBankEmpty;

  /// No description provided for @exmPaperUse.
  ///
  /// In en, this message translates to:
  /// **'Use {count} questions'**
  String exmPaperUse(int count);

  /// No description provided for @exmReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get exmReason;

  /// No description provided for @qbUnitAdd.
  ///
  /// In en, this message translates to:
  /// **'Add unit'**
  String get qbUnitAdd;

  /// No description provided for @qbUnitEdit.
  ///
  /// In en, this message translates to:
  /// **'Change unit'**
  String get qbUnitEdit;

  /// No description provided for @qbUnitName.
  ///
  /// In en, this message translates to:
  /// **'Unit name'**
  String get qbUnitName;

  /// No description provided for @qbUnitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No units yet.'**
  String get qbUnitsEmpty;

  /// No description provided for @qbQuestionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get qbQuestionAdd;

  /// No description provided for @qbQuestionEdit.
  ///
  /// In en, this message translates to:
  /// **'Change question'**
  String get qbQuestionEdit;

  /// No description provided for @qbQuestionText.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get qbQuestionText;

  /// No description provided for @qbQuestionMarks.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get qbQuestionMarks;

  /// No description provided for @qbQuestionType.
  ///
  /// In en, this message translates to:
  /// **'Kind of question'**
  String get qbQuestionType;

  /// No description provided for @qbTypeMcq.
  ///
  /// In en, this message translates to:
  /// **'Multiple choice'**
  String get qbTypeMcq;

  /// No description provided for @qbTypeShort.
  ///
  /// In en, this message translates to:
  /// **'Short answer'**
  String get qbTypeShort;

  /// No description provided for @qbTypeLong.
  ///
  /// In en, this message translates to:
  /// **'Long answer'**
  String get qbTypeLong;

  /// No description provided for @qbQuestionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No questions in this unit yet.'**
  String get qbQuestionsEmpty;

  /// No description provided for @qbUnitBy.
  ///
  /// In en, this message translates to:
  /// **'{teacher} · {cls} · {subject}'**
  String qbUnitBy(String teacher, String cls, String subject);

  /// No description provided for @exmStudentResults.
  ///
  /// In en, this message translates to:
  /// **'Exam results'**
  String get exmStudentResults;

  /// No description provided for @exmStudentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {obtained} of {outOf} ({pct}%)'**
  String exmStudentTotal(String obtained, String outOf, String pct);

  /// No description provided for @exmStudentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exams yet.'**
  String get exmStudentEmpty;

  /// No description provided for @payTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payTitle;

  /// No description provided for @payTabTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get payTabTeachers;

  /// No description provided for @payTabStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get payTabStaff;

  /// No description provided for @payTabMine.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get payTabMine;

  /// No description provided for @payEmpty.
  ///
  /// In en, this message translates to:
  /// **'No one to show.'**
  String get payEmpty;

  /// No description provided for @paySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get paySalary;

  /// No description provided for @payFuelBill.
  ///
  /// In en, this message translates to:
  /// **'Fuel bill'**
  String get payFuelBill;

  /// No description provided for @paySalaryNow.
  ///
  /// In en, this message translates to:
  /// **'Salary {amount} a month'**
  String paySalaryNow(String amount);

  /// No description provided for @paySalaryNone.
  ///
  /// In en, this message translates to:
  /// **'Salary not set'**
  String get paySalaryNone;

  /// No description provided for @paySetSalary.
  ///
  /// In en, this message translates to:
  /// **'Set salary'**
  String get paySetSalary;

  /// No description provided for @paySalaryFrom.
  ///
  /// In en, this message translates to:
  /// **'From month'**
  String get paySalaryFrom;

  /// No description provided for @paySalaryHistory.
  ///
  /// In en, this message translates to:
  /// **'Salary history'**
  String get paySalaryHistory;

  /// No description provided for @payFrom.
  ///
  /// In en, this message translates to:
  /// **'from {month}'**
  String payFrom(String month);

  /// No description provided for @payBalance.
  ///
  /// In en, this message translates to:
  /// **'To pay {amount}'**
  String payBalance(String amount);

  /// No description provided for @payTotals.
  ///
  /// In en, this message translates to:
  /// **'Due {due} · Paid {paid}'**
  String payTotals(String due, String paid);

  /// No description provided for @payLineDue.
  ///
  /// In en, this message translates to:
  /// **'{label}: due {due}, paid {paid}'**
  String payLineDue(String label, String due, String paid);

  /// No description provided for @payPay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get payPay;

  /// No description provided for @payMode.
  ///
  /// In en, this message translates to:
  /// **'How paid'**
  String get payMode;

  /// No description provided for @payHistory.
  ///
  /// In en, this message translates to:
  /// **'Payments made'**
  String get payHistory;

  /// No description provided for @payHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get payHistoryEmpty;

  /// No description provided for @payReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt {no}'**
  String payReceipt(String no);

  /// No description provided for @payNothingDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing is due.'**
  String get payNothingDue;

  /// No description provided for @payFuelOn.
  ///
  /// In en, this message translates to:
  /// **'{van} · {date}'**
  String payFuelOn(String van, String date);

  /// No description provided for @anaTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get anaTitle;

  /// No description provided for @anaStudentAttendance.
  ///
  /// In en, this message translates to:
  /// **'Student attendance'**
  String get anaStudentAttendance;

  /// No description provided for @anaFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get anaFees;

  /// No description provided for @anaExams.
  ///
  /// In en, this message translates to:
  /// **'Exam results'**
  String get anaExams;

  /// No description provided for @anaStaffAttendance.
  ///
  /// In en, this message translates to:
  /// **'Teacher & staff attendance'**
  String get anaStaffAttendance;

  /// No description provided for @anaPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments to staff'**
  String get anaPayments;

  /// No description provided for @anaFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get anaFuel;

  /// No description provided for @anaLessons.
  ///
  /// In en, this message translates to:
  /// **'Daily lessons'**
  String get anaLessons;

  /// No description provided for @anaSeriesAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance %'**
  String get anaSeriesAttendance;

  /// No description provided for @anaSeriesFeesCollected.
  ///
  /// In en, this message translates to:
  /// **'Fees collected each month'**
  String get anaSeriesFeesCollected;

  /// No description provided for @anaSeriesFeesBalance.
  ///
  /// In en, this message translates to:
  /// **'Fees still to come, by class'**
  String get anaSeriesFeesBalance;

  /// No description provided for @anaSeriesExamAverage.
  ///
  /// In en, this message translates to:
  /// **'Average % in each exam'**
  String get anaSeriesExamAverage;

  /// No description provided for @anaSeriesStaffPresent.
  ///
  /// In en, this message translates to:
  /// **'Came in'**
  String get anaSeriesStaffPresent;

  /// No description provided for @anaSeriesStaffAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent or on leave'**
  String get anaSeriesStaffAbsent;

  /// No description provided for @anaSeriesPaidOut.
  ///
  /// In en, this message translates to:
  /// **'Paid out each month'**
  String get anaSeriesPaidOut;

  /// No description provided for @anaSeriesFuelAmount.
  ///
  /// In en, this message translates to:
  /// **'Fuel spent'**
  String get anaSeriesFuelAmount;

  /// No description provided for @anaSeriesFuelMileage.
  ///
  /// In en, this message translates to:
  /// **'Kilometres per litre'**
  String get anaSeriesFuelMileage;

  /// No description provided for @anaSeriesLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons recorded %'**
  String get anaSeriesLessons;

  /// No description provided for @anaSumCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get anaSumCollected;

  /// No description provided for @anaSumBalance.
  ///
  /// In en, this message translates to:
  /// **'Still to come'**
  String get anaSumBalance;

  /// No description provided for @anaSumOwed.
  ///
  /// In en, this message translates to:
  /// **'Still owed to staff'**
  String get anaSumOwed;

  /// No description provided for @anaSumPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid out'**
  String get anaSumPaid;

  /// No description provided for @anaEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to draw for this period.'**
  String get anaEmpty;

  /// No description provided for @anaPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get anaPeriod;

  /// No description provided for @perTitle.
  ///
  /// In en, this message translates to:
  /// **'What this person may do'**
  String get perTitle;

  /// No description provided for @perReason.
  ///
  /// In en, this message translates to:
  /// **'Why are you giving this?'**
  String get perReason;

  /// No description provided for @perGive.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get perGive;

  /// No description provided for @perTakeBackAsk.
  ///
  /// In en, this message translates to:
  /// **'Take back “{label}”?'**
  String perTakeBackAsk(String label);

  /// No description provided for @perTakeBack.
  ///
  /// In en, this message translates to:
  /// **'Take back'**
  String get perTakeBack;

  /// No description provided for @perReasonShown.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String perReasonShown(String reason);

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeAreas.
  ///
  /// In en, this message translates to:
  /// **'Your areas'**
  String get homeAreas;

  /// No description provided for @homeLatestNotice.
  ///
  /// In en, this message translates to:
  /// **'Latest notice'**
  String get homeLatestNotice;

  /// No description provided for @homeNoNotice.
  ///
  /// In en, this message translates to:
  /// **'No notices yet.'**
  String get homeNoNotice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
