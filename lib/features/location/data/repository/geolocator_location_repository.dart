import 'package:geolocator/geolocator.dart';

import '../../domain/entities/location_reading.dart';
import '../../domain/repository/location_repository.dart';

class GeolocatorLocationRepository implements LocationRepository {
  @override
  Future<LocationReading> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationProblem.servicesOff);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(LocationProblem.denied);
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationProblem.deniedForever);
    }
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return LocationReading(
        latitude: p.latitude,
        longitude: p.longitude,
        isMocked: p.isMocked,
      );
    } catch (_) {
      throw const LocationException(LocationProblem.unavailable);
    }
  }
}
