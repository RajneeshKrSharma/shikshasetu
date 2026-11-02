/// What counts as an email address on a form: a name, one `@`, and a domain
/// with at least one dot and a 2+ letter ending (`name@school.in`).
class EmailRule {
  const EmailRule();

  static final _pattern = RegExp(
    r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9](?:[A-Za-z0-9\-]*[A-Za-z0-9])?'
    r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9\-]*[A-Za-z0-9])?)*\.[A-Za-z]{2,}$',
  );

  bool isValid(String? value) => _pattern.hasMatch((value ?? '').trim());
}
