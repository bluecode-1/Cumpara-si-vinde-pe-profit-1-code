import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/location/location_service.dart';
import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/onboarding/domain/city.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/consents_controller.dart';
import 'package:profitnet/features/onboarding/presentation/interests_controller.dart';
import 'package:profitnet/features/onboarding/presentation/location_controller.dart';
import 'package:profitnet/features/onboarding/presentation/name_controller.dart';

import '../../../support/controller_harness.dart';

const UserProfile _profile = UserProfile(
  id: 'user-1',
  displayName: 'Ioana',
  onboardingCompleted: false,
);

const List<InterestCategory> _categories = <InterestCategory>[
  InterestCategory(id: 'c1', name: 'Electronice'),
  InterestCategory(id: 'c2', name: 'Cărți'),
];

void main() {
  setUpAll(() {
    registerFallbackValue(const GeoPoint(lat: 0, lng: 0));
    registerFallbackValue(const <ConsentDecision>[]);
    registerFallbackValue(const <String>{});
  });

  group('ConsentsController', () {
    late Harness harness;
    ConsentsController controller() =>
        harness.container.read(consentsControllerProvider.notifier);
    ConsentsState state() => harness.container.read(consentsControllerProvider);

    setUp(() async {
      harness = Harness();
      await harness.signInAt(OnboardingStep.consents);
      harness.container.listen(consentsControllerProvider, (_, _) {});
    });

    test('nothing is granted by default', () {
      expect(state().granted, isEmpty);
      expect(state().canContinue, isFalse);
    });

    test('both required consents are needed to continue', () async {
      controller().setGranted(ConsentPurpose.terms, granted: true);
      expect(state().canContinue, isFalse);
      controller().setGranted(ConsentPurpose.marketing, granted: true);
      expect(state().canContinue, isFalse);
      controller().setGranted(ConsentPurpose.privacy, granted: true);
      expect(state().canContinue, isTrue);
      controller().setGranted(ConsentPurpose.terms, granted: false);
      expect(state().canContinue, isFalse);

      await controller().submit();
      verifyNever(() => harness.repository.saveConsents(any()));
    });

    test('submits all five decisions and moves on to Name', () async {
      when(() => harness.repository.saveConsents(any()))
          .thenAnswer((_) async {});
      controller()
        ..setGranted(ConsentPurpose.terms, granted: true)
        ..setGranted(ConsentPurpose.privacy, granted: true)
        ..setGranted(ConsentPurpose.analytics, granted: true);

      await controller().submit();

      verify(
        () => harness.repository.saveConsents(const <ConsentDecision>[
          ConsentDecision(purpose: ConsentPurpose.terms, granted: true),
          ConsentDecision(purpose: ConsentPurpose.privacy, granted: true),
          ConsentDecision(purpose: ConsentPurpose.marketing, granted: false),
          ConsentDecision(purpose: ConsentPurpose.analytics, granted: true),
          ConsentDecision(
            purpose: ConsentPurpose.aiPhotoProcessing,
            granted: false,
          ),
        ]),
      ).called(1);
      expect(
        harness.session,
        const SessionState.signedIn(
          displayName: '',
          pendingStep: OnboardingStep.name,
        ),
      );
    });

    test('a failure keeps the user on the step with the error', () async {
      when(() => harness.repository.saveConsents(any()))
          .thenThrow(const AppError.network());
      controller()
        ..setGranted(ConsentPurpose.terms, granted: true)
        ..setGranted(ConsentPurpose.privacy, granted: true);

      await controller().submit();

      expect(state().error, const AppError.network());
      expect(state().isSubmitting, isFalse);
      expect(state().canContinue, isTrue);
      expect(
        (harness.session as SignedIn).pendingStep,
        OnboardingStep.consents,
      );
    });
  });

  group('NameController', () {
    late Harness harness;
    NameController controller() =>
        harness.container.read(nameControllerProvider.notifier);
    NameState state() => harness.container.read(nameControllerProvider);

    setUp(() async {
      harness = Harness();
      await harness.signInAt(OnboardingStep.name);
      harness.container.listen(nameControllerProvider, (_, _) {});
    });

    test(
      'rejects names outside 2-40 characters without a server call',
      () async {
        for (final String name in <String>['', ' a ', 'a' * 41]) {
          await controller().submit(name);
          expect(state(), const NameState(isInvalidLength: true));
        }
        verifyNever(() => harness.repository.updateDisplayName(any()));
      },
    );

    test('saves the trimmed name and moves on to Location', () async {
      when(() => harness.repository.updateDisplayName(any()))
          .thenAnswer((_) async => _profile);

      await controller().submit('  Ioana ');

      verify(() => harness.repository.updateDisplayName('Ioana')).called(1);
      expect(
        harness.session,
        const SessionState.signedIn(
          displayName: 'Ioana',
          pendingStep: OnboardingStep.location,
        ),
      );
    });

    test('a failure is exposed; editing clears it', () async {
      when(() => harness.repository.updateDisplayName(any()))
          .thenThrow(const AppError.unknown(status: 500));

      await controller().submit('Ioana');
      expect(state(), const NameState(error: AppError.unknown(status: 500)));
      expect((harness.session as SignedIn).pendingStep, OnboardingStep.name);

      controller().inputChanged();
      expect(state(), const NameState());
    });
  });

  group('LocationController', () {
    late Harness harness;
    LocationController controller() =>
        harness.container.read(locationControllerProvider.notifier);
    LocationState state() => harness.container.read(locationControllerProvider);

    Future<void> start(LocationResult result) async {
      harness = Harness(location: result);
      await harness.signInAt(OnboardingStep.location, displayName: 'Ioana');
      harness.container.listen(locationControllerProvider, (_, _) {});
      when(() => harness.repository.saveConsents(any()))
          .thenAnswer((_) async {});
      when(() => harness.repository.updateHomeLocation(any()))
          .thenAnswer((_) async => _profile);
    }

    test('permission granted: records the LOCATION consent and sends the '
        'position rounded to 2 decimals', () async {
      await start(
        const LocationFound(GeoPoint(lat: 44.4267674, lng: 26.1025384)),
      );

      await controller().useMyLocation();

      verifyInOrder(<void Function()>[
        () => harness.repository.saveConsents(const <ConsentDecision>[
          ConsentDecision(purpose: ConsentPurpose.location, granted: true),
        ]),
        () => harness.repository.updateHomeLocation(
          const GeoPoint(lat: 44.43, lng: 26.1),
        ),
      ]);
      expect(
        (harness.session as SignedIn).pendingStep,
        OnboardingStep.interests,
      );
    });

    for (final LocationResult result in const <LocationResult>[
      LocationPermissionDenied(),
      LocationUnavailable(),
    ]) {
      test('${result.runtimeType}: nothing is sent, the user is pointed to '
          'the city list and is not blocked', () async {
        await start(result);

        await controller().useMyLocation();

        expect(state(), const LocationState(isLocationDenied: true));
        verifyNever(() => harness.repository.saveConsents(any()));
        verifyNever(() => harness.repository.updateHomeLocation(any()));

        await controller().pickCity(manualCities[1]);
        verify(
          () => harness.repository.updateHomeLocation(
            const GeoPoint(lat: 46.77, lng: 23.6),
          ),
        ).called(1);
        verifyNever(() => harness.repository.saveConsents(any()));
        expect(
          (harness.session as SignedIn).pendingStep,
          OnboardingStep.interests,
        );
      });
    }

    test('choosing a city does not ask for the device location', () async {
      await start(const LocationPermissionDenied());

      await controller().pickCity(manualCities.first);

      expect(harness.locationService.calls, 0);
      verify(
        () => harness.repository.updateHomeLocation(
          const GeoPoint(lat: 44.43, lng: 26.1),
        ),
      ).called(1);
    });

    test('a failure keeps the user on the step with the error', () async {
      await start(const LocationFound(GeoPoint(lat: 45, lng: 25)));
      when(() => harness.repository.updateHomeLocation(any()))
          .thenThrow(const AppError.network());

      await controller().useMyLocation();

      expect(state(), const LocationState(error: AppError.network()));
      expect(
        (harness.session as SignedIn).pendingStep,
        OnboardingStep.location,
      );
    });
  });

  group('InterestsController', () {
    late Harness harness;
    InterestsController controller() =>
        harness.container.read(interestsControllerProvider.notifier);
    InterestsState state() =>
        harness.container.read(interestsControllerProvider);

    Future<void> start() async {
      await harness.signInAt(OnboardingStep.interests, displayName: 'Ioana');
      harness.container.listen(interestsControllerProvider, (_, _) {});
      await pumpEventQueue();
    }

    setUp(() {
      harness = Harness();
      when(() => harness.repository.topLevelCategories())
          .thenAnswer((_) async => _categories);
      when(
        () => harness.repository.completeOnboarding(any()),
      ).thenAnswer((_) async => _profile.copyWith(onboardingCompleted: true));
    });

    test('loads the categories', () async {
      await start();
      expect(state().categories, _categories);
      expect(state().isLoading, isFalse);
      expect(state().selectedIds, isEmpty);
    });

    test('a load failure can be retried', () async {
      when(() => harness.repository.topLevelCategories())
          .thenThrow(const AppError.network());
      await start();
      expect(state().loadError, const AppError.network());
      expect(state().isLoading, isFalse);

      when(() => harness.repository.topLevelCategories())
          .thenAnswer((_) async => _categories);
      await controller().retryLoad();
      expect(state().loadError, isNull);
      expect(state().categories, _categories);
    });

    test('finish sends the selection and completes onboarding', () async {
      await start();
      controller()
        ..toggle('c1')
        ..toggle('c2')
        ..toggle('c1');
      expect(state().selectedIds, <String>{'c2'});

      await controller().finish();

      verify(() => harness.repository.completeOnboarding(<String>{'c2'}))
          .called(1);
      expect(
        harness.session,
        const SessionState.signedIn(displayName: 'Ioana'),
      );
    });

    test('skip completes onboarding with no interests, ignoring the '
        'selection', () async {
      await start();
      controller().toggle('c1');

      await controller().skip();

      verify(() => harness.repository.completeOnboarding(<String>{})).called(1);
      expect(
        harness.session,
        const SessionState.signedIn(displayName: 'Ioana'),
      );
    });

    test('skip works even when the categories failed to load', () async {
      when(() => harness.repository.topLevelCategories())
          .thenThrow(const AppError.network());
      await start();

      await controller().skip();

      expect(
        harness.session,
        const SessionState.signedIn(displayName: 'Ioana'),
      );
    });

    test('a failure keeps the user on the step with the error', () async {
      when(() => harness.repository.completeOnboarding(any()))
          .thenThrow(const AppError.network());
      await start();

      await controller().finish();

      expect(state().submitError, const AppError.network());
      expect(state().isSubmitting, isFalse);
      expect(
        (harness.session as SignedIn).pendingStep,
        OnboardingStep.interests,
      );
    });
  });
}
