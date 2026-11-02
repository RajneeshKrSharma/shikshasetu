import '../entities/location_reading.dart';

abstract interface class LocationRepository {
  /// Current position. Throws [LocationException] when it cannot be read.
  Future<LocationReading> current();
}
