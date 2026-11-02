import 'package:geocoding/geocoding.dart';

import '../../domain/repository/address_repository.dart';

/// Reverse geocoding through the phone's own geocoder. It needs internet.
class GeocodingAddressRepository implements AddressRepository {
  GeocodingAddressRepository({Geocoding? geocoding})
    : _geocoding = geocoding ?? Geocoding();

  final Geocoding _geocoding;

  /// A geocoder without a backend can hang, so give up after a while.
  static const _timeout = Duration(seconds: 8);

  @override
  Future<String?> addressOf(double latitude, double longitude) async {
    try {
      final places = await _geocoding
          .placemarkFromCoordinates(latitude, longitude)
          .timeout(_timeout);
      if (places.isEmpty) return null;
      final p = places.first;
      final parts = <String>[];
      for (final part in [
        p.name,
        p.street,
        p.subLocality,
        p.locality,
        p.administrativeArea,
        p.postalCode,
      ]) {
        final text = part?.trim() ?? '';
        if (text.isNotEmpty && !parts.contains(text)) parts.add(text);
      }
      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }
}
