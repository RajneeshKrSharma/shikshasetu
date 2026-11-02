/// What a staff member's role means for the school's records.
class StaffRole {
  const StaffRole._();

  /// A driver has a van, and the van's number is kept with them.
  static bool drivesVehicle(String roleTitle) {
    final t = roleTitle.toLowerCase();
    return t.contains('driver') || t.contains('ड्राइवर') || t.contains('चालक');
  }
}
