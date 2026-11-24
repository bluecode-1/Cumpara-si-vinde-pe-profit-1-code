/// Validates Romanian mobile numbers and converts them to E.164.
///
/// Accepted inputs, with or without spaces: `07XXXXXXXX`, `7XXXXXXXX` and
/// `+407XXXXXXXX`. Anything else is rejected without calling the server.
abstract final class PhoneNumberNormalizer {
  /// The fixed country prefix shown in front of the input field.
  static const String countryPrefix = '+40';

  static final RegExp _whitespace = RegExp(r'\s+');
  static final RegExp _accepted = RegExp(r'^(?:\+40|0)?(7\d{8})$');

  /// Returns the number as `+407XXXXXXXX`, or `null` when [input] is not a
  /// valid Romanian mobile number.
  static String? normalize(String input) {
    final RegExpMatch? match = _accepted.firstMatch(
      input.replaceAll(_whitespace, ''),
    );
    return match == null ? null : '$countryPrefix${match.group(1)}';
  }
}
