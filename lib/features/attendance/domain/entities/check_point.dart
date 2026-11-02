import 'package:equatable/equatable.dart';

/// Where and when a check-in or check-out was recorded.
class CheckPoint extends Equatable {
  const CheckPoint({
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    this.selfiePath,
    this.faceScore,
  });

  final double latitude;
  final double longitude;

  /// Distance from the school location at that moment.
  final double distanceMeters;
  final String? selfiePath;

  /// How well the face matched the teacher's Face ID (cosine similarity), when
  /// Face ID was used.
  final double? faceScore;

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    distanceMeters,
    selfiePath,
    faceScore,
  ];
}
