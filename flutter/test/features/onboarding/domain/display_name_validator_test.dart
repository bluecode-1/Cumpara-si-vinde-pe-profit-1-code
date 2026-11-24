import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/features/onboarding/domain/display_name_validator.dart';

void main() {
  test('accepts 2 to 40 characters', () {
    expect(DisplayNameValidator.normalize('Io'), 'Io');
    expect(DisplayNameValidator.normalize('Ioana'), 'Ioana');
    expect(DisplayNameValidator.normalize('a' * 40), 'a' * 40);
  });

  test('trims surrounding whitespace before measuring', () {
    expect(DisplayNameValidator.normalize('  Ioana \n'), 'Ioana');
    expect(DisplayNameValidator.normalize(' ${'a' * 40} '), 'a' * 40);
    expect(DisplayNameValidator.normalize(' a '), isNull);
  });

  test('keeps inner spaces', () {
    expect(DisplayNameValidator.normalize('Ana Maria'), 'Ana Maria');
  });

  test('rejects names that are too short or too long', () {
    expect(DisplayNameValidator.normalize(''), isNull);
    expect(DisplayNameValidator.normalize('    '), isNull);
    expect(DisplayNameValidator.normalize('A'), isNull);
    expect(DisplayNameValidator.normalize('a' * 41), isNull);
  });

  test('counts Romanian diacritics and emoji as one character each', () {
    expect(DisplayNameValidator.normalize('Șț'), 'Șț');
    expect(DisplayNameValidator.normalize('ș' * 40), 'ș' * 40);
    expect(DisplayNameValidator.normalize('ș' * 41), isNull);
    // One code point, two UTF-16 code units.
    expect(DisplayNameValidator.normalize('😀'), isNull);
    expect(DisplayNameValidator.normalize('😀' * 40), '😀' * 40);
  });
}
