/// A teacher joined with their attendance row for one day.
class TeacherAttendanceDto {
  const TeacherAttendanceDto({
    required this.teacherId,
    required this.teacherName,
    this.checkIn,
    this.checkOut,
    this.inLat,
    this.inLon,
    this.inDistance,
    this.inSelfie,
    this.inFaceScore,
    this.outLat,
    this.outLon,
    this.outDistance,
    this.outSelfie,
    this.outFaceScore,
  });

  final String teacherId;
  final String teacherName;
  final int? checkIn;
  final int? checkOut;
  final double? inLat;
  final double? inLon;
  final double? inDistance;
  final String? inSelfie;
  final double? inFaceScore;
  final double? outLat;
  final double? outLon;
  final double? outDistance;
  final String? outSelfie;
  final double? outFaceScore;

  factory TeacherAttendanceDto.fromMap(Map<String, Object?> m) =>
      TeacherAttendanceDto(
        teacherId: m['uid']! as String,
        teacherName: m['uname']! as String,
        checkIn: m['check_in'] as int?,
        checkOut: m['check_out'] as int?,
        inLat: m['in_lat'] as double?,
        inLon: m['in_lon'] as double?,
        inDistance: m['in_distance'] as double?,
        inSelfie: m['in_selfie'] as String?,
        inFaceScore: m['in_face_score'] as double?,
        outLat: m['out_lat'] as double?,
        outLon: m['out_lon'] as double?,
        outDistance: m['out_distance'] as double?,
        outSelfie: m['out_selfie'] as String?,
        outFaceScore: m['out_face_score'] as double?,
      );
}
