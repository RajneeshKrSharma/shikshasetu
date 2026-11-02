import 'package:equatable/equatable.dart';

import '../../../../core/domain/gender.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../exams/domain/entities/exam_paper.dart';

/// What every person profile shows about the person.
class ProfileDetails extends Equatable {
  const ProfileDetails({
    required this.id,
    required this.name,
    required this.phone,
    required this.registeredOn,
    this.aadhaarMasked = '',
    this.address,
    this.gender,
    this.dateOfBirth,
  });

  final String id;
  final String name;
  final String phone;
  final String aadhaarMasked;
  final String? address;
  final Gender? gender;
  final DateTime? dateOfBirth;
  final DateTime registeredOn;

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    aadhaarMasked,
    address,
    gender,
    dateOfBirth,
    registeredOn,
  ];
}

class StudentAttendanceEntry extends Equatable {
  const StudentAttendanceEntry(this.day, this.status);

  final DateTime day;
  final AttendanceStatus status;

  @override
  List<Object?> get props => [day, status];
}

class ProfilePayment extends Equatable {
  const ProfilePayment({
    required this.id,
    required this.amount,
    required this.paidAt,
  });

  final int id;
  final int amount;
  final DateTime paidAt;

  String get receiptNo => 'R-${id.toString().padLeft(5, '0')}';

  @override
  List<Object?> get props => [id, amount, paidAt];
}

/// One fee the person owes (or is owed), with what has been paid against it.
class ProfileFee extends Equatable {
  const ProfileFee({
    required this.accountId,
    required this.total,
    required this.paid,
    required this.dueDate,
    required this.payments,
  });

  final String accountId;
  final int total;
  final int paid;
  final DateTime dueDate;

  /// Newest first.
  final List<ProfilePayment> payments;

  int get pending => total - paid;

  @override
  List<Object?> get props => [accountId, total, paid, dueDate, payments];
}

/// A student's marks in one paper.
class ExamResult extends Equatable {
  const ExamResult({
    required this.paperId,
    required this.title,
    required this.subject,
    required this.date,
    required this.obtained,
    required this.total,
  });

  final String paperId;
  final String title;
  final String subject;
  final DateTime date;
  final int obtained;
  final int total;

  double get percent => total == 0 ? 0 : obtained * 100 / total;

  @override
  List<Object?> get props => [paperId, title, subject, date, obtained, total];
}

class StudentProfile extends Equatable {
  const StudentProfile({
    required this.details,
    required this.classSection,
    required this.rollNo,
    this.guardian,
    this.attendance = const [],
    this.fees = const [],
    this.results = const [],
  });

  final ProfileDetails details;
  final String classSection;
  final int rollNo;
  final String? guardian;

  /// Newest day first.
  final List<StudentAttendanceEntry> attendance;
  final List<ProfileFee> fees;

  /// Newest paper first.
  final List<ExamResult> results;

  @override
  List<Object?> get props => [
    details,
    classSection,
    rollNo,
    guardian,
    attendance,
    fees,
    results,
  ];
}

/// A teacher's check-in and check-out on one day.
class TeacherDayRecord extends Equatable {
  const TeacherDayRecord({
    required this.day,
    this.checkIn,
    this.checkOut,
    this.distanceMeters,
    this.faceScore,
  });

  final DateTime day;
  final DateTime? checkIn;
  final DateTime? checkOut;

  /// Distance from the school at check-in.
  final double? distanceMeters;

  /// How well the face matched at check-in, when Face ID was used.
  final double? faceScore;

  @override
  List<Object?> get props => [
    day,
    checkIn,
    checkOut,
    distanceMeters,
    faceScore,
  ];
}

/// A question paper the teacher set.
class TeacherPaper extends Equatable {
  const TeacherPaper({
    required this.id,
    required this.title,
    required this.subject,
    required this.classSection,
    required this.date,
    required this.status,
  });

  final String id;
  final String title;
  final String subject;
  final String classSection;
  final DateTime date;
  final PaperStatus status;

  @override
  List<Object?> get props => [id, title, subject, classSection, date, status];
}

class TeacherProfile extends Equatable {
  const TeacherProfile({
    required this.details,
    required this.email,
    required this.employeeId,
    required this.active,
    this.subject,
    this.classSection,
    this.attendance = const [],
    this.papers = const [],
    this.fees = const [],
  });

  final ProfileDetails details;
  final String email;
  final String employeeId;
  final bool active;
  final String? subject;

  /// The class they are class teacher of, if any.
  final String? classSection;

  /// Newest day first.
  final List<TeacherDayRecord> attendance;
  final List<TeacherPaper> papers;
  final List<ProfileFee> fees;

  @override
  List<Object?> get props => [
    details,
    email,
    employeeId,
    active,
    subject,
    classSection,
    attendance,
    papers,
    fees,
  ];
}
