/// Rules for the public display name: 2 to 40 characters after trimming.
abstract final class DisplayNameValidator {
  static const int minLength = 2;
  static const int maxLength = 40;

  /// Returns the trimmed name, or `null` when its length is out of range.
  /// Length is counted in Unicode code points, so "Ștefan" counts 6.
  static String? normalize(String input) {
    final String name = input.trim();
    final int length = name.runes.length;
    return length >= minLength && length <= maxLength ? name : null;
  }
}
