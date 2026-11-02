import 'package:equatable/equatable.dart';

class LocationReading extends Equatable {
  const LocationReading({
    required this.latitude,
    required this.longitude,
    required this.isMocked,
  });

  final double latitude;
  final double longitude;

  /// True when the device reports a fake (mock) location.
  final bool isMocked;

  @override
  List<Object?> get props => [latitude, longitude, isMocked];
}

enum LocationProblem { servicesOff, denied, deniedForever, unavailable }

class LocationException implements Exception {
  const LocationException(this.problem);
  final LocationProblem problem;
}
