abstract interface class AddressRepository {
  /// A readable address for the point, or null when none can be found
  /// (offline, or no result).
  Future<String?> addressOf(double latitude, double longitude);
}
