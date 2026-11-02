import 'package:equatable/equatable.dart';

import '../../../session/domain/entities/account.dart';
import '../../../session/domain/entities/permission.dart';

/// A class given to a teacher for a subject.
class Allotment extends Equatable {
  const Allotment({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.classId,
    required this.className,
    required this.subject,
  });

  final String id;
  final String teacherId;
  final String teacherName;
  final String classId;
  final String className;
  final String subject;

  @override
  List<Object?> get props => [
    id,
    teacherId,
    teacherName,
    classId,
    className,
    subject,
  ];
}

class AllotmentDraft extends Equatable {
  const AllotmentDraft({
    required this.teacherId,
    required this.classId,
    required this.subject,
  });

  final String teacherId;
  final String classId;
  final String subject;

  @override
  List<Object?> get props => [teacherId, classId, subject];
}

/// What a teacher taught in a class on a day.
class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.allotmentId,
    required this.teacherName,
    required this.className,
    required this.subject,
    required this.takenOn,
    required this.topic,
  });

  final String id;
  final String allotmentId;
  final String teacherName;
  final String className;
  final String subject;
  final DateTime takenOn;
  final String topic;

  @override
  List<Object?> get props => [
    id,
    allotmentId,
    teacherName,
    className,
    subject,
    takenOn,
    topic,
  ];
}

/// An allotment for one day: its lesson, or none while it is pending.
class LessonStatus extends Equatable {
  const LessonStatus({required this.allotment, required this.lesson});

  final Allotment allotment;
  final Lesson? lesson;

  bool get recorded => lesson != null;

  @override
  List<Object?> get props => [allotment, lesson];
}

class TeachingAccess {
  const TeachingAccess._({
    required this.canAllot,
    required this.canSeeBoard,
    required this.canRecord,
  });

  factory TeachingAccess.of(Account account) => TeachingAccess._(
    canAllot: account.can(Permission.allotClasses),
    canSeeBoard: account.canAny(const [
      Permission.manageTeachers,
      Permission.allotClasses,
    ]),
    canRecord: account.can(Permission.recordDailyLesson),
  );

  final bool canAllot;
  final bool canSeeBoard;
  final bool canRecord;
}
