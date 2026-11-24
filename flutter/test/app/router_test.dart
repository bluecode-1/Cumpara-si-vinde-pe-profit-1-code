import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/app/router.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_state.dart';

const List<String> _allLocations = <String>[
  AppRoutes.welcome,
  AppRoutes.phone,
  AppRoutes.code,
  AppRoutes.consents,
  AppRoutes.name,
  AppRoutes.location,
  AppRoutes.interests,
  AppRoutes.home,
];

void main() {
  String? redirect(
    SessionState session,
    String location, {
    bool pendingCode = false,
  }) => resolveRedirect(
    session: session,
    hasPendingOtpChallenge: pendingCode,
    location: location,
  );

  group('no session', () {
    const SessionState session = SessionState.signedOut();

    test('Welcome and Phone are reachable', () {
      expect(redirect(session, AppRoutes.welcome), isNull);
      expect(redirect(session, AppRoutes.phone), isNull);
    });

    test('Code is reachable only while a code is pending', () {
      expect(redirect(session, AppRoutes.code, pendingCode: true), isNull);
      expect(redirect(session, AppRoutes.code), AppRoutes.phone);
    });

    test('everything else goes to Welcome', () {
      for (final String location in <String>[
        AppRoutes.consents,
        AppRoutes.name,
        AppRoutes.location,
        AppRoutes.interests,
        AppRoutes.home,
        '/unknown',
      ]) {
        expect(
          redirect(session, location),
          AppRoutes.welcome,
          reason: location,
        );
      }
    });
  });

  group('session with onboarding in progress', () {
    const Map<OnboardingStep, String> routes = <OnboardingStep, String>{
      OnboardingStep.consents: AppRoutes.consents,
      OnboardingStep.name: AppRoutes.name,
      OnboardingStep.location: AppRoutes.location,
      OnboardingStep.interests: AppRoutes.interests,
    };

    test('every step has a route', () {
      expect(routes.keys, OnboardingStep.values);
    });

    routes.forEach((OnboardingStep step, String route) {
      test('resumes at ${step.name} from anywhere', () {
        final SessionState session = SessionState.signedIn(
          displayName: '',
          pendingStep: step,
        );
        for (final String location in _allLocations) {
          expect(
            redirect(session, location, pendingCode: true),
            location == route ? isNull : route,
            reason: location,
          );
        }
      });
    });
  });

  group('session with onboarding completed', () {
    const SessionState session = SessionState.signedIn(displayName: 'Ioana');

    test('always lands on Home', () {
      for (final String location in _allLocations) {
        expect(
          redirect(session, location),
          location == AppRoutes.home ? isNull : AppRoutes.home,
          reason: location,
        );
      }
    });
  });
}
