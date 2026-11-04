import 'package:equatable/equatable.dart';

/// One day of a printed timetable: the papers held on it.
class TimetableSheetDay extends Equatable {
  const TimetableSheetDay({required this.day, required this.subjects});

  final DateTime day;
  final List<String> subjects;

  @override
  List<Object?> get props => [day, subjects];
}

/// What heads every printed sheet: the school's logo and address. The school's
/// name comes from the server; these two are fixed by the school.
class PrintLetterhead extends Equatable {
  const PrintLetterhead({
    required this.logoAsset,
    required this.schoolName,
    required this.address,
  });

  /// Path of the logo image bundled with the app.
  final String logoAsset;

  /// Printed when the school's saved name is blank.
  final String schoolName;
  final String address;

  @override
  List<Object?> get props => [logoAsset, schoolName, address];
}

/// A class's saved timetable for one exam, ready to be printed.
class TimetableSheet extends Equatable {
  const TimetableSheet({
    required this.schoolName,
    required this.examLabel,
    required this.className,
    required this.academicYear,
    required this.days,
  });

  final String schoolName;

  /// What the school calls the exam, such as "Half Yearly".
  final String examLabel;
  final String className;

  /// Such as "2026-27".
  final String academicYear;
  final List<TimetableSheetDay> days;

  @override
  List<Object?> get props => [
    schoolName,
    examLabel,
    className,
    academicYear,
    days,
  ];
}

/// The words on the printed sheet, already in the person's language.
class TimetablePrintLabels extends Equatable {
  const TimetablePrintLabels({
    required this.localeCode,
    required this.title,
    required this.classWord,
    required this.dateColumn,
    required this.dayColumn,
    required this.subjectColumn,
    required this.examWord,
    required this.sessionWord,
  });

  final String localeCode;

  /// The heading under the school's name, such as "Time Table".
  final String title;
  final String classWord;
  final String dateColumn;
  final String dayColumn;
  final String subjectColumn;

  /// "Examination", added after the exam's name: "Half Yearly Examination".
  final String examWord;

  /// "Session", printed before the year: "Session 26-27".
  final String sessionWord;

  @override
  List<Object?> get props => [
    localeCode,
    title,
    classWord,
    dateColumn,
    dayColumn,
    subjectColumn,
    examWord,
    sessionWord,
  ];
}
