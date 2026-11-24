import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/core/error/problem_dto.dart';
import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/core/model/money.dart';
import 'package:profitnet/core/network/token_pair_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/auth_session_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/category_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/consent_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/me_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/otp_dtos.dart';

import '../../../support/fixtures.dart';

/// Contract tests: every shared fixture in `api/fixtures` must decode into
/// the hand-written DTOs. The same files are decoded by the Android and iOS
/// test suites.
void main() {
  // One decoder per fixture. A new fixture without a decoder fails the
  // "every fixture is covered" test below.
  final Map<String, void Function()> decoders = <String, void Function()>{
    'auth_otp_request.202.json': () {
      final OtpChallengeDto dto = OtpChallengeDto.fromJson(
        fixtureObject('auth_otp_request.202.json'),
      );
      expect(dto.challengeId, '0193f6a0-1c2d-7b3a-9e4f-5a6b7c8d9e01');
      expect(dto.retryAfterSeconds, 30);
    },
    'auth_otp_verify.200.json': () {
      final AuthSessionDto dto = AuthSessionDto.fromJson(
        fixtureObject('auth_otp_verify.200.json'),
      );
      expect(dto.accessToken, 'fixture.access.token');
      expect(dto.refreshToken, 'fixture-refresh-token-1');
      expect(dto.expiresInSeconds, 900);
      expect(dto.isNewUser, isTrue);
      expect(dto.user.id, '0193f6a0-2a00-7000-8000-000000000001');
      expect(dto.user.displayName, isEmpty);
      expect(dto.user.phone, '+40712345678');
      expect(dto.user.onboardingCompleted, isFalse);
      expect(dto.user.homeLocation, isNull);
      expect(
        dto.user.limits.maxTransaction,
        const Money(amountMinor: 150000, currency: Currency.ron),
      );
    },
    'auth_refresh.200.json': () {
      final TokenPairDto dto = TokenPairDto.fromJson(
        fixtureObject('auth_refresh.200.json'),
      );
      expect(dto.accessToken, 'fixture.access.token.2');
      expect(dto.refreshToken, 'fixture-refresh-token-2');
      expect(dto.expiresInSeconds, 900);
      expect(dto.toTokens().accessToken, 'fixture.access.token.2');
    },
    'categories.200.json': () {
      final List<CategoryDto> dtos = fixtureList('categories.200.json')
          .map(CategoryDto.fromJson)
          .toList();
      expect(dtos, hasLength(8));
      expect(dtos.every((CategoryDto c) => c.parentId == null), isTrue);
      expect(dtos.first.slug, 'haine');
      expect(dtos.first.name, 'Haine și încălțăminte');
      expect(dtos.first.iconKey, 'clothing');
      expect(dtos.first.isVehicle, isFalse);
      expect(dtos.last.isVehicle, isTrue);
    },
    'me.new.200.json': () {
      final MeDto dto = MeDto.fromJson(fixtureObject('me.new.200.json'));
      expect(dto.displayName, isEmpty);
      expect(dto.verificationTier, VerificationTierDto.phone);
      expect(dto.sellerType, SellerTypeDto.occasional);
      expect(dto.badges, isEmpty);
      expect(dto.completedTransactions, 0);
      expect(dto.memberSince, DateTime(2026, 11, 23));
      expect(dto.locale, 'ro');
      expect(dto.currency, Currency.ron);
      expect(dto.email, isNull);
      expect(dto.emailVerified, isFalse);
      expect(dto.traderInfo, isNull);
      expect(dto.onboardingCompleted, isFalse);
    },
    'me.onboarded.200.json': () {
      final MeDto dto = MeDto.fromJson(fixtureObject('me.onboarded.200.json'));
      expect(dto.displayName, 'Ioana');
      expect(dto.city, 'Cluj-Napoca');
      expect(dto.homeLocation, const GeoPoint(lat: 46.77, lng: 23.6));
      expect(dto.completedTransactions, 34);
      expect(dto.badges, const <BadgeDto>[
        BadgeDto(attribute: ReputationAttributeDto.punctual, confirmations: 23),
        BadgeDto(
          attribute: ReputationAttributeDto.asDescribed,
          confirmations: 31,
        ),
      ]);
      expect(
        dto.limits.monthlyVolume,
        const Money(amountMinor: 500000, currency: Currency.ron),
      );
      expect(dto.onboardingCompleted, isTrue);
    },
    'me_consents.200.json': () {
      final List<ConsentDto> dtos = fixtureList('me_consents.200.json')
          .map(ConsentDto.fromJson)
          .toList();
      expect(dtos.map((ConsentDto c) => c.purpose), <ConsentPurposeDto>[
        ConsentPurposeDto.terms,
        ConsentPurposeDto.privacy,
        ConsentPurposeDto.marketing,
        ConsentPurposeDto.analytics,
        ConsentPurposeDto.location,
        ConsentPurposeDto.aiPhotoProcessing,
      ]);
      expect(dtos.map((ConsentDto c) => c.granted), <bool>[
        true,
        true,
        false,
        false,
        true,
        false,
      ]);
      expect(
        dtos.every((ConsentDto c) => c.policyVersion == '2026-11'),
        isTrue,
      );
      expect(dtos.first.updatedAt, DateTime.utc(2026, 11, 23, 10));
    },
    'problem_otp_invalid.422.json': () {
      final ProblemDto dto = ProblemDto.fromJson(
        fixtureObject('problem_otp_invalid.422.json'),
      );
      expect(dto.code, 'OTP_INVALID');
      expect(dto.status, 422);
      expect(dto.type, 'https://api.profitnet.example/problems/otp-invalid');
      expect(dto.title, 'Cod incorect');
      expect(dto.detail, isNotNull);
      expect(dto.errors, isNull);
    },
    'problem_rate_limited.429.json': () {
      final ProblemDto dto = ProblemDto.fromJson(
        fixtureObject('problem_rate_limited.429.json'),
      );
      expect(dto.code, 'RATE_LIMITED');
      expect(dto.status, 429);
    },
  };

  group('fixtures decode into DTOs', () {
    decoders.forEach(test);
  });

  test('every fixture in api/fixtures is covered by a contract test', () {
    final Set<String> onDisk = Directory(sharedFixturesPath)
        .listSync()
        .whereType<File>()
        .map((File file) => file.uri.pathSegments.last)
        .toSet();
    expect(onDisk, isNotEmpty);
    expect(decoders.keys.toSet(), onDisk);
  });

  group('forward compatibility', () {
    test('unknown enum values do not break decoding', () {
      final Map<String, dynamic> json = fixtureObject('me.onboarded.200.json');
      json['verificationTier'] = 'BIOMETRIC';
      json['sellerType'] = 'CHARITY';
      (json['badges'] as List<dynamic>).add(<String, dynamic>{
        'attribute': 'GENEROUS',
        'confirmations': 5,
      });
      final MeDto dto = MeDto.fromJson(json);
      expect(dto.verificationTier, VerificationTierDto.unknown);
      expect(dto.sellerType, SellerTypeDto.unknown);
      expect(dto.badges.last.attribute, ReputationAttributeDto.unknown);

      final ConsentDto consent = ConsentDto.fromJson(<String, dynamic>{
        ...fixtureList('me_consents.200.json').first,
        'purpose': 'PROFILING',
      });
      expect(consent.purpose, ConsentPurposeDto.unknown);
    });

    test('unknown members are ignored and optional ones may be absent', () {
      final Map<String, dynamic> json = fixtureObject('me.new.200.json')
        ..['somethingNew'] = <String, dynamic>{'a': 1}
        ..remove('completedTransactions')
        ..remove('emailVerified')
        ..remove('onboardingCompleted')
        ..remove('avatarUrl')
        ..remove('homeLocation');
      final MeDto dto = MeDto.fromJson(json);
      expect(dto.completedTransactions, 0);
      expect(dto.emailVerified, isFalse);
      expect(dto.onboardingCompleted, isFalse);
    });
  });

  group('request bodies match the contract', () {
    test('OTP request and verify', () {
      expect(
        const OtpRequestDto(phone: '+40712345678').toJson(),
        <String, dynamic>{'phone': '+40712345678'},
      );
      expect(
        const OtpVerifyRequestDto(challengeId: 'c-1', code: '123456').toJson(),
        <String, dynamic>{'challengeId': 'c-1', 'code': '123456'},
      );
    });

    test('MeUpdate only sends the members that are set', () {
      expect(
        const MeUpdateDto(displayName: 'Ioana').toJson(),
        <String, dynamic>{'displayName': 'Ioana'},
      );
      expect(
        const MeUpdateDto(homeLocation: GeoPoint(lat: 46.77, lng: 23.6))
            .toJson(),
        <String, dynamic>{
          'homeLocation': <String, dynamic>{'lat': 46.77, 'lng': 23.6},
        },
      );
      expect(
        const MeUpdateDto(
          interestCategoryIds: <String>[],
          onboardingCompleted: true,
        ).toJson(),
        <String, dynamic>{
          'interestCategoryIds': <String>[],
          'onboardingCompleted': true,
        },
      );
    });

    test('consent purposes use the wire names', () {
      expect(
        const ConsentUpdateDto(
          purpose: ConsentPurposeDto.aiPhotoProcessing,
          granted: false,
          policyVersion: '2026-11',
        ).toJson(),
        <String, dynamic>{
          'purpose': 'AI_PHOTO_PROCESSING',
          'granted': false,
          'policyVersion': '2026-11',
        },
      );
      expect(
        const Money(amountMinor: 1, currency: Currency.eur).toJson(),
        <String, dynamic>{'amountMinor': 1, 'currency': 'EUR'},
      );
    });
  });
}
