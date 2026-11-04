// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'शिक्षा सेतु';

  @override
  String get roleLabelPrincipal => 'प्रधानाचार्य';

  @override
  String get roleLabelTeacher => 'शिक्षक';

  @override
  String get navDashboard => 'होम';

  @override
  String get navAttendance => 'उपस्थिति';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get loginWelcome => 'वापसी पर स्वागत है';

  @override
  String get loginSubtitle => 'जारी रखने के लिए साइन इन करें';

  @override
  String get fieldEmail => 'ईमेल';

  @override
  String get fieldPassword => 'पासवर्ड';

  @override
  String get actionSignIn => 'साइन इन';

  @override
  String get actionSignOut => 'साइन आउट';

  @override
  String get errorEmailInvalid => 'सही ईमेल दर्ज करें';

  @override
  String get errorPasswordRequired => 'पासवर्ड दर्ज करें';

  @override
  String get errorInvalidCredentials => 'ईमेल या पासवर्ड गलत है';

  @override
  String get loginDemoTitle => 'डेमो अकाउंट — भरने के लिए टैप करें';

  @override
  String greetingMorning(String name) {
    return 'सुप्रभात, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'नमस्कार, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'शुभ संध्या, $name';
  }

  @override
  String roleAndDate(String role, String date) {
    return '$role · $date';
  }

  @override
  String get dayOpen => 'आज विद्यालय खुला है';

  @override
  String get dayClosed => 'आज विद्यालय बंद है';

  @override
  String get dayPending => 'प्रधानाचार्य की मंज़ूरी का इंतज़ार है';

  @override
  String get actionApprove => 'स्वीकृत करें';

  @override
  String get actionKeepClosed => 'विद्यालय बंद रखें';

  @override
  String get actionChangeDecision => 'निर्णय बदलें';

  @override
  String get sectionTodayAtGlance => 'आज एक नज़र में';

  @override
  String get sectionMyDay => 'मेरा दिन';

  @override
  String get statTeachersPresent => 'उपस्थित शिक्षक';

  @override
  String get statStudentsPresent => 'उपस्थित छात्र';

  @override
  String get statClassesMarked => 'उपस्थिति भरी कक्षाएँ';

  @override
  String get statTeachersNotIn => 'अनुपस्थित शिक्षक';

  @override
  String get statCheckedIn => 'चेक-इन हुआ';

  @override
  String get statNotCheckedIn => 'चेक-इन नहीं हुआ';

  @override
  String get statPresent => 'उपस्थित';

  @override
  String get statNotInYet => 'अभी नहीं आए';

  @override
  String statClassAttendance(String name) {
    return 'विद्यार्थियों की उपस्थिति: कक्षा $name';
  }

  @override
  String get valueDone => 'पूर्ण';

  @override
  String get valuePending => 'बाकी';

  @override
  String valueOutOf(int value, int total) {
    return '$value/$total';
  }

  @override
  String get attendanceTitle => 'उपस्थिति';

  @override
  String get tabTeachers => 'शिक्षक';

  @override
  String get tabStudents => 'छात्र';

  @override
  String get tabMyAttendance => 'मेरी उपस्थिति';

  @override
  String get sectionMyAttendanceToday => 'आज की मेरी उपस्थिति';

  @override
  String get sectionClasses => 'कक्षाएँ';

  @override
  String get labelCheckIn => 'चेक-इन';

  @override
  String get labelCheckOut => 'चेक-आउट';

  @override
  String get labelWorked => 'कार्य समय';

  @override
  String get actionCheckIn => 'चेक इन';

  @override
  String get actionCheckOut => 'चेक आउट';

  @override
  String get noticeCheckInLocked =>
      'जब प्रधानाचार्य आज विद्यालय खुला घोषित करेंगे, तब आप चेक-इन कर सकेंगे।';

  @override
  String get noticeCheckedOut => 'आपने चेक-आउट कर लिया है। कल मिलते हैं!';

  @override
  String get chipNotIn => 'नहीं आए';

  @override
  String get chipCheckedOut => 'चेक-आउट हुआ';

  @override
  String get chipInSchool => 'विद्यालय में';

  @override
  String get chipNotMarked => 'नहीं भरी';

  @override
  String get chipMarkNow => 'अभी भरें';

  @override
  String get chipDone => 'पूर्ण';

  @override
  String timeInOut(String inTime, String outTime) {
    return 'अंदर $inTime  ·  बाहर $outTime';
  }

  @override
  String classTitle(String name) {
    return 'कक्षा $name';
  }

  @override
  String get classNotMarkedYet => 'अभी उपस्थिति नहीं भरी';

  @override
  String classPresentOfTotal(int present, int total) {
    return '$total में से $present उपस्थित';
  }

  @override
  String classPresentAbsent(int present, int absent) {
    return '$present उपस्थित · $absent अनुपस्थित';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours घं $minutes मि';
  }

  @override
  String get actionMarkAllPresent => 'सभी को उपस्थित करें';

  @override
  String get actionSaveAttendance => 'उपस्थिति सहेजें';

  @override
  String get messageAttendanceSaved => 'उपस्थिति सहेज ली गई';

  @override
  String get statusPresent => 'उपस्थित';

  @override
  String get statusAbsent => 'अनुपस्थित';

  @override
  String get statusLate => 'देरी से';

  @override
  String get statusPresentShort => 'उ';

  @override
  String get statusAbsentShort => 'अ';

  @override
  String get statusLateShort => 'दे';

  @override
  String get verifyTitle => 'सत्यापन हो रहा है';

  @override
  String get verifyLocation => 'विद्यालय की लोकेशन जाँची जा रही है';

  @override
  String get verifyFace => 'चेहरा सत्यापित हो रहा है';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileEmployeeId => 'कर्मचारी आईडी';

  @override
  String get profileEmail => 'ईमेल';

  @override
  String get profilePhone => 'फ़ोन';

  @override
  String get profileJoined => 'नियुक्ति तिथि';

  @override
  String get profileSubject => 'विषय';

  @override
  String get profileClassTeacherOf => 'कक्षा शिक्षक';

  @override
  String get profileAdminNote =>
      'प्रधानाचार्य के रूप में आप विद्यालय के दिन मंज़ूर कर सकते हैं और सबकी उपस्थिति देख सकते हैं।';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get moduleExams => 'परीक्षाएँ';

  @override
  String get moduleAnalytics => 'विश्लेषण';

  @override
  String get moduleFees => 'शुल्क';

  @override
  String get moduleRegistration => 'विद्यार्थी या स्टाफ़ जोड़ें';

  @override
  String get moduleTeachers => 'शिक्षक';

  @override
  String get moduleNotices => 'सूचनाएँ';

  @override
  String get sectionQuickAccess => 'त्वरित पहुँच';

  @override
  String get examsTitle => 'परीक्षाएँ';

  @override
  String get tabUpcoming => 'अभी नहीं हुए';

  @override
  String get tabPastPapers => 'पिछले पेपर';

  @override
  String get actionCreatePaper => 'पेपर बनाएँ';

  @override
  String get emptyUpcoming =>
      'अभी कोई आगामी या ड्राफ़्ट पेपर नहीं है।\n\"पेपर बनाएँ\" दबाकर जोड़ें।';

  @override
  String get emptyPast => 'अभी कोई आयोजित पेपर नहीं है।';

  @override
  String get paperStatusDraft => 'ड्राफ़्ट';

  @override
  String get paperStatusScheduled => 'निर्धारित';

  @override
  String get paperStatusConducted => 'परीक्षा हो चुकी';

  @override
  String paperSubjectClass(String subject, String cls) {
    return '$subject · कक्षा $cls';
  }

  @override
  String paperMarksDuration(int marks, int minutes) {
    return '$marks अंक · $minutes मिनट';
  }

  @override
  String get sectionQuestions => 'प्रश्न';

  @override
  String questionNumber(int n) {
    return 'प्र$n';
  }

  @override
  String marksShort(int marks) {
    return '$marks अंक';
  }

  @override
  String get createPaperTitle => 'नया प्रश्न पत्र';

  @override
  String get fieldPaperTitle => 'पेपर का शीर्षक';

  @override
  String get fieldSubject => 'विषय';

  @override
  String get fieldClass => 'कक्षा';

  @override
  String get fieldDate => 'तारीख़';

  @override
  String get fieldDuration => 'अवधि';

  @override
  String durationMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get fieldQuestion => 'प्रश्न';

  @override
  String get fieldMarks => 'अंक';

  @override
  String paperTotalMarks(int marks) {
    return 'कुल $marks अंक';
  }

  @override
  String get actionAddQuestion => 'प्रश्न जोड़ें';

  @override
  String get actionSaveDraft => 'ड्राफ़्ट सहेजें';

  @override
  String get actionSchedule => 'निर्धारित करें';

  @override
  String get actionRemove => 'हटाएँ';

  @override
  String get errorRequired => 'आवश्यक';

  @override
  String get messagePaperSaved => 'पेपर सहेजा गया';

  @override
  String get feesTitle => 'शुल्क';

  @override
  String get tabOthers => 'अन्य';

  @override
  String get feesCollected => 'प्राप्त';

  @override
  String get feesPending => 'बाकी';

  @override
  String get feesTotal => 'कुल';

  @override
  String get searchByName => 'नाम से खोजें';

  @override
  String get filterAll => 'सभी';

  @override
  String get feeStatusPaid => 'चुकाया';

  @override
  String get feeStatusPartial => 'आंशिक';

  @override
  String get feeStatusOverdue => 'अतिदेय';

  @override
  String get feeStatusDue => 'देय';

  @override
  String feePaidOfTotal(String paid, String total) {
    return '$total में से $paid चुकाए';
  }

  @override
  String feeDueOn(String date) {
    return 'देय तिथि $date';
  }

  @override
  String get fieldAmount => 'राशि';

  @override
  String get errorAmountInvalid => 'सही राशि दर्ज करें';

  @override
  String get errorAmountExceeds => 'बाकी राशि से अधिक नहीं हो सकती';

  @override
  String get actionRecordPayment => 'भुगतान दर्ज करें';

  @override
  String get messagePaymentRecorded => 'भुगतान दर्ज हुआ';

  @override
  String get emptyNoResults => 'कोई मेल खाता रिकॉर्ड नहीं मिला।';

  @override
  String get registrationTitle => 'विद्यार्थी या स्टाफ़ जोड़ें';

  @override
  String get personStudent => 'छात्र';

  @override
  String get personTeacher => 'शिक्षक';

  @override
  String get personOther => 'अन्य';

  @override
  String get actionRegister => 'पंजीकरण करें';

  @override
  String get registerTitle => 'अपना खाता बनाएँ';

  @override
  String get fieldFullName => 'पूरा नाम';

  @override
  String get fieldAadhaar => 'आधार संख्या';

  @override
  String get fieldPhone => 'मोबाइल नंबर';

  @override
  String get fieldGuardian => 'अभिभावक का नाम';

  @override
  String get fieldRole => 'भूमिका (जैसे वैन चालक)';

  @override
  String get aadhaarHelper =>
      'हम नंबर जाँचते हैं, लेकिन सिर्फ़ आख़िरी 4 अंक सेव करते हैं।';

  @override
  String get fieldAadhaarReason => 'आधार नंबर न देने का कारण';

  @override
  String get hintAadhaarReason =>
      'जैसे आधार अभी बना नहीं, कार्ड खो गया, आवेदन किया है';

  @override
  String get errorAadhaarInvalid => 'सही 12 अंकों की आधार संख्या दर्ज करें';

  @override
  String get errorPhoneInvalid => '10 अंकों का मोबाइल नंबर दर्ज करें';

  @override
  String get messageRegistered => 'पंजीकरण सफल रहा';

  @override
  String registeredOnLabel(String date) {
    return 'पंजीकरण $date';
  }

  @override
  String get emptyPeople => 'अभी कोई पंजीकृत नहीं है।';

  @override
  String get staffTitle => 'शिक्षक';

  @override
  String get emptyStaff => 'कोई शिक्षक नहीं मिला।';

  @override
  String get staffActive => 'सक्रिय';

  @override
  String get staffInactive => 'निष्क्रिय';

  @override
  String get staffNoClass => 'कोई कक्षा नहीं सौंपी';

  @override
  String staffClassTeacher(String cls) {
    return '$cls के कक्षा शिक्षक';
  }

  @override
  String sheetAssignTitle(String name) {
    return '$name को कक्षा सौंपें';
  }

  @override
  String classTakenBy(String name) {
    return 'पहले से $name को सौंपी गई';
  }

  @override
  String get actionRemoveAssignment => 'कक्षा असाइनमेंट हटाएँ';

  @override
  String get noticesTitle => 'सूचनाएँ';

  @override
  String get actionPostNotice => 'सूचना भेजें';

  @override
  String get emptyNotices => 'अभी कोई सूचना नहीं है।';

  @override
  String get fieldNoticeTitle => 'शीर्षक';

  @override
  String get fieldNoticeBody => 'संदेश';

  @override
  String get messageNoticePosted => 'सूचना भेजी गई';

  @override
  String noticePostedBy(String name, String date) {
    return '$name द्वारा · $date';
  }

  @override
  String get analyticsTitle => 'विश्लेषण';

  @override
  String get sectionAttendanceTrend => 'उपस्थिति — पिछले 7 दिन (%)';

  @override
  String get sectionSubjectAverages => 'विषयवार औसत अंक (%)';

  @override
  String get sectionFeeCollection => 'शुल्क संग्रह';

  @override
  String get sectionTeacherReport => 'शिक्षक रिपोर्ट';

  @override
  String avgCheckInLabel(String time) {
    return 'औसत चेक-इन $time';
  }

  @override
  String percentValue(int percent) {
    return '$percent%';
  }

  @override
  String get dialogUnsavedTitle => 'बदलाव छोड़ें?';

  @override
  String get dialogUnsavedBody => 'उपस्थिति के बदलाव सहेजे नहीं गए हैं।';

  @override
  String get actionKeepEditing => 'संपादन जारी रखें';

  @override
  String get actionDiscard => 'छोड़ें';

  @override
  String get moduleClasses => 'कक्षा प्रबंधन';

  @override
  String get classesTitle => 'कक्षा प्रबंधन';

  @override
  String get actionAddClass => 'कक्षा जोड़ें';

  @override
  String get actionEditClass => 'कक्षा बदलें';

  @override
  String get fieldClassName => 'कक्षा का नाम';

  @override
  String get hintClassName => 'जैसे 9-A';

  @override
  String get errorClassExists => 'यह कक्षा पहले से मौजूद है';

  @override
  String classStudentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छात्र',
    );
    return '$_temp0';
  }

  @override
  String get classNoTeacher => 'कोई कक्षा शिक्षक नहीं';

  @override
  String dialogDeleteClassTitle(String name) {
    return 'कक्षा $name हटाएँ?';
  }

  @override
  String dialogDeleteClassBody(int count) {
    return 'इससे कक्षा, उसके $count विद्यार्थी और उनकी उपस्थिति हट जाएगी। इसे वापस नहीं किया जा सकता।';
  }

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionSave => 'सहेजें';

  @override
  String get feesFilters => 'फ़िल्टर';

  @override
  String get feesFilterStatus => 'स्थिति';

  @override
  String get feesFilterClass => 'कक्षा';

  @override
  String get feesFilterDueDate => 'देय तिथि';

  @override
  String get feesFilterSort => 'क्रम';

  @override
  String get feesSortUrgency => 'सबसे ज़रूरी';

  @override
  String get feesSortName => 'नाम (अ से ज्ञ)';

  @override
  String get feesSortPending => 'सबसे ज़्यादा बकाया';

  @override
  String get feesSortDue => 'सबसे पहले देय';

  @override
  String get feesClearAll => 'सब हटाएँ';

  @override
  String get feesShowResults => 'नतीजे दिखाएँ';

  @override
  String feesResultSummary(int count, String pending) {
    return '$count मिले · $pending बकाया';
  }

  @override
  String feeRollNo(int roll) {
    return 'रोल $roll';
  }

  @override
  String get dateAnyTime => 'कोई भी तारीख़';

  @override
  String get datePickRange => 'तारीख़ चुनें';

  @override
  String get dateToday => 'आज';

  @override
  String get dateThisWeek => 'इस सप्ताह';

  @override
  String get dateThisMonth => 'इस महीने';

  @override
  String get paymentsFilterDate => 'भुगतान की तारीख़';

  @override
  String paymentsSummary(int count, String amount) {
    return '$count भुगतान · $amount';
  }

  @override
  String get paymentsNone => 'इन फ़िल्टर से कोई भुगतान नहीं मिला।';

  @override
  String paymentsOf(String name) {
    return 'भुगतान: $name';
  }

  @override
  String get staffAddTeacher => 'शिक्षक जोड़ें';

  @override
  String get staffActionAssignClass => 'कक्षा सौंपें';

  @override
  String get qtMcq => 'बहुविकल्पीय';

  @override
  String get qtTrueFalse => 'सही / गलत';

  @override
  String get qtFillBlank => 'रिक्त स्थान भरें';

  @override
  String get qtMatch => 'मिलान करें';

  @override
  String get qtShort => 'लघु उत्तर';

  @override
  String get qtLong => 'दीर्घ उत्तर';

  @override
  String get qtMcqHint => 'कई विकल्पों वाला प्रश्न';

  @override
  String get qtTrueFalseHint => 'कथन को सही या गलत बताना';

  @override
  String get qtFillBlankHint => 'खाली जगह वाला वाक्य';

  @override
  String get qtMatchHint => 'दो स्तंभों के पद जोड़ना';

  @override
  String get qtShortHint => 'एक-दो पंक्तियों में उत्तर';

  @override
  String get qtLongHint => 'विस्तार से उत्तर';

  @override
  String get paperChooseType => 'प्रश्न का प्रकार चुनें';

  @override
  String get paperInstructions => 'सामान्य निर्देश';

  @override
  String get paperInstructionsHint => 'जैसे: सभी प्रश्न अनिवार्य हैं।';

  @override
  String get paperAddQuestion => 'प्रश्न जोड़ें';

  @override
  String get paperScan => 'फ़ोटो स्कैन';

  @override
  String get paperPaste => 'टेक्स्ट पेस्ट करें';

  @override
  String get paperFromMaster => 'प्रश्न बैंक';

  @override
  String get paperSetMarksAll => 'सबके अंक तय करें';

  @override
  String get paperMarksForAll => 'हर प्रश्न के अंक';

  @override
  String get paperApply => 'लागू करें';

  @override
  String get paperShuffle => 'फेंटें';

  @override
  String get paperShuffleQuestions => 'प्रश्न फेंटें';

  @override
  String get paperShuffleOptions => 'प्रश्न और विकल्प दोनों फेंटें';

  @override
  String get paperShuffleNote =>
      'प्रश्न सिर्फ़ अपने प्रकार में ही बदले जाते हैं। जैसे, MCQ सिर्फ़ MCQ के बीच बदलेंगे।';

  @override
  String get paperDuplicate => 'प्रतिलिपि';

  @override
  String get paperSaveToMaster => 'प्रश्न बैंक में सेव करें';

  @override
  String get paperSavedToMaster => 'प्रश्न बैंक में सेव हो गया';

  @override
  String get paperCheckChip => 'जाँचें';

  @override
  String paperFoundN(int count) {
    return '$count प्रश्न जोड़े गए। कृपया जाँच लें।';
  }

  @override
  String get paperPasteTitle => 'प्रश्न पेस्ट करें';

  @override
  String get paperPasteHint =>
      'अपने प्रश्न यहाँ चिपकाएँ या लिखें। हर प्रश्न पर नंबर डालें। विकल्प (a) (b) (c) में लिखें।';

  @override
  String get paperPasteAction => 'प्रश्न जोड़ें';

  @override
  String get paperDragHint => 'क्रम बदलने के लिए दबाकर खींचें';

  @override
  String optionLabel(String letter) {
    return 'विकल्प $letter';
  }

  @override
  String get qAddOption => 'विकल्प जोड़ें';

  @override
  String get qCorrectAnswer => 'सही उत्तर';

  @override
  String get qTrue => 'सही';

  @override
  String get qFalse => 'गलत';

  @override
  String get qBlankHint => 'खाली जगह के लिए ____ लिखें।';

  @override
  String get qBlankAnswer => 'उत्तर (उत्तर-कुंजी के लिए)';

  @override
  String get qColumnA => 'स्तंभ क';

  @override
  String get qColumnB => 'स्तंभ ख';

  @override
  String get qAddPair => 'जोड़ी जोड़ें';

  @override
  String get qCheckMatches => 'देखें कि हर जोड़ी सही मिली है।';

  @override
  String get qNeedBlank => 'खाली जगह के लिए ____ जोड़ें';

  @override
  String get qNeedOptions => 'कम से कम दो विकल्प जोड़ें';

  @override
  String get qNeedPairs => 'कम से कम दो पूरी जोड़ियाँ जोड़ें';

  @override
  String get actionSendForApproval => 'स्वीकृति के लिए भेजें';

  @override
  String get actionApproveSave => 'स्वीकृत करें और सहेजें';

  @override
  String get paperStatusSubmitted => 'स्वीकृति की प्रतीक्षा';

  @override
  String get paperStatusChanges => 'बदलाव माँगे गए';

  @override
  String get paperStatusApproved => 'स्वीकृत';

  @override
  String get paperTabToApprove => 'स्वीकृति हेतु';

  @override
  String get paperTabReady => 'तैयार';

  @override
  String get paperTabDrafts => 'मसौदे';

  @override
  String paperSetBy(String name) {
    return 'तैयार किया: $name';
  }

  @override
  String get paperAwaitingTitle => 'आपकी स्वीकृति की प्रतीक्षा है';

  @override
  String get paperAwaitingBody =>
      'प्रश्न पढ़ें। आप उन्हें बदल, हटा या फेंट सकते हैं, फिर मंज़ूर करें।';

  @override
  String get paperYourStatusSubmitted =>
      'प्रधानाचार्य को भेज दिया गया। मंज़ूर होने पर यहाँ दिखेगा।';

  @override
  String get paperSentBackTitle => 'बदलाव के लिए वापस भेजा गया';

  @override
  String get actionSendBack => 'वापस भेजें';

  @override
  String get actionEditPaper => 'पेपर बदलें';

  @override
  String get actionDeletePaper => 'पेपर हटाएँ';

  @override
  String get sendBackTitle => 'बदलाव के लिए वापस भेजें';

  @override
  String get sendBackHint => 'क्या बदलना चाहिए?';

  @override
  String get paperDeleteTitle => 'यह पेपर हटाएँ?';

  @override
  String get paperDeleteBody => 'पेपर और उसके प्रश्न हटा दिए जाएँगे।';

  @override
  String get messagePaperSubmitted =>
      'स्वीकृति के लिए प्रधानाचार्य को भेजा गया';

  @override
  String get messagePaperApproved => 'पेपर स्वीकृत';

  @override
  String get messagePaperSentBack => 'शिक्षक को वापस भेजा गया';

  @override
  String get messagePaperShuffled => 'प्रश्न फेंटे गए';

  @override
  String get paperPreviewPrint => 'पूर्वावलोकन और प्रिंट';

  @override
  String get masterTitle => 'प्रश्न बैंक';

  @override
  String get masterEmpty =>
      'आपका प्रश्न बैंक खाली है। प्रश्न यहाँ सेव करें, ताकि किसी भी पेपर में दोबारा इस्तेमाल कर सकें।';

  @override
  String get masterAdd => 'प्रश्न जोड़ें';

  @override
  String get masterEdit => 'प्रश्न बदलें';

  @override
  String get masterSubjectOptional => 'विषय (वैकल्पिक)';

  @override
  String get masterSaved => 'प्रश्न बैंक में सेव हो गया';

  @override
  String get masterRemoved => 'प्रश्न बैंक से हटा दिया';

  @override
  String get masterPickTitle => 'प्रश्न बैंक से चुनें';

  @override
  String masterAddSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रश्न जोड़ें',
      zero: 'प्रश्न चुनें',
    );
    return '$_temp0';
  }

  @override
  String get masterNoMatch => 'प्रश्न बैंक में कुछ नहीं मिला।';

  @override
  String get masterRemoveTitle => 'प्रश्न बैंक से हटाएँ?';

  @override
  String get emptyPapersHere => 'यहाँ कोई पेपर नहीं।';

  @override
  String get categoryExamPaper => 'परीक्षाएँ';

  @override
  String get approvalExamQuestion =>
      'एक प्रश्न-पत्र आपकी समीक्षा की प्रतीक्षा में है।';

  @override
  String get actionReviewPaper => 'पेपर देखें';

  @override
  String get logoTitle => 'विद्यालय का लोगो';

  @override
  String get logoHelp => 'लोगो हर प्रश्न-पत्र के ऊपर छपता है।';

  @override
  String get logoChoose => 'गैलरी से चुनें';

  @override
  String get logoChange => 'लोगो बदलें';

  @override
  String get logoRemove => 'लोगो हटाएँ';

  @override
  String get logoNone => 'अभी कोई लोगो नहीं';

  @override
  String get printSecMcq => 'सही उत्तर चुनिए';

  @override
  String get printSecTrueFalse => 'सही या गलत बताइए';

  @override
  String get printSecFill => 'रिक्त स्थान भरिए';

  @override
  String get printSecMatch => 'मिलान कीजिए';

  @override
  String get printSecShort => 'लघु उत्तरीय प्रश्न';

  @override
  String get printSecLong => 'दीर्घ उत्तरीय प्रश्न';

  @override
  String printMarks(int marks) {
    return '[$marks अंक]';
  }

  @override
  String printSection(String letter) {
    return 'खंड $letter';
  }

  @override
  String get printTimeAllowed => 'समय';

  @override
  String get printMaxMarks => 'पूर्णांक';

  @override
  String get printName => 'नाम';

  @override
  String get printRollNo => 'अनुक्रमांक';

  @override
  String get printAnswerKey => 'उत्तर-कुंजी';

  @override
  String get printEndOfPaper => '— प्रश्न-पत्र समाप्त —';

  @override
  String get printModeInk => 'इंक / लेज़र (A4)';

  @override
  String get printModeThermal => 'छोटा ब्लूटूथ प्रिंटर';

  @override
  String get printIncludeKey => 'उत्तर-कुंजी जोड़ें';

  @override
  String get printCopies => 'प्रतियाँ';

  @override
  String get printRoll => 'कागज़ का रोल';

  @override
  String get printMm58 => '58 मिमी';

  @override
  String get printMm80 => '80 मिमी';

  @override
  String get printPrinters => 'जुड़े हुए प्रिंटर';

  @override
  String get printRefresh => 'ताज़ा करें';

  @override
  String get printNoPrinters =>
      'कोई प्रिंटर नहीं मिला। फ़ोन की ब्लूटूथ सेटिंग्स में अपना प्रिंटर जोड़ें, फिर रीफ़्रेश दबाएँ।';

  @override
  String get printBluetoothOff => 'प्रिंटर खोजने के लिए ब्लूटूथ चालू करें।';

  @override
  String get printNeedPermission =>
      'फ़ोन की सेटिंग में इस ऐप को ब्लूटूथ की अनुमति दें।';

  @override
  String get printUnsupported => 'थर्मल प्रिंट के लिए Android या iPhone चाहिए।';

  @override
  String get printTipInk =>
      'पूरे पेपर के लिए सबसे अच्छा: Wi-Fi वाला A4 प्रिंटर (इंकजेट या लेज़र)। प्रिंटर अगली स्क्रीन पर चुनें।';

  @override
  String get printTipThermal =>
      'उत्तर कुंजी और छोटी पर्चियों के लिए ठीक: 58 mm या 80 mm का ब्लूटूथ प्रिंटर। पूरा पेपर छापने में बहुत रोल लगता है।';

  @override
  String get printAction => 'प्रिंट';

  @override
  String get printShare => 'PDF साझा करें';

  @override
  String get printSent => 'प्रिंटर को भेज दिया गया';

  @override
  String get printCancelled => 'प्रिंट रद्द किया गया';

  @override
  String get printPickPrinter => 'पहले प्रिंटर चुनें';

  @override
  String get printConnectFailed =>
      'जुड़ नहीं सका। जाँचें कि प्रिंटर चालू और पास में है।';

  @override
  String get printWriteFailed => 'प्रिंटर ने जवाब देना बंद कर दिया।';

  @override
  String get printFailed => 'प्रिंट नहीं हो सका।';

  @override
  String get printBuilding => 'पेपर तैयार हो रहा है…';

  @override
  String get printOnlyApproved =>
      'पेपर स्वीकृत होने के बाद ही प्रिंट हो सकता है।';

  @override
  String get cloudTitle => 'क्लाउड सिंक';

  @override
  String get cloudIntro =>
      'आपका डेटा इस फ़ोन में सेव रहता है और बिना इंटरनेट के चलता है। इंटरनेट होने पर उसका ऑनलाइन बैकअप भी हो जाता है।';

  @override
  String get cloudNotConfigured =>
      'इस ऐप में ऑनलाइन बैकअप अभी चालू नहीं है। कृपया सहायता से संपर्क करें।';

  @override
  String cloudConnectedAs(String email) {
    return '$email से जुड़ा है';
  }

  @override
  String get cloudProject => 'क्लाउड आईडी';

  @override
  String get cloudSchoolId => 'क्लाउड में विद्यालय की आईडी';

  @override
  String get cloudSyncNow => 'अभी सिंक करें';

  @override
  String get cloudSyncing => 'सिंक हो रहा है…';

  @override
  String cloudLastSync(String when) {
    return 'आख़िरी सिंक: $when';
  }

  @override
  String get cloudNeverSynced => 'अभी तक सिंक नहीं हुआ';

  @override
  String get cloudUpToDate => 'सब कुछ पहले से क्लाउड में है।';

  @override
  String cloudSentSummary(int count) {
    return '$count रिकॉर्ड भेजे गए';
  }

  @override
  String cloudRemovedSummary(int count) {
    return '$count रिकॉर्ड हटाए गए';
  }

  @override
  String get cloudWhatIsSent => 'क्या भेजा जाता है';

  @override
  String get cloudWhatIsSentBody =>
      'विद्यार्थी, शिक्षक, स्टाफ़, कक्षाएँ, उपस्थिति, परीक्षा, फ़ीस, सूचनाएँ और सेटिंग्स का बैकअप होता है। पासवर्ड, फ़ोटो और सेल्फ़ी कभी नहीं भेजे जाते।';

  @override
  String get cloudSyncedNotice => 'क्लाउड में सिंक हो गया';

  @override
  String get cloudNeedSignIn =>
      'पहले साइन इन करें। ऑनलाइन बैकअप के लिए प्रधानाचार्य का लॉगिन चाहिए।';

  @override
  String get cloudNotOwner =>
      'इस विद्यालय का ऑनलाइन डेटा किसी दूसरे लॉगिन का है।';

  @override
  String get cloudOffline =>
      'कनेक्ट नहीं हो पाया। इंटरनेट देखें। आपका डेटा इस फ़ोन में सुरक्षित है।';

  @override
  String get cloudFailed => 'सिंक पूरा नहीं हुआ। फिर कोशिश होगी।';

  @override
  String get faceNudgeStarting => 'कैमरा खुल रहा है…';

  @override
  String get faceNudgeShowFace => 'कैमरे को अपना चेहरा दिखाइए';

  @override
  String get faceNudgeOnlyOne => 'केवल एक चेहरा, कृपया';

  @override
  String get faceNudgeCloser => 'थोड़ा पास आइए';

  @override
  String get faceNudgeBack => 'थोड़ा पीछे हटिए';

  @override
  String get faceNudgeCenter => 'चेहरा गोले के अंदर रखिए';

  @override
  String get faceNudgeStraight => 'सीधे कैमरे की ओर देखिए';

  @override
  String get faceNudgeOpenEyes => 'आँखें खोलिए';

  @override
  String get faceNudgeHold => 'स्थिर रहिए…';

  @override
  String get faceNudgeBlink => 'अब एक बार पलक झपकाइए';

  @override
  String get faceNudgeCapturing => 'हो गया';

  @override
  String get faceCaptureEnrollTitle => 'फ़ेस आईडी सेट करें';

  @override
  String get faceCaptureVerifyTitle => 'पुष्टि करें कि यह आप हैं';

  @override
  String faceCaptureStep(int current, int total) {
    return 'फ़ोटो $current / $total';
  }

  @override
  String get faceFlipCamera => 'कैमरा बदलें';

  @override
  String get faceCameraDenied =>
      'फ़ेस आईडी के लिए फ़ोन की सेटिंग में कैमरे की अनुमति दें।';

  @override
  String get faceCameraMissing => 'इस फ़ोन पर फ्रंट कैमरा नहीं खुल सका।';

  @override
  String get faceTitle => 'फ़ेस आईडी';

  @override
  String get faceIntro =>
      'चेक-इन में आपका चेहरा और विद्यालय की लोकेशन देखी जाती है। चेहरा इस फ़ोन में सिर्फ़ अंकों के रूप में सेव होता है। कोई फ़ोटो नहीं रखी जाती और कुछ ऑनलाइन नहीं जाता।';

  @override
  String get faceStatusOn => 'फ़ेस आईडी सेट है';

  @override
  String get faceStatusOff => 'फ़ेस आईडी सेट नहीं है';

  @override
  String get faceSetUp => 'फ़ेस आईडी सेट करें';

  @override
  String get faceReplace => 'दोबारा सेट करें';

  @override
  String get faceRemove => 'फ़ेस आईडी हटाएँ';

  @override
  String get faceSetUpDone => 'फ़ेस आईडी सेट हो गया';

  @override
  String get faceRemoved => 'फ़ेस आईडी हटा दिया गया';

  @override
  String faceEnrolledOn(String date) {
    return '$date को सेट हुआ';
  }

  @override
  String get faceErrNotFound =>
      'साफ़ चेहरा नहीं मिला। अच्छी रोशनी में कैमरे की ओर देखकर फिर कोशिश करें।';

  @override
  String get faceErrUnavailable => 'इस फ़ोन पर फ़ेस आईडी नहीं चल सका।';

  @override
  String get checkErrFaceMismatch =>
      'चेहरा मेल नहीं खाया। अच्छी रोशनी में कैमरे की ओर देखकर फिर कोशिश करें।';

  @override
  String get checkErrFaceNotFound =>
      'साफ़ चेहरा नहीं मिला। कैमरे की ओर देखकर फिर कोशिश करें।';

  @override
  String get checkErrFaceUnavailable =>
      'इस फ़ोन पर फ़ेस आईडी नहीं चल सका। प्रधानाचार्य से मदद लें।';

  @override
  String get faceNudgeSetUpPrompt =>
      'चेहरे से चेक-इन के लिए फ़ेस आईडी सेट करें।';

  @override
  String faceScore(int percent) {
    return 'चेहरा मिलान $percent%';
  }

  @override
  String get aadhaarScan => 'आधार कार्ड स्कैन करें';

  @override
  String get aadhaarScanHint =>
      'कार्ड के आगे का साफ़, सीधा फ़ोटो लें जहाँ 12 अंकों का नंबर छपा है। फ़ोटो इसी फ़ोन पर पढ़ा जाता है और सहेजा नहीं जाता।';

  @override
  String get aadhaarScanFilled => 'कार्ड से आधार नंबर भर दिया गया';

  @override
  String get aadhaarScanNotFound =>
      'सही आधार नंबर नहीं मिला। कार्ड के आगे का और साफ़ फ़ोटो लें।';

  @override
  String get aadhaarScanFailed => 'फ़ोटो पढ़ा नहीं जा सका। फिर कोशिश करें।';

  @override
  String get aadhaarScanning => 'कार्ड पढ़ा जा रहा है…';

  @override
  String get aadhaarProbTitleNoNumber => 'नंबर दिखाई नहीं दिया';

  @override
  String get aadhaarProbNoNumber =>
      '12 अंकों का नंबर नहीं मिला। कार्ड को सीधा पकड़ें, ताकि नंबर साफ़ और बड़ा दिखे।';

  @override
  String get aadhaarProbTitleNoText => 'फ़ोटो साफ़ नहीं है';

  @override
  String get aadhaarProbNoText =>
      'कुछ पढ़ा नहीं जा सका। फ़ोटो धुँधली, अँधेरी या कार्ड की नहीं हो सकती। अच्छी रोशनी में दोबारा लें।';

  @override
  String get aadhaarProbTitleMasked => 'इस कार्ड में नंबर छिपा है';

  @override
  String get aadhaarProbMasked =>
      'सिर्फ़ आख़िरी चार अंक दिख रहे हैं (XXXX XXXX 1234)। ऐसा कार्ड लें जिसमें पूरे 12 अंक दिखें।';

  @override
  String get aadhaarProbTitleVid => 'यह वर्चुअल ID है';

  @override
  String get aadhaarProbVid =>
      'यह 16 अंकों की वर्चुअल ID है। कार्ड पर छपा 12 अंकों का आधार नंबर स्कैन करें।';

  @override
  String get aadhaarProbTitleChecksum => 'एक अंक गलत पढ़ा गया लगता है';

  @override
  String aadhaarProbChecksum(String number) {
    return 'हमने $number पढ़ा, लेकिन यह गलत लग रहा है। साफ़ फ़ोटो लें या हाथ से सुधारें।';
  }

  @override
  String get aadhaarProbTitleError => 'फ़ोटो पढ़ी नहीं जा सकी';

  @override
  String get aadhaarProbError =>
      'फ़ोटो पढ़ते समय कुछ गड़बड़ हुई। फिर कोशिश करें।';

  @override
  String get aadhaarTipsTitle => 'अच्छी फ़ोटो के लिए';

  @override
  String get aadhaarTipLight => 'अच्छी रोशनी, चमक या परछाईं नहीं';

  @override
  String get aadhaarTipFlat => 'कार्ड सीधा, चारों कोने दिखें';

  @override
  String get aadhaarTipFront => 'वह तरफ़ जिस पर 12 अंकों का नंबर है';

  @override
  String get aadhaarRetake => 'दूसरी फ़ोटो लें';

  @override
  String get aadhaarEditByHand => 'खुद सुधारें';

  @override
  String get aadhaarTypeInstead => 'खुद टाइप करें';

  @override
  String get fieldDob => 'जन्म तिथि';

  @override
  String bornOnLabel(String date) {
    return 'जन्म: $date';
  }

  @override
  String aadhaarFilledFromCard(String items) {
    return 'कार्ड से भरा गया: $items';
  }

  @override
  String get aadhaarItemNumber => 'आधार नंबर';

  @override
  String get aadhaarItemName => 'नाम';

  @override
  String get aadhaarItemDob => 'जन्म तिथि';

  @override
  String get fieldGender => 'लिंग';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'महिला';

  @override
  String get genderOther => 'अन्य';

  @override
  String get fieldAddress => 'पता';

  @override
  String get aadhaarItemGender => 'लिंग';

  @override
  String get aadhaarItemAddress => 'पता';

  @override
  String get aadhaarScanIntro =>
      'कार्ड के दोनों तरफ़ की फ़ोटो लें। आगे नाम, जन्म तिथि और नंबर होता है। पीछे पता होता है। फ़ोटो इसी फ़ोन में पढ़ी जाती हैं, सेव नहीं होतीं।';

  @override
  String get aadhaarSideFront => 'आगे की तरफ़';

  @override
  String get aadhaarSideFrontHint => 'नाम, लिंग, जन्म तिथि और आधार नंबर';

  @override
  String get aadhaarSideBack => 'पीछे की तरफ़';

  @override
  String get aadhaarSideBackHint => 'पता';

  @override
  String get aadhaarRetakeSide => 'दोबारा लें';

  @override
  String get aadhaarAddBack =>
      'पता पाने के लिए पीछे की तरफ़ की फ़ोटो भी जोड़ें।';

  @override
  String get aadhaarRead => 'कार्ड पढ़ें';

  @override
  String get aadhaarReading => 'कार्ड पढ़ा जा रहा है…';

  @override
  String get aadhaarFound => 'क्या मिला';

  @override
  String get aadhaarNotFound => 'नहीं मिला';

  @override
  String get aadhaarUse => 'फ़ॉर्म भरें';

  @override
  String get aadhaarRetakeBoth => 'फ़ोटो दोबारा लें';

  @override
  String get aadhaarBackNoAddress =>
      'पीछे की फ़ोटो में पता नहीं मिला। आप खुद लिख सकते हैं।';

  @override
  String get aadhaarMismatchTitle => 'दोनों फ़ोटो में अलग-अलग नंबर हैं';

  @override
  String aadhaarMismatchBody(String front, String back) {
    return 'आगे की फ़ोटो में $front है पर पीछे की फ़ोटो में $back। हो सकता है ये दो अलग कार्ड हों, इसलिए पीछे का पता नहीं लिया गया। उसी कार्ड के पीछे की फ़ोटो दोबारा लें।';
  }

  @override
  String get aadhaarMismatchAddress =>
      'नहीं लिया गया: पीछे की फ़ोटो में अलग आधार नंबर है।';

  @override
  String get registrationListAll => 'सभी पंजीकृत लोग';

  @override
  String get drawerSectionProfiles => 'प्रोफ़ाइल';

  @override
  String get profileStudents => 'विद्यार्थी प्रोफ़ाइल';

  @override
  String get profileTeachers => 'शिक्षक प्रोफ़ाइल';

  @override
  String get profileClassTeachers => 'कक्षा-शिक्षक';

  @override
  String get profileNoOne => 'इन फ़िल्टर से कोई नहीं मिला।';

  @override
  String get profileOverview => 'सारांश';

  @override
  String get profileAttendance => 'उपस्थिति';

  @override
  String get profileFees => 'फ़ीस';

  @override
  String get profileResults => 'परिणाम';

  @override
  String get profilePapers => 'बनाए गए पेपर';

  @override
  String get profileDetails => 'विवरण';

  @override
  String profileJoinedOn(String date) {
    return 'जुड़े: $date';
  }

  @override
  String get profileClassLabel => 'कक्षा और रोल नंबर';

  @override
  String profileClassTeacherOfClass(String cls) {
    return '$cls के कक्षा-शिक्षक';
  }

  @override
  String get profileDates => 'तारीख़ें';

  @override
  String profileAttended(int percent) {
    return 'उपस्थित $percent%';
  }

  @override
  String profileDaysRecorded(int count) {
    return '$count दिन दर्ज';
  }

  @override
  String profileDaysPresent(int count) {
    return '$count दिन उपस्थित';
  }

  @override
  String get profileNoAttendance => 'इन फ़िल्टर के लिए कोई उपस्थिति दर्ज नहीं।';

  @override
  String get profileNoResults => 'अभी कोई परीक्षा अंक दर्ज नहीं।';

  @override
  String get profileNoFees => 'कोई फ़ीस दर्ज नहीं।';

  @override
  String get profileNoPapers => 'अभी कोई पेपर नहीं बनाया।';

  @override
  String get profileNoPayments => 'अभी कोई भुगतान नहीं।';

  @override
  String profileMarksOf(int obtained, int total) {
    return '$obtained / $total';
  }

  @override
  String profileTotalPaid(String amount) {
    return 'कुल भुगतान: $amount';
  }

  @override
  String get profilePaymentHistory => 'पूरा भुगतान इतिहास';

  @override
  String get profileNotFound => 'यह व्यक्ति नहीं मिला।';

  @override
  String get profileStillIn => 'अभी चेक-इन है';

  @override
  String get dobErrFuture => 'जन्म तिथि भविष्य की नहीं हो सकती।';

  @override
  String dobErrYoung(int years) {
    return 'उम्र बहुत कम है: कम से कम $years वर्ष होनी चाहिए।';
  }

  @override
  String dobErrOld(int years) {
    return 'उम्र बहुत ज़्यादा है: अधिकतम $years वर्ष होनी चाहिए।';
  }

  @override
  String get calendarTitle => 'विद्यालय कैलेंडर';

  @override
  String get calendarToday => 'आज';

  @override
  String get calendarOpen => 'विद्यालय खुला था';

  @override
  String get calendarClosed => 'विद्यालय बंद';

  @override
  String get calendarNoRecord => 'कोई रिकॉर्ड नहीं';

  @override
  String get calendarWeeklyOff => 'साप्ताहिक अवकाश';

  @override
  String get calendarThisMonth => 'इस महीने';

  @override
  String calendarYear(String date) {
    return '$date से शैक्षणिक वर्ष';
  }

  @override
  String get calendarDaysOpen => 'विद्यालय खुलने के दिन';

  @override
  String get calendarDaysClosed => 'बंद के दिन';

  @override
  String get calendarDaysNoRecord => 'बिना रिकॉर्ड वाले दिन';

  @override
  String get calendarNoRecordNote =>
      'रविवार साप्ताहिक अवकाश है और गिना नहीं जाता।';

  @override
  String get calendarTapHint => 'विवरण देखने के लिए किसी दिन पर दबाएँ।';

  @override
  String get calendarTapHintPrincipal =>
      'किसी दिन पर टैप करके जानकारी देखें या बदलें। हर बदलाव का कारण बताना ज़रूरी है।';

  @override
  String get calendarMarkOpen => 'विद्यालय चला दर्ज करें';

  @override
  String get calendarMarkClosed => 'विद्यालय बंद दर्ज करें';

  @override
  String get calendarClearDay => 'यह दिन साफ़ करें';

  @override
  String get calendarReasonTitle => 'यह दिन क्यों बदल रहे हैं?';

  @override
  String get calendarReasonHint =>
      'जैसे: भारी बारिश, दिवाली की छुट्टी, परीक्षा का दिन';

  @override
  String get calendarReasonRequired => 'कृपया कारण लिखें (कम से कम 3 अक्षर)।';

  @override
  String get calendarSave => 'बदलाव सहेजें';

  @override
  String calendarReason(String reason) {
    return 'कारण: $reason';
  }

  @override
  String get calendarNoReason => 'कोई कारण दर्ज नहीं';

  @override
  String calendarMarkedBy(String name, String when) {
    return '$name ने दर्ज किया, $when';
  }

  @override
  String get calendarHistory => 'इतिहास';

  @override
  String get calendarNoHistory => 'इस दिन के लिए कोई बदलाव दर्ज नहीं।';

  @override
  String get calendarSaved => 'कैलेंडर अपडेट हो गया';

  @override
  String get calendarNotAllowed => 'कैलेंडर केवल प्रधानाचार्य बदल सकते हैं।';

  @override
  String get calendarFailed => 'बदलाव सहेजा नहीं जा सका।';

  @override
  String get holidaysTitle => 'छुट्टियाँ';

  @override
  String get holidayAdd => 'छुट्टी जोड़ें';

  @override
  String get holidayFilterUpcoming => 'आने वाली';

  @override
  String get holidayFilterPast => 'बीती हुई';

  @override
  String get holidayFilterAll => 'सभी';

  @override
  String get holidayListUpcoming => 'आने वाली छुट्टियाँ';

  @override
  String get holidayListPast => 'बीती हुई छुट्टियाँ';

  @override
  String get holidayListAll => 'सभी छुट्टियाँ';

  @override
  String holidayDays(int count) {
    return '$count दिन';
  }

  @override
  String holidaySummary(int holidays, int days) {
    return '$holidays छुट्टियाँ · $days दिन';
  }

  @override
  String get holidayOnNow => 'अभी चल रही';

  @override
  String holidayInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन में',
      one: 'कल',
    );
    return '$_temp0';
  }

  @override
  String get holidayPast => 'बीत गई';

  @override
  String get holidayEmpty => 'अभी कोई छुट्टी नहीं जोड़ी गई।';

  @override
  String get holidayEmptyPrincipal =>
      'अभी कोई छुट्टी नहीं जोड़ी गई। विद्यालय की छुट्टियों की सूची भरने के लिए \"छुट्टियाँ जोड़ें\" दबाएँ।';

  @override
  String get holidayEmptyFilter => 'इस सूची में कोई छुट्टी नहीं।';

  @override
  String holidayEntryTitle(int number) {
    return 'छुट्टी $number';
  }

  @override
  String get holidayReason => 'कारण';

  @override
  String get holidayReasonHint => 'जैसे: दिवाली की छुट्टियाँ, गणतंत्र दिवस';

  @override
  String get holidayPickDates => 'तारीख़ या तारीख़ें चुनें';

  @override
  String get holidayDatesHelp => 'एक दिन के लिए वही तारीख़ दो बार चुनें।';

  @override
  String get holidayDatesRequired => 'तारीख़ या तारीख़ें चुनें';

  @override
  String get holidayAnother => 'एक और छुट्टी जोड़ें';

  @override
  String holidaySaveAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन सहेजें',
      zero: 'छुट्टियाँ सहेजें',
    );
    return '$_temp0';
  }

  @override
  String get holidayAddIntro =>
      'छुट्टियाँ तारीख़ और कारण के साथ जोड़ें, फिर सब एक साथ सेव करें। सबको वे छुट्टियों की सूची और कैलेंडर में दिखेंगी।';

  @override
  String holidaySaved(int added) {
    return '$added छुट्टी के दिन जोड़े गए';
  }

  @override
  String holidaySavedSkipped(int added, int skipped) {
    return '$added दिन जोड़े गए। $skipped दिन छोड़ दिए गए, उन पर विद्यालय पहले से चला दर्ज है।';
  }

  @override
  String holidayInvalidDates(int max) {
    return 'तारीख़ें जाँचें: हर छुट्टी की तारीख़ें चाहिए, और कोई भी $max दिन से लंबी नहीं हो सकती।';
  }

  @override
  String get holidayRemove => 'यह छुट्टी हटाएँ';

  @override
  String get holidayRemoved => 'छुट्टी हटा दी गई';

  @override
  String get calendarHoliday => 'छुट्टी';

  @override
  String get holidaySuggestedPick => 'भारत की छुट्टियों में से चुनें';

  @override
  String get holidaySuggested => 'भारत की छुट्टियाँ';

  @override
  String get holidaySuggestedNote =>
      'त्योहारों की तारीख़ें हर साल बदलती हैं। सेव करने से पहले तारीख़ें देख लें। बाद में बदल भी सकते हैं।';

  @override
  String holidaySuggestedAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छुट्टियाँ जोड़ें',
      one: '1 छुट्टी जोड़ें',
    );
    return '$_temp0';
  }

  @override
  String get scrollForMore => 'और देखने के लिए स्क्रॉल करें';

  @override
  String get moduleAttendance => 'उपस्थिति';

  @override
  String get moduleMarkAttendance => 'विद्यार्थियों की उपस्थिति';

  @override
  String get modulePayments => 'भुगतान इतिहास';

  @override
  String get notClassTeacherMessage =>
      'आप अभी किसी कक्षा के कक्षा-शिक्षक नहीं हैं, इसलिए उपस्थिति लगाने के लिए कोई कक्षा नहीं है।';

  @override
  String get drawerSectionAcademics => 'पढ़ाई';

  @override
  String get drawerSectionPeople => 'लोग';

  @override
  String get drawerSectionMoney => 'पैसे';

  @override
  String get drawerSectionSchool => 'विद्यालय';

  @override
  String scrollForMoreCount(int count) {
    return 'और देखने के लिए स्क्रॉल करें · कुल $count';
  }

  @override
  String get sectionApprovals => 'अनुमोदन';

  @override
  String get sectionOverview => 'आज एक नज़र में';

  @override
  String get actionContinue => 'आगे बढ़ें';

  @override
  String get actionDelete => 'हटाएँ';

  @override
  String get actionEdit => 'बदलें';

  @override
  String get actionMore => 'और विकल्प';

  @override
  String get messageClassAdded => 'कक्षा जोड़ी गई';

  @override
  String get messageClassUpdated => 'कक्षा बदली गई';

  @override
  String get messageClassDeleted => 'कक्षा हटाई गई';

  @override
  String get emptyClasses =>
      'अभी कोई कक्षा नहीं है।\n\"कक्षा जोड़ें\" दबाकर बनाएँ।';

  @override
  String get emptyStudents =>
      'इस कक्षा में अभी कोई छात्र नहीं है।\nपंजीकरण मॉड्यूल से छात्र जोड़ें।';

  @override
  String get actionScanQuestions => 'फ़ोटो से स्कैन करें';

  @override
  String get scanSourceTitle => 'प्रश्न स्कैन करें';

  @override
  String get scanLanguage => 'लिखावट की भाषा';

  @override
  String get scanCamera => 'फ़ोटो खींचें';

  @override
  String get scanGallery => 'गैलरी से चुनें';

  @override
  String get scanProcessing => 'टेक्स्ट पढ़ा जा रहा है…';

  @override
  String get scanNoText =>
      'कोई टेक्स्ट नहीं मिला। साफ़ और रोशनी वाली फ़ोटो लें।';

  @override
  String get scanFailed => 'फ़ोटो पढ़ी नहीं जा सकी। कृपया फिर कोशिश करें।';

  @override
  String get scanReviewTitle => 'स्कैन किए प्रश्न जाँचें';

  @override
  String get scanReviewHint =>
      'स्कैन में गलती हो सकती है। हर प्रश्न देखें, लिखावट सुधारें और जो प्रश्न नहीं है उसका निशान हटा दें।';

  @override
  String actionAddSelected(int count) {
    return '$count प्रश्न जोड़ें';
  }

  @override
  String get setupTitle => 'अपना विद्यालय सेट करें';

  @override
  String get setupSubtitle =>
      'प्रधानाचार्य का लॉगिन बनाएँ। शिक्षकों को बाद में जोड़ सकते हैं।';

  @override
  String get fieldSchoolName => 'विद्यालय का नाम';

  @override
  String get fieldConfirmPassword => 'पासवर्ड दोबारा लिखें';

  @override
  String get actionCreateSchool => 'विद्यालय बनाएँ';

  @override
  String errorPasswordShort(int min) {
    return 'कम से कम $min अक्षर रखें';
  }

  @override
  String get errorPasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get errorInactiveAccount =>
      'यह अकाउंट निष्क्रिय है। कृपया प्रधानाचार्य से संपर्क करें।';

  @override
  String get errorWrongCurrentPassword => 'मौजूदा पासवर्ड गलत है';

  @override
  String get errorEmailTaken => 'यह ईमेल पहले से उपयोग में है';

  @override
  String get fieldLoginEmail => 'लॉगिन ईमेल';

  @override
  String get fieldTempPassword => 'अस्थायी पासवर्ड';

  @override
  String get helperTempPassword =>
      'यह शिक्षक को दें। साइन इन के बाद वे इसे बदल सकते हैं।';

  @override
  String get fieldCurrentPassword => 'मौजूदा पासवर्ड';

  @override
  String get fieldNewPassword => 'नया पासवर्ड';

  @override
  String get actionEditProfile => 'प्रोफ़ाइल बदलें';

  @override
  String get actionChangePassword => 'पासवर्ड बदलें';

  @override
  String get actionChangeEmail => 'ईमेल बदलें';

  @override
  String get actionSend => 'भेजें';

  @override
  String get changeEmailHint =>
      'नए ईमेल पर एक सत्यापन लिंक भेजा जाएगा। उसे खोलने के बाद आपका ईमेल बदल जाएगा।';

  @override
  String get fieldNewEmail => 'नया ईमेल';

  @override
  String get messageEmailChangeSent =>
      'सत्यापन लिंक भेज दिया गया है। ईमेल बदलने के लिए उसे खोलें।';

  @override
  String get messageProfileUpdated => 'प्रोफ़ाइल अपडेट हुई';

  @override
  String get messagePasswordChanged => 'पासवर्ड बदल गया';

  @override
  String get checkErrSchoolClosed =>
      'प्रधानाचार्य ने आज को अभी विद्यालय का दिन नहीं माना है।';

  @override
  String get checkErrNotConfigured =>
      'विद्यालय की लोकेशन सेट नहीं है। प्रधानाचार्य से प्रोफ़ाइल → विद्यालय सेटिंग्स में सेट करवाएँ।';

  @override
  String get checkErrServicesOff => 'लोकेशन (GPS) चालू करके फिर कोशिश करें।';

  @override
  String get checkErrPermissionDenied =>
      'चेक-इन के लिए लोकेशन की अनुमति चाहिए।';

  @override
  String get checkErrPermissionForever =>
      'लोकेशन की अनुमति बंद है। फ़ोन सेटिंग्स में अनुमति दें।';

  @override
  String get checkErrUnavailable =>
      'आपकी लोकेशन नहीं मिली। खुले में फिर कोशिश करें।';

  @override
  String get checkErrMockLocation =>
      'नकली लोकेशन वाला ऐप चालू है। उसे बंद करके दोबारा कोशिश करें।';

  @override
  String checkErrOutside(int meters) {
    return 'आप विद्यालय से $meters मीटर दूर हैं। चेक-इन के लिए पास आएँ।';
  }

  @override
  String get checkErrSelfie => 'चेक-इन के लिए सेल्फ़ी ज़रूरी है।';

  @override
  String get checkInHint =>
      'हम आपकी लोकेशन जाँचते हैं और सबूत के लिए सेल्फ़ी लेते हैं।';

  @override
  String distanceFromSchool(int meters) {
    return 'विद्यालय से $meters मीटर';
  }

  @override
  String teacherReportWindow(int days) {
    return 'पिछले $days दिन (सिर्फ़ विद्यालय के दिन)';
  }

  @override
  String get emptyTrend => 'पिछले 7 दिनों में छात्र उपस्थिति नहीं भरी गई।';

  @override
  String get emptyMarks => 'इस कक्षा के लिए अभी परीक्षा के अंक दर्ज नहीं हैं।';

  @override
  String get noCheckInsYet => 'इस अवधि में कोई चेक-इन नहीं';

  @override
  String get schoolSettingsTitle => 'विद्यालय सेटिंग्स';

  @override
  String get sectionSchoolLocation => 'विद्यालय की लोकेशन';

  @override
  String get locationNotSet => 'अभी सेट नहीं है';

  @override
  String locationValue(String lat, String lon) {
    return 'अक्षांश $lat, देशांतर $lon';
  }

  @override
  String get locationHelp =>
      'विद्यालय के गेट पर या परिसर के बीच खड़े होकर बटन दबाएँ।';

  @override
  String get actionUseCurrentLocation => 'मेरी मौजूदा लोकेशन इस्तेमाल करें';

  @override
  String get fieldRadius => 'अनुमत दूरी';

  @override
  String get helperRadius => 'चेक-इन के लिए शिक्षक को कितना पास होना चाहिए।';

  @override
  String get unitMeters => 'मीटर';

  @override
  String get errorRadiusInvalid => 'दूरी मीटर में दर्ज करें';

  @override
  String get errorLocationRequired => 'पहले विद्यालय की लोकेशन सेट करें';

  @override
  String get messageSettingsSaved => 'सेटिंग्स सहेजी गईं';

  @override
  String get backupTitle => 'बैकअप व रीस्टोर';

  @override
  String get backupNever => 'अभी तक कोई बैकअप नहीं लिया';

  @override
  String backupLast(String when) {
    return 'आखिरी बैकअप: $when';
  }

  @override
  String get actionBackupShare => 'बैकअप बनाएँ और भेजें';

  @override
  String get actionBackupSave => 'बैकअप इस फ़ोन में सहेजें';

  @override
  String get sectionRestore => 'रीस्टोर';

  @override
  String get actionRestoreFromFile => 'बैकअप फ़ाइल से रीस्टोर करें';

  @override
  String get actionRestore => 'रीस्टोर करें';

  @override
  String get messageBackupDone => 'बैकअप बन गया';

  @override
  String get messageBackupFailed => 'बैकअप नहीं बन सका';

  @override
  String get messageRestoreDone => 'रीस्टोर हो गया। कृपया फिर साइन इन करें।';

  @override
  String get messageRestoreFailed => 'रीस्टोर नहीं हो सका। कुछ नहीं बदला।';

  @override
  String get errBackupNotBackup => 'यह फ़ाइल शिक्षा सेतु का बैकअप नहीं है।';

  @override
  String get errBackupNewer =>
      'यह बैकअप ऐप के नए वर्ज़न से बना है। कृपया ऐप अपडेट करें।';

  @override
  String get errBackupCorrupt => 'यह बैकअप फ़ाइल खराब है।';

  @override
  String get dialogRestoreTitle => 'सारा डेटा बदलें?';

  @override
  String dialogRestoreBody(String date, int students, int users) {
    return '$date का बैकअप: $students विद्यार्थी, $users खाते। ऐप का सारा डेटा बदल जाएगा और आप साइन आउट हो जाएँगे।';
  }

  @override
  String get actionEnterMarks => 'अंक दर्ज करें';

  @override
  String get actionMarkConducted => 'आयोजित चिह्नित करें';

  @override
  String marksEntryTitle(String title) {
    return 'अंक — $title';
  }

  @override
  String outOfMarks(int total) {
    return '/ $total';
  }

  @override
  String get errorMarksTooHigh => 'कुल अंकों से अधिक';

  @override
  String get messageMarksSaved => 'अंक सहेजे गए';

  @override
  String get actionAddFee => 'शुल्क जोड़ें';

  @override
  String get sectionPayments => 'भुगतान';

  @override
  String get emptyPayments => 'अभी कोई भुगतान नहीं।';

  @override
  String get actionShareReceipt => 'रसीद भेजें';

  @override
  String get emptyFeePeople =>
      'यहाँ सबकी फ़ीस पहले से जुड़ी है, या अभी कोई रजिस्टर नहीं है।';

  @override
  String get fieldPerson => 'व्यक्ति';

  @override
  String get fieldDueDate => 'देय तिथि';

  @override
  String get messageFeeAdded => 'शुल्क जोड़ा गया';

  @override
  String dashSchoolAndDate(String school, String date) {
    return '$school · $date';
  }

  @override
  String get sectionNeedsAttention => 'आपके ध्यान के लिए';

  @override
  String get allClearTitle => 'सब ठीक है';

  @override
  String get allClearBody => 'अभी आपके ध्यान के लिए कुछ नहीं है।';

  @override
  String attTeachersNotIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count शिक्षकों ने चेक-इन नहीं किया',
    );
    return '$_temp0';
  }

  @override
  String attClassesNotMarked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कक्षाओं की उपस्थिति अभी नहीं भरी',
    );
    return '$_temp0';
  }

  @override
  String attOverdueFees(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खातों का शुल्क अतिदेय · $amount',
    );
    return '$_temp0';
  }

  @override
  String get attLocationMissing =>
      'विद्यालय की लोकेशन सेट नहीं है, इसलिए शिक्षक चेक-इन नहीं कर सकते।';

  @override
  String get attNoBackup =>
      'अभी तक बैकअप नहीं। आपका डेटा सिर्फ़ इस फ़ोन में है।';

  @override
  String get actionReview => 'देखें';

  @override
  String get actionViewAll => 'सभी देखें';

  @override
  String get kpiTeachersIn => 'आए शिक्षक';

  @override
  String get kpiStudentsPresent => 'उपस्थित छात्र';

  @override
  String get kpiFeesCollected => 'प्राप्त शुल्क';

  @override
  String get kpiClassesMarked => 'उपस्थिति भरी कक्षाएँ';

  @override
  String get sectionClassAttendance => 'आज की कक्षावार उपस्थिति';

  @override
  String feesOverdueAmount(String amount) {
    return 'अतिदेय $amount';
  }

  @override
  String get sectionUpcomingExams => 'आगामी परीक्षाएँ';

  @override
  String get emptyUpcomingExams => 'कोई परीक्षा निर्धारित नहीं है।';

  @override
  String get sectionLatestNotice => 'नवीनतम सूचना';

  @override
  String get emptyLatestNotice => 'अभी कोई सूचना नहीं।';

  @override
  String get approvalsTitle => 'स्वीकृतियाँ';

  @override
  String get approvalsNeedsApproval => 'स्वीकृति चाहिए';

  @override
  String get approvalsNonePending => 'कोई स्वीकृति बाकी नहीं';

  @override
  String get actionView => 'देखें';

  @override
  String get actionReject => 'अस्वीकार करें';

  @override
  String get sectionPendingApprovals => 'बाकी';

  @override
  String get sectionDecidedApprovals => 'निर्णय हो चुके';

  @override
  String get emptyApprovals => 'अभी स्वीकृति के लिए कुछ नहीं है।';

  @override
  String get statusApproved => 'स्वीकृत';

  @override
  String get statusRejected => 'अस्वीकृत';

  @override
  String get themeTitle => 'थीम रंग';

  @override
  String get themeHelp =>
      'ऐप के लिए दो रंग चुनें: मुख्य रंग और दूसरा रंग। सबको यही दिखेंगे।';

  @override
  String get themeCurrent => 'मौजूदा रंग';

  @override
  String get themeDefault => 'काला-सफ़ेद';

  @override
  String get themeBlue => 'नीला';

  @override
  String get themeIndigo => 'गहरा नीला';

  @override
  String get themePurple => 'बैंगनी';

  @override
  String get themeTeal => 'हरा-नीला';

  @override
  String get themeGreen => 'हरा';

  @override
  String get themeOrange => 'नारंगी';

  @override
  String get themeRed => 'लाल';

  @override
  String get themeBrown => 'भूरा';

  @override
  String get themePreview => 'पूर्वावलोकन';

  @override
  String get themeMainTitle => 'मुख्य रंग';

  @override
  String get themeAccentTitle => 'दूसरा (एक्सेंट) रंग';

  @override
  String get themeAccentAuto => 'मुख्य जैसा';

  @override
  String get themeCustom => 'अपना रंग';

  @override
  String get themePickerTitle => 'कोई भी रंग चुनें';

  @override
  String get themeHue => 'रंगत';

  @override
  String get themeSaturation => 'गहराई';

  @override
  String get themeBrightness => 'चमक';

  @override
  String get themeApply => 'यह रंग लगाएँ';

  @override
  String get addressLoading => 'पता खोजा जा रहा है…';

  @override
  String get addressUnavailable => 'पता उपलब्ध नहीं (इंटरनेट चाहिए)';

  @override
  String get welcomeTitle => 'स्वागत है';

  @override
  String get welcomeSubtitle => 'आप कौन हैं?';

  @override
  String get welcomePrincipal => 'मैं प्रधानाचार्य हूँ';

  @override
  String get welcomePrincipalHint => 'इस फ़ोन पर नया विद्यालय बनाएँ';

  @override
  String get welcomeAlreadyRegistered =>
      'विद्यालय पहले से पंजीकृत है? साइन इन करें';

  @override
  String get registeredSignInTitle => 'अपने विद्यालय में साइन इन करें';

  @override
  String get registeredSignInSubtitle =>
      'प्रधानाचार्य: विद्यालय पंजीकृत करते समय का ईमेल और पासवर्ड। शिक्षक: प्रधानाचार्य द्वारा दिया गया ईमेल और पासवर्ड। आपके विद्यालय का डेटा लोड किया जाएगा।';

  @override
  String get registeredSignInBusy =>
      'आपके विद्यालय का डेटा वापस लाया जा रहा है। इसमें एक मिनट लग सकता है…';

  @override
  String get errorSchoolNotFound =>
      'यह खाता किसी विद्यालय से जुड़ा नहीं है। कृपया अपने एडमिन से संपर्क करें।';

  @override
  String get actionBack => 'वापस';

  @override
  String get errorPasswordWeak =>
      'यह पासवर्ड बहुत आम या सरल है। कम से कम 8 अक्षर रखें, अक्षर और अंक दोनों के साथ।';

  @override
  String get errorTooManyAttempts =>
      'बहुत ज़्यादा कोशिशें हो गईं। कृपया बाद में दोबारा प्रयास करें।';

  @override
  String get errorAuthOffline =>
      'इंटरनेट कनेक्शन नहीं है। कृपया इंटरनेट चालू करके दोबारा प्रयास करें।';

  @override
  String get errorProfileMissing =>
      'आपका खाता इस फ़ोन पर लोड नहीं हो सका। इंटरनेट चालू करके दोबारा प्रयास करें।';

  @override
  String get errorAuthUnavailable =>
      'यह अभी उपलब्ध नहीं है। कृपया दोबारा प्रयास करें।';

  @override
  String get cloudSignedOutBanner =>
      'ऑनलाइन बैकअप के लिए प्रधानाचार्य का लॉगिन चाहिए। शुरू करने के लिए इंटरनेट के साथ साइन आउट करके दोबारा साइन इन करें।';

  @override
  String get syncNotifChannel => 'डेटा सिंक';

  @override
  String get syncNotifTitle => 'डेटा सर्वर पर सिंक हो रहा है';

  @override
  String syncNotifProgress(int done, int total) {
    return '$total में से $done पूरे';
  }

  @override
  String get cloudAutoSyncTitle => 'अपने-आप सिंक';

  @override
  String get cloudAutoSyncHelp =>
      'ऐप खुला रहने पर हर कुछ मिनट में बदलावों का बैकअप लेता है, और ऐप छोड़ते समय एक बार और। इंटरनेट चाहिए।';

  @override
  String get cloudAutoSyncOff => 'बंद';

  @override
  String cloudAutoSyncHours(int hours) {
    return '$hours घंटे';
  }

  @override
  String cloudSyncProgress(int done, int total) {
    return '$total में से $done';
  }

  @override
  String cloudAutoSyncMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get syncNotifDone => 'डेटा सर्वर पर सेव हो गया';

  @override
  String syncNotifDoneAt(String time) {
    return 'आखिरी सिंक: $time';
  }

  @override
  String get syncFeatureSettings => 'सेटिंग्स';

  @override
  String get syncFeatureStaff => 'स्टाफ़';

  @override
  String get syncFeatureClasses => 'कक्षाएँ';

  @override
  String get syncFeatureStudents => 'छात्र';

  @override
  String get syncFeatureCalendar => 'स्कूल कैलेंडर';

  @override
  String get syncFeatureAttendance => 'उपस्थिति';

  @override
  String get syncFeatureExams => 'परीक्षाएँ';

  @override
  String get syncFeatureFees => 'फ़ीस';

  @override
  String get syncFeatureNotices => 'सूचनाएँ';

  @override
  String get syncFeatureQuestionBank => 'प्रश्न बैंक';

  @override
  String syncNotifChecking(String feature, int done, int total) {
    return '$feature जाँच रहे हैं · $total में से $done';
  }

  @override
  String get syncNotifUpToDate => 'सब कुछ पहले से अपडेट था';

  @override
  String syncNotifNext(String when) {
    return 'अगला सिंक $when में';
  }

  @override
  String syncFeaturesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ीचर',
      one: '1 फ़ीचर',
    );
    return '$_temp0';
  }

  @override
  String get syncNotifTapHint => 'विवरण के लिए टैप करें';

  @override
  String get syncDetailsTitle => 'सिंक विवरण';

  @override
  String get syncDetailsLastSync => 'आखिरी सिंक';

  @override
  String get syncDetailsLastData => 'आखिरी बार भेजा गया डेटा';

  @override
  String get syncDetailsNothingSent => 'अभी तक कोई डेटा नहीं भेजा गया।';

  @override
  String syncDetailsAtTime(String date, String time) {
    return '$date, $time';
  }

  @override
  String syncDetailsRemoved(int count) {
    return '$count हटाए गए';
  }

  @override
  String syncStripLast(String when) {
    return 'आखिरी सिंक $when';
  }

  @override
  String syncStripNext(String when) {
    return 'अगला सिंक $when';
  }

  @override
  String get syncStripOff => 'अपने-आप सिंक बंद है';

  @override
  String get syncStripSyncing => 'डेटा सर्वर पर सिंक हो रहा है…';

  @override
  String get approvalNotifChannel => 'मंज़ूरी के अनुरोध';

  @override
  String get approvalNotifOneTitle => 'मंज़ूरी के लिए नया अनुरोध';

  @override
  String approvalNotifOneBody(String teacher, String title) {
    return '$teacher ने \"$title\" मंज़ूरी के लिए भेजा';
  }

  @override
  String approvalNotifManyTitle(int count) {
    return 'मंज़ूरी के $count नए अनुरोध';
  }

  @override
  String get approvalNotifManyBody => 'देखने के लिए ऐप खोलें';

  @override
  String dashTodoWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अनुरोध आपका इंतज़ार कर रहे हैं',
      one: '1 अनुरोध आपका इंतज़ार कर रहा है',
    );
    return '$_temp0';
  }

  @override
  String get dashTodoWaitingHint => 'शिक्षक आपके जवाब का इंतज़ार कर रहे हैं।';

  @override
  String get dashTodoReview => 'अभी देखें';

  @override
  String get dashTodoNone => 'कोई अनुरोध बाकी नहीं है';

  @override
  String get dashTodoNoneHint => 'शिक्षकों के नए अनुरोध यहाँ दिखेंगे।';

  @override
  String get dashTodayTitle => 'आज विद्यालय में';

  @override
  String get dashTeachersHere => 'शिक्षक आए';

  @override
  String get dashStudentsHere => 'विद्यार्थी आए';

  @override
  String get dashClassesDone => 'कक्षाएँ पूरी';

  @override
  String get dashFeesLeft => 'बाकी फ़ीस';

  @override
  String get dashQuickTitle => 'जल्दी खोलें';

  @override
  String get dashMore => 'और';

  @override
  String get dashTeacherWaitTitle => 'प्रधानाचार्य का इंतज़ार है';

  @override
  String get dashTeacherWaitBody =>
      'प्रधानाचार्य ने आज के लिए विद्यालय अभी खुला नहीं किया है। यह पेज अपने आप बदल जाएगा।';

  @override
  String get dashTeacherClosedTitle => 'आज विद्यालय बंद है';

  @override
  String get dashTeacherClosedBody => 'आज चेक-इन की ज़रूरत नहीं है।';

  @override
  String get dashTeacherOpenTitle => 'आज विद्यालय खुला है';

  @override
  String get dashTeacherOpenBody => 'विद्यालय पहुँचकर चेक-इन दबाएँ।';

  @override
  String get dashTeacherInTitle => 'आप चेक-इन हैं';

  @override
  String dashTeacherInBody(String time) {
    return '$time पर चेक-इन किया। जाते समय चेक-आउट दबाएँ।';
  }

  @override
  String get dashTeacherOutTitle => 'आज का काम पूरा';

  @override
  String get dashPapersTitle => 'मेरे प्रश्न पत्र';

  @override
  String get dashPapersNone => 'आपने अभी कोई प्रश्न पत्र नहीं बनाया।';

  @override
  String dashPapersWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रधानाचार्य के जवाब का इंतज़ार',
      one: '1 प्रधानाचार्य के जवाब का इंतज़ार',
    );
    return '$_temp0';
  }

  @override
  String dashPapersSentBack(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वापस आए, बदलाव करें',
      one: '1 वापस आया, बदलाव करें',
    );
    return '$_temp0';
  }

  @override
  String dashPapersDrafts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ड्राफ़्ट भेजे नहीं गए',
      one: '1 ड्राफ़्ट भेजा नहीं गया',
    );
    return '$_temp0';
  }

  @override
  String dashPapersApproved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मंज़ूर',
      one: '1 मंज़ूर',
    );
    return '$_temp0';
  }

  @override
  String get dashRefreshed => 'अपडेट हो गया';

  @override
  String approvalsWaitingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अनुरोध बाकी',
      one: '1 अनुरोध बाकी',
    );
    return '$_temp0';
  }

  @override
  String get approvalsPullHint => 'नए अनुरोध देखने के लिए नीचे खींचें';

  @override
  String get approvalsDecidedApproved => 'मंज़ूर';

  @override
  String get approvalsDecidedRejected => 'मंज़ूर नहीं';

  @override
  String get descAttendance => 'आज कौन आया, देखें: शिक्षक और विद्यार्थी';

  @override
  String get descMarkAttendance =>
      'अपनी कक्षा के विद्यार्थियों को उपस्थित, अनुपस्थित या देर से आया लगाएँ';

  @override
  String get descExams => 'प्रश्न पत्र बनाएँ और मंज़ूरी के लिए भेजें';

  @override
  String get descQuestionBank =>
      'आपके सेव किए प्रश्न, किसी भी पेपर में दोबारा इस्तेमाल करें';

  @override
  String get descStudentProfiles =>
      'हर विद्यार्थी की जानकारी, उपस्थिति, फ़ीस और अंक';

  @override
  String get descTeacherProfiles =>
      'हर शिक्षक की जानकारी, चेक-इन और प्रश्न पत्र';

  @override
  String get descClasses => 'कक्षाएँ जोड़ें और उनके विद्यार्थी देखें';

  @override
  String get descRegister => 'नया विद्यार्थी, शिक्षक या स्टाफ़ जोड़ें';

  @override
  String get descTeachers => 'कक्षा-शिक्षक, विषय, चालू या बंद';

  @override
  String get descFees => 'बाकी फ़ीस देखें और भुगतान लें';

  @override
  String get descPayments => 'अब तक मिले सभी भुगतान';

  @override
  String get descApprovals => 'आपके जवाब का इंतज़ार करते अनुरोध';

  @override
  String get descAnalytics => 'विद्यालय के चार्ट और रिपोर्ट';

  @override
  String get descCalendar => 'देखें कि कौन से दिन विद्यालय खुला या बंद रहा';

  @override
  String get descHolidays => 'विद्यालय की छुट्टियों की सूची';

  @override
  String get descNotices => 'विद्यालय में सबके लिए संदेश';

  @override
  String get drawerMoreTitle => 'और विकल्प';

  @override
  String get moduleMyAttendance => 'मेरी उपस्थिति';

  @override
  String get descMyAttendance => 'आपका अपना चेक-इन और चेक-आउट';

  @override
  String get myAttendanceTitle => 'मेरी उपस्थिति (चेक-इन)';

  @override
  String markingTitle(String name) {
    return 'विद्यार्थियों की उपस्थिति · कक्षा $name';
  }

  @override
  String get categoryTeachingSubject => 'विषय';

  @override
  String approvalSubjectQuestion(String name) {
    return '$name इस कक्षा में यह विषय पढ़ाना चाहते हैं।';
  }

  @override
  String get moduleMySubjects => 'मेरे विषय';

  @override
  String get descMySubjects =>
      'आप जो विषय और कक्षाएँ पढ़ाते हैं। नया विषय माँगें।';

  @override
  String subjectsTitleFor(String name) {
    return '$name के विषय';
  }

  @override
  String get subjectAskButton => 'विषय माँगें';

  @override
  String get subjectGiveButton => 'विषय दें';

  @override
  String get subjectSheetAskTitle => 'प्रधानाचार्य से विषय माँगें';

  @override
  String subjectSheetGiveTitle(String name) {
    return '$name को विषय दें';
  }

  @override
  String get subjectSheetHint => 'पहले कक्षा चुनें, फिर विषय।';

  @override
  String get subjectSend => 'अनुरोध भेजें';

  @override
  String get subjectGive => 'विषय दें';

  @override
  String get subjectStatusApproved => 'अनुमति है';

  @override
  String get subjectStatusPending => 'प्रधानाचार्य का इंतज़ार';

  @override
  String get subjectStatusRejected => 'मंज़ूर नहीं';

  @override
  String get subjectRequestSent => 'अनुरोध प्रधानाचार्य को भेज दिया';

  @override
  String get subjectGiven => 'विषय दे दिया';

  @override
  String get subjectEmptyTeacher =>
      'आपके पास अभी कोई विषय नहीं है। प्रधानाचार्य से माँगने के लिए नीचे का बटन दबाएँ।';

  @override
  String get subjectEmptyPrincipal =>
      'अभी कोई विषय नहीं दिया गया। देने के लिए नीचे का बटन दबाएँ।';

  @override
  String subjectRegistered(String subject) {
    return 'पंजीकृत विषय: $subject (सभी कक्षाएँ)';
  }

  @override
  String get subjectRemoveTitle => 'यह विषय हटाएँ?';

  @override
  String subjectRemoveBody(String subject, String cls) {
    return '$subject · $cls हटा दिया जाएगा।';
  }

  @override
  String get subjectNoneForPaper =>
      'आपके पास अभी कोई विषय नहीं है। पेपर बनाने से पहले प्रधानाचार्य से विषय माँगें।';

  @override
  String get subjectChooseClassFirst => 'पहले कक्षा चुनें';

  @override
  String get subjectNoneInClass => 'इस कक्षा में कोई विषय अनुमत नहीं';

  @override
  String get staffActionSubjects => 'विषय और कक्षाएँ';

  @override
  String get staffActionSubjectsHint => 'यह शिक्षक क्या और कहाँ पढ़ाते हैं';

  @override
  String get paperDetailsTitle => 'पेपर की जानकारी';

  @override
  String get paperMoreOptions => 'और विकल्प';

  @override
  String get paperMoreOptionsHint => 'विद्यार्थियों के लिए निर्देश (वैकल्पिक)';

  @override
  String get paperQuickAdd => 'या कई प्रश्न एक साथ जोड़ें';

  @override
  String paperQuestionsCount(int count, int marks) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रश्न',
      one: '1 प्रश्न',
    );
    return '$_temp0 · $marks अंक';
  }

  @override
  String get paperTools => 'औज़ार';

  @override
  String get tabWaiting => 'इंतज़ार में';

  @override
  String get tabReady => 'तैयार';

  @override
  String get tabDrafts => 'ड्राफ़्ट';

  @override
  String get tabDone => 'हो चुके';

  @override
  String get dialogSignOutTitle => 'साइन आउट करें?';

  @override
  String get dialogSignOutBody => 'दोबारा साइन इन करना होगा।';

  @override
  String get actionRefresh => 'रीफ़्रेश';

  @override
  String get noticeAnnounceTitle => 'सबके डैशबोर्ड पर चलाएँ';

  @override
  String get noticeAnnounceHint => 'जब तक आप रोकें नहीं, यह ऊपर चलता रहेगा।';

  @override
  String get announceStop => 'घोषणा रोकें';

  @override
  String get dashSchoolToday => 'आज विद्यालय';

  @override
  String get dashStateOpen => 'खुला';

  @override
  String get dashStateClosed => 'बंद';

  @override
  String get dashStateWaiting => 'इंतज़ार';

  @override
  String get dashTeachersAbsent => 'अनुपस्थित शिक्षक';

  @override
  String get dashStudentsAbsent => 'अनुपस्थित विद्यार्थी';

  @override
  String get dashFeesCollected => 'वसूल हुई फ़ीस';

  @override
  String get dashOverdueFees => 'लेट फ़ीस खाते';

  @override
  String get dashUpcomingExams => 'आने वाली परीक्षाएँ';

  @override
  String get dashRequestsTitle => 'शिक्षकों के अनुरोध';

  @override
  String get dashRequestsNone => 'आपके जवाब के लिए कोई अनुरोध बाकी नहीं।';

  @override
  String dashRequestsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अनुरोधों को आपके जवाब का इंतज़ार है।',
      one: '1 अनुरोध को आपके जवाब का इंतज़ार है।',
    );
    return '$_temp0 Approvals खोलने के लिए दबाएँ।';
  }

  @override
  String get dashRequestsClear => 'कोई बाकी नहीं';

  @override
  String dashRequestsCount(int count) {
    return '$count बाकी';
  }

  @override
  String greetingNight(String name) {
    return 'शुभ रात्रि, $name';
  }

  @override
  String get actionSync => 'सिंक';

  @override
  String get actionSyncHint =>
      'आपका डेटा क्लाउड में सेव करता है और नए अनुरोध देखता है';

  @override
  String get dashSyncing => 'सिंक हो रहा है: डेटा सेव और नए अनुरोधों की जाँच…';

  @override
  String get syncStripDetails => 'ब्यौरा';

  @override
  String get syncTable_app_settings => 'स्कूल की सेटिंग';

  @override
  String get syncTable_users => 'शिक्षक और प्रिंसिपल की प्रोफ़ाइल';

  @override
  String get syncTable_other_staff => 'अन्य स्टाफ़';

  @override
  String get syncTable_teacher_subjects => 'शिक्षकों के विषय';

  @override
  String get syncTable_classes => 'कक्षाएँ';

  @override
  String get syncTable_students => 'छात्र';

  @override
  String get syncTable_school_days => 'स्कूल के दिन';

  @override
  String get syncTable_school_day_changes => 'स्कूल दिन के बदलाव';

  @override
  String get syncTable_teacher_attendance => 'शिक्षक उपस्थिति';

  @override
  String get syncTable_student_attendance => 'छात्र उपस्थिति';

  @override
  String get syncTable_exam_papers => 'प्रश्न-पत्र';

  @override
  String get syncTable_exam_questions => 'प्रश्न-पत्र के प्रश्न';

  @override
  String get syncTable_exam_marks => 'परीक्षा के अंक';

  @override
  String get syncTable_fee_accounts => 'फ़ीस खाते';

  @override
  String get syncTable_fee_payments => 'फ़ीस भुगतान';

  @override
  String get syncTable_notices => 'सूचनाएँ';

  @override
  String get syncTable_master_questions => 'प्रश्न बैंक';

  @override
  String syncStripSent(int count) {
    return 'भेजे गए $count';
  }

  @override
  String syncStripReceived(int count) {
    return 'मिले $count';
  }

  @override
  String get syncStripNothingYet => 'अभी तक कुछ भेजा या मिला नहीं';

  @override
  String syncStripLastData(String when) {
    return 'आखिरी डेटा $when';
  }

  @override
  String get syncDetailsStatus => 'स्थिति';

  @override
  String get syncDetailsNextSync => 'अगला सिंक';

  @override
  String syncDetailsChecksEvery(int seconds) {
    return 'हर $seconds सेकंड में नया डेटा देखता है';
  }

  @override
  String get syncDetailsSyncingNow => 'अभी सिंक हो रहा है…';

  @override
  String get syncDetailsCloudUpload => 'क्लाउड में सेव';

  @override
  String get syncDetailsLastCheck => 'नया डेटा देखने की आखिरी बार';

  @override
  String get syncDetailsSentTitle => 'इस फ़ोन से भेजा गया';

  @override
  String get syncDetailsReceivedTitle => 'इस फ़ोन पर मिला';

  @override
  String get syncDetailsNothingReceived => 'अभी तक कुछ नया नहीं मिला।';

  @override
  String syncDetailsRecordsSent(int count) {
    return '$count रिकॉर्ड';
  }

  @override
  String syncDetailsRecordsRemoved(int count) {
    return '$count रिकॉर्ड हटाए गए';
  }

  @override
  String get syncDetailsOffline => 'आखिरी बार सर्वर से जुड़ नहीं पाया।';

  @override
  String get syncDetailsNeverChecked => 'अभी जाँच नहीं हुई';

  @override
  String get staffTapForMore => 'और करने के लिए टैप करें: कक्षा, विषय आदि';

  @override
  String get registerWho => 'आप किसे रजिस्टर कर रहे हैं?';

  @override
  String aadhaarMissingReason(String reason) {
    return 'आधार नहीं: $reason';
  }

  @override
  String get syncKindAdded => 'नया';

  @override
  String get syncKindChanged => 'बदला';

  @override
  String get syncKindRemoved => 'हटाया';

  @override
  String get syncDetailsEarlierUnknown => 'पहले की वैल्यू सेव नहीं थी';

  @override
  String syncDetailsMoreNotListed(int count) {
    return '$count और रिकॉर्ड सूची में नहीं';
  }

  @override
  String get syncValueEmpty => '(खाली)';

  @override
  String get syncDetailsWas => 'पहले';

  @override
  String get syncDetailsNow => 'अब';

  @override
  String get dashTeachersTitle => 'शिक्षक';

  @override
  String get dashStudentsTitle => 'छात्र';

  @override
  String dashTotalCount(int count) {
    return 'कुल $count';
  }

  @override
  String get attReportTitle => 'उपस्थिति रिपोर्ट';

  @override
  String get attReportCardTitle => 'उपस्थिति की स्थिति';

  @override
  String get attReportCardHint =>
      'छात्र, शिक्षक और अन्य · तालिका देखने के लिए टैप करें';

  @override
  String get attGroupStudents => 'छात्र';

  @override
  String get attGroupTeachers => 'शिक्षक';

  @override
  String get attGroupOthers => 'अन्य';

  @override
  String get attMarkNotMarked => 'अंकित नहीं';

  @override
  String get attMarkNotTracked => 'दर्ज नहीं';

  @override
  String get attColName => 'नाम';

  @override
  String get attColClassRole => 'कक्षा / भूमिका';

  @override
  String get attColStatus => 'स्थिति';

  @override
  String get attColTime => 'आगमन';

  @override
  String get attFilterDetail => 'कक्षा / विषय / भूमिका';

  @override
  String get attSearchName => 'नाम से खोजें';

  @override
  String get attClearFilters => 'फ़िल्टर हटाएँ';

  @override
  String attShowing(int shown, int total) {
    return '$total में से $shown दिख रहे हैं';
  }

  @override
  String get attReportEmpty => 'इन फ़िल्टर से कोई नहीं मिला।';

  @override
  String get attReportOthersNote =>
      'अन्य स्टाफ़ की उपस्थिति ऐप में दर्ज नहीं होती।';

  @override
  String get attReportToday => 'आज';

  @override
  String get attReportPickDay => 'दिन चुनें';

  @override
  String get attReminderTitle => 'आपने अभी चेक-इन नहीं किया है';

  @override
  String get attReminderBody =>
      'अभी चेक-इन करें ताकि आज की उपस्थिति दर्ज हो जाए।';

  @override
  String get demoDataTitle => 'डेमो डेटा';

  @override
  String get demoDataBody =>
      'हर सुविधा को आज़माने के लिए स्कूल में नकली डेटा भरें: नर्सरी से 8वीं तक की कक्षाएँ, छात्र, पुरुष और महिला शिक्षक, अन्य स्टाफ़, उपस्थिति, परीक्षाएँ, फ़ीस, सूचनाएँ और बहुत कुछ। आपका अपना डेटा नहीं बदलेगा, और \"हटाएँ\" सिर्फ़ डेमो डेटा हटाता है। आपको दोबारा साइन इन करना होगा।';

  @override
  String get demoDataLoad => 'भरें';

  @override
  String get demoDataRemove => 'हटाएँ';

  @override
  String get demoDataLoaded =>
      'डेमो डेटा जोड़ दिया गया। कृपया दोबारा साइन इन करें।';

  @override
  String get demoDataRemoved =>
      'डेमो डेटा हटा दिया गया। कृपया दोबारा साइन इन करें।';

  @override
  String get demoDataFailed => 'डेमो डेटा नहीं बदल सका। कृपया फिर कोशिश करें।';

  @override
  String get featureFees => 'फ़ीस';

  @override
  String get featureAccessories => 'एक्सेसरीज़';

  @override
  String get featurePerformance => 'प्रदर्शन';

  @override
  String get featureAttendance => 'उपस्थिति';

  @override
  String get featureClasses => 'कक्षाएँ';

  @override
  String get featureTeacherPayment => 'शिक्षक भुगतान';

  @override
  String get featureQuestionBank => 'प्रश्न बैंक';

  @override
  String get featureExamPapers => 'परीक्षा पेपर';

  @override
  String get featureStaffPayment => 'भुगतान';

  @override
  String get featureBills => 'बिल';

  @override
  String get featureSubjects => 'विषय';

  @override
  String get addStudentTitle => 'छात्र जोड़ें';

  @override
  String get addTeacherTitle => 'शिक्षक जोड़ें';

  @override
  String get addStaffTitle => 'स्टाफ़ जोड़ें';

  @override
  String get editStudentTitle => 'छात्र बदलें';

  @override
  String get messageSaved => 'सहेजा गया';

  @override
  String get searchStudentsHint => 'नाम या रोल नंबर खोजें';

  @override
  String get searchTeachersHint => 'नाम या विषय खोजें';

  @override
  String get searchStaffHint => 'नाम या पद खोजें';

  @override
  String get filterAllClasses => 'सभी कक्षाएँ';

  @override
  String summaryVan(String van) {
    return 'वैन $van';
  }

  @override
  String summaryClassTeacher(String name) {
    return 'कक्षा शिक्षक, $name';
  }

  @override
  String get memberOpen => 'खोलें';

  @override
  String get memberEdit => 'बदलें';

  @override
  String get memberMakeInactive => 'निष्क्रिय करें';

  @override
  String get memberMakeActive => 'सक्रिय करें';

  @override
  String get memberInactiveTag => 'निष्क्रिय';

  @override
  String memberShowInactive(int count) {
    return 'निष्क्रिय दिखाएँ ($count)';
  }

  @override
  String memberMadeInactive(String name) {
    return '$name अब निष्क्रिय है';
  }

  @override
  String memberMadeActive(String name) {
    return '$name फिर से सक्रिय है';
  }

  @override
  String get actionUndo => 'पूर्ववत करें';

  @override
  String get dashStudentsIn => 'छात्र आए';

  @override
  String get dashTeachersIn => 'शिक्षक आए';

  @override
  String get dashOthersIn => 'अन्य स्टाफ़ आया';

  @override
  String get dashNotMarkedYet => 'अभी दर्ज नहीं';

  @override
  String dashInOf(int present, int total) {
    return '$total में से $present';
  }

  @override
  String get navStudents => 'छात्र';

  @override
  String get navTeachers => 'शिक्षक';

  @override
  String get navOthers => 'अन्य';

  @override
  String get syncTable_staff_attendance => 'अन्य स्टाफ़ की उपस्थिति';

  @override
  String get attTitleStudents => 'छात्र उपस्थिति';

  @override
  String get attTitleTeachers => 'शिक्षक उपस्थिति';

  @override
  String get attTitleOthers => 'स्टाफ़ उपस्थिति';

  @override
  String attTabAll(int count) {
    return 'सभी $count';
  }

  @override
  String attTabMark(String label, int count) {
    return '$label $count';
  }

  @override
  String get attMeaningTeachers =>
      'उपस्थित यानी लोकेशन और चेहरे के साथ चेक-इन। अनुपस्थित यानी इस दिन चेक-इन नहीं।';

  @override
  String get attMeaningStudents =>
      'उपस्थित, अनुपस्थित और देर से कक्षा शिक्षक दर्ज करते हैं। दर्ज होने तक कक्षा \"दर्ज नहीं\" दिखती है।';

  @override
  String get attMeaningOthers =>
      'स्टाफ़ की उपस्थिति आप खुद दर्ज करते हैं। \"दर्ज नहीं\" यानी इस दिन का काम बाकी है।';

  @override
  String get attFilterClass => 'कक्षा';

  @override
  String get attFilterRole => 'पद';

  @override
  String get attMarkStaff => 'उपस्थिति दर्ज करें';

  @override
  String get attStaffMarkTitle => 'स्टाफ़ उपस्थिति दर्ज करें';

  @override
  String attTeachersCheckedIn(int present, int total) {
    return '$total में से $present शिक्षक चेक-इन कर चुके';
  }

  @override
  String get syncTable_fee_structure => 'फ़ीस सेटअप';

  @override
  String get proofAddPhoto => 'फ़ोटो जोड़ें';

  @override
  String get proofTakePhoto => 'फ़ोटो लें';

  @override
  String get proofFromGallery => 'गैलरी से चुनें';

  @override
  String get proofRemove => 'हटाएँ';

  @override
  String get proofSignHere => 'यहाँ हस्ताक्षर करें';

  @override
  String get proofClear => 'मिटाएँ';

  @override
  String get proofView => 'प्रमाण देखें';

  @override
  String get proofNone => 'कोई प्रमाण नहीं जोड़ा';

  @override
  String get proofPhotoTitle => 'फ़ोटो प्रमाण';

  @override
  String get proofSignatureTitle => 'हस्ताक्षर';

  @override
  String get proofSignedTag => 'हस्ताक्षरित';

  @override
  String get proofPhotoTag => 'फ़ोटो';

  @override
  String get proofMissing => 'यह फ़ाइल अब इस फ़ोन में नहीं है।';

  @override
  String get feeHeadAcademic => 'शैक्षणिक फ़ीस';

  @override
  String get feeHeadDress => 'ड्रेस';

  @override
  String get feeHeadBooks => 'किताबें';

  @override
  String get feeHeadVan => 'वैन';

  @override
  String get feeHeadPayment => 'भुगतान';

  @override
  String get payModeCash => 'नकद';

  @override
  String get payModeUpi => 'यूपीआई';

  @override
  String get payModeCheque => 'चेक';

  @override
  String get payModeBank => 'बैंक';

  @override
  String feeDueLast(String due, String last) {
    return 'देय $due · अंतिम तिथि $last';
  }

  @override
  String get feeNoPaymentYet => 'अभी कोई भुगतान नहीं';

  @override
  String get feeChangeDates => 'तिथियाँ बदलें';

  @override
  String feeDatesNote(String note) {
    return 'अलग तिथियाँ: $note';
  }

  @override
  String get recordPaymentTitle => 'भुगतान दर्ज करें';

  @override
  String get fieldPaidOn => 'भुगतान की तिथि';

  @override
  String get fieldHowPaid => 'कैसे दिया';

  @override
  String get fieldReferenceUpi => 'यूपीआई ट्रांज़ैक्शन आईडी';

  @override
  String get fieldReferenceCheque => 'चेक नंबर';

  @override
  String get fieldReferenceBank => 'बैंक रेफ़रेंस (UTR)';

  @override
  String get fieldReferenceCash => 'रसीद बुक नंबर (वैकल्पिक)';

  @override
  String get fieldProofPhoto => 'प्रमाण (फ़ोटो या स्क्रीनशॉट)';

  @override
  String get errorReferenceRequired => 'रेफ़रेंस लिखें।';

  @override
  String get errorProofRequired =>
      'इस तरह के भुगतान के लिए प्रमाण की फ़ोटो जोड़ें।';

  @override
  String messagePaymentSavedReceipt(String no) {
    return 'भुगतान दर्ज हुआ। रसीद $no';
  }

  @override
  String get paymentProofYes => 'प्रमाण जुड़ा';

  @override
  String get paymentProofNo => 'प्रमाण नहीं';

  @override
  String get feeAccountNotFound => 'यह फ़ीस अब नहीं है।';

  @override
  String get feeLedgerPaymentsTitle => 'भुगतान';

  @override
  String get fieldReason => 'कारण';

  @override
  String get feeSetupTitle => 'फ़ीस सेटअप';

  @override
  String get feeSetupDue => 'देय तिथि';

  @override
  String get feeSetupLast => 'अंतिम तिथि';

  @override
  String get feeSetupAmount => 'राशि';

  @override
  String feeSetupApplies(String name) {
    return 'ये $name के सभी छात्रों पर लागू हैं।';
  }

  @override
  String get feeSetupNotSet => 'अभी सेट नहीं है';

  @override
  String get feeSetupEdit => 'बदलें';

  @override
  String get feeSetupSetUp => 'सेट करें';

  @override
  String get feeSetupGive => 'छात्रों को दें';

  @override
  String feeSetupGiven(int count) {
    return '$count छात्रों को यह फ़ीस दी गई';
  }

  @override
  String get feeSetupNoneToGive => 'सभी के पास यह फ़ीस पहले से है';

  @override
  String get feeSetupMeaning =>
      'देय तिथि वह दिन है जब फ़ीस देनी होती है। अंतिम तिथि के बाद फ़ीस \"बकाया\" दिखती है। किसी एक छात्र की तिथि अलग करनी हो तो उसकी अपनी फ़ीस स्क्रीन से बदलें।';

  @override
  String get feeSetupVanNote => 'सिर्फ़ उन छात्रों के लिए जो वैन से आते हैं।';

  @override
  String get feeSetupNoClasses => 'पहले कक्षाएँ जोड़ें।';

  @override
  String get syncTable_accessory_items => 'ड्रेस और किताबों की सूची';

  @override
  String get syncTable_accessory_issues => 'दी गई ड्रेस और किताबें';

  @override
  String get fieldVan => 'वैन (अगर छात्र वैन से आता है)';

  @override
  String get fieldNoVan => 'वैन नहीं';

  @override
  String get accKindDress => 'ड्रेस';

  @override
  String get accKindBooks => 'किताबें';

  @override
  String accSummaryDone(int done, int total) {
    return '$total में से $done को दी';
  }

  @override
  String accSummaryNot(int count) {
    return '$count को नहीं दी';
  }

  @override
  String get accSetDress => 'ड्रेस सेट';

  @override
  String get accSetBooks => 'किताबों की सूची';

  @override
  String get accSetEmpty => 'अभी सेट नहीं है। \"सेट बदलें\" दबाएँ।';

  @override
  String get accEditSet => 'सेट बदलें';

  @override
  String get accSetHintDress => 'हर पंक्ति में एक चीज़, जैसे: शर्ट';

  @override
  String get accSetHintBooks => 'हर पंक्ति में एक किताब';

  @override
  String accSizesButton(int done, int total) {
    return 'ड्रेस साइज़ $done/$total';
  }

  @override
  String accSizeLabel(String size) {
    return 'साइज़ $size';
  }

  @override
  String get accSizeNotNoted => 'साइज़ नहीं लिखा';

  @override
  String get accNoteSize => 'साइज़ लिखें';

  @override
  String get accIssue => 'दें';

  @override
  String get accGive => 'दें';

  @override
  String accGivenOf(int done, int total) {
    return '$total में से $done दी';
  }

  @override
  String get accComplete => 'पूरा';

  @override
  String get accIssuedTag => 'दी गई';

  @override
  String get accSizesTitle => 'ड्रेस के साइज़';

  @override
  String accSizesNoted(int done, int total) {
    return '$total में से $done लिखे';
  }

  @override
  String get accSizesOrder => 'ऑर्डर सारांश';

  @override
  String accSizesNotNoted(int count) {
    return 'नहीं लिखे ×$count';
  }

  @override
  String get accSizesField => 'साइज़';

  @override
  String get accSizesSave => 'साइज़ सहेजें';

  @override
  String get accSizesSaved => 'साइज़ सहेजे गए';

  @override
  String get accIssueTitleDress => 'ड्रेस दें';

  @override
  String get accIssueTitleBooks => 'किताबें दें';

  @override
  String get accItemsGiven => 'दी जाने वाली चीज़ें';

  @override
  String get accSets => 'सेट';

  @override
  String get accReceivedBy => 'किसने लिया';

  @override
  String get accSignTitle => 'लेने वाले के हस्ताक्षर';

  @override
  String get accPhotoOptional => 'फ़ोटो (वैकल्पिक)';

  @override
  String accIssuedBy(String name) {
    return '$name ने दिया';
  }

  @override
  String get accIssueAndSave => 'दें और रसीद सहेजें';

  @override
  String accIssuedSaved(String no) {
    return 'सहेजा गया। रसीद $no';
  }

  @override
  String get accProblemNoItems => 'कम से कम एक चीज़ चुनें।';

  @override
  String get accProblemReceiver => 'लिखें कि किसने लिया।';

  @override
  String get accProblemSignature => 'लेने वाले को हस्ताक्षर करने होंगे।';

  @override
  String get accProblemSize => 'साइज़ लिखें।';

  @override
  String get accNoItemsSetup => 'पहले इस कक्षा की सूची बनाएँ (\"सेट बदलें\")।';

  @override
  String get accLogEmpty => 'अभी कुछ नहीं दिया गया।';

  @override
  String get accLogViewSignature => 'हस्ताक्षर देखें';

  @override
  String get accLogViewPhoto => 'फ़ोटो देखें';

  @override
  String accLogReceived(String name, String date) {
    return '$name ने लिया · $date';
  }

  @override
  String get accLogGiveRest => 'बाकी दें';

  @override
  String accNotGivenYet(String items) {
    return 'अभी नहीं दी: $items';
  }

  @override
  String get profileAccessories => 'एक्सेसरीज़';

  @override
  String get accNoClasses => 'पहले कक्षाएँ जोड़ें।';

  @override
  String get approvalsSearchHint => 'नाम, कक्षा या शीर्षक से खोजें';

  @override
  String approvalsTabWaiting(int count) {
    return 'प्रतीक्षा में $count';
  }

  @override
  String approvalsTabAnswered(int count) {
    return 'जवाब दिए $count';
  }

  @override
  String approvalsChipCount(String label, int count) {
    return '$label $count';
  }

  @override
  String get fieldVanNumber => 'वैन नंबर';

  @override
  String get hintVanNumber => 'जैसे UP32 AB 1234';

  @override
  String dashWaitingTitle(int count) {
    return '$count आपके जवाब का इंतज़ार कर रहे हैं';
  }

  @override
  String get dashWaitingNone => 'आपके लिए कुछ बाकी नहीं है';

  @override
  String get dashWaitingOpen => 'खोलें';

  @override
  String get dashSectionPeople => 'लोग';

  @override
  String get homeTileTiming => 'स्कूल का समय';

  @override
  String get homeTileAssembly => 'प्रार्थना सभा';

  @override
  String get homeTilePeriods => 'पीरियड सारणी';

  @override
  String get homeTileCalendar => 'कैलेंडर';

  @override
  String get homeTileSettings => 'सेटिंग्स';

  @override
  String homeGreetingLine(String date, String greeting) {
    return '$date · $greeting';
  }

  @override
  String get syncTable_school_timings => 'कक्षाओं का समय';

  @override
  String get syncTable_bell_slots => 'पीरियड का समय';

  @override
  String get syncTable_assembly_duty => 'सभा की ड्यूटी';

  @override
  String get syncTable_timetable_entries => 'कक्षा की समय-सारणी';

  @override
  String get timingTitle => 'स्कूल का समय';

  @override
  String get timingStarts => 'स्कूल शुरू';

  @override
  String get timingEnds => 'स्कूल खत्म';

  @override
  String get timingNotSet => 'सेट नहीं';

  @override
  String get timingWorkingDays => 'कार्य दिवस';

  @override
  String get timingClassRules => 'कुछ कक्षाओं का अलग समय';

  @override
  String get timingAddAnother => '+ एक और समय जोड़ें';

  @override
  String get timingSeasonal => 'मौसम के हिसाब से समय';

  @override
  String get timingSeasonalHint =>
      'गर्मी का समय एक तारीख से, सर्दी का समय एक तारीख से।';

  @override
  String get timingAdd => '+ जोड़ें';

  @override
  String get timingNote =>
      'होम, पीरियड सारणी और शिक्षक के चेक-इन पर दिखता है। शुरू होने के बाद चेक-इन को \"देर\" गिनना है या नहीं, यह अभी तय नहीं।';

  @override
  String get timingRuleTitle => 'समय';

  @override
  String get timingRuleClasses =>
      'इन कक्षाओं के लिए (कोई नहीं चुनी तो सभी कक्षाएँ)';

  @override
  String get timingRuleFrom => 'इस तारीख से';

  @override
  String get timingRuleFromNone => 'हर दिन';

  @override
  String get timingRuleRemove => 'हटाएँ';

  @override
  String timingRuleFromDate(String range, String date) {
    return '$date से $range';
  }

  @override
  String get assemblyTitle => 'प्रार्थना सभा';

  @override
  String get assemblyTime => 'समय';

  @override
  String get assemblyPlace => 'जगह';

  @override
  String get assemblyDays => 'दिन';

  @override
  String get assemblyOrder => 'क्रम';

  @override
  String get assemblyOrderHint => 'हर पंक्ति में एक चीज़, जैसे: प्रार्थना';

  @override
  String get assemblyDutyTitle => 'किसकी ड्यूटी';

  @override
  String assemblyInCharge(String name) {
    return 'प्रभारी: $name';
  }

  @override
  String get assemblyDutyClass => 'कक्षा';

  @override
  String get assemblyDutyTeacher => 'प्रभारी शिक्षक';

  @override
  String get assemblyDutyClear => 'हटाएँ';

  @override
  String get periodsTitle => 'पीरियड का समय';

  @override
  String get periodsAdd => '+ पीरियड';

  @override
  String get periodsHint =>
      'पूरे स्कूल की घंटी का समय। इसके बाद कक्षाएँ विषय भरती हैं।';

  @override
  String get periodsAssembly => 'सभा';

  @override
  String get periodsFixed => 'तय';

  @override
  String periodN(int n) {
    return 'पीरियड $n';
  }

  @override
  String get periodBreakTag => 'अवकाश';

  @override
  String get periodEdit => 'बदलें';

  @override
  String get periodKindPeriod => 'पीरियड';

  @override
  String get periodKindBreak => 'अवकाश';

  @override
  String get periodLabel => 'नाम (अवकाश के लिए, जैसे लंच)';

  @override
  String periodMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get periodsTimetableButton => 'कक्षा की समय-सारणी';

  @override
  String get periodRemove => 'हटाएँ';

  @override
  String periodTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get periodEndBeforeStart => 'अंत का समय शुरू के बाद होना चाहिए।';

  @override
  String get timetableTitle => 'समय-सारणी';

  @override
  String get timetableCopy => 'यहाँ कॉपी करें…';

  @override
  String get timetableChange => 'बदलें';

  @override
  String get timetableNotSet => 'सेट नहीं';

  @override
  String get timetableClear => 'हटाएँ';

  @override
  String timetableConflict(
    String teacher,
    String className,
    String slot,
    String day,
  ) {
    return '$teacher $day को $slot में पहले से $className को पढ़ा रहे हैं। दूसरा शिक्षक या पीरियड चुनें।';
  }

  @override
  String get timetableNoOptions =>
      'इस कक्षा में अभी किसी शिक्षक को विषय नहीं सौंपा गया। शिक्षक के \"विषय\" से सौंपें।';

  @override
  String timetableCopied(int copied, int skipped) {
    return '$copied पीरियड कॉपी हुए, $skipped छूटे (शिक्षक व्यस्त)';
  }

  @override
  String timetableCopyTo(String day) {
    return '$day को यहाँ कॉपी करें';
  }

  @override
  String get timetableNoSlots => 'पहले पीरियड का समय तय करें।';

  @override
  String timetablePickTitle(String slot, String day) {
    return '$slot · $day';
  }

  @override
  String get actionDone => 'हो गया';

  @override
  String get categoryTagExam => 'परीक्षा';

  @override
  String get categoryTagSubject => 'विषय';

  @override
  String get categoryTagBill => 'बिल';

  @override
  String approvalsSubtitle(int waiting, int total) {
    return '$waiting प्रतीक्षा में · कुल $total';
  }

  @override
  String get approvalAllow => 'अनुमति दें';

  @override
  String get approvalDecline => 'मना करें';

  @override
  String get approvalTabWaiting => 'प्रतीक्षा';

  @override
  String get approvalTabApproved => 'स्वीकृत';

  @override
  String get approvalTabRejected => 'अस्वीकृत';

  @override
  String get aadhaarScanCardTitle => 'आधार कार्ड स्कैन करें';

  @override
  String get aadhaarScanCardHint => 'नाम, जन्म तिथि, लिंग, पता भर देता है';

  @override
  String get saveStudent => 'छात्र सहेजें';

  @override
  String get saveTeacher => 'शिक्षक सहेजें';

  @override
  String get saveStaff => 'स्टाफ़ सहेजें';

  @override
  String get actionAssignFee => '+ फ़ीस जोड़ें';

  @override
  String profileTileFeesDue(String amount) {
    return '$amount बाकी';
  }

  @override
  String get profileTileFeesClear => 'सब जमा';

  @override
  String profileTileAvg(int percent) {
    return 'औसत $percent%';
  }

  @override
  String profileTileAttendance(int percent) {
    return 'इस सत्र $percent%';
  }

  @override
  String get profileTileNone => 'अभी कुछ नहीं';

  @override
  String profileGuardianLine(String name, String phone) {
    return 'अभिभावक: $name · $phone';
  }

  @override
  String get syncTable_staff_bills => 'ईंधन के बिल';

  @override
  String get syncTable_staff_settlements => 'स्टाफ़ को भुगतान';

  @override
  String get categoryStaffBill => 'बिल';

  @override
  String approvalBillLine(String name, String detail, String date) {
    return '$name · $detail · $date';
  }

  @override
  String get billsTitle => 'बिल';

  @override
  String get billsAdd => '+ बिल';

  @override
  String get billsTabAll => 'सभी';

  @override
  String get billsTabPending => 'प्रतीक्षा';

  @override
  String get billsTabApproved => 'स्वीकृत';

  @override
  String get billsTabPaid => 'चुकाए';

  @override
  String billRowTitle(String kind, String amount) {
    return '$kind · $amount';
  }

  @override
  String billRowSub(String date, String litres, String proof) {
    return '$date · $litres ली. · $proof';
  }

  @override
  String billRowSubNoLitres(String date, String proof) {
    return '$date · $proof';
  }

  @override
  String get billPhasePending => 'मंज़ूरी बाकी';

  @override
  String get billPhaseApproved => 'स्वीकृत';

  @override
  String get billPhaseRejected => 'अस्वीकृत';

  @override
  String get billPhasePaid => 'चुकाया';

  @override
  String get billPhotoYes => 'फ़ोटो';

  @override
  String get billPhotoNo => 'फ़ोटो नहीं';

  @override
  String get billsRule =>
      'सिर्फ़ स्वीकृत बिल का भुगतान हो सकता है। प्रतीक्षा वाले और अस्वीकृत बिल बंद हैं।';

  @override
  String get billsEmpty => 'अभी कोई बिल नहीं।';

  @override
  String get fuelPetrol => 'पेट्रोल';

  @override
  String get fuelDiesel => 'डीज़ल';

  @override
  String get addBillTitle => 'बिल जोड़ें';

  @override
  String get fieldBillDate => 'तिथि';

  @override
  String get fieldLitres => 'लीटर';

  @override
  String get fieldBillAmount => 'राशि';

  @override
  String get fieldBillPhoto => 'बिल की फ़ोटो';

  @override
  String get fieldBillNote => 'टिप्पणी (वैकल्पिक)';

  @override
  String get billSendForApproval => 'मंज़ूरी के लिए भेजें';

  @override
  String get billSent => 'बिल मंज़ूरी के लिए भेजा गया';

  @override
  String get errBillAmount => 'राशि लिखें।';

  @override
  String get errBillPhoto => 'बिल की फ़ोटो जोड़ें।';

  @override
  String get billChooseStaff => 'किसका बिल है?';

  @override
  String get staffPaymentTitle => 'भुगतान';

  @override
  String get staffPayableNow => 'अभी देने योग्य (स्वीकृत बिल)';

  @override
  String get staffEligible => 'योग्य · स्वीकृत';

  @override
  String staffSettle(String amount) {
    return '$amount चुकाएँ';
  }

  @override
  String get staffNotEligible => 'अभी योग्य नहीं';

  @override
  String get staffLockedWaiting => 'आपकी मंज़ूरी का इंतज़ार';

  @override
  String get staffLocked => 'बंद';

  @override
  String get staffGoApprovals => 'मंज़ूरियाँ';

  @override
  String get staffPayHistory => 'भुगतान का इतिहास';

  @override
  String get staffNothingPayable => 'अभी देने के लिए कुछ तैयार नहीं।';

  @override
  String staffPayableLine(String amount) {
    return '$amount देय';
  }

  @override
  String staffBillsWaiting(int count) {
    return '$count मंज़ूरी के इंतज़ार में';
  }

  @override
  String get staffNoBillsYet => 'अभी कोई बिल नहीं';

  @override
  String get settleTitle => 'भुगतान चुकाएँ';

  @override
  String get settleAmountPaid => 'दी गई राशि';

  @override
  String get settleProof => 'भुगतान का प्रमाण';

  @override
  String settlePaidBy(String name) {
    return '$name ने दिया';
  }

  @override
  String get settleConfirm => 'पक्का करें और वाउचर सहेजें';

  @override
  String settleSaved(String no) {
    return 'चुकाया गया। वाउचर $no';
  }

  @override
  String get settleNothing => 'कम से कम एक बिल चुनें।';

  @override
  String get settleNotApproved => 'इनमें से कुछ बिल अब स्वीकृत नहीं हैं।';

  @override
  String get settlementsTitle => 'भुगतान का इतिहास';

  @override
  String get settlementsEmpty => 'अभी कोई भुगतान नहीं।';

  @override
  String settlementLine(String mode, String date) {
    return '$mode · $date';
  }

  @override
  String settlementRef(String ref) {
    return 'संदर्भ $ref';
  }

  @override
  String settlementBills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बिलों के लिए',
      one: '1 बिल के लिए',
    );
    return '$_temp0';
  }

  @override
  String get settlementViewProof => 'प्रमाण देखें';

  @override
  String staffRoleLine(String phone) {
    return 'फ़ोन $phone';
  }

  @override
  String get staffTilePayment => 'भुगतान';

  @override
  String get staffTileBills => 'बिल';

  @override
  String get teacherSubjectsListTitle => 'विषय';

  @override
  String teacherSubjectsLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count विषय',
      one: '1 विषय',
      zero: 'अभी कोई विषय नहीं',
    );
    return '$_temp0';
  }

  @override
  String get navMyClass => 'मेरी कक्षा';

  @override
  String get navExams => 'परीक्षाएँ';

  @override
  String get teacherTodayPeriods => 'आज के पीरियड';

  @override
  String get teacherNoPeriods => 'आज के लिए कोई पीरियड तय नहीं।';

  @override
  String get teacherAddQuestion => '+ प्रश्न';

  @override
  String teacherAssemblyDuty(String day) {
    return 'सभा की ड्यूटी: $day';
  }

  @override
  String teacherAssemblyDutyLine(String className, String time) {
    return '$className · $time';
  }

  @override
  String get teacherMarkNow => 'अभी दर्ज करें';

  @override
  String teacherClassNotMarked(String className) {
    return '$className की उपस्थिति दर्ज नहीं';
  }

  @override
  String teacherClassStudents(int count) {
    return '$count छात्र';
  }

  @override
  String teacherClassMarked(String className) {
    return '$className की उपस्थिति हो गई';
  }

  @override
  String teacherClassPresentOf(int present, int total) {
    return '$total में से $present उपस्थित';
  }

  @override
  String myClassTitle(String name) {
    return 'मेरी कक्षा · $name';
  }

  @override
  String get myClassNone =>
      'अभी आपको कोई कक्षा नहीं मिली। प्रधानाचार्य से पूछें।';

  @override
  String get myClassMark => 'उपस्थिति दर्ज करें';

  @override
  String get myClassView => 'आज की उपस्थिति देखें';

  @override
  String get syncTable_question_units => 'प्रश्न बैंक की इकाइयाँ';

  @override
  String get bankTitle => 'मेरा प्रश्न बैंक';

  @override
  String get bankAddQuestion => '+ प्रश्न';

  @override
  String bankSummary(int count, int units) {
    return '$units इकाइयों में $count प्रश्न';
  }

  @override
  String get bankUnitEmpty => 'अभी कोई प्रश्न नहीं';

  @override
  String get bankNoScopes =>
      'आपके पास अभी कोई विषय नहीं। प्रधानाचार्य से माँगें।';

  @override
  String get bankNoUnits => 'अभी कोई इकाई नहीं। पहले इकाई जोड़ें, फिर प्रश्न।';

  @override
  String get bankAddTitle => 'प्रश्न जोड़ें';

  @override
  String get bankAddPhoto => 'प्रश्नों की फोटो लें';

  @override
  String get bankAddPhotoHint => 'किताब, वर्कशीट या बोर्ड से।';

  @override
  String get bankFastest => 'सबसे तेज़';

  @override
  String get bankAddGallery => 'फोन से फोटो चुनें';

  @override
  String get bankAddGalleryHint => 'जो फोटो पहले ली हो।';

  @override
  String get bankAddType => 'एक प्रश्न लिखें';

  @override
  String get bankAddTypeHint => 'खुद लिखें।';

  @override
  String get bankClassSubject => 'कक्षा · विषय';

  @override
  String get bankUnitLabel => 'इकाई';

  @override
  String get bankNewUnit => '+ नई इकाई';

  @override
  String get bankNewUnitTitle => 'नई इकाई';

  @override
  String get bankNewUnitHint => 'जैसे इकाई 2 · क्रिया';

  @override
  String get bankAddOneTitle => 'प्रश्न जोड़ें';

  @override
  String get bankSaveAnother => 'सहेजें और एक और जोड़ें';

  @override
  String get bankSaved => 'प्रश्न सहेजा गया';

  @override
  String get bankDeleted => 'प्रश्न हटाया गया';

  @override
  String get bankPickUnit => 'पहले इकाई चुनें।';

  @override
  String get photoTitle => 'फोटो से प्रश्न';

  @override
  String photoStep(int n) {
    return 'चरण $n / 4';
  }

  @override
  String get photoWhereGo => 'ये कहाँ जाएँ?';

  @override
  String get photoTips => 'साफ फोटो के लिए';

  @override
  String get photoTip1 => 'अच्छी रोशनी, छाया नहीं';

  @override
  String get photoTip2 => 'पन्ना सीधा, चारों कोने दिखें';

  @override
  String get photoTip3 => 'एक बार में एक पन्ना';

  @override
  String photoPages(int count) {
    return 'ली गई फोटो: $count';
  }

  @override
  String photoPageN(int n) {
    return 'पन्ना $n';
  }

  @override
  String get photoAddPage => 'एक और पन्ना जोड़ें';

  @override
  String get photoRead => 'प्रश्न पढ़ें';

  @override
  String get photoReading => 'फोटो पढ़ी जा रही है…';

  @override
  String get photoNothing => 'कोई प्रश्न नहीं पढ़ा जा सका। साफ फोटो लें।';

  @override
  String photoFound(int count, int pages, String name) {
    return '$pages पन्नों में $count प्रश्न मिले · $name';
  }

  @override
  String get photoCheckEach =>
      'हर एक देखें। ठीक करने के लिए प्रश्न पर टैप करें।';

  @override
  String photoFilterAll(int count) {
    return 'सभी $count';
  }

  @override
  String photoFilterNeed(int count) {
    return 'उत्तर चाहिए $count';
  }

  @override
  String photoFilterCheck(int count) {
    return 'जाँचें $count';
  }

  @override
  String get flagReady => 'तैयार';

  @override
  String get flagAnswerMissing => 'उत्तर नहीं है';

  @override
  String get flagCheckPairs => 'जोड़े जाँचें';

  @override
  String get flagLeftOut => 'छोड़ा गया';

  @override
  String get photoHeadingNote => 'शीर्षक लगता है, प्रश्न नहीं';

  @override
  String photoSaveTo(String name) {
    return '$name में सहेजें';
  }

  @override
  String photoSaveN(int count) {
    return '$count सहेजें';
  }

  @override
  String get photoFixTitle => 'प्रश्न ठीक करें';

  @override
  String photoFixOf(int n, int total) {
    return '$n / $total';
  }

  @override
  String get photoPrevious => 'पिछला';

  @override
  String get photoNext => 'अगला';

  @override
  String get photoSavedTitle => 'सहेजा गया';

  @override
  String photoSavedCount(int count) {
    return '$count प्रश्न जोड़े गए';
  }

  @override
  String photoBefore(String name) {
    return '$name पहले';
  }

  @override
  String photoNow(String name) {
    return '$name अब';
  }

  @override
  String get photoTakeAnother => 'एक और फोटो लें';

  @override
  String get photoMakePaper => 'मेरे बैंक से पेपर बनाएँ';

  @override
  String get kindWeekly => 'साप्ताहिक टेस्ट';

  @override
  String get kindMidMonthly => 'मासिक मध्य टेस्ट';

  @override
  String get kindUnitTest => 'यूनिट टेस्ट';

  @override
  String get kindHalfYearly => 'अर्धवार्षिक परीक्षा';

  @override
  String get kindYearlyFinal => 'वार्षिक अंतिम परीक्षा';

  @override
  String get makeTitle => 'पेपर बनाएँ';

  @override
  String makeStep(int n) {
    return 'चरण $n / 5';
  }

  @override
  String get makeExamType => 'परीक्षा का प्रकार';

  @override
  String get makeTotalMarks => 'कुल अंक';

  @override
  String get makeTime => 'समय (मिनट)';

  @override
  String get makeDate => 'परीक्षा की तारीख';

  @override
  String get makeNextUnits => 'आगे: इकाइयाँ चुनें';

  @override
  String get makePickUnits => 'इस टेस्ट में कौन सी इकाइयाँ हैं?';

  @override
  String makeUnitCount(int count) {
    return '$count प्रश्न';
  }

  @override
  String get makeNoQuestions => 'आपके बैंक में प्रश्न नहीं';

  @override
  String makeUnitsSummary(int units, int count) {
    return '$units इकाइयाँ · चुनने के लिए $count प्रश्न';
  }

  @override
  String get makeNextTypes => 'आगे: प्रश्नों के प्रकार';

  @override
  String makePlanned(int planned, int total) {
    return '$total में से $planned अंक तय';
  }

  @override
  String get makeTypesHave => 'इन इकाइयों में आपके प्रश्न प्रकार';

  @override
  String makeAvailable(int count) {
    return '$count उपलब्ध';
  }

  @override
  String get makeTakeFrom => 'यहाँ से लें:';

  @override
  String get makeQuestions => 'प्रश्न';

  @override
  String get makeMarksEach => 'प्रति प्रश्न अंक';

  @override
  String get makeNotUsed => 'उपयोग नहीं';

  @override
  String makeShort(int want, int have) {
    return '$want माँगे, बैंक में सिर्फ $have हैं।';
  }

  @override
  String get makeMakeSet => 'सेट बनाएँ';

  @override
  String get makeReviewTitle => 'सेट देखें';

  @override
  String makeMarksOf(int have, int want) {
    return '$have / $want अंक';
  }

  @override
  String get makeReplace => 'बदलें';

  @override
  String get makeNewSet => 'नया सेट बनाएँ';

  @override
  String get makeNext => 'आगे';

  @override
  String get makeReplaceTitle => 'प्रश्न बदलें';

  @override
  String get makeReplacing => 'बदला जा रहा है';

  @override
  String get makeOtherOfType => 'आपके बैंक के इसी प्रकार के अन्य प्रश्न';

  @override
  String get makeUse => 'चुनें';

  @override
  String get makeReplaceHint =>
      'पेपर में पहले से मौजूद प्रश्न छिपे हैं। अंक तय के अनुसार रहेंगे।';

  @override
  String get makeNoOthers => 'इस प्रकार के और प्रश्न नहीं हैं।';

  @override
  String get makeSendTitle => 'मंज़ूरी के लिए भेजें';

  @override
  String makeSummaryLine(String name, int marks, int minutes) {
    return '$name · $marks अंक · $minutes मिनट';
  }

  @override
  String makeMadeFrom(int count) {
    return 'मेरे प्रश्न बैंक से बना · $count प्रश्न हाथ से बदले';
  }

  @override
  String get makeSaveDraft => 'ड्राफ्ट सहेजें';

  @override
  String get makeSend => 'प्रधानाचार्य को भेजें';

  @override
  String makeMismatch(int have, int want) {
    return 'सेट में $have अंक हैं, पेपर को $want चाहिए।';
  }

  @override
  String get makeSent => 'प्रधानाचार्य को भेज दिया।';

  @override
  String get makeDraftSaved => 'ड्राफ्ट सहेजा गया।';

  @override
  String get makeNeedTotal => 'पहले कुल अंक और समय भरें।';

  @override
  String get makeNeedUnits => 'कम से कम एक इकाई चुनें जिसमें प्रश्न हों।';

  @override
  String get makeNeedTypes => 'कम से कम एक प्रकार के प्रश्नों की संख्या चुनें।';

  @override
  String get newPaperTitle => 'नया पेपर';

  @override
  String get newPaperFromBank => 'मेरे प्रश्न बैंक से बनाएँ';

  @override
  String get newPaperFromBankHint =>
      'इकाइयाँ और प्रकार चुनें। सेट अपने आप बनेगा।';

  @override
  String get newPaperWrite => 'खुद प्रश्न लिखें';

  @override
  String get newPaperWriteHint => 'लिखें, स्कैन करें या एक-एक चुनें।';

  @override
  String get tabSent => 'भेजे गए';

  @override
  String get tabApproved => 'मंज़ूर';

  @override
  String get examsNewPaper => '+ नया पेपर';

  @override
  String get examsMyBank => 'मेरा प्रश्न बैंक';

  @override
  String get profileCheckInHistory => 'चेक-इन का इतिहास';

  @override
  String get profileCalendarHolidays => 'कैलेंडर और छुट्टियाँ';

  @override
  String get loginNewSchool => 'नया स्कूल? प्रधानाचार्य के रूप में शुरू करें';

  @override
  String get loginRestoreSchool => 'स्कूल पहले से पंजीकृत है? वापस लाएँ';

  @override
  String get loginOr => 'या';

  @override
  String get resetTitle => 'नया स्कूल शुरू करें?';

  @override
  String get resetBody =>
      'इस फोन में पिछले स्कूल का डेटा है। नया स्कूल शुरू करने पर वह इस फोन से मिट जाएगा। क्लाउड का डेटा नहीं छुआ जाएगा।';

  @override
  String get resetConfirm => 'मिटाएँ और नया शुरू करें';

  @override
  String get monTitle => 'डेटा मॉनिटर';

  @override
  String get monCheck => 'जाँचें';

  @override
  String get monAgainst => 'किससे मिलाएँ';

  @override
  String get monSrcCloud => 'क्लाउड';

  @override
  String get monSrcFile => 'फाइल';

  @override
  String get monSrcDb => 'फोन का डेटा';

  @override
  String monRows(int count) {
    return '$count पंक्तियाँ';
  }

  @override
  String monAsOf(String time) {
    return '$time तक का';
  }

  @override
  String get monCheckCloud => 'क्लाउड जाँचें';

  @override
  String get monCheckCloudHint => 'क्लाउड से हर table की गिनती पढ़ता है।';

  @override
  String get monNotRead => 'अभी पढ़ा नहीं';

  @override
  String get monProblemMissing => 'अभी डेटा फाइल नहीं बनी';

  @override
  String get monProblemNotSignedIn => 'क्लाउड में साइन-इन नहीं';

  @override
  String get monProblemOffline => 'क्लाउड नहीं मिल रहा';

  @override
  String get monProblemOther => 'पढ़ा नहीं जा सका';

  @override
  String get monTable => 'table';

  @override
  String get monAllMatch => 'सभी table मेल खाती हैं';

  @override
  String monSomeDiffer(int count) {
    return '$count table अलग हैं';
  }

  @override
  String monOnlyIn(String name) {
    return 'सिर्फ $name में';
  }

  @override
  String get monChanged => 'अलग मान';

  @override
  String monSame(int count) {
    return '$count पंक्तियाँ एक जैसी हैं';
  }

  @override
  String get monMatches => 'दोनों पूरी तरह मेल खाते हैं।';

  @override
  String monShowing(int count) {
    return 'पहली $count दिखाई गई';
  }

  @override
  String get monReading => 'पढ़ रहे हैं…';

  @override
  String monFileWritten(String time) {
    return 'डेटा फाइल लिखी गई $time';
  }

  @override
  String get monFileFailed => 'डेटा फाइल लिखी नहीं जा सकी';

  @override
  String monCompareWith(String name) {
    return '$name से मिलाया जा रहा है';
  }

  @override
  String get monCheckNow => 'अभी जाँचें';

  @override
  String get monPhone => 'फोन';

  @override
  String get monCloudCost => 'क्लाउड से हर table की गिनती पढ़ता है।';

  @override
  String monMatchLine(String name, String other) {
    return '$name में $other जितनी ही पंक्तियाँ हैं';
  }

  @override
  String monDiffLine(int count, String other) {
    return '$count table $other से अलग हैं';
  }

  @override
  String monShowDifferences(int count) {
    return 'फर्क ($count)';
  }

  @override
  String monShowAll(int count) {
    return 'सभी पंक्तियाँ ($count)';
  }

  @override
  String get monStatusSame => 'एक जैसी';

  @override
  String get monStatusDifferent => 'अलग';

  @override
  String get monEmptyValue => '(खाली)';

  @override
  String monCountsLine(
    int same,
    String a,
    int onlyA,
    String b,
    int onlyB,
    int diff,
  ) {
    return 'एक जैसी $same · सिर्फ $a $onlyA · सिर्फ $b $onlyB · अलग $diff';
  }

  @override
  String get monSource => 'स्रोत';

  @override
  String monReadBoth(String a, String b) {
    return '$a और $b दोबारा पढ़ें';
  }

  @override
  String monRefreshLabel(String a, String b) {
    return 'ताज़ा करें: $a + $b';
  }

  @override
  String get monRefreshHint => 'ताज़ा करना सिर्फ ऊपर चुनी दो जगह पढ़ता है।';

  @override
  String monExternalWritten(String time) {
    return 'Downloads/ShikshaSetu की प्रति लिखी गई $time';
  }

  @override
  String get monExternalFailed =>
      'Downloads/ShikshaSetu की प्रति नहीं लिखी जा सकी';

  @override
  String get genderMaleShort => 'पु';

  @override
  String get genderFemaleShort => 'म';

  @override
  String get genderOtherShort => 'अन्य';

  @override
  String backupAutoLast(String time) {
    return 'अपने आप की कॉपी: $time';
  }

  @override
  String get backupAutoNone => 'अपने आप की कॉपी अभी नहीं बनी';

  @override
  String get backupAutoFailed => 'अपने आप की कॉपी नहीं लिखी जा सकी';

  @override
  String get actionBackupShareZip => 'बैकअप शेयर करें';

  @override
  String get backupShareHint => 'ताज़ा डेटा Drive, WhatsApp या ईमेल पर भेजें।';

  @override
  String get restoreHint =>
      'Downloads/ShikshaSetu से shiksha_setu_latest चुनें।';

  @override
  String get rpTitle => 'रिस्टोर से पहले जाँचें';

  @override
  String rpBackupFrom(String time) {
    return 'बैकअप बना $time';
  }

  @override
  String get rpNoChange => 'बैकअप में ऐप जैसा ही डेटा है। कुछ नहीं बदलेगा।';

  @override
  String rpWillChange(int added, int changed, int removed) {
    return 'रिस्टोर से $added पंक्तियाँ जुड़ेंगी, $changed बदलेंगी और $removed हट जाएँगी।';
  }

  @override
  String rpLoseWarning(int removed) {
    return '$removed पंक्तियाँ ऐप में हैं पर इस बैकअप में नहीं। वे खो जाएँगी।';
  }

  @override
  String get rpLegend => 'अभी = आज ऐप में। बैकअप = आपकी चुनी फाइल।';

  @override
  String get rpNow => 'अभी';

  @override
  String get rpBackup => 'बैकअप';

  @override
  String rpAdd(int count) {
    return '+$count जुड़ेंगी';
  }

  @override
  String rpRemove(int count) {
    return '−$count खोएँगी';
  }

  @override
  String rpChange(int count) {
    return '~$count बदलेंगी';
  }

  @override
  String get rpRestoreButton => 'यह बैकअप रिस्टोर करें';

  @override
  String get rpRestoreLosing => 'फिर भी रिस्टोर करें';

  @override
  String get rpNothingToRestore => 'रिस्टोर करने को कुछ नहीं';

  @override
  String get actionBackupDownload => 'डाउनलोड';

  @override
  String get messageBackupDownloaded => 'बैकअप सहेजा गया';

  @override
  String rpNewerBanner(String app, String backup) {
    return 'ऐप में इस बैकअप ($backup) से नए बदलाव हैं (आखिरी बदलाव $app)। रिस्टोर करने पर वे पुराने डेटा से बदल जाएँगे।';
  }

  @override
  String get rpRestoreOverriding => 'फिर भी रिस्टोर करें';

  @override
  String get rpOverrideTitle => 'आपका डेटा बदल दें?';

  @override
  String rpOverrideBody(int changed, int removed) {
    return 'इससे ऐप की $changed पंक्तियाँ बैकअप वाली पंक्तियों से बदल जाएँगी और $removed पंक्तियाँ हट जाएँगी, जो बैकअप में नहीं हैं।\n\nआपका मौजूदा डेटा पहले Downloads/ShikshaSetu/shiksha_setu_before_restore.json के रूप में रखा जाता है (पिछले रिस्टोर वाली फाइल की जगह)।';
  }

  @override
  String get rpOverrideConfirm => 'बदलें और रिस्टोर करें';

  @override
  String get rhTitle => 'आखिरी रिस्टोर';

  @override
  String rhLine(String time, String backup) {
    return '$time को $backup के बैकअप से रिस्टोर हुआ';
  }

  @override
  String rhCounts(int added, int changed, int removed) {
    return '$added जुड़ीं · $changed बदलीं · $removed खोईं';
  }

  @override
  String get rhSaved =>
      'आपका पहले का डेटा: Downloads/ShikshaSetu/shiksha_setu_before_restore.json';

  @override
  String get rhNotSaved => 'आपका पहले का डेटा Downloads में कॉपी नहीं हो सका';

  @override
  String get rhForced => 'ऐप में इस बैकअप से नए बदलाव थे';

  @override
  String get rpOldTitle => 'यह पुराना बैकअप है';

  @override
  String rpOldBody(int changed, int removed) {
    return 'ऐप में इस बैकअप से नया डेटा पहले से है।\n\nफिर भी पुराने डेटा से बदलना है? $changed पंक्तियाँ अपने पुराने रूप से बदल जाएँगी और $removed पंक्तियाँ हट जाएँगी।\n\nआपका मौजूदा डेटा पहले Downloads/ShikshaSetu/shiksha_setu_before_restore.json के रूप में रखा जाता है (पिछले रिस्टोर वाली फाइल की जगह)।';
  }

  @override
  String get homeSchoolPlans => 'स्कूल की योजनाएँ';

  @override
  String get homeSchoolPlansHint => 'समय, सभा, पीरियड, कैलेंडर और छुट्टियाँ';

  @override
  String safePillSafe(String time) {
    return 'सुरक्षित $time';
  }

  @override
  String get safePillSaving => 'सहेजा जा रहा है…';

  @override
  String get safePillFailed => 'सहेजा नहीं गया';

  @override
  String get safePillOff => 'क्लाउड बंद';

  @override
  String needsYouTitle(int count) {
    return 'आपकी ज़रूरत · $count';
  }

  @override
  String get needsYouNone => 'सब पूरा है';

  @override
  String get needsYouNoneHint => 'आपके लिए कुछ रुका नहीं है।';

  @override
  String get homeTodayInSchool => 'आज स्कूल में';

  @override
  String get quickNotice => 'सूचना';

  @override
  String homePlansMore(int count) {
    return '+$count और';
  }

  @override
  String get planTimingHint => 'स्कूल कब शुरू और खत्म होता है';

  @override
  String get planAssemblyHint => 'समय, जगह और किसकी ड्यूटी';

  @override
  String get planPeriodsHint => 'घंटी का समय और कक्षाओं की समय-सारणी';

  @override
  String get planCalendarHint => 'स्कूल के दिन और छुट्टियाँ';

  @override
  String get planHolidaysHint => 'छुट्टियाँ जोड़ें या बदलें';

  @override
  String get quickNoticeHint => 'सबके लिए सूचना डालें';

  @override
  String get wsAsk => 'आपको क्या चाहिए?';

  @override
  String get wsAddStudentHint => 'नया छात्र जोड़ने के लिए टैप करें';

  @override
  String get wsAddTeacherHint => 'नया शिक्षक जोड़ने के लिए टैप करें';

  @override
  String get wsAddStaffHint =>
      'ड्राइवर, हेल्पर या अन्य स्टाफ जोड़ने के लिए टैप करें';

  @override
  String get wsListStudents => 'सभी छात्र';

  @override
  String get wsListTeachers => 'सभी शिक्षक';

  @override
  String get wsListStaff => 'सारा स्टाफ';

  @override
  String wsListHint(int count) {
    return '$count पंजीकृत · खोजें, देखें और बदलें';
  }

  @override
  String get wsFeesHint => 'फीस तय करें, भुगतान लें, बकाया देखें';

  @override
  String get wsAccessoriesHint => 'छात्रों को दी गई ड्रेस और किताबें';

  @override
  String get wsPerformanceHint => 'अंक, परिणाम और कक्षाओं का प्रदर्शन';

  @override
  String get wsStudentAttendanceHint => 'आज कौन आया, कक्षा के अनुसार';

  @override
  String get wsClassesHint => 'कक्षाएँ, सेक्शन और कक्षा अध्यापक';

  @override
  String get wsTeacherPaymentHint => 'शिक्षकों को भुगतान करें और भुगतान देखें';

  @override
  String get wsQuestionBankHint => 'पेपर के लिए रखे प्रश्न';

  @override
  String get wsExamPapersHint => 'बने और मंज़ूरी के लिए भेजे पेपर';

  @override
  String get wsTeacherAttendanceHint => 'चेक-इन और कौन स्कूल में है';

  @override
  String get wsSubjectsHint => 'कौन सा विषय कौन पढ़ाता है';

  @override
  String get wsStaffAttendanceHint => 'आज कौन आया';

  @override
  String get wsStaffPaymentHint => 'स्टाफ को भुगतान करें और मंज़ूर बिल निपटाएँ';

  @override
  String get wsBillsHint => 'मंज़ूरी के लिए पेट्रोल और डीज़ल के बिल';

  @override
  String get accAddTitle => 'जोड़ें';

  @override
  String get accAddHint => 'किसी कक्षा में ड्रेस का टुकड़ा या किताब जोड़ें';

  @override
  String get accManageTitle => 'देखें, बदलें, हटाएँ';

  @override
  String get accManageHint => 'हर कक्षा की ड्रेस और किताबों की सूची';

  @override
  String get accGiveTitle => 'छात्रों को दें';

  @override
  String get accGiveHint => 'कक्षा के अनुसार ड्रेस या किताबें दें';

  @override
  String get accSizesHint => 'हर छात्र का साइज़ लिखें';

  @override
  String get accRecordsTitle => 'रिकॉर्ड';

  @override
  String get accRecordsHint => 'किसे क्या मिला, रसीद के साथ';

  @override
  String get accItemName => 'चीज़ का नाम';

  @override
  String get accItemAdded => 'जोड़ा गया';

  @override
  String get accItemRemoved => 'हटाया गया';

  @override
  String get accEditItem => 'चीज़ बदलें';

  @override
  String get accDeleteItemTitle => 'यह चीज़ हटाएँ?';

  @override
  String get accNothingHere => 'यहाँ अभी कुछ नहीं।';

  @override
  String get accNoRecords => 'अभी तक कुछ दिया नहीं गया।';

  @override
  String get accPickClass => 'कक्षा चुनें';

  @override
  String get actionSignInWithGoogle => 'Google से साइन इन करें';

  @override
  String get errorNotRegistered =>
      'यह Google खाता विद्यालय में पंजीकृत नहीं है। प्रधानाचार्य से जुड़वाएँ।';

  @override
  String get registerSubtitle =>
      'प्रधानाचार्य के रूप में पंजीकरण करें। अगले चरण में विद्यालय बनाएँगे।';

  @override
  String get loginRegister => 'नए हैं? पंजीकरण करें';

  @override
  String get schoolSetupTitle => 'अपने विद्यालय का नाम';

  @override
  String get schoolSetupSubtitle =>
      'यह नाम पूरे ऐप में दिखेगा। शिक्षक बाद में जोड़ सकते हैं।';

  @override
  String get loginAdminNote =>
      'खाते विद्यालय के एडमिन द्वारा बनाए जाते हैं। साइन इन न हो पाए तो कृपया अपने प्रधानाचार्य से संपर्क करें।';

  @override
  String get srvOffline =>
      'स्कूल के सर्वर से जुड़ नहीं पा रहे। इंटरनेट जाँचें और फिर कोशिश करें।';

  @override
  String get srvInvalidCredentials =>
      'ईमेल या पासवर्ड गलत है, या यह खाता बंद है।';

  @override
  String get srvSessionExpired =>
      'आपका सत्र समाप्त हो गया। कृपया फिर से साइन इन करें।';

  @override
  String get srvForbidden => 'आपको यह करने की अनुमति नहीं है।';

  @override
  String get srvNotFound => 'यह नहीं मिला। शायद इसे हटा दिया गया है।';

  @override
  String get srvInvalid => 'कृपया जो भरा है उसे जाँचें।';

  @override
  String get srvRejected => 'इसकी अनुमति नहीं मिली।';

  @override
  String get srvTooManyRequests =>
      'बहुत ज़्यादा कोशिशें हुईं। थोड़ा रुककर फिर कोशिश करें।';

  @override
  String get srvUnavailable => 'सर्वर पर कुछ गड़बड़ हुई। कृपया फिर कोशिश करें।';

  @override
  String get actionRetry => 'फिर कोशिश करें';

  @override
  String get comingSoon => 'यह हिस्सा स्कूल के सर्वर से जोड़ा जा रहा है।';

  @override
  String get navStaff => 'कर्मचारी';

  @override
  String get navRequests => 'अनुरोध';

  @override
  String get navPayments => 'भुगतान';

  @override
  String get navAnalytics => 'ग्राफ़';

  @override
  String get navSchool => 'स्कूल';

  @override
  String get navNotices => 'सूचनाएँ';

  @override
  String get navFuelBills => 'ईंधन बिल';

  @override
  String get navVicePrincipal => 'उप-प्रधानाचार्य';

  @override
  String get navMore => 'और';

  @override
  String get roleLabelVicePrincipal => 'उप-प्रधानाचार्य';

  @override
  String get roleLabelStaff => 'कर्मचारी';

  @override
  String get profileChangeName => 'नाम बदलें';

  @override
  String get schoolTitle => 'स्कूल';

  @override
  String get schoolNameNotSet => 'स्कूल का नाम तय नहीं';

  @override
  String get schoolSeasonInUse => 'चालू समय-सारणी';

  @override
  String get seasonSummer => 'गर्मी';

  @override
  String get seasonWinter => 'सर्दी';

  @override
  String schoolTimingOf(String season) {
    return '$season का समय';
  }

  @override
  String schoolHours(String opens, String closes) {
    return '$opens से $closes';
  }

  @override
  String get schoolTimingNotSet => 'अभी तय नहीं';

  @override
  String schoolPeriodCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पीरियड',
      one: '1 पीरियड',
      zero: 'कोई पीरियड नहीं',
    );
    return '$_temp0';
  }

  @override
  String get schoolInUse => 'चालू';

  @override
  String get schoolHolidays => 'छुट्टियाँ';

  @override
  String get fieldOpens => 'स्कूल खुलता है';

  @override
  String get fieldCloses => 'स्कूल बंद होता है';

  @override
  String get fieldStarts => 'शुरू';

  @override
  String get fieldEnds => 'खत्म';

  @override
  String get schoolPeriods => 'पीरियड';

  @override
  String get schoolAddPeriod => 'पीरियड जोड़ें';

  @override
  String get schoolNoPeriods => 'अभी कोई पीरियड नहीं।';

  @override
  String schoolPeriodName(int n) {
    return 'पीरियड $n का नाम (वैकल्पिक)';
  }

  @override
  String get holidayEdit => 'छुट्टी बदलें';

  @override
  String get fieldHolidayName => 'छुट्टी का नाम';

  @override
  String get fieldFirstDay => 'पहला दिन';

  @override
  String get fieldLastDay => 'आखिरी दिन';

  @override
  String get holidaysEmpty => 'इस महीने से आगे कोई छुट्टी नहीं।';

  @override
  String get noticePost => 'सूचना डालें';

  @override
  String get noticeKindNotice => 'सूचना';

  @override
  String get noticeAnnouncement => 'घोषणा';

  @override
  String get noticeWithdraw => 'हटाएँ';

  @override
  String get noticeWithdrawTitle => 'यह सूचना हटाएँ?';

  @override
  String get noticeWithdrawBody => 'अब यह किसी को नहीं दिखेगी।';

  @override
  String get stuTitle => 'छात्र';

  @override
  String get stuTabStudents => 'छात्र';

  @override
  String get stuTabClasses => 'कक्षाएँ';

  @override
  String get stuSearch => 'नाम से खोजें';

  @override
  String get stuAllClasses => 'सभी कक्षाएँ';

  @override
  String get stuAdd => 'छात्र जोड़ें';

  @override
  String get stuEdit => 'छात्र बदलें';

  @override
  String get stuRemove => 'छात्र हटाएँ';

  @override
  String get stuRestore => 'छात्र वापस लाएँ';

  @override
  String stuRemoveAsk(String name) {
    return '$name को हटाएँ? उनका रिकॉर्ड और फीस बनी रहेगी।';
  }

  @override
  String get stuRemoved => 'हटाए गए';

  @override
  String get stuEmpty => 'कोई छात्र नहीं मिला।';

  @override
  String stuRoll(String roll) {
    return 'रोल $roll';
  }

  @override
  String get stuRollField => 'रोल नंबर (खाली छोड़ें तो अगला मिलेगा)';

  @override
  String get stuGuardianField => 'अभिभावक का नाम';

  @override
  String get stuUsesVan => 'स्कूल वैन से आता है';

  @override
  String get stuVanYes => 'वैन से आता है';

  @override
  String get stuVanNo => 'वैन से नहीं आता';

  @override
  String get stuClassesEmpty => 'अभी कोई कक्षा नहीं। \"कक्षा जोड़ें\" दबाएँ।';

  @override
  String get stuClassLevel => 'स्तर';

  @override
  String get stuClassSection => 'सेक्शन (एक ही हो तो खाली छोड़ें)';

  @override
  String stuClassRemoveAsk(String name) {
    return '$name को हटाएँ?';
  }

  @override
  String get stuLevelNursery => 'नर्सरी';

  @override
  String get stuLevelLkg => 'एलकेजी';

  @override
  String get stuLevelUkg => 'यूकेजी';

  @override
  String get feeTab => 'फीस';

  @override
  String get feeSetupTab => 'फीस तय करें';

  @override
  String get itemsTab => 'ड्रेस और किताबें';

  @override
  String get feeOnlyDue => 'सिर्फ बकाया वाले';

  @override
  String get feeAccountsEmpty => 'कोई फीस खाता नहीं मिला।';

  @override
  String feeBalanceOf(String amount) {
    return 'बकाया $amount';
  }

  @override
  String get feeDue => 'देय';

  @override
  String get feePaid => 'जमा';

  @override
  String get feeBalance => 'बकाया';

  @override
  String get feeNotSet => 'तय नहीं';

  @override
  String get feeSetAmount => 'राशि तय करें';

  @override
  String get feeReceive => 'फीस जमा लें';

  @override
  String get feeHeadTuition => 'ट्यूशन';

  @override
  String feeReceipt(String no) {
    return 'रसीद $no';
  }

  @override
  String get feeNote => 'टिप्पणी (वैकल्पिक)';

  @override
  String get feePayments => 'जमा की गई फीस';

  @override
  String get feeNoPayments => 'अभी कोई जमा नहीं।';

  @override
  String get feeSell => 'ड्रेस या किताबें बेचें';

  @override
  String get feeNoClasses => 'पहले कक्षा जोड़ें।';

  @override
  String get itemAdd => 'सामान जोड़ें';

  @override
  String get itemEdit => 'सामान बदलें';

  @override
  String get itemName => 'सामान का नाम';

  @override
  String get itemPrice => 'कीमत';

  @override
  String get itemClass => 'कक्षा';

  @override
  String get itemAllClasses => 'सभी कक्षाएँ';

  @override
  String get itemKind => 'प्रकार';

  @override
  String get itemKindDress => 'ड्रेस';

  @override
  String get itemKindBooks => 'किताबें';

  @override
  String get itemsEmpty => 'अभी कुछ नहीं। \"सामान जोड़ें\" दबाएँ।';

  @override
  String get itemQuantity => 'मात्रा';

  @override
  String get itemSellAction => 'बेचें';

  @override
  String get itemsForSale => 'इस कक्षा के लिए कुछ उपलब्ध नहीं।';

  @override
  String get memTeachers => 'शिक्षक';

  @override
  String get memStaff => 'कर्मचारी';

  @override
  String get memVicePrincipals => 'उप-प्रधानाचार्य';

  @override
  String get memTeacherAdd => 'शिक्षक जोड़ें';

  @override
  String get memStaffAdd => 'कर्मचारी जोड़ें';

  @override
  String get memVpAdd => 'उप-प्रधानाचार्य नियुक्त करें';

  @override
  String get memTeacherEdit => 'शिक्षक बदलें';

  @override
  String get memStaffEdit => 'कर्मचारी बदलें';

  @override
  String get memVpEdit => 'उप-प्रधानाचार्य बदलें';

  @override
  String get memTeachersEmpty => 'कोई शिक्षक नहीं मिला।';

  @override
  String get memStaffEmpty => 'कोई कर्मचारी नहीं मिला।';

  @override
  String get memVpEmpty => 'अभी कोई उप-प्रधानाचार्य नहीं।';

  @override
  String get memJobTitle => 'पद (जैसे वैन ड्राइवर)';

  @override
  String get memShowRemoved => 'हटाए गए भी दिखाएँ';

  @override
  String get memRemove => 'हटाएँ';

  @override
  String get memRestore => 'वापस लाएँ';

  @override
  String memRemoveAsk(String name) {
    return '$name को हटाएँ? वे अब साइन इन नहीं कर पाएँगे।';
  }

  @override
  String get memResetPassword => 'नया पासवर्ड तय करें';

  @override
  String get memPasswordChanged => 'पासवर्ड बदल गया';

  @override
  String get memEmailHint => 'वे इसी ईमेल से साइन इन करेंगे';

  @override
  String get navLessons => 'मेरे पाठ';

  @override
  String get tchAllotments => 'कक्षाएँ';

  @override
  String get tchLessonBoard => 'दैनिक पाठ';

  @override
  String get tchAllot => 'कक्षा सौंपें';

  @override
  String get tchAllotmentsEmpty => 'अभी कोई कक्षा नहीं सौंपी गई।';

  @override
  String get tchTeacher => 'शिक्षक';

  @override
  String get tchSubject => 'विषय';

  @override
  String tchRemoveAllotmentAsk(String subject, String name) {
    return 'इस शिक्षक से $name का $subject वापस लें?';
  }

  @override
  String get tchRecorded => 'दर्ज';

  @override
  String get tchPending => 'अभी दर्ज नहीं';

  @override
  String get tchBoardEmpty =>
      'कोई कक्षा नहीं सौंपी गई, इसलिए कुछ दर्ज करने को नहीं।';

  @override
  String get tchRecordLesson => 'आज का पाठ दर्ज करें';

  @override
  String get tchEditLesson => 'पाठ बदलें';

  @override
  String get tchTopic => 'क्या पढ़ाया';

  @override
  String get tchLessonsEmpty => 'अभी कोई पाठ दर्ज नहीं।';

  @override
  String get tchMyClasses => 'मेरी कक्षाएँ';

  @override
  String get tchRecentLessons => 'हाल के पाठ';

  @override
  String tchClassSubject(String name, String subject) {
    return '$name · $subject';
  }

  @override
  String get tchDayPick => 'दिन';

  @override
  String get fltVans => 'वैन';

  @override
  String get fltFuelBills => 'ईंधन बिल';

  @override
  String get fltVanAdd => 'वैन जोड़ें';

  @override
  String get fltVanEdit => 'वैन बदलें';

  @override
  String get fltVanName => 'वैन का नाम या नंबर';

  @override
  String get fltDriver => 'ड्राइवर';

  @override
  String get fltNoDriver => 'कोई ड्राइवर नहीं';

  @override
  String get fltVansEmpty => 'अभी कोई वैन नहीं।';

  @override
  String get fltBillsEmpty => 'कोई ईंधन बिल नहीं।';

  @override
  String get fltBillAdd => 'ईंधन बिल जोड़ें';

  @override
  String get fltFuelType => 'ईंधन';

  @override
  String get fltPetrol => 'पेट्रोल';

  @override
  String get fltDiesel => 'डीज़ल';

  @override
  String get fltLitres => 'लीटर';

  @override
  String get fltRate => 'प्रति लीटर दर';

  @override
  String get fltOdometer => 'ओडोमीटर (किमी)';

  @override
  String get fltBilledOn => 'बिल की तारीख';

  @override
  String get fltVan => 'वैन';

  @override
  String get fltStatusPending => 'लंबित';

  @override
  String get fltStatusApproved => 'स्वीकृत';

  @override
  String get fltStatusRejected => 'अस्वीकृत';

  @override
  String get fltAllStatuses => 'सभी';

  @override
  String get fltWithdraw => 'वापस लें';

  @override
  String get fltApprove => 'स्वीकार करें';

  @override
  String get fltReject => 'अस्वीकार करें';

  @override
  String get fltRejectReason => 'कारण';

  @override
  String fltMileage(String km, String kpl) {
    return '$km किमी · $kpl किमी/ली';
  }

  @override
  String fltBillLine(String litres, String rate) {
    return '$litres ली, दर $rate';
  }

  @override
  String fltSubmittedBy(String name) {
    return '$name द्वारा';
  }

  @override
  String fltRejectedWhy(String reason) {
    return 'अस्वीकृत: $reason';
  }

  @override
  String get fltNoVanForDriver => 'आपको अभी कोई वैन नहीं दी गई है।';

  @override
  String get attStudentsTab => 'छात्र';

  @override
  String get attReportTab => 'रिपोर्ट';

  @override
  String get attMineTab => 'मेरी उपस्थिति';

  @override
  String get attPeopleTab => 'शिक्षक और कर्मचारी';

  @override
  String get attPresent => 'उपस्थित';

  @override
  String get attLate => 'देर से';

  @override
  String get attAbsent => 'अनुपस्थित';

  @override
  String get attLeave => 'अवकाश पर';

  @override
  String get attHoliday => 'छुट्टी';

  @override
  String get attNotInYet => 'अभी नहीं आए';

  @override
  String get attMarkAll => 'सभी को उपस्थित करें';

  @override
  String get attSave => 'उपस्थिति सहेजें';

  @override
  String get attSaved => 'उपस्थिति सहेजी गई';

  @override
  String get attPickClass => 'कक्षा चुनें';

  @override
  String get attRosterEmpty => 'इस कक्षा में कोई छात्र नहीं।';

  @override
  String get attCheckIn => 'चेक इन';

  @override
  String get attCheckOut => 'चेक आउट';

  @override
  String attCheckedInAt(String time) {
    return 'आगमन $time';
  }

  @override
  String attCheckedOutAt(String time) {
    return 'प्रस्थान $time';
  }

  @override
  String get attMineEmpty => 'अभी कोई उपस्थिति दर्ज नहीं।';

  @override
  String get attBoardEmpty => 'दिखाने के लिए कोई नहीं।';

  @override
  String get attHolidayToday => 'यह दिन छुट्टी का है।';

  @override
  String get attAllRoles => 'सभी';

  @override
  String get attRoleTeachers => 'शिक्षक';

  @override
  String get attRoleStaff => 'कर्मचारी';

  @override
  String get attCorrect => 'समय सुधारें';

  @override
  String get attCheckInTime => 'आने का समय';

  @override
  String get attCheckOutTime => 'जाने का समय (वैकल्पिक)';

  @override
  String attTally(int present, int late, int absent) {
    return '$present उपस्थित · $late देर से · $absent अनुपस्थित';
  }

  @override
  String get attRange => 'अवधि';

  @override
  String get attReportNeedsRange => 'रिपोर्ट के लिए अवधि चुनें।';

  @override
  String get attDay => 'दिन';

  @override
  String get reqTitle => 'अनुरोध';

  @override
  String get reqEmpty => 'कोई अनुरोध नहीं।';

  @override
  String get reqRaiseLeave => 'अवकाश माँगें';

  @override
  String get reqRaiseMeeting => 'मीटिंग माँगें';

  @override
  String get reqKindLeave => 'अवकाश';

  @override
  String get reqKindMeeting => 'मीटिंग';

  @override
  String get reqAllKinds => 'सभी';

  @override
  String get reqStatusPending => 'लंबित';

  @override
  String get reqStatusApproved => 'स्वीकृत';

  @override
  String get reqStatusRejected => 'अस्वीकृत';

  @override
  String get reqStatusWithdrawn => 'वापस लिया';

  @override
  String get reqFrom => 'से';

  @override
  String get reqTo => 'तक';

  @override
  String get reqReason => 'कारण';

  @override
  String get reqSubject => 'विषय';

  @override
  String get reqDetails => 'विवरण (वैकल्पिक)';

  @override
  String get reqPreferredOn => 'पसंदीदा दिन (वैकल्पिक)';

  @override
  String get reqSend => 'भेजें';

  @override
  String get reqWithdraw => 'वापस लें';

  @override
  String get reqApprove => 'स्वीकार करें';

  @override
  String get reqReject => 'अस्वीकार करें';

  @override
  String get reqRejectReason => 'अस्वीकार करने का कारण';

  @override
  String get reqMeetingOn => 'मीटिंग का दिन';

  @override
  String get reqMeetingAt => 'मीटिंग का समय';

  @override
  String reqBy(String name) {
    return '$name की ओर से';
  }

  @override
  String reqDecidedBy(String name, String date) {
    return '$name, $date';
  }

  @override
  String reqMeetingFixed(String date, String time) {
    return 'मीटिंग $date को $time बजे';
  }

  @override
  String reqNote(String note) {
    return 'टिप्पणी: $note';
  }

  @override
  String get exmTitle => 'परीक्षाएँ';

  @override
  String get exmTabExams => 'परीक्षाएँ';

  @override
  String get exmTabBank => 'प्रश्न बैंक';

  @override
  String get exmSchedule => 'परीक्षा तय करें';

  @override
  String get exmEdit => 'परीक्षा बदलें';

  @override
  String get exmEmpty => 'कोई परीक्षा नहीं मिली।';

  @override
  String get exmType => 'परीक्षा का प्रकार';

  @override
  String get exmTypeUnitTest => 'यूनिट टेस्ट';

  @override
  String get exmTypeMidTerm => 'मध्यावधि';

  @override
  String get exmTypeAnnual => 'वार्षिक';

  @override
  String get exmSubject => 'विषय';

  @override
  String get exmHeldOn => 'परीक्षा का दिन';

  @override
  String get exmMaxMarks => 'कुल अंक';

  @override
  String get exmAwaiting => 'अनुमोदन की प्रतीक्षा में पेपर';

  @override
  String get exmRemoveAsk => 'यह परीक्षा हटाएँ?';

  @override
  String exmTeacher(String name) {
    return 'शिक्षक: $name';
  }

  @override
  String exmMarksOf(int marks, String max) {
    return '$max में से $marks';
  }

  @override
  String get exmEnterMarks => 'अंक भरें';

  @override
  String get exmMarksSave => 'अंक सहेजें';

  @override
  String get exmAbsent => 'अनुपस्थित';

  @override
  String get exmMarksField => 'अंक';

  @override
  String get exmMarksTooHigh => 'कुल अंकों से अधिक';

  @override
  String get exmResults => 'परिणाम';

  @override
  String exmResultsStats(String entered, int absent) {
    return '$entered दर्ज · $absent अनुपस्थित';
  }

  @override
  String exmAverage(String value) {
    return 'औसत $value%';
  }

  @override
  String exmHighLow(String high, String low) {
    return 'सर्वाधिक $high · न्यूनतम $low';
  }

  @override
  String get exmNotEntered => 'दर्ज नहीं';

  @override
  String get exmPaper => 'प्रश्न पत्र';

  @override
  String get exmPaperNone => 'अभी कोई पेपर नहीं।';

  @override
  String get exmPaperCompose => 'प्रश्न चुनें';

  @override
  String get exmPaperSend => 'अनुमोदन के लिए भेजें';

  @override
  String get exmPaperApprove => 'पेपर स्वीकार करें';

  @override
  String get exmPaperReject => 'वापस भेजें';

  @override
  String get exmPaperStatusDraft => 'मसौदा';

  @override
  String get exmPaperStatusSent => 'अनुमोदन की प्रतीक्षा';

  @override
  String get exmPaperStatusApproved => 'स्वीकृत';

  @override
  String get exmPaperStatusRejected => 'वापस भेजा';

  @override
  String exmPaperTotal(int marks) {
    return 'कुल $marks अंक';
  }

  @override
  String exmPaperNote(String note) {
    return 'टिप्पणी: $note';
  }

  @override
  String get exmPaperBankEmpty =>
      'इस कक्षा और विषय के प्रश्न नहीं हैं। प्रश्न बैंक में जोड़ें।';

  @override
  String exmPaperUse(int count) {
    return '$count प्रश्न लें';
  }

  @override
  String get exmReason => 'कारण';

  @override
  String get qbUnitAdd => 'यूनिट जोड़ें';

  @override
  String get qbUnitEdit => 'यूनिट बदलें';

  @override
  String get qbUnitName => 'यूनिट का नाम';

  @override
  String get qbUnitsEmpty => 'अभी कोई यूनिट नहीं।';

  @override
  String get qbQuestionAdd => 'प्रश्न जोड़ें';

  @override
  String get qbQuestionEdit => 'प्रश्न बदलें';

  @override
  String get qbQuestionText => 'प्रश्न';

  @override
  String get qbQuestionMarks => 'अंक';

  @override
  String get qbQuestionType => 'प्रश्न का प्रकार';

  @override
  String get qbTypeMcq => 'बहुविकल्पीय';

  @override
  String get qbTypeShort => 'लघु उत्तर';

  @override
  String get qbTypeLong => 'दीर्घ उत्तर';

  @override
  String get qbQuestionsEmpty => 'इस यूनिट में अभी कोई प्रश्न नहीं।';

  @override
  String qbUnitBy(String teacher, String cls, String subject) {
    return '$teacher · $cls · $subject';
  }

  @override
  String get exmStudentResults => 'परीक्षा परिणाम';

  @override
  String exmStudentTotal(String obtained, String outOf, String pct) {
    return 'कुल $outOf में से $obtained ($pct%)';
  }

  @override
  String get exmStudentEmpty => 'अभी कोई परीक्षा नहीं।';

  @override
  String get payTitle => 'भुगतान';

  @override
  String get payTabTeachers => 'शिक्षक';

  @override
  String get payTabStaff => 'कर्मचारी';

  @override
  String get payTabMine => 'मेरा खाता';

  @override
  String get payEmpty => 'दिखाने के लिए कोई नहीं।';

  @override
  String get paySalary => 'वेतन';

  @override
  String get payFuelBill => 'ईंधन बिल';

  @override
  String paySalaryNow(String amount) {
    return 'वेतन $amount प्रति माह';
  }

  @override
  String get paySalaryNone => 'वेतन तय नहीं';

  @override
  String get paySetSalary => 'वेतन तय करें';

  @override
  String get paySalaryFrom => 'किस माह से';

  @override
  String get paySalaryHistory => 'वेतन का इतिहास';

  @override
  String payFrom(String month) {
    return '$month से';
  }

  @override
  String payBalance(String amount) {
    return 'देय $amount';
  }

  @override
  String payTotals(String due, String paid) {
    return 'देय $due · जमा $paid';
  }

  @override
  String payLineDue(String label, String due, String paid) {
    return '$label: देय $due, चुकाया $paid';
  }

  @override
  String get payPay => 'भुगतान करें';

  @override
  String get payMode => 'कैसे चुकाया';

  @override
  String get payHistory => 'किए गए भुगतान';

  @override
  String get payHistoryEmpty => 'अभी कोई भुगतान नहीं।';

  @override
  String payReceipt(String no) {
    return 'रसीद $no';
  }

  @override
  String get payNothingDue => 'कुछ देय नहीं।';

  @override
  String payFuelOn(String van, String date) {
    return '$van · $date';
  }

  @override
  String get anaTitle => 'विश्लेषण';

  @override
  String get anaStudentAttendance => 'छात्र उपस्थिति';

  @override
  String get anaFees => 'फीस';

  @override
  String get anaExams => 'परीक्षा परिणाम';

  @override
  String get anaStaffAttendance => 'शिक्षक और कर्मचारी उपस्थिति';

  @override
  String get anaPayments => 'कर्मचारियों को भुगतान';

  @override
  String get anaFuel => 'ईंधन';

  @override
  String get anaLessons => 'दैनिक पाठ';

  @override
  String get anaSeriesAttendance => 'उपस्थिति %';

  @override
  String get anaSeriesFeesCollected => 'हर माह जमा फीस';

  @override
  String get anaSeriesFeesBalance => 'कक्षा के अनुसार बकाया फीस';

  @override
  String get anaSeriesExamAverage => 'हर परीक्षा में औसत %';

  @override
  String get anaSeriesStaffPresent => 'उपस्थित';

  @override
  String get anaSeriesStaffAbsent => 'अनुपस्थित या अवकाश पर';

  @override
  String get anaSeriesPaidOut => 'हर माह चुकाया';

  @override
  String get anaSeriesFuelAmount => 'ईंधन पर खर्च';

  @override
  String get anaSeriesFuelMileage => 'किमी प्रति लीटर';

  @override
  String get anaSeriesLessons => 'दर्ज पाठ %';

  @override
  String get anaSumCollected => 'जमा';

  @override
  String get anaSumBalance => 'बकाया';

  @override
  String get anaSumOwed => 'स्टाफ का बकाया';

  @override
  String get anaSumPaid => 'चुकाया';

  @override
  String get anaEmpty => 'इस अवधि के लिए दिखाने को कुछ नहीं।';

  @override
  String get anaPeriod => 'अवधि';

  @override
  String get perTitle => 'यह व्यक्ति क्या कर सकता है';

  @override
  String get perReason => 'आप यह क्यों दे रहे हैं?';

  @override
  String get perGive => 'अनुमति दें';

  @override
  String perTakeBackAsk(String label) {
    return '“$label” की अनुमति वापस लें?';
  }

  @override
  String get perTakeBack => 'वापस लें';

  @override
  String perReasonShown(String reason) {
    return 'कारण: $reason';
  }

  @override
  String homeGreeting(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get homeAreas => 'आपके क्षेत्र';

  @override
  String get homeLatestNotice => 'ताज़ा सूचना';

  @override
  String get homeNoNotice => 'अभी कोई सूचना नहीं।';

  @override
  String get betaNotice =>
      'बीटा संस्करण: ऐप को बेहतर बनाते समय आपको बदलाव या त्रुटियाँ दिख सकती हैं।';

  @override
  String get betaBadge => 'बीटा';

  @override
  String get navExamTimetable => 'परीक्षा समय-सारणी';

  @override
  String get ttbSettings => 'समय-सारणी की सेटिंग';

  @override
  String get ttbPickClass => 'समय-सारणी बनाने के लिए कक्षा चुनें।';

  @override
  String get ttbNoSubjects =>
      'इस कक्षा के किसी विषय में अभी शिक्षक नहीं है। पहले शिक्षक जोड़ें।';

  @override
  String get ttbSkipHint => 'किसी विषय को छोड़ना हो तो उसकी तारीख खाली रखें।';

  @override
  String get ttbDate => 'तारीख';

  @override
  String get ttbStart => 'शुरू होने का समय';

  @override
  String get ttbMarks => 'अंक';

  @override
  String get ttbDuration => 'मिनट';

  @override
  String get ttbSave => 'समय-सारणी सहेजें';

  @override
  String get ttbSaved => 'समय-सारणी सहेज ली गई।';

  @override
  String get ttbNote => 'कृपया ध्यान दें';

  @override
  String get ttbSavedHeading => 'सहेजी हुई समय-सारणी';

  @override
  String get ttbNoneSaved => 'इस कक्षा के लिए अभी कुछ तय नहीं है।';

  @override
  String get ttbSetMarks => 'सामान्य अंक';

  @override
  String get ttbSetDuration => 'सामान्य अवधि (मिनट)';

  @override
  String get ttbSetStart => 'सामान्य शुरू होने का समय';

  @override
  String get ttbSetShowTime => 'शुरू होने का समय और अवधि दिखाएँ';

  @override
  String get ttbSetSameDay => 'एक दिन में दो पेपर';

  @override
  String get ttbRuleAllow => 'अनुमति दें';

  @override
  String get ttbRuleWarn => 'चेतावनी दें';

  @override
  String get ttbRuleBlock => 'रोकें';

  @override
  String get ttbSetGap => 'दो पेपर के बीच खाली दिन';

  @override
  String get ttbSetOffDays => 'साप्ताहिक छुट्टी';

  @override
  String get ttbSetOffDates => 'छुट्टी की तारीखें';

  @override
  String get ttbAddDate => 'तारीख जोड़ें';

  @override
  String get ttbSetNames => 'परीक्षा के नाम';

  @override
  String get ttbSettingsSaved => 'सेटिंग सहेज ली गई।';

  @override
  String get ttbHoliday => 'छुट्टी';
}
