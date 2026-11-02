import '../../domain/entities/check_point.dart';
import '../../domain/entities/teacher_attendance.dart';
import '../dto/teacher_attendance_dto.dart';

class TeacherAttendanceModel extends TeacherAttendance {
  const TeacherAttendanceModel({
    required super.teacherId,
    required super.teacherName,
    super.checkIn,
    super.checkOut,
    super.checkInPoint,
    super.checkOutPoint,
  });

  factory TeacherAttendanceModel.fromDto(TeacherAttendanceDto d) {
    DateTime? time(int? v) =>
        v == null ? null : DateTime.fromMillisecondsSinceEpoch(v);

    CheckPoint? point(
      double? lat,
      double? lon,
      double? dist,
      String? img,
      double? face,
    ) => lat == null
        ? null
        : CheckPoint(
            latitude: lat,
            longitude: lon!,
            distanceMeters: dist!,
            selfiePath: img,
            faceScore: face,
          );

    return TeacherAttendanceModel(
      teacherId: d.teacherId,
      teacherName: d.teacherName,
      checkIn: time(d.checkIn),
      checkOut: time(d.checkOut),
      checkInPoint: point(
        d.inLat,
        d.inLon,
        d.inDistance,
        d.inSelfie,
        d.inFaceScore,
      ),
      checkOutPoint: point(
        d.outLat,
        d.outLon,
        d.outDistance,
        d.outSelfie,
        d.outFaceScore,
      ),
    );
  }
}
