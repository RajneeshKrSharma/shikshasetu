import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/check_result.dart';
import '../repository/attendance_repository.dart';
import 'verify_teacher_presence.dart';

class TeacherCheckParams extends Equatable {
  const TeacherCheckParams({
    required this.teacherId,
    required this.at,
    this.teacherName = '',
  });

  final String teacherId;
  final DateTime at;
  final String teacherName;

  @override
  List<Object?> get props => [teacherId, at, teacherName];
}

/// Verifies presence, then records the teacher's check-in.
class CheckInTeacher implements UseCase<CheckResult, TeacherCheckParams> {
  const CheckInTeacher(this._verify, this._repository);

  final VerifyTeacherPresence _verify;
  final AttendanceRepository _repository;

  @override
  Future<CheckResult> call(TeacherCheckParams p) async {
    final result = await _verify(
      VerifyPresenceParams(
        teacherId: p.teacherId,
        day: p.at,
        teacherName: p.teacherName,
      ),
    );
    if (result.ok) {
      await _repository.checkIn(p.teacherId, p.at, result.point!);
    }
    return result;
  }
}

/// Verifies presence, then records the teacher's check-out.
class CheckOutTeacher implements UseCase<CheckResult, TeacherCheckParams> {
  const CheckOutTeacher(this._verify, this._repository);

  final VerifyTeacherPresence _verify;
  final AttendanceRepository _repository;

  @override
  Future<CheckResult> call(TeacherCheckParams p) async {
    final result = await _verify(
      VerifyPresenceParams(
        teacherId: p.teacherId,
        day: p.at,
        teacherName: p.teacherName,
      ),
    );
    if (result.ok) {
      await _repository.checkOut(p.teacherId, p.at, result.point!);
    }
    return result;
  }
}
