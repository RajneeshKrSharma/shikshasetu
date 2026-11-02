import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/usecase.dart';
import '../entities/attendance.dart';
import '../repository/attendance_repository.dart';

class RosterParams extends Equatable {
  const RosterParams(this.classId, this.day);

  final String classId;
  final DateTime day;

  @override
  List<Object?> get props => [classId, day];
}

class GetRoster implements UseCase<List<RosterLine>, RosterParams> {
  const GetRoster(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<List<RosterLine>> call(RosterParams p) =>
      _repository.roster(p.classId, p.day);
}

class MarkRosterParams extends Equatable {
  const MarkRosterParams(this.classId, this.day, this.lines);

  final String classId;
  final DateTime day;
  final List<RosterLine> lines;

  @override
  List<Object?> get props => [classId, day, lines];
}

class MarkRoster implements UseCase<List<RosterLine>, MarkRosterParams> {
  const MarkRoster(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<List<RosterLine>> call(MarkRosterParams p) =>
      _repository.markRoster(p.classId, p.day, p.lines);
}

class ReportParams extends Equatable {
  const ReportParams(this.classId, this.from, this.to);

  final String classId;
  final DateTime from;
  final DateTime to;

  @override
  List<Object?> get props => [classId, from, to];
}

class GetStudentReport implements UseCase<List<StudentTally>, ReportParams> {
  const GetStudentReport(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<List<StudentTally>> call(ReportParams p) =>
      _repository.report(p.classId, p.from, p.to);
}

class CheckIn implements UseCase<WorkRecord, DateTime> {
  const CheckIn(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<WorkRecord> call(DateTime _) => _repository.checkIn();
}

class CheckOut implements UseCase<WorkRecord, DateTime> {
  const CheckOut(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<WorkRecord> call(DateTime _) => _repository.checkOut();
}

class RangeParams extends Equatable {
  const RangeParams(this.from, this.to);

  final DateTime from;
  final DateTime to;

  @override
  List<Object?> get props => [from, to];
}

class GetMyAttendance implements UseCase<List<WorkRecord>, RangeParams> {
  const GetMyAttendance(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<List<WorkRecord>> call(RangeParams p) =>
      _repository.mine(p.from, p.to);
}

class BoardParams extends Equatable {
  const BoardParams(this.day, {this.role});

  final DateTime day;
  final String? role;

  @override
  List<Object?> get props => [day, role];
}

class GetDayBoard implements UseCase<DayBoard, BoardParams> {
  const GetDayBoard(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<DayBoard> call(BoardParams p) =>
      _repository.board(p.day, role: p.role);
}

class CorrectAttendance implements UseCase<void, CorrectionDraft> {
  const CorrectAttendance(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<void> call(CorrectionDraft draft) => _repository.correct(draft);
}
