import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/features/onboarding/domain/phone_number_normalizer.dart';

void main() {
  group('PhoneNumberNormalizer accepts', () {
    const Map<String, String> accepted = <String, String>{
      '0712345678': '+40712345678',
      '712345678': '+40712345678',
      '+40712345678': '+40712345678',
      '0712 345 678': '+40712345678',
      '712 345 678': '+40712345678',
      '+40 712 345 678': '+40712345678',
      '  0712 345 678  ': '+40712345678',
      '+4 0 7 1 2 3 4 5 6 7 8': '+40712345678',
      '0799999999': '+40799999999',
      '07\t12345678': '+40712345678',
    };
    accepted.forEach((String input, String expected) {
      test('"$input" -> $expected', () {
        expect(PhoneNumberNormalizer.normalize(input), expected);
      });
    });
  });

  group('PhoneNumberNormalizer rejects', () {
    const List<String> rejected = <String>[
      '',
      '   ',
      '07123456', // too short
      '07123456789', // too long
      '0212345678', // landline
      '0612345678', // not a mobile prefix
      '12345678', // 8 digits without a mobile prefix
      '+40212345678', // landline in E.164
      '0040712345678', // 00 international prefix is not accepted
      '40712345678', // country code without +
      '+407123456789', // too long in E.164
      '+4071234567', // too short in E.164
      '+41712345678', // other country
      '0712-345-678', // only spaces are allowed as separators
      '(0712) 345 678',
      '0712345678a',
      'abcdefghij',
      '+', '+40', '0',
      '٠٧١٢٣٤٥٦٧٨', // non-ASCII digits
    ];
    for (final String input in rejected) {
      test('"$input"', () {
        expect(PhoneNumberNormalizer.normalize(input), isNull);
      });
    }
  });
}
