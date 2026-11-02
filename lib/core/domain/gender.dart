/// A person's gender, as printed on an Aadhaar card (which lists transgender
/// people separately; they are kept here under [other]).
enum Gender {
  male,
  female,
  other;

  static Gender? parse(String? name) {
    for (final g in values) {
      if (g.name == name) return g;
    }
    return null;
  }
}
